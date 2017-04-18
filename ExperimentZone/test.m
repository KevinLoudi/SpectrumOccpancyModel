
%see the stationary of time series
load Data_Canada
Y = DataTable.INF_C;
%Test a time series for a unit root 
[h,pValue] = adftest(Y)
%% 

load Data_GDP;
Y = log(Data);
plot(Y)
%Test for a unit root against a trend-stationary alternative, 
%augmenting the model with 0, 1, and 2 lagged difference terms.
h = adftest(Y,'model','TS','lags',0:5)

%% see the autocorrelation of time series
load Data_MarkPound;
returns = price2ret(Data);
res = returns - mean(returns);
%h1 = 0 indicates that there is not enough evidence to reject the null hypothesis
% that the residuals of the returns are not autocorrelated.
[h,pValue] = lbqtest(res,'lags',[5,10,15])

%% 
a=rand(1000,1);
time_series_CorrAnalysis(a,150);

