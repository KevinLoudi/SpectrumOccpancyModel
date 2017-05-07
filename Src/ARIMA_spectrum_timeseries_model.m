% Propose: SARIMA-based spectrum statistics time series modelling and
%     forcasting
% Author: Kevin
% Date: March 30th, 2017

clc; clear; close all;
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
%% Data pre-process
[ts,time,ts_info]=time_series_Load('scr');
time_num=datenum(time'); 
figure; 
%plot(time_num,ts,'--','Color','b','LineWidth',0.6); datetick; hold on;
scatter(time_num,ts,6,'filled'); hold on;
[ts,time]=time_series_Refine(ts,time);
time_num=datenum(time'); 
plot(time_num,ts,'Color','g','LineWidth',0.6); datetick; hold off;
xlabel('时间','FontSize',12); ylabel('SCR值','FontSize',12); legend('SCR序列','SCR-H序列','FontSize',12);

path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/scr_h';
%print(path,'-dpng','-r500');
%% 
close all;
[acf,pacf,d]=time_series_CorrAnalysis(ts,150);
path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/acf_pacf';
print(path,'-dpng','-r500');
%% Seasonal and tendency analysis
close all;
[Tendency,Seasonal,DeTendency]=time_series_season_tendency(ts, time, 24);
path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/scr_h_decompose';
print(path,'-dpng','-r500');
%% ARIMA model build
[p,q,d_r,AIC]=time_series_choose_Order(ts,6,6,2,24);

%% ARIMA forcast
d=0;
time_series_Forcast(ts,time,135,p,q,d,0,0,0,24);
path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/scr_h_resuid';
print(path,'-dpng','-r500');
%% GARCH process
Mdl = garch('GARCHLags',1,'ARCHLags',1,'Offset',NaN);

%% 
% figure(1);
% path='D:\\doc\\PapaerLibrary\\Figures\\Draft_6_figs\\acf_pacf';
%  print(path,'-dpng','-r500');
 
%  figure(3);
%  path='D:\\doc\\PapaerLibrary\\Figures\\Draft_6_figs\\forc';
%  print(path,'-dpng','-r500');





