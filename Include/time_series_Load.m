% Propose: load spectrum time series- scr, cvd
% Author: Kevin
% Date: March 30th, 2017

%ts: time series (array)
%time: time stamps (datetime)
%ts_info: time series information (string)
function [ts,time,ts_info]=time_series_Load(type_str)
  if(nargin<1)
      type_str='scr';
  end
% ts; time; ts_info;
  if(strcmp(type_str,'scr'))
      data_path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\%s';
      load(sprintf(data_path, 'Timeindex_1710_1740.mat')); %tot_time
      load(sprintf(data_path, 'Duty_cycle_1710_1740.mat')); %dc
      
      %preprocessing
     time=datetime(tot_time,'InputFormat','yyyy-MM-dd HH:mm:SS');
     ts=dc;
     nan_ix=find(ts==0);
     ts(nan_ix)=[]; time(nan_ix)=[];
     ts_info='GSM 1800 DL/ SCR/ 1710-1740MHz/ 7 days';;
  else
     error('Dataset do not exist!!!'); exit;
  end
end