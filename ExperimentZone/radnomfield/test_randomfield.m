% Propose: test random field 
% Author: Kevin
% Date: March 29th, 2017
  
%% Point process
lambda=10;%intensity of the process
[pproc] = poisson2d(lambda);
figure(1);
scatter(pproc(:,1),pproc(:,2)); %[0,1]x[0,1]
  
  %% (2-D) Radom field
  % build the correlation struct
  corr.name = 'exp';
  corr.c0 = [0.2 1]; % anisotropic correlation
  
  %set up the spatial grid
  steps=51; range=1;
  x = linspace(0,range,steps);
  [X,Y] = meshgrid(x,x); mesh = [X(:) Y(:)]; % 2-D mesh

  % set a spatially varying variance (must be positive!)
  corr.sigma = cos(pi*mesh(:,1)).*sin(2*pi*mesh(:,2))+1.5;

  %generate a spatial random field
  [F,KL] = randomfield(corr,mesh,...
              'trunc', 10);

  % plot the realization
  % normalize X, Y
  
  %plot X-Y random field
  surf(X,Y,reshape(F,steps,steps)); view(2); colorbar;
  