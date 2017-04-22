# Propose: Emprical data-drived spatial spectrum model
# Author: Kevin
# Environment: R 3.3
# Date: March 31th, 2017

#load data
library(R.matlab)
graphics.off()
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\Position(2015).mat"
sp_loc<-readMat(path)
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\StatData2.mat"
sp_data<-readMat(path)
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\StatGrids.mat"
sp_grid<-readMat(path)


#gather observed data
obs_data<-data.frame(x=sp_loc$Lon,y=sp_loc$Lat,sample=sp_data$StatData2,
                     distance=sp_data$Distance)
#create coordinates
coordinates(obs_data)=~x+y
#plot observed data
bubble(obs_data,"sample",maxsize=3,main = "频谱能量密度分布",
       xlab="经度", ylab="纬度",
       xlim=c(103, 105), ylim=c(29, 31))


#load prediction-grid
pre_grid<-data.frame(x=sp_grid$x,y=sp_grid$y,distance=sp_grid$distance)
coordinates(pre_grid)=~x+y
gridded(pre_grid)=TRUE
#show prediction-grid

png(filename="D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_distance.png",
    width = 4, height = 4, units = 'in', res = 500)
spplot(pre_grid,colorkey=TRUE)
dev.off()
title("与发射塔的距离")



#see the spatial tendency
library(gstat)
png(filename="D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_decade.png",
    width = 4, height = 4, units = 'in', res = 500)

plot(sample~distance,obs_data,type="p",
     xlab='Distance/km',ylab='Spectrum power density/dBuV/m')
abline(lm(sample~distance,obs_data),dots)

dev.off()

#conduct IDW 
res.idw=idw(sample~1,obs_data,pre_grid)
class(res.idw)
png(filename="D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_idw.png",
    width = 4, height = 4, units = 'in', res = 500)
spplot(res.idw["var1.pred"],xlab="经度",ylab="纬度")
dev.off()


#calculate variograms of observed data
#res.vgm=variogram(sample~1,obs_data)
#res.vgm
#res.fit=fit.variogram(res.vgm, model = vgm(c("Exp", "Sph")))
#res.fit
#plot(res.vgm,res.fit,xlab='经纬度棋盘距离')

#automaticly fit variograms to model
library(automap)
png(filename="D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_direction.png",
    width = 4, height = 4, units = 'in', res = 500)
res.autofit = autofitVariogram(sample~1,obs_data,         #formula input_data
                               model = c("Sph", "Exp", "Gau", "Mat"), #model list
                               kappa = c(0.05, seq(0.2, 2, 0.1), 5, 10), #smoothing parameter of Matern model
                               verbose = TRUE, #extra feedbacks on the fitting process
                               miscFitOptions = list(merge.small.bins = TRUE), #Generalized Least Squares sample variogram is calculated
                               alpha=c(0,45,90,135)) #additional control over the fitting process
plot(res.autofit)
plot(res.autofit$exp_var)
dev.off()

#automaticly kriging prediction
png(filename="D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_krige.png",
    width = 4, height = 4, units = 'in', res = 500)
res.autokrige = autoKrige(sample~1,obs_data,
                          model = c("Sph", "Exp", "Gau", "Ste"),
                          kappa = c(0.05, seq(0.2, 2, 0.1), 5, 10),
                          verbose = TRUE,
                          miscFitOptions = list(merge.small.bins = TRUE))
plot(res.autokrige)
dev.off()


#perform cross-validation
res.autokrige.cv=autoKrige.cv(sample~1,obs_data,
                              model = c("Sph"), nfold = 10)
#mean_error: cross-validation residual,ideally small
#me_mean: mean error divided by the mean of the observed values, measure for how large
#   the mean_error is in contrast to the mean of the dataset
#MSE: Mean Squared error
#MSNE: Mean Squared Normalized Error, mean of the squared z-scores. Ideally small.
#cor_obspred: Correlation between the observed and predicted values. Ideally 1.
#cor_predres Correlation between the predicted and the residual values. Ideally 0.
#RMSE Root Mean Squared Error of the residual. Ideally small.
#RMSE_sd RMSE divided by the standard deviation of the observed values. Provides a
#    measure variation of the residuals vs the variation of the observed values.
#URMSE: Unbiased Root Mean Squared Error of the residual. Ideally small.
#iqr:Interquartile Range of the residuals. Ideally small.
library(ggplot2)
compare.cv(res.autokrige.cv)

#par(mfrow=c(1,2))
#automapPlot(res.autokrige$krige_output, "var1.pred",
#            sp.layout = list("sp.points", obs_data),
#            xlab="经度",ylab="纬度",zlab="频谱能量密度",
#            font.lab=12)

#dev.print(device=png,"D:/doc/PapaerLibrary/Figures/Draft_6_figs/spatial_krige.png",
#          width = 4, height = 4, units = 'in', res = 500)


#calculate variogram against distance
res.rvgm=variogram(log(sample)~sqrt(distance),obs_data)
res.rfit=fit.variogram(res.rvgm, model=vgm(1,"Exp",0.09,3))
res.rfit
plot(res.rvgm,res.rfit,xlab='平方根距离/sqrt(km)')

res.krige=krige(sample~1,obs_data,pre_grid,model=
                   res.fit,nmax=15,nmin=3)
spplot(res.krige["var1.pred"])
spplot(res.krige["var1.var"])

#save results to .mat files
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\kriging_results.mat"
writeMat(path,krige_res=res.krige$var1.pred,
         krige_err=res.krige$var1.var)
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\idw_results.mat"
writeMat(path,idw_res=res.idw$var1.pred,
         idw_err=res.idw$var1.var)


#conditional gaussian simulation
res.condsim=krige(log(sample)~1, obs_data,pre_grid,
                  model=res.fit, nmax=10, 
                  nsim=4)
spplot(res.condsim, main="four conditional simulation")

res.condsim2=krige(log(sample)~sqrt(distance),obs_data,pre_grid,
                   model=res.rfit, nmax=10, 
                   nsim=4)
spplot(res.condsim2, main="four conditional simulation")


#directional variograms
res.dir=variogram(sample~1, obs_data,alpha=c(0,45,90,135))
res.dirfit=vgm(0.06,"Exp",0.08,0.002, anis=c(45,.4))
plot(res.dir,res.dirfit,as.table=TRUE)

res.rdir=variogram(log(sample)~sqrt(distance),obs_data,alpha=c(0,45,90,135))
plot(res.rdir,res.rfit,as.table=TRUE)

#variogram maps
res.vgmmap=variogram(log(sample)~sqrt(distance),obs_data,cutoff=1500,
                     width=100,map=TRUE)
plot(res.vgmmap,threshold=5)

#plot different model
show.vgms(model="Mat",kappa.range = c(0.1,0.2,0.5,1,2,15,10,30),
          max=10,plot = TRUE,xlab='距离',ylab='半变差值')

show.vgms(models = c("Exp", "Gau","Sph", "Mat"), nugget = 0.1,
          xlab='距离',ylab='半变差值')

#plot vgm comparison figure
library(gstat)
plot(variogramLine(vgm(1, "Sph", 10, anis=c(0,0.5)), dir=c(0,1,0), dist_vector = 0.5))

