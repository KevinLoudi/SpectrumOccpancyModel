% Propose: Perpare spatial data set
% Author: Kevin
% Environment: Matlab 2015b
% Date: March 31th, 2017

function spatial_data_Prepare(path,grid_num)
  addpath('D:\\Code\\WorkSpace\\SpectrumModel\\Include');
  if (nargin<2)
      %default data path
      path='D:\\Code\\WorkSpace\\SpectrumModel\\Datas';
      grid_num=100;
  end
  if (~exist(path))
      error('No found path!!'); exit;
  end
  path=Join_string({path,'\\%s'});
  load(sprintf(path, 'Position(2015).mat'));
  load(sprintf(path,'StatData.mat'));
  pu=[104.0922 30.6646];
  
  for i=1:length(StatData)
    StatData2(i)=StatData{1,i}(1,1);
    Distance(i)=Calculate_distance_by_latlon([Lon(i) Lat(i)],pu,'Haversine');
  end
 StatData2=StatData2';
 Distance=Distance';
 save(sprintf(path, 'StatData2.mat'),'StatData2','Distance');
 
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

grid_x=grid_min_lon:(grid_max_lon-grid_min_lon)/(grid_num-1):grid_max_lon;
grid_y=grid_min_lat:(grid_max_lat-grid_min_lat)/(grid_num-1):grid_max_lat;

x=ones(grid_num*grid_num,1);
y=ones(size(x));
grids=cell(length(grid_x),length(grid_y));
distance=zeros(size(grids));

t=1;
for i=1:grid_num
    for j=1:grid_num
         x(t)=grid_x(1,i); 
         y(t)=grid_y(1,j);
        %calculate each grids distance to pu transmitter
        distance(t)=Calculate_distance_by_latlon([x(t),y(t)], pu, 'Haversine');
        t=t+1;
    end
end
save(sprintf(path, 'StatGrids.mat'),'grid_x','grid_y','x', 'y','distance');

end