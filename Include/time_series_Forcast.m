% Propose: ARIMA forcast 
% Author: Kevin
% Date: March 30th, 2017

function time_series_Forcast(ts,time,est,p,q,d,P,Q,D,season)
if(nargin<10)
    error('Lack parameters!!'); return;
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
EstMdl_all=estimate(Mdl,Y,'X',time_num);
[Ew,Vw] = infer(EstMdl_all,Y);
figure;
subplot(3,1,1);
plot(Ew); title('模型残差','FontSize',12);
xlabel('样本标号','FontSize',12); ylabel('残差值','FontSize',12); 

subplot(3,1,2); 
histogram(Ew,50,'Normalization','probability'); title('模型残差分布','FontSize',12); 
xlabel('残差值','FontSize',12); ylabel('样本频率','FontSize',12); hold on;
y = min(Ew):0.02:max(Ew);
pd = fitdist(Ew,'Normal');
f =pdf(pd,y);
plot(y,f/length(Ew),'LineWidth',1.5); hold off;

subplot(3,1,3);
qqplot(Ew); title('残差QQ图','FontSize',12);
xlabel('标准正态分位数','FontSize',12); ylabel('样本分位数','FontSize',12);



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