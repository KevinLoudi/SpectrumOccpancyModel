% Propose: Generate random point in [0,1]x[0,1]
% Author: Kevin
% Date: March 29th, 2017

function [X,Y]=Distribute_random_points(point_num)
  %exception handling
   if(nargin<1)
      point_num=10; %set default point number
   end
   if(point_num<1)
       error('Illegal point number!!!'); exit;
   end
  
  point_num=ceil(point_num);
  [locations] = poisson2d(point_num);
  X=locations(:,1);
  Y=locations(:,2);
end

function [pproc] = poisson2d(lambda)
%   (square [0,1]x[0,1]). 
% 
% [pproc] = poisson2d(lambda)
%
% Inputs: lambda - intensity of the process
%
% Outputs: pproc - a matrix with 2 columns with coordinates of the
%          points of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % the number of points is Poisson(lambda)-distributed
  npoints = poissrnd(lambda);

  % conditioned that the number of points is N,
  % the points are uniformly distributed
  pproc = rand(npoints, 2);

  % plot the process
  % plot(pproc(:, 1), pproc(:, 2), '.');
  
end