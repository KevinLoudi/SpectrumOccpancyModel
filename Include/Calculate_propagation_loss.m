% Propose: Calculate radio propagation loss through ITU.P.R-1546 model,
%    uint dB muV/m
% Author: Kevin
% Date: March 29th, 2017

%distance_range: trans to receiver distance
%frequence: carrier frequence
%trans_height: transmitter effective antenna height 
%rece_height: reciever antenna height
%t_ratio: Percentage time defined
%terrin: Height of base antenna above terrain
%path_str: 'Land','Sea','Warm','Cold',, type of field strength
%tca:terrain clearance angle (degrees)
%environment_str: 'land','urban','dense',''open

%example: 
 %           addpath('D:\\Code\\WorkSpace\\SpectrumModel\\ExperimentZone\\itu_pr1546')
%            [Loss]=Calculate_radio_propagation(20,100,100...
%          ,50 ,50,10,5,'Land','dense',0)
function [Loss]=Calculate_propagation_loss(distance_range,frequence,trans_height...
          ,terrin ,t_ratio,tca,rece_height,path_str,environment_str)
   
   if(nargin<9)
       warning('Using default set up!!');
       distance_range=10; frequence=100; trans_height=100; terrin=100; rece_height=5;
       t_ratio=50; tca=10; path_str='Land'; environment_str='dense';
   end
   
   %distance in the model should greater than 1
   ix=find(distance_range<1); 
   distance_range(ix)=1;
   
   len=length(distance_range); 
   for i=1:len
    Loss(i)=P1546FieldStr(distance_range(i),frequence,t_ratio,trans_height,terrin)...
      -Step_12(frequence,tca)-Step_14(rece_height,frequence,path_str,...
      environment_str,distance_range,trans_height);
   end

end



