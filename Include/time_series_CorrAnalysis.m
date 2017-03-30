% Propose: primary analysis of time series: acf and pacf
% Author: Kevin
% Date: March 30th, 2017

function [acf, pacf]=time_series_CorrAnalysis(ts, max_lags)
if (nargin<2)
    max_lags=length(ts)/2;
    warning('Default acf and pacf length: half of input time series length!!');
end
if(nargin<1)
    error('Illegal input!!'); exit;
end

figure;
%plot acf
subplot(2,1,1);
autocorr(ts,max_lags); 
[acf, lags, bounds]=autocorr(ts,max_lags); 
xlim([1 max_lags]);
uconf = 1.96/sqrt(1000);
lconf = -uconf;
hold on;
plot([1 max_lags],[1 1]'*[lconf uconf],'r');
grid;

%plot pacf
subplot(2,1,2);
[arcoefs,E,K] = aryule(ts,max_lags);
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
hold off;
end