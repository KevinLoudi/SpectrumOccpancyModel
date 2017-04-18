% Propose: time series tendency and seasonal fitler 
% Author: Kevin
% Date: March 30th, 2017

function [Tendency,Seasonal,DeTendency]=time_series_season_tendency(ts, time, periods)
if(nargin<3)
    warning('Automaticly set periodic as 24!!'); 
    periods=24;
end

y = reshape(ts, length(ts), 1);
T = length(y);
time_num=datenum(time'); 

figure
subplot(3,1,1);
plot(time_num,y); datetick;
title('SCR-H序列确定性趋势','FontSize',12);
ylabel('SCR值','FontSize',12);
hold on;

sW13 = [1/(2*periods);repmat(1/periods,periods-1,1);1/(2*periods)];
yS = conv(y,sW13,'same');
yS(1:6) = yS(7); yS(T-5:T) = yS(T-6);

xt = y-yS;

h = plot(time_num, yS,'r','LineWidth',2); datetick;
legend(h,'24-期 滑动平均值','FontSize',12)
hold off;
Tendency=yS;

s = periods;
sidx = cell(s,1);
for i = 1:s
 sidx{i,1} = i:s:T;
end

sidx{1:2};

sst = cellfun(@(x) mean(xt(x)),sidx);

% Put smoothed values back into a vector of length N
nc = floor(T/s); % no. complete years
rm = mod(T,s); % no. extra months
sst = [repmat(sst,nc,1);sst(1:rm)];

% Center the seasonal estimate (additive)
sBar = mean(sst); % for centering
sst = sst-sBar;

subplot(3,1,2);
plot(time_num, sst); datetick;
Seasonal=sst;
title('季节性分量','FontSize',12);
ylabel('SCR值','FontSize',12);

dt = y - sst;
DeTendency=dt;
subplot(3,1,3);
plot(time_num, dt); datetick;
title('去除周期后的SCR-H序列分量','FontSize',12);
ylabel('SCR值','FontSize',12);
end