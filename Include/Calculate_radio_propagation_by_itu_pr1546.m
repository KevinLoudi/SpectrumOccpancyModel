% Propose: Calculate radio propagation loss through ITU.P.R-1546 model,
%    uint dB muV/m
% Author: Kevin
% Date: March 29th, 2017

%distance: trans to receiver distance
%frequence: carrier frequence
%trans_height: transmitter effective antenna height 
%rece_height: reciever antenna height
%t_ratio: Percentage time defined
%terrin: Height of base antenna above terrain
%path_str: 'Land','Sea','Warm','Cold',, type of field strength
%tca:terrain clearance angle (degrees)
%environment_str: 'land','urban','dense',''open
function [Loss]=Calculate_radio_propagation_by_itu_pr1546(distance,frequence,trans_height...
          terrin ,t_ratio,tca,rece_height,path_str,environment_str,default_case)
   
   if(default_case==1||nargin<10)
       warning('Using default set up!!');
       distance=10; frequence=100; trans_height=100; rece_height=5;
       t_ratio=50; tca=10;
   end
       Loss=P1546FieldStr(distance,frequence,t_ratio,trans_height,terrin)...
    -Step_12(frequence,tca)-Step_14(rece_height,frequence,path_str,...
    environment_str,distance,trans_height);

end



