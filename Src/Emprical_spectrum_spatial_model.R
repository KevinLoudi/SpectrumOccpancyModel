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
bubble(obs_data,"sample",maxsize=1.5,main = "频谱能量密度分布",
       xlab="经度", ylab="纬度",
       xlim=c(103, 105), ylim=c(29, 31))


#load prediction-grid
pre_grid<-data.frame(x=sp_grid$x,y=sp_grid$y,distance=sp_grid$distance)
coordinates(pre_grid)=~x+y
gridded(pre_grid)=TRUE
#show prediction-grid
spplot(pre_grid)
title("与发射塔的距离")



#see the spatial tendency
library(gstat)
plot(log(sample)~sqrt(distance),obs_data,xlab='平方根距离/sqrt(km)',ylab='对数频谱能量/log(dBuV/m)')
abline(lm(log(sample)~sqrt(distance),obs_data))
#conduct IDW 
res.idw=idw(sample~1,obs_data,pre_grid)
class(res.idw)
spplot(res.idw["var1.pred"],main="sample inverse distance")


#calculate variograms of observed data
res.vgm=variogram(sample~1,obs_data)
res.vgm
res.fit=fit.variogram(res.vgm, model = vgm(1,"Sph",0.05,1))
res.fit
plot(res.vgm,res.fit,xlab='经纬度棋盘距离')

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
res.dir=variogram(log(sample)~1, obs_data,alpha=c(0,90,180,270))
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
