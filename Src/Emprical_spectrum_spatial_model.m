% Propose: Emprical data-drived spatial spectrum model
% Author: Kevin
% Environment: Matlab 2015b
% Date: March 31th, 2017

clear; clc; close all;
spatial_data_Prepare();
%% 
% for process part, turn to .R file

%% 
path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas';
path=Join_string({path,'\\%s'});
load(sprintf(path, 'Position(2015).mat'));
load(sprintf(path,'StatData2.mat'));
load(sprintf(path,'StatGrids.mat'));

%% 
% mesh(grid_x,grid_y,distance);
imagesc(distance);

