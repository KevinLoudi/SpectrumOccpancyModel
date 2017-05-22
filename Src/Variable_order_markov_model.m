% Propose: Variable-order markov model for prediction
% Author: Kevin
% Environment: Matlab 2015b
% Date: May 18th, 2017

clear; clc; close all;
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Tools\\ContextTreeWeightedHMM');

%% Generate sim-dataset
noise_mu=10; noise_theate=3;
len=1e4; lamda=5; p=0.8; s_num=5;
[traffic_data,traffic,r]=M_Geo_C_model(noise_mu,noise_theate,len,lamda,p,s_num);
seq_str=Join_string(traffic);

%% Prepare inputs
alp = alphabet(seq_str);
split_point=length(seq_str)-10;
seq_train=seq_str(1:split_point);
seq_test=seq_str((split_point+1):end); 

disp('---------------------------------------------------');
disp('working with AB={0,1}');
disp('---------------------------------------------------');
disp(' ');

%% Set model parameters
ALGS = {'LZms', 'LZ78', 'PPMC', 'DCTW', 'PST'};
params.ab_size = size(alp);
params.d = 10;  %maxmium order of VMM order %D
params.m = 2; %only for LZ-MS
params.s = 8; %only for LZ-MS
params.pMin = 0.006; %only for PST
params.alpha= 0; %only for PST
params.gamma = 0.0006; %only for PST
params.r = 1.05; %only for PST
params.vmmOrder = params.d; 

%% Traning and prediction
for i=1:length(ALGS),
    disp(sprintf('Working with %s', ALGS{i} ));
    disp('--------')
    %create a VMM through training 
    jVmm = vmm_create(map(alp, seq_train),  ALGS{i}, params);
    disp(sprintf('Pr(0 | 00) = %f', vmm_getPr(jVmm, map(alp,'0'), map(alp,'00'))));
    disp(sprintf('Pr(1 | 00) = %f', vmm_getPr(jVmm, map(alp,'1'), map(alp,'00'))));
    % calculates the length in bits of the  "compressed" representation of
    % seq.  -log[ Pr ( seq | jVmm) ]
    disp(sprintf('-lg(Pr(tar))=%f', vmm_logEval(jVmm,map(alp, seq_test))));
    disp('--------')
    disp(' ');
end

%% Cross-vaildation
%split the origianal dataset into 5 parts
split_point=[1, floor(length(seq_str)/5),floor(2*length(seq_str)/5),floor(3*length(seq_str)/5),...
    floor(4*length(seq_str)/5), length(seq_str)];
datasets=cell(1,5);
for i=1:5
    datasets{i}=seq_str(split_point(i):split_point(i+1));
end
train_sets=strcat(datasets{1},datasets{2},datasets{4},datasets{5});
test_sets=datasets{3};

%randomly set trainning and predicting dataset selection
%select a point to start prediction test
rand_sel=floor((length(test_sets)-10)*rand());
context=test_sets(rand_sel-10:rand_sel); %condition
rcs=test_sets((rand_sel+1):(rand_sel+10));%real channel status
pre_steps=length(rcs); %would-be prediction steps
pre_states=zeros(1,pre_steps); %array to preserve prediction results

display('Test prediction ability....');

%conduct repeated test
test_len=20:20:2000;
test_times=length(test_len);
for time=1:test_times
train_sets_tmp=train_sets(1:test_len(time));
%conduct prediction test
ALGS={'PPMC'};
for ii=1:length(ALGS),
    disp(sprintf('Working with %s', ALGS{ii} ));
    disp('--------')
  for i=1:pre_steps
    jVmm = vmm_create(map(alp, train_sets_tmp),  ALGS{ii}, params); %create model
    p_0=vmm_getPr(jVmm, map(alp,'0'), map(alp,context));
    p_1=vmm_getPr(jVmm, map(alp,'1'), map(alp,context)); %get prediction probability for both status
    %decide the prediction result
    if p_0>p_1
        pre_states(i)=0;
    else
        pre_states(i)=1;
    end
    %update context
    context(1)=[];
    context=strcat(context, rcs(i));
  end
  %display(sprintf('Prediction results of %s', ALGS{ii}));
  pre_cs=Join_string(pre_states)
  err=(pre_cs-rcs);
  %display(sprintf('Error rate of %s: ', ALGS{ii}, num2str(sum(abs(err))/length(err))));
end
end





