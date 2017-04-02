% Propose: Emprical data-drived spatial spectrum model
% Author: Kevin
% Environment: Matlab 2015b
% Date: March 31th, 2017

clear; clc; close all;
spatial_data_Prepare();
%% 
% for process part, turn to .R file

%% 
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas';
path=Join_string({path,'\\%s'});
load(sprintf(path, 'Position(2015).mat'));
load(sprintf(path,'StatData2.mat'));
load(sprintf(path,'StatGrids.mat'));

%% Distance map
figure;
distance=reshape(distance,100,100);
grid_x=Normalize(grid_x,0,1);
grid_y=Normalize(grid_y,0,1);
imagesc(grid_x,grid_y,distance);
c=colorbar;
ylabel(c,'距离/km','FontSize',12);
xlabel('相对经度','FontSize',12); ylabel('相对纬度','FontSize',12);
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_distance';
print(path,'-dpng','-r500');

%% IDW map
path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas';
path=Join_string({path,'\\%s'});
load(sprintf(path, 'idw_results.mat'));
idw_res=reshape(idw_res,100,100);
idw_err=reshape(idw_err,100,100);

figure;
imagesc(grid_x,grid_y,idw_res);
c=colorbar;
ylabel(c,'频谱能量/dB\muV^{-1}','FontSize',12);
xlabel('相对经度','FontSize',12); ylabel('相对纬度','FontSize',12);
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

figure;
imagesc(grid_x,grid_y,idw_err);
c=colorbar;
ylabel(c,'估计误差/(dB\muV^{-1})^{2}','FontSize',12);
xlabel('相对经度','FontSize',12); ylabel('相对纬度','FontSize',12);
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

%% Krige Map
path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas';
path=Join_string({path,'\\%s'});
load(sprintf(path, 'kriging_results.mat'));
krige_res=reshape(krige_res,100,100);
krige_err=reshape(krige_err,100,100);

figure;
imagesc(grid_x,grid_y,krige_res);
c=colorbar;
ylabel(c,'频谱能量/dB\muV^{-1}','FontSize',12);
xlabel('相对经度','FontSize',12); ylabel('相对纬度','FontSize',12);
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

figure;
imagesc(grid_x,grid_y,krige_err);
c=colorbar;
ylabel(c,'估计误差','FontSize',12);
xlabel('相对经度','FontSize',12); ylabel('相对纬度','FontSize',12);
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');


%% 
path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_distance';
print(path,'-dpng','-r500');

path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_idw';
print(path,'-dpng','-r500');

path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_krige';
print(path,'-dpng','-r500');

path='D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_krige_err';
print(path,'-dpng','-r500');