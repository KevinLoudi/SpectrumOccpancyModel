% Propose: generate a determinstic spectrum map with random field 'terrin'
%   and random point process  "transmitter distribution"
% Author: Kevin
% Date: March 29th, 2017


%% Simulation of PU
clear; clc;
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
pu_info_obj.frequency=100; %MHz carrier signal frequence
pu_info_obj.trans_height=200; %m  transmitter effective antenna height 
pu_info_obj.t_ratio=50; %50% Percentage time defined
pu_info_obj.tca=10; %degree terrain clearance angle
pu_info_obj.rec_height=5; %m  reciever antenna height
pu_info_obj.path_type='Land';
pu_info_obj.environment='dense';
grid_num=100;
[energy_mat,map_locations,map_height]=Simulation_primary_user_propagation(pu_info_obj,grid_num,50);

%% Plot simulation results
figure(1);

t=1;
for i=1:grid_num
    for j=1:grid_num
    X(t)=map_locations{i,j}(1,2);
    Y(t)=map_locations{i,j}(1,1);
    t=t+1;
    end
end
x=reshape(X,grid_num,grid_num);
y=reshape(Y,grid_num,grid_num);
[C,h]=contour(x(:,1),y(1,:),map_height);  ylabel('相对纬度' ,'FontSize',12); xlabel({['相对经度'],[]} ,'FontSize',12); 
c=colorbar; ylabel(c,'地形高度/m' ,'FontSize',12); 
axis equal ; 
clabel(C,h);
clabel(C,h,'FontSize',12,'Color','black');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

%% 
figure;
imagesc(X,Y,energy_mat); c=colorbar; colormap(grey);  ylabel('相对纬度' ,'FontSize',12); xlabel({['相对经度'],[]} ,'FontSize',12);  
ylabel(c,'频谱能量/dB\muV^{-1}' ,'FontSize',12); axis equal; 
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

%% Save plot results
figure(1);
path='D:\\doc\\PapaerLibrary\\Figures\\Draft_6_figs\\spatial_determinstic_height';
print(path,'-dpng','-r500');

figure(2);
path='D:\\doc\\PapaerLibrary\\Figures\\Draft_6_figs\\spatial_determinstic_results';
print(path,'-dpng','-r500');


