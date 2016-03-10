# Method: RandomForest
library(randomForest)

sam <- readOGR('data/test', layer = 'samples_Merge')
str(sam@data$Class)

# Convert string class values into numeric codes
sam@data$Code <- as.numeric(sam@data$Class)

# Rasterize the sample data, using the complete mosaic raster
mos_tot <- brick('data/tiff/path_167_168.tif')
names(mos_tot) <- c("band1","band2","band3","band4","band5","band6","band7")
mos <- mos_tot$band4
plot(mos)
classes <- rasterize(sam, mos, field='Code')
writeRaster(classes, 'data/tiff/rasterizedclasses_0903.tif', overwrite=TRUE)

# Load path 167
classes <- raster('data/tiff/rasterizedclasses_0903.tif')
path168 <- brick('data/tiff/path_168.tif')
names(path168) <- c("band1","band2","band3","band4","band5","band6","band7")

# crop rasterized layer
classes168 <- crop(classes, path168)
covmasked <- mask(path168, classes168)

names(classes168) <- "class"
trainingsbrick <- addLayer(covmasked, classes168)
plot(trainingsbrick)

# Extract all values into a matrix
valuetable <- getValues(trainingsbrick)
saveRDS(valuetable, 'data/rdata/valuetable.rds')

valuetable <- na.omit(valuetable)
valuetable <- as.data.frame(valuetable)
head(valuetable, n = 10)

valuetable <- readRDS('data/rdata/valuetable.rds')

valuetable$class <- factor(valuetable$class, levels = c(1:9))

library(randomForest)
modelRF <- randomForest(x=valuetable[ ,c(1:7)], y=valuetable$class, importance = TRUE)
predLC <- predict(path168, model=modelRF, na.rm=TRUE)

cols <- c("darkkhaki", "burlywood", "forestgreen", "orange3", "darkolivegreen3", "darkgreen", "darkseagreen4", "firebrick4", "deepskyblue4")
plot(predLC, col=cols, legend=F)
legend("bottomright", legend=c("Acacia Woodland", "Bare Land", "Bushland", "Farmland", "Grassland", "Prosopis", "Riverain", "Urban", "Water"), fill = cols, bg="white")
writeRaster(predLC, "data/test/landcoverMap_168_0903.tif", format="GTiff")
