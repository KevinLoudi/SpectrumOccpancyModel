% Propose: refine and cut-off time series
% Author: Kevin
% Date: March 30th, 2017

%ts: time series  time: time stamps
%period: refine period
function [ts_new,time_new]=time_series_Refine(ts, time ,period)
  if(nargin<3)
      period=hours(1); 
      warning('Defaultly set period as an hour');
  end
  if(nargin<2)
      error('Incorrect input!!'); exit;
  end
  
  start_time=time(1); end_time=time(end);
  %ts_period=0; time_ix=0;
  t=start_time;  i=1;
  while t<end_time
    %locate sample within an hout
    interval=find((time>=t)&(time<(t+period)));
    %average sample value within the period
    ts_period(i)=sum(ts(interval))/length(interval);
    time_ix(i)=t;
    i=i+1;
    t=t+period;
  end

  ts_new=ts_period;
  time_new=time_ix;
end