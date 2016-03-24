# Method: RandomForest
library(randomForest)
library(raster)
library(rgdal)

#-------------------------------------------- Path 167 -------------------------------------------------------
sam <- readOGR('data/shpFiles/SampleData', layer = 'Sample_Data_Riverain')
levels(sam@data$Class)
str(sam@data$Class)
# Convert string class values into numeric codes
sam@data$Code <- as.numeric(sam@data$Class)
sam@data$Code

# Rasterize the sample data, using the complete mosaic raster
mos_tot <- brick('data/tiff/path_167_168.tif')
names(mos_tot) <- c("band1","band2","band3","band4","band5","band6","band7")
mos <- mos_tot$band4
plot(mos)
classes <- rasterize(sam, mos, field='Code')
writeRaster(classes, 'data/tiff/rasterizedclasses_R_2303.tif', overwrite=TRUE)

# Load path 167
classes <- raster('data/tiff/rasterizedclasses_R_2303.tif')
path167 <- brick('data/tiff/path_167.tif')
names(path167) <- c("band1","band2","band3","band4","band5","band6","band7")

# crop rasterized layer
classes167 <- crop(classes, path167)
writeRaster(classes167, 'data/tiff/rasterizedclasses_R_167_2303.tif', overwrite=TRUE)
covmasked <- mask(path167, classes167)
plot(covmasked)
#writeRaster(covmasked, 'data/tiff/covmasked_167_2203.tif', overwrite=TRUE)

names(classes167) <- "class"
trainingsbrick <- addLayer(covmasked, classes167)
plot(trainingsbrick)

# Extract all values into a matrix
valuetable <- getValues(trainingsbrick)
valuetable <- na.omit(valuetable)
valuetable <- as.data.frame(valuetable)
saveRDS(valuetable, 'data/rdata/valuetable167_Riverain_2303_2.rds')

valuetable <- readRDS('data/rdata/valuetable167_Riverain_2303_2.rds')

head(valuetable, n = 10)
unique(valuetable$class)

valuetable$class <- factor(valuetable$class, levels = c(1:8))

library(randomForest)
modelRF <- randomForest(x=valuetable[ ,c(1:7)], y=valuetable$class, importance = TRUE)
saveRDS(modelRF, 'data/rdata/modelRF_Riverain_167_2.rds')
predLC <- predict(path167, model=modelRF, na.rm=TRUE)

cols <- c("burlywood", "forestgreen", "orange3", "darkolivegreen3", "darkgreen", "darkseagreen4", "firebrick4", "deepskyblue4")
plot(predLC, col=cols, legend=F)
legend("bottomright", legend=c("Bare Land", "Bushland", "Farmland", "Grassland", "Prosopis", "Riverain", "Urban", "Water"), fill = cols, bg="white")
writeRaster(predLC, "data/tiff/landcoverMap_Riverain_167_2303.tif", format="GTiff")


#-------------------------------------------- Path 168 -------------------------------------------------------
# Load path 168
classes <- raster('data/tiff/rasterizedclasses_R_2303.tif')
path168 <- brick('data/tiff/path_168.tif')
names(path168) <- c("band1","band2","band3","band4","band5","band6","band7")

# crop rasterized layer
classes168 <- crop(classes, path168)
writeRaster(classes168, 'data/tiff/rasterizedclasses_R_168_2303.tif', overwrite=TRUE)
covmasked <- mask(path168, classes168)
plot(covmasked)

names(classes168) <- "class"
trainingsbrick <- addLayer(covmasked, classes168)
plot(trainingsbrick)

# Extract all values into a matrix
valuetable <- getValues(trainingsbrick)
valuetable <- na.omit(valuetable)
valuetable <- as.data.frame(valuetable)
saveRDS(valuetable, 'data/rdata/valuetable168_Riverain_2303_2.rds')

head(valuetable, n = 10)
unique(valuetable$class)

valuetable$class <- factor(valuetable$class, levels = c(1:8))

library(randomForest)
modelRF <- randomForest(x=valuetable[ ,c(1:7)], y=valuetable$class, importance = TRUE)
saveRDS(modelRF, 'data/rdata/modelRF_Riverain_168_2.rds')
predLC <- predict(path168, model=modelRF, na.rm=TRUE)

cols <- c("burlywood", "forestgreen", "orange3", "darkolivegreen3", "darkgreen", "darkseagreen4", "firebrick4", "deepskyblue4")
plot(predLC, col=cols, legend=F)
legend("bottomright", legend=c("Bare Land", "Bushland", "Farmland", "Grassland", "Prosopis", "Riverain", "Urban", "Water"), fill = cols, bg="white")
writeRaster(predLC, "data/tiff/landcoverMap_Riverain_168_2303.tif", format="GTiff")
