%plot_data
load('drift_2_data.mat')

fig2=figure('Position', [10, 10, 900, 900]);
hold on

col = cell(18,1);
col(:) = 'grey';
for ind=300:2:length(pos_x)
    
    %colors
    c(:) = 'grey';
    
    %% Plotting trajectory
    subplot(2,2,1)
  if ver_id(ind) ==1
      c(:) = 'green';
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'g-')
  else
      c(1) = 'red';
      c(ver_id)
      plot(pos_x(ind-2: ind),pos_y(ind-2:ind),'r-')
  end
  axis([-2 4 -2 4])
  hold on
  drawnow
  
  %% plotting text
  subplot(2,2,2 )
  axis([0 100 0 220])
  hold on
  text(2,200,'Controller: CPO','Color','red','FontSize',14)
  text(2,190,'Monitor: KeymeraX','Color','red','FontSize',14)
  text(2,180,'Condition 1:','Color','red','FontSize',12)
  text(2,170,'Condition 2:','Color','red','FontSize',12)
  text(2,160,'Condition 3:','Color','red','FontSize',12)
  text(2,150,'Condition 4:','Color','red','FontSize',12)
  text(2,140,'Condition 5:','Color','red','FontSize',12)
  text(2,130,'Condition 6:','Color','red','FontSize',12)
  text(2,120,'Condition 7:','Color','red','FontSize',12)
  text(2,110,'Condition 8:','Color','red','FontSize',12)
  drawnow
  hold on
   
  pause(0.001)
end