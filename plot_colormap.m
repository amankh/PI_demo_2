%plot_data

close all 
clear 
load('rs1_data.mat')


fig2=figure('Position', [10, 10, 900, 900]);
hold on
c = autumn(16);
i = 1;
for ind=4:2:1000
    
  if ver_id(ind) ==1
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'g')
      %text(0,3.5,'Monitor: Safe','Color','green','FontSize',15)
      title('Monitor: Safe', 'color', 'green')
  else
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'color', c(abs(ver_id(ind)),:))
      %text(0,3.5,'Monitor: Unsafe','Color','red','FontSize',15)
      str1 = 'Monitor:Unsafe [Condition ' + string(abs(ver_id(ind))) + ' violated]';
      title(str1, 'color', 'red')
  end
  %title(str1)
  axis([-2 4 -2 4])
  xlabel('Position X in m')
  ylabel('Position Y in m')
  hold on
  
  F2(i) = getframe(gcf);
  i = i+1;
  
  drawnow
  pause(0.03)
end

%% generate videos
frame_rate = length(ver_id)/(end_time - start_time)

%% video 2
writerObj2 = VideoWriter('rs1_colormap.avi');
writerObj2.FrameRate = 27;
open(writerObj2);
for i=1:length(F2)
    % convert the image to a frame
    frame = F2(i) ;    
    writeVideo(writerObj2, frame);
end
close(writerObj2);