% Propose: generate a determinstic spectrum map with random field 'terrin'
%   and random point process  "transmitter distribution"
% Author: Kevin
% Date: March 29th, 2017

clear; clc; close all;
%% Generate terrin height as random field
grids_num=51;
[X,Y,Z]=Generate_random_field(grids_num);
Z=Normalize(Z);
figure(1);
surf(X,Y,Z); view(2); colorbar;

%% Generate random distributed transmitters
trans_num=5;
[trans_X, trans_Y]=Distribute_random_points(trans_num);
figure(2);
scatter(trans_X,trans_Y);

%% Calculate radio propagation loss through ITU.P.R-1546 model


