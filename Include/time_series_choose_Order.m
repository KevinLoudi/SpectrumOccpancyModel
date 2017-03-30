% Propose: choose ARIMA order
% Author: Kevin
% Date: March 30th, 2017

%p,q,d : ARIMA(p,d,q)
function [p,q,d]=time_series_choose_Order(ts, max_p, max_q, max_d, season)
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
for p = 1:max_p
    for q = 1:max_q
        mod = arima('D',0,'Seasonality',season,'ARLags',p,'MALags',q);
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
[~,bic] = aicbic(log_likehood,pq_sum+1,100);
BicTable=reshape(bic,max_p,max_q);

%choose order from bic table according to the smallesr bic
[maxBic,ind] = min(BicTable(:));
[p,q]= ind2sub(size(BicTable),ind);
d=0;

%Residuals and Conditionall variances
mod=arima('D',0,'Seasonality',season,'ARLags',p,'MALags',q);
mod.Constant=constant;
[Ew,Vw] = infer(mod,ts);
figure;
subplot(3,1,1);
plot(Ew); title 'Inferred Residuals';

subplot(3,1,2);
plot(Vw,'r','LineWidth',2);
hold on;
plot(V);
legend('Without Presample','With Presample');
title 'Inferred Conditional Variances';
hold off

subplot(3,1,2);
plot(Vw(1:5),'r','LineWidth',2);
hold on;
plot(V(1:5));
legend('Without Presample','With Presample');
title 'Beginning of Series';
hold off


end