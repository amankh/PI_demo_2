%plot_data
close all
clear

load('rs1_data.mat')
n_val = normalize(ver_val,'range', [-1 1]);

min_val = min(ver_val);
max_val = max(ver_val);

fig2=figure('Position', [10, 10, 1000, 1200]);
hold on

a =[wpt_x, wpt_y];
wx = unique(a(:,1:2), 'rows');


col = cell(18,1);
col(:) = {'black'};

j = 1;
i= 250;
map = copper(16);
prev_id = -1;
for ind=i:800
   ind 
  %colors
   col(:) = {'black'};
    
  %% Plotting trajectory
  h1 = subplot(2,2,1);
  %cla(h1)
  hold on
  plot(wx(:,1), wx(:,2), 'bo')
  if ver_id(ind) ==1
      col(18) = {'green'};
      plot(pos_x(ind),pos_y(ind),'go')
  else
      col(18) = {'red'};
      col(abs(ver_id(ind))) = {'red'};
      plot(pos_x(ind),pos_y(ind),'*','Color', map(abs(ver_id(ind)),:))
  end
  %plot(pos_x(i: ind),pos_y(i:ind),'b-')
  axis([-2 4 -2 4])
  title('Vehicle trajectory')
  xlabel('Position X(m)')
  ylabel('Position y(m)')
  drawnow
  %hold off

  %% plotting text
  h2 = subplot(2,2,2 );
  cla(h2)
  axis([0 240 0 240])
  title('Monitor Status')
  ylabel('Condition Colormap')
  xlabel('Violated Coditions in Red')
  hold on
  %text(2,220,'Controller: CPO','Color',string(col(17)),'FontSize',14)
  text(30,200,'KeYmaera X','Color',string(col(18)),'FontSize',14)
  text(2,180,'C 1:','Color',map(1,:),'FontSize',10)
  text(2,170,'C 2:','Color',map(2,:),'FontSize',10)
  text(2,160,'C 3:','Color',map(3,:),'FontSize',10)
  text(2,150,'C 4:','Color',map(4,:),'FontSize',10)
  text(2,140,'C 5:','Color',map(5,:),'FontSize',10)
  text(2,130,'C 6:','Color',map(6,:),'FontSize',10)
  text(2,120,'C 7:','Color',map(7,:),'FontSize',10)
  text(2,110,'C 8:','Color',map(8,:),'FontSize',10)
  text(2,100,'C 9:','Color',map(9,:),'FontSize',10)
  text(2,90,'C 10:','Color',map(10,:),'FontSize',10)
  text(2,80,'C 11:','Color',map(11,:),'FontSize',10)
  text(2,70,'C 12:','Color',map(12,:),'FontSize',10)
  text(2,60,'C 13:','Color',map(13,:),'FontSize',10)
  text(2,50,'C 14:','Color',map(14,:),'FontSize',10)
  text(2,40,'C 15:','Color',map(15,:),'FontSize',10)
  text(2,30,'C 16:','Color',map(16,:),'FontSize',10)
  
  text(39,180,'failed to reset time','Color',string(col(1)),'FontSize',10)
  text(39,170,'controller modified speed measurement','Color',string(col(2)),'FontSize',10)
  text(39,160,'control  will violate lower speed limit','Color',string(col(3)),'FontSize',10)
  text(39,150,'control  will violate upper speed limit','Color',string(col(4)),'FontSize',10)
  text(39,140,'control will make car go in reverse','Color',string(col(5)),'FontSize',10)
  text(39,130,'control exceeds upper acceleration limit','Color',string(col(6)),'FontSize',10)
  text(39,120,'control  exceeds braking limit','Color',string(col(7)),'FontSize',10)
  text(39,110,'brake incompatible with speed limit ','Color',string(col(8)),'FontSize',10)
  text(39,100,'acceleration incompatible with speed limit ','Color',string(col(9)),'FontSize',10)
  text(39,90,'invalid speed limit (violates vl < vh)','Color',string(col(10)),'FontSize',10)
  text(39,80,'invalid speed limit  (violates 0<=vl)','Color',string(col(11)),'FontSize',10)
  text(39,70,'invalid goal (not on tube to origin)','Color',string(col(12)),'FontSize',10)
  text(39,60,'invalid goal (not on tube to origin)','Color',string(col(13)),'FontSize',10)
  text(39,50,'invalid tube (exceeds curve radius)','Color',string(col(14)),'FontSize',10)
  text(39,40,'invalid tube (goal not ahead of car)','Color',string(col(15)),'FontSize',10)
  text(39,30,'invalid steering (not in direction of goal)','Color',string(col(16)),'FontSize',10)
  drawnow
  hold off
  
  
  
  %% plotting values
  h3 = subplot(2,2,3);
  
  hold on
  %pos = [pos_x(ind)-(abs(n_val(ind))/2),  pos_y(ind)-(abs(n_val(ind))/2),abs(n_val(ind)),abs(n_val(ind))];
  
  if ver_id(ind) <0
      min_val = min(ver_val(ver_id==ver_id(ind)));
      val = (ver_val(ind))/min_val;
      val = max(val, 0.05);
      pos = [pos_x(ind)-(val/2),  pos_y(ind)-(val/2),val,val];
      
      rectangle('Position',pos,'Curvature',[1 1], 'EdgeColor', map(abs(ver_id(ind)),:))
  else
      val = (ver_val(ind))/max_val;
      val = max(val, 0.05);
      pos = [pos_x(ind)-(val/2),  pos_y(ind)-(val/2),val,val];
      rectangle('Position',pos,'Curvature',[1 1], 'EdgeColor', 'green')
  end
  axis([-2 4 -2 4])
  title('Safety Margin (green is safe)')
  xlabel('Position X(m)')
  ylabel('Position y(m)')
  drawnow
  
   %% plotting vals
  h4 = subplot(2,2,4);
  hold on
  title('Safety Margin')
  xi = ind -i+1;
  if ver_id(ind) ==1
      if val==0.05
          val=0;
      end
      plot(xi, val,'g*')
      %text(0,3.5,'Monitor: Safe','Color','green','FontSize',15)
  else
      plot(xi, -val,'*','Color', map(abs(ver_id(ind)),:))
      if ver_id(ind)~= prev_id
          %text(xi,-val,'\leftarrow'+ string(abs(ver_id(ind))),'FontSize',10, 'Clipping', 'on')
          prev_id = ver_id(ind);
      end
          
  end
 plot([xi-1,xi], [0,0], 'b-')
  %plot(wpt_y(ind), wpt_x(ind),'b*' )
  %plot(wpt_x(ind-2:ind), wpt_y(ind-2:ind), 'y-')
  xlabel('Time step')
  ylabel('Safety margin') 
  %axis([max(0, xi-150) max(150, xi) -1.2 1.2])
  drawnow
%   
%   
%   
%   
  F2(j) = getframe(gcf);
  j = j+1;
  pause(0.01)
end



%% generate videos
frame_rate = length(ver_id)/(end_time - start_time)

%% video 2
writerObj2 = VideoWriter('rs1_new_plot_v2.avi');
writerObj2.FrameRate = 26;
open(writerObj2);
for i=1:length(F2)
    % convert the image to a frame
    frame = F2(i) ;    
    writeVideo(writerObj2, frame);
end
close(writerObj2);