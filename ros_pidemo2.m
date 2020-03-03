%% 
% @brief: read rosbag file and prepare data for System Identification Tests
% @author: amankh
%
% @TO_DO: orientation convert from quat to euler
clc
clear 
close all

% load bag file
%rosbag_file = 'data/vicon_120619/drift_wp_ed_1_2019-12-06-19-42-58.bag';
rosbag_file = 'data/vicon_120619/2019-12-06-16-07-15.bag';

%rosbag_file = 'monitor_2019-11-08-16-18-56.bag';



%name to save plots or file with
exp = 'drift2';
bag = rosbag(rosbag_file);
bag.AvailableTopics

%% find out the start and end time so edge cases are not used

% estimate different time each topics exists
bag_start = bag.StartTime;
bag_end = bag.EndTime;

%temp_cmd_select = select(bag, 'Topic', '/aa_quant_monitor/ctrlverdict');
temp_cmd_select = select(bag, 'Topic', '/aa_planner/waypoints');
ctrverdict_start = temp_cmd_select.StartTime;
ctrverdict_end = temp_cmd_select.EndTime;

% set the time to use
start_time = ctrverdict_start;
end_time = ctrverdict_end ;
%start_time = bag_start;
%end_time = bag_end ;



%% position and velocity
ekf_select=select(bag, 'Time',[start_time end_time] ,'Topic', '/vicon/body_odom');
ekf_msgs= readMessages(ekf_select);
ekf_vel_ts = timeseries(ekf_select,'Twist.Twist.Linear.X', 'Twist.Twist.Linear.Y', 'Twist.Twist.Angular.Z');
ekf_pos_ts = timeseries(ekf_select,'Pose.Pose.Position.X', 'Pose.Pose.Position.Y', 'Pose.Pose.Orientation.Z');

raw_pos_x = ekf_pos_ts.Data(:,1);
raw_pos_y = ekf_pos_ts.Data(:,2);
% @TO_DO: orientation convert from quat to euler
raw_vel_x = ekf_vel_ts.Data(:,1);
raw_vel_y = ekf_vel_ts.Data(:,2);
raw_yaw_rate = ekf_vel_ts.Data(:,3);

%% commands
cmd_select=select(bag,'Time', [start_time end_time] ,'Topic', '/commands/keyboard');
cmd_msgs= readMessages(cmd_select);
cmd_ts = timeseries(cmd_select,'Drive.SteeringAngle', 'Drive.Speed');
cmd_vel = cmd_ts.Data(:,2);
cmd_steering_angle = cmd_ts.Data(:,1);

%% ctrl verdict
% ver_select=select(bag, 'Time',[start_time end_time] ,'Topic', '/aa_quant_monitor/ctrlverdict');
% ver_msgs= readMessages(ver_select);
% ver_ts = timeseries(ver_select,'Point.X', 'Point.Y');
% ver_id = ver_ts.Data(:,1);
% ver_val = ver_ts.Data(:,2);

%% waypoints
wpt_select=select(bag, 'Time',[start_time end_time] ,'Topic', '/aa_planner/waypoints');
wpt_msgs= readMessages(wpt_select);
wpt_ts = timeseries(wpt_select,'X', 'Y');
wpt_x = wpt_ts.Data(:,1);
wpt_y = wpt_ts.Data(:,2);

% raw_imu_x = imu_ts.Data(:,1);
% raw_imu_y = imu_ts.Data(:,2);
% %moving average to reduce noise
% mvg_imu_x = movmean(raw_imu_x, 50);
% mvg_imu_y = movmean(raw_imu_y, 50);


%% resample data
% pos_x = resample(raw_pos_x, length(ver_id), length(raw_pos_x));
% pos_y = resample(raw_pos_y, length(ver_id), length(raw_pos_y));
pos_x = resample(raw_pos_x, length(cmd_vel), length(raw_pos_x));
pos_y = resample(raw_pos_y, length(cmd_vel), length(raw_pos_y));

%% save to processed datad to mat files
%save(strcat(exp, '_data'),'pos_x','pos_y', 'ver_id', 'ver_val', 'start_time', 'end_time', 'wpt_x', 'wpt_y')

%% plot figures

