%% 
clear; clc; close all;
data_path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\%s';
load(sprintf(data_path, 'Timeindex_1710_1740.mat')); %tot_time
load(sprintf(data_path, 'Duty_cycle_1710_1740.mat')); %dc
%% ARIMA Preparation
%delete NaN members 
ix=find(dc==0);
dc(ix)=[];
time=datetime(tot_time,'InputFormat','yyyy-MM-dd HH:mm:SS');
time(ix)=[];
start_time=time(1);
end_time=time(end);

%set one hour as a period
period=hours(1); 

t=start_time;
i=1;
while t<end_time
    %locate sample within an hout
    interval=find((time>=t)&(time<(t+period)));
    %average sample value within the period
    dc_period(i)=sum(dc(interval))/length(interval);
    time_ix(i)=t;
    i=i+1;
    t=t+period;
end
figure(1);
plot(time_ix,dc_period);

%% Demo ACF and PACF of the time series
max_lags=150;
[acf,lags] = xcorr(dc_period,max_lags,'coeff');
figure(2);
subplot(2,1,1);
% stem(lags(max_lags+1:end),acf(max_lags+1:end));
% xlabel('Lag');
% ylabel('ACF');
% title('Sample Autocorrelation Function');
% xlim([1 max_lags])
% uconf = 1.96/sqrt(1000);
% lconf = -uconf;
% hold on;
% plot([1 max_lags],[1 1]'*[lconf uconf],'r');
% grid;
autocorr(dc_period,max_lags);

subplot(2,1,2);
max_lags=150;
[arcoefs,E,K] = aryule(dc_period,max_lags);
pacf = -K;
stem(pacf,'filled');
xlabel('Lag');
ylabel('Partial ACF');
title('Partial Autocorrelation Sequence');
xlim([1 max_lags]);
uconf = 1.96/sqrt(1000);
lconf = -uconf;
hold on;
plot([1 max_lags],[1 1]'*[lconf uconf],'r');
grid;


%% Choose ARIMA model order through AIC and BIC
MAX_P=6; MAX_Q=6; 
Y=dc_period'; %does not accept multiple paths of data
LOGL = zeros(MAX_P,MAX_P); %Initialize
PQ = zeros(MAX_Q,MAX_Q);
%model specifications
Y_min=sort(Y,'ascend');
constant=sum(Y_min(1:10))/10;

%estimate model with different ARMA order
for p = 1:MAX_P
    for q = 1:MAX_Q
        mod = arima('D',0,'Seasonality',24,'ARLags',p,'MALags',q,'SMALags',1);
        mod.Constant=constant;
        [fit,~,logL] = estimate(mod,Y,'print',false);
        LOGL(p,q) = logL;
        PQ(p,q) = p+q;
     end
end
%Calculate the BIC
LOGL = reshape(LOGL,MAX_P^2,1);
PQ = reshape(PQ,MAX_Q^2,1);
[~,bic] = aicbic(LOGL,PQ+1,100);
%choose the (p,q) with smallest bic in bic matrix
BicTable=reshape(bic,MAX_P,MAX_Q);

%find maximun element index in the matrix
[maxBic,ind] = min(BicTable(:));
[p,q]= ind2sub(size(BicTable),ind);

display('Order selection finished!!!');
display('AR order: '); p,
display('MA order: '); q,
%% forcast with SARIMA(p,d,q)x(P,D,Q)s
Mdl = regARIMA('D',0,'Seasonality',24,'ARLags',p,'MALags',q,'SARLags',1,'SMALags',...
    1,'Intercept',0);
Mdl.Constant=constant;
T=length(time_ix);
estInds=1:135; %model estimation period
nSim=T-length(estInds); %model forcast period
foreInds = (T-nSim+1):T;

time_num=datenum(time_ix');
EstMdl = estimate(Mdl,Y(estInds),'X',time_num(estInds));
[YF,YMSE] = forecast(EstMdl,nSim,'X0',time_num(estInds),...
    'Y0',Y(estInds),'XF',time_num(foreInds));
ForecastInt = [YF,YF] + 1.96*[-sqrt(YMSE), sqrt(YMSE)];

%% Forcast 
figure(3)
h1 = plot(time_num,Y);
title('{\bf Forecasted Monthly Passenger Totals}')
hold on
h2 = plot(time_num(foreInds),YF,'Color','r','LineWidth',2);
h3 = plot(time_num(foreInds), ForecastInt,'k--','LineWidth',2);
datetick
legend([h1,h2,h3(1)],'Observations','MMSE Forecasts',...
    '95% MMSE Forecast Intervals','Location','NorthWest')
axis tight;
hold off;
