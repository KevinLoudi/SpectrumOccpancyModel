% Propose: Normalize value of a matrix or a vector
% Author: Kevin
% Date: March 29th, 2017

%data: a matrix or a vector
%t_min, t_max: target minmum and maxium value after normalization
function [data_nor]=Normalize(data,t_min, t_max)
  [row,col]=size(data);
  %exception handling
  if(row<2 || col<2)
      warning('No need to do normalize!!!');
      exit;
  end
  data=data(:); %data=reshape(data,row*col,1); 
  if(max(data)==min(data))
      warning('Data set elements with identical values!!!');
      exit;
  end
  
  %set default value
  if(nargin<3)
      t_min=0; t_max=1;
  end

  %centralize normalization
  data_nor=(data-min(data))/(max(data)-min(data));
  %shift to another range
  data_nor=data_nor*(t_max-t_min)+t_min;
  %recover matrix form
  data_nor=reshape(data_nor,row,col);
end