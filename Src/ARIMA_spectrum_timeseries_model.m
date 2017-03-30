% Propose: SARIMA-based spectrum statistics time series modelling and
%     forcasting
% Author: Kevin
% Date: March 30th, 2017

clc; clear; close all;
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
%% ARIMA model build
[ts,time,ts_info]=time_series_Load('scr');
[ts,time]=time_series_Refine(ts,time);
[acf,pacf]=time_series_CorrAnalysis(ts,150);
[p,q,d]=time_series_choose_Order(ts);

%% ARIMA forcast
time_series_Forcast(ts,time,135,p,q,d,0,0,0,24);