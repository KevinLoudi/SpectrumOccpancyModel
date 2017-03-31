clear; clc;
addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
load('Position(2015).mat');
load('StatData.mat');

pu_lon=104.0922;  %x
pu_lat=30.6646; %y
pu=[pu_lon pu_lat];

for i=1:60
    StatData2(i)=StatData{1,i}(1,1);
    Distance(i)=Calculate_distance_by_latlon([Lon(i) Lat(i)],pu,'Haversine');
end
StatData2=StatData2';
Distance=Distance';
save('StatData2.mat','StatData2','Distance');

%% 
%generate a grid
max_lat=max(Lat);
min_lat=min(Lat);
max_lon=max(Lon);
min_lon=min(Lon);
len_lat=max_lat-min_lat;
len_lon=max_lon-min_lon;

grid_max_lat=max_lat+len_lat/8;
grid_min_lat=min_lat-len_lat/8;
grid_max_lon=max_lon+len_lon/8;
grid_min_lon=min_lon-len_lon/8;

grid_num=80;
grid_x=grid_min_lon:(grid_max_lon-grid_min_lon)/(grid_num-1):grid_max_lon;
grid_y=grid_min_lat:(grid_max_lat-grid_min_lat)/(grid_num-1):grid_max_lat;


grids=cell(length(grid_x),length(grid_y));
distance=zeros(size(grids));

for i=1:grid_num
    for j=1:grid_num
        grids{i,j}=[grid_x(1,i) grid_y(1,j)];
        %calculate each grids distance to pu transmitter
        distance(i,j)=Calculate_distance_by_latlon(grids{i,j}, pu, 'Haversine');
    end
end

%% 
x=ones(grid_num*grid_num,1);
y=ones(size(x));
t=1;
for i=1:grid_num
    for j=1:grid_num
       x(t)=grids{i,j}(1,1);   
       y(t)=grids{i,j}(1,2);   
       t=t+1;
       if(x(i*j)==1)
           display('abnormal');
       end
    end
end
distance=reshape(distance,grid_num*grid_num,1);
save('StatGrids.mat','x', 'y','distance');

%% 
clear; clc; close all;
grid_num=80;
load('kriging_results.mat');
load('StatGrids.mat');
krige_err=reshape(krige_err,grid_num, grid_num);
krige_res=reshape(krige_res,grid_num, grid_num);
x=reshape(x,grid_num, grid_num);
y=reshape(y,grid_num, grid_num);
figure;
(x,y,krige_res);

