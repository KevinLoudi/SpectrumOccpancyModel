library(sp)
data(meuse)
names(meuse)

coordinates(meuse)=~x+y #promote data.frame meuse into a SpatialPoints-
# DataFrame 
class(meuse) #"SpatialPointsDataFrame"
summary(meuse)

coordinates(meuse)[1:5,]
bubble(meuse,"zinc",main = "zinc concentrations (ppm)")

data(meuse.grid)
summary(meuse.grid)
class(meuse.grid)
coordinates(meuse.grid)=~x+y
class(meuse.grid)
gridded(meuse.grid)=TRUE
class(meuse.grid)

image(meuse.grid["dist"])
title("distance to river (red = 0)")

library(gstat)
zinc.idw=idw(zinc~1,meuse,meuse.grid) #inverse distance weighted
class(zinc.idw)
spplot(zinc.idw["var1.pred"],main="zinc inverse distance")

plot(log(zinc)~sqrt(dist),meuse)
abline(lm(log(zinc)~sqrt(dist),meuse))
############################
library(R.matlab)
graphics.off()
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\Position(2015).mat"
sp_loc<-readMat(path)
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\StatData2.mat"
sp_data<-readMat(path)
path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\StatGrids.mat"
sp_grid<-readMat(path)

data<-data.frame(x=sp_loc$Lon,y=sp_loc$Lat,sample=sp_data$StatData2,distance=sp_data$Distance)
coordinates(data)=~x+y
class(data)
summary(data)
coordinates(data)[1:5,]
bubble(data,"sample",main = "spectrum samples")

data.grid=cbind(x=sp_grid$x,y=sp_grid$y)
row.names(data.grid) = paste("point", 1:nrow(data.grid), sep="")
data.grid=SpatialPoints(data.grid)
plot(data.grid@coords)

data.grid<-data.frame(x=sp_grid$x,y=sp_grid$y,distance=sp_grid$distance)
summary(data.grid)
class(data.grid)
coordinates(data.grid)=~x+y
#proj4string(data.grid) <- CRS("+init=epsg:28992")
class(data.grid)
gridded(data.grid)=TRUE
class(data.grid)
image(data.grid["distance"])
spplot(data.grid)
title("distance to PU transmitter")

library(gstat)
sample.idw=idw(sample~1,data,data.grid)
class(sample.idw)
spplot(sample.idw["var1.pred"],main="sample inverse distance")

graphics.off()
plot(log(sample)~sqrt(distance),data)
abline(lm(log(sample)~sqrt(distance),data))

#variograms
data.vgm=variogram(log(sample)~1,data)
data.vgm
data.fit=fit.variogram(data.vgm, model = vgm(1,"Sph",0.05,1))
data.fit
plot(data.vgm,data.fit)

data.rvgm=variogram(log(sample)~sqrt(distance),data)
data.rfit=fit.variogram(data.rvgm, model=vgm(1,"Exp",0.03,1))
data.rfit
plot(data.rvgm,data.rfit)

data.krige=krige(log(sample)~1,data,data.grid,model=
                   data.fit)
spplot(data.krige["var1.pred"])




path<-"D:\\Code\\WorkSpace\\SpectrumModel\\Datas\\kriging_results.mat"
writeMat(path,krige_res=data.krige$var1.pred,krige_err=data.krige$var1.var)
