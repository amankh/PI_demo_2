%plot_data
load('drift_2_data.mat')

fig1=figure('Position', [10, 10, 900, 900]);
hold on

c = lines(16);
i =1;
for ind=300:2:length(pos_x)
    
  if ver_id(ind) ==1
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'g')
      %text(0,3.5,'Monitor: Safe','Color','green','FontSize',15)
      title('Monitor: Safe', 'color', 'green')
  else
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'color', 'r')
      %text(0,3.5,'Monitor: Unsafe','Color','red','FontSize',15)
      str1 = 'Monitor:Unsafe [Condition ' + string(abs(ver_id(ind))) + ' violated]';
      title(str1, 'color', 'red')
  end
  %title(str1)
  axis([-2 4 -2 4])
  hold on
  F1(i) = getframe(gcf);
  i = i+1;
  drawnow
  
  pause(0.03)
end
close all

%% generate videos
frame_rate = length(ver_id)/(end_time - start_time)


%% video 1
writerObj = VideoWriter('safe_unsafe.avi');
writerObj.FrameRate = 26;
open(writerObj);
for i=1:length(F1)
    % convert the image to a frame
    frame = F1(i) ;    
    writeVideo(writerObj, frame);
end
close(writerObj);
