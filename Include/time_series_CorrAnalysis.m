% Propose: primary analysis of time series: acf and pacf
% Author: Kevin
% Date: March 30th, 2017

function [acf, pacf,d]=time_series_CorrAnalysis(ts, max_lags)
if (nargin<2)
    max_lags=length(ts)/2;
    warning('Default acf and pacf length: half of input time series length!!');
end
if(nargin<1)
    error('Illegal input!!'); return;
end

%test stationary and autocorrelation
display('Conduct ADF test ....');
d=0;
[h,pValue] = adftest(ts,'model','TS');
if h==0
    fprintf('Not stationary, Test Result = %d, pValue = %f\n', h, pValue);
    %difference time series until reach stationary
    while h==0
        d=d+1;
        tmp_ts=diff(ts,d);
        [h,pValue] =adftest(tmp_ts,'model','TS');
    end
    fprintf('Reach stationary after %d - order difference, with  pValue = %f \n', d, pValue);
    figure; plot(tmp_ts); title('stationary time series after difference!!');
    ts=diff(ts,d); %do 1-stage difference
else
    fprintf('Reject not stationary, Test Result = %d, pValue = %f\n', h, pValue);
end
display('Conduct LB test ...');
[h,pValue] = adftest(ts);
if h==0
    fprintf('Auto-correlated, Test Result = %d, pValue = %f\n', h, pValue);
else
    fprintf('Reject auto-correlated, Test Result = %d, pValue = %f\n', h, pValue);
end
display('Conduct LM test ...');
[h,pValue] = archtest(ts);
if h==0
    fprintf('No heteroscedasticity, Test Result = %d, pValue = %f\n',h, pValue);
else
    fprintf('Reject no heteroscedasticity, Test Result = %d, pValue = %f\n', h, pValue);
end

%plot acf
figure;
subplot(2,1,1);
autocorr(ts,max_lags); 
[acf, lags, bounds]=autocorr(ts,max_lags); 
title('')
xlim([1 max_lags]);
uconf = 1.96/sqrt(1000);
lconf = -uconf;
hold on;
plot([1 max_lags],[1 1]'*[lconf uconf],'r');
title('自回归函数（ACF）', 'FontSize', 12); xlabel('滞后期数', 'FontSize', 12); ylabel('ACF', 'FontSize', 12);
grid on;

%plot pacf
subplot(2,1,2);
[arcoefs,E,K] = aryule(ts,max_lags);
pacf = -K;
stem(pacf,'filled');
xlabel('滞后期数', 'FontSize', 12);
ylabel('PACF', 'FontSize', 12);
title('偏自回归函数（PACF）', 'FontSize', 12);
xlim([1 max_lags]);
uconf = 1.96/sqrt(1000);
lconf = -uconf;
hold on;
plot([1 max_lags],[1 1]'*[lconf uconf],'r');
grid;
hold off;
end