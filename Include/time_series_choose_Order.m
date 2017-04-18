% Propose: choose ARIMA order
% Author: Kevin
% Date: March 30th, 2017

%p,q,d : ARIMA(p,d,q)
function [p,q,d,BicTable]=time_series_choose_Order(ts, max_p, max_q, max_d, season)
 if(nargin<5)
     max_p=4; max_q=4; max_d=4; season=24;
     warning('Defaultly set maximum order as 4!!');
 end

 ts=reshape(ts, length(ts), 1);
 log_likehood=zeros(max_p, max_q);
 pq_sum = zeros(max_p,max_q);
 ts_min=sort(ts,'ascend');
 constant=sum(ts_min(1:10))/10;
 
 %select d to make time series stationary
 
 
 %estimate model with different ARMA order
for p = 0:max_p
    for q = 0:max_q
        if (p~=0)&&(q~=0)
           mod = arima('D',0,'Seasonality',season,'ARLags',p,'MALags',q);
        elseif(p==0)
           mod = ar(Y, N)('D',0,'Seasonality',season,'MALags',q,'SMALags',1);
        elseif(q==0)
           mod = arima('D',0,'Seasonality',season,'ARLags',p); 
        else
           error('Illegal model order!!');
        end
        %arima('D',0,'Seasonality',24,'ARLags',p,'MALags',q,'SMALags',1);
        mod.Constant=constant;
        [fit,~,logL] = estimate(mod,ts,'print',false);
        log_likehood(p,q) = logL;
        pq_sum(p,q) = p+q;
     end
end

%generate a bic table
log_likehood = reshape(log_likehood,max_p^2,1);
pq_sum = reshape(pq_sum,max_q^2,1);
[~,aic] = aicbic(log_likehood,pq_sum+1,100);
BicTable=reshape(aic,max_p,max_q);

%choose order from bic table according to the smallesr bic
[maxBic,ind] = min(BicTable(:));
[p,q]= ind2sub(size(BicTable),ind);
d=0;

end