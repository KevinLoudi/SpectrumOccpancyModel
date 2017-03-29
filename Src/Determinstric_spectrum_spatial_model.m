% Propose: generate a determinstic spectrum map with random field 'terrin'
%   and random point process  "transmitter distribution"
% Author: Kevin
% Date: March 29th, 2017


%% Simulation of PU
clear; clc;
pu_info_obj.frequency=1800; %MHz carrier signal frequence
pu_info_obj.trans_height=100; %m  transmitter effective antenna height 
pu_info_obj.t_ratio=50; %50% Percentage time defined
pu_info_obj.tca=10; %degree terrain clearance angle
pu_info_obj.rec_height=5; %m  reciever antenna height
pu_info_obj.path_type='Land';
pu_info_obj.environment='dense';
energy_mat=Simulation_primary_user_propagation(pu_info_obj,51,50);

