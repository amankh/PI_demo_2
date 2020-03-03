%plot_data
close all
clear

load('drift_2_data.mat')

fig2=figure('Position', [10, 10, 900, 900]);
hold on

col = cell(18,1);
col(:) = {'black'};

j = 1;
i= 400;
map = copper(16);
%map(:,2) = 0;
for ind=i:length(pos_x)
    
    %colors
   col(:) = {'black'};
    
    %% Plotting trajectory
  h1 = subplot(2,2,1);
  %cla(h1)
  hold on
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
  drawnow
  %hold off
  %% plotting text
  
  h2 = subplot(2,2,2 );
  cla(h2)
  axis([0 50 0 240])
  hold on
  %text(2,220,'Controller: CPO','Color',string(col(17)),'FontSize',14)
  text(2,200,'Monitor: KeymeraX','Color',string(col(18)),'FontSize',14)
  text(2,180,'Condition 1:','Color',map(1,:),'FontSize',12)
  text(2,170,'Condition 2:','Color',map(2,:),'FontSize',12)
  text(2,160,'Condition 3:','Color',map(3,:),'FontSize',12)
  text(2,150,'Condition 4:','Color',map(4,:),'FontSize',12)
  text(2,140,'Condition 5:','Color',map(5,:),'FontSize',12)
  text(2,130,'Condition 6:','Color',map(6,:),'FontSize',12)
  text(2,120,'Condition 7:','Color',map(7,:),'FontSize',12)
  text(2,110,'Condition 8:','Color',map(8,:),'FontSize',12)
  text(2,100,'Condition 9:','Color',map(9,:),'FontSize',12)
  text(2,90,'Condition 10:','Color',map(10,:),'FontSize',12)
  text(2,80,'Condition 11:','Color',map(11,:),'FontSize',12)
  text(2,70,'Condition 12:','Color',map(12,:),'FontSize',12)
  text(2,60,'Condition 13:','Color',map(13,:),'FontSize',12)
  text(2,50,'Condition 14:','Color',map(14,:),'FontSize',12)
  text(2,40,'Condition 15:','Color',map(15,:),'FontSize',12)
  text(2,30,'Condition 16:','Color',map(16,:),'FontSize',12)
  
  text(29,180,'valid','Color',string(col(1)),'FontSize',12)
  text(29,170,'valid','Color',string(col(2)),'FontSize',12)
  text(29,160,'valid','Color',string(col(3)),'FontSize',12)
  text(29,150,'valid','Color',string(col(4)),'FontSize',12)
  text(29,140,'valid','Color',string(col(5)),'FontSize',12)
  text(29,130,'valid','Color',string(col(6)),'FontSize',12)
  text(29,120,'valid','Color',string(col(7)),'FontSize',12)
  text(29,110,'valid','Color',string(col(8)),'FontSize',12)
  text(29,100,'valid','Color',string(col(9)),'FontSize',12)
  text(29,90,'valid','Color',string(col(10)),'FontSize',12)
  text(29,80,'valid','Color',string(col(11)),'FontSize',12)
  text(29,70,'valid','Color',string(col(12)),'FontSize',12)
  text(29,60,'valid','Color',string(col(13)),'FontSize',12)
  text(29,50,'valid','Color',string(col(14)),'FontSize',12)
  text(29,40,'valid','Color',string(col(15)),'FontSize',12)
  text(29,30,'valid','Color',string(col(16)),'FontSize',12)
  drawnow
  hold off
  
  F2(j) = getframe(gcf);
  j = j+1;
   
  pause(0.01)
end



%% generate videos
frame_rate = length(ver_id)/(end_time - start_time)

%% video 2
writerObj2 = VideoWriter('Condittions2.avi');
writerObj2.FrameRate = 26;
open(writerObj2);
for i=1:length(F2)
    % convert the image to a frame
    frame = F2(i) ;    
    writeVideo(writerObj2, frame);
end
close(writerObj2);