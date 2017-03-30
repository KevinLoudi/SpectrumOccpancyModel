figure(3)
h1 = plot(time_num,Y);
title('{\bf Forecasted Monthly Passenger Totals}')
hold on
h2 = plot(time_num(foreInds),YF,'Color','r','LineWidth',2);
h3 = plot(time_num(foreInds),ForecastInt,'k--','LineWidth',2);
% datetick('x','HHPM');
legend([h1,h2,h3(1)],'Observations','MMSE Forecasts',...
    '95% MMSE Forecast Intervals','Location','NorthWest')
% axis tight
hold off