fig1 = figure(1);
hold on 
plot(raw_pos_x, raw_pos_y, 'b*')
plot(pos_x, pos_y, 'r-')
plot(pos_x(1), pos_y(1), 'k*')
xlabel('Pos X')
ylabel('Pos Y')
legend('raw', 'downsampled')
title('Position in meters (start marked in black)')
%saveas(fig1, strcat(exp,'_position.png'))


% fig2=figure('Position', [10, 10, 900, 900]);
% hold on
% for ind=300:2:length(pos_x)
%     %% Plotting trajectory
%     subplot(2,2,1)
%   if ver_id(ind) ==1
%       plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'g-')
%   else
%       plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'r-')
%   end
%   axis([-2 4 -2 4])
%   hold on
%   drawnow
%   
%   %% plotting text
%   subplot(2,2,2 )
%   axis([0 100 0 220])
%   hold on
%   text(2,200,'Controller: CPO','Color','red','FontSize',14)
%   text(2,190,'Monitor: KeymeraX','Color','red','FontSize',14)
%   text(2,180,'Condition 1:','Color','red','FontSize',12)
%   text(2,170,'Condition 2:','Color','red','FontSize',12)
%   text(2,160,'Condition 3:','Color','red','FontSize',12)
%   text(2,150,'Condition 4:','Color','red','FontSize',12)
%   text(2,140,'Condition 5:','Color','red','FontSize',12)
%   text(2,130,'Condition 6:','Color','red','FontSize',12)
%   text(2,120,'Condition 7:','Color','red','FontSize',12)
%   text(2,110,'Condition 8:','Color','red','FontSize',12)
%   drawnow
%   hold on
%   
%   
%   pause(0.001)
%   ind;
% end



% fig3 = figure(3);
% subplot(2,1,1)
% hold on
% plot(raw_imu_x,'g--')
% plot(mvg_imu_x, 'r-', 'LineWidth',1)
% title('Imu data filtered X- longitudinal')
% subplot(2,1,2)
% hold on
% plot(raw_imu_y,'y--')
% plot(mvg_imu_y, 'b-', 'LineWidth',1)
% title('Imu data filtered Y-lateral')
% saveas(fig3, strcat(exp,'_imu_raw_data.png'))

% fig4 = figure(4);
% subplot(2,1,1)
% hold on
% plot(mvg_imu_x, 'r-', 'LineWidth',1)
% plot(mvg_imu_y, 'b-', 'LineWidth',1)
% legend('long-X', 'lateral -Y')
% title('Imu filtered data before downsampling')
% subplot(2,1,2)
% hold on
% plot(imu_x,'r-')
% plot(imu_y,'b-')
% legend('long-X', 'lateral -Y')
% title('Imu filtered data after downsampling')
% saveas(fig4, strcat(exp,'_imu_downsampled.png'))

% fig5 = figure(5);
% subplot(2,1,1)
% hold on
% plot(raw_pos_x, 'r-', 'LineWidth',1)
% plot(raw_pos_y, 'b-', 'LineWidth',1)
% plot(raw_vel_x, 'g-', 'LineWidth',1)
% plot(raw_vel_y, 'c-', 'LineWidth',1)
% plot(raw_yaw_rate, 'm-', 'LineWidth',1)
% title('localization data before downsampling')
% subplot(2,1,2)
% hold on
% plot(pos_x, 'r-', 'LineWidth',1)
% plot(pos_y, 'b-', 'LineWidth',1)
% plot(vel_x, 'g-', 'LineWidth',1)
% plot(vel_y, 'c-', 'LineWidth',1)
% plot(yaw_rate, 'm-', 'LineWidth',1)
% title('localization data after downsampling')
% saveas(fig5, strcat(exp,'_localization_downsampled.png'))
% 

fig6 = figure(6);
subplot(3,1,1)
hold on
plot(cmd_vel, 'r-')
plot(raw_vel_x, 'b-')
plot(raw_vel_y, 'g-')
legend('cmd vel-X','obs vel -X', 'obs vel -Y')
title('Commanded and observed velocities in m/s')
subplot(3,1,2)
hold on
plot(raw_yaw_rate,'r-')
title('Observed Yaw rate in rad/s')
subplot(3,1,3)
hold on
plot(cmd_steering_angle,'r-')
title('Commanded Steering angle in rad')
% saveas(fig6, strcat(exp,'_cmd_obs.png'))