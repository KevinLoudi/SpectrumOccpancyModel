% Propose: ARIMA forcast 
% Author: Kevin
% Date: March 30th, 2017

function time_series_Forcast(ts,time,est,p,q,d,P,Q,D,season)
if(nargin<10)
    error('Lack parameters!!'); exit;
end

%build model, parameters cannot be zero
Mdl = regARIMA('D',0,'Seasonality',season,'ARLags',p,'MALags',q,...
    'Intercept',0);
% Mdl = regARIMA('D',D,'Seasonality',season,'ARLags',p,'MALags',q,'SARLags',P,'SMALags',...
%     Q,'Intercept',0);
% Mdl.Constant=constant;
Y=reshape(ts,length(ts),1);


%prepare estimation and forcast data set
T=length(time);
estInds=1:est; %model estimation period
nSim=T-length(estInds); %model forcast period
foreInds = (T-nSim+1):T;

%estimate model
time_num=datenum(time'); %double-type date time
EstMdl = estimate(Mdl,Y(estInds),'X',time_num(estInds));

%valid model
[Ew,Vw] = infer(EstMdl,Y(estInds));
figure;
subplot(3,1,1);
plot(Ew); title 'Inferred Residuals';

subplot(3,1,2);
plot(Vw,'r','LineWidth',2);
title 'Inferred Conditional Variances';

%forcast model
[YF,YMSE] = forecast(EstMdl,nSim,'X0',time_num(estInds),...
    'Y0',Y(estInds),'XF',time_num(foreInds));
ForecastInt = [YF,YF] + 1.96*[-sqrt(YMSE), sqrt(YMSE)];

%plot forcast results
figure;
h1 = plot(time_num,Y);
title('{\bf Forecasted Monthly Passenger Totals}');
hold on
h2 = plot(time_num(foreInds),YF,'Color','r','LineWidth',2);
h3 = plot(time_num(foreInds), ForecastInt,'k--','LineWidth',2);
datetick;
legend([h1,h2,h3(1)],'Observations','MMSE Forecasts',...
    '95% MMSE Forecast Intervals','Location','NorthWest');
axis tight;
hold off;

end