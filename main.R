# Eline van Elburg
# 08-02-2016
# Thesis REG

# Load needed R packages
library(sp)
library(rgdal)
library(rgeos)
library(ggplot2)
library(raster)

# Load R files
source('R/bufferState.R')
source('R/cropFiles.R')
source('R/simplifyRaster.R')
source('R/getIntersection.R')

# Used folders
mainDir <- getwd()
dataDir <- 'data'
shpDir <- 'data/shpFiles'
bricksDir <- 'data/bricks'
outputDir <- 'output'
gcpFolder <- "data/GCP_Coordinates"
im_dry <- "data/Images_DrySeason"
im_wet <- "data/Images_WetSeason"
testDir <- 'data/test'
tiffDir <- 'data/tiff'

# Create data structure
dirList <- list(dataDir, bricksDir, shpDir, outputDir, testDir, tiffDir)
for (dir in dirList) {
  dir.create(file.path(mainDir, dir), showWarnings = FALSE)
}

# Download Afar state boundaries and buffer them a little bit.
destFolder <- shpDir
afar_latlong <- getState('ETH','Afar',500, destFolder)
plot(afar_latlong)
# Transform the coordinate system to planar
prj_string_UTM37 <- CRS("+proj=utm +zone=37 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
afar <- spTransform(afar_latlong, CRSobj = prj_string_UTM37)
# Save to shapefile
writeOGR(afar,(file.path(shpDir, 'Afar')),'Afar',driver="ESRI Shapefile")

# Open shp layer to perform buffer on
afar_edit <- readOGR((file.path(shpDir, 'Afar')), 'Afar_Edit')
plot(afar_edit)
# Buffer the state with a distance of 20 km
buffState <- bufferState(afar_edit,19000)
plot(buffState)
plot(afar_edit, add=TRUE)

# Save buffer to shapefile
#fn <- 'Afar_buffer'
fn <- 'Afar_Edit_Buffer'
writeOGR(buffState,(file.path(shpDir, 'Afar')),fn,driver="ESRI Shapefile")

# Show GCPs on top
gcps_latlong <- readOGR(gcpFolder, "GCP_Coords")
gcps <- spTransform(gcps_latlong, CRSobj = prj_string_UTM37)
proj4string(gcps)
plot(gcps, add=TRUE, pch=19, col = "darkgreen")

# Map a nice ggplot.
map <- readOGR((file.path(shpDir, 'Afar')), layer="Afar_buffer", p4s="+init=epsg:32637")
map <- spTransform(map, CRS("+proj=longlat +datum=WGS84"))
nPolys <- sapply(map@polygons, function(x)length(x@Polygons))
region <- map[which(nPolys==max(nPolys)),]
region.df <- fortify(region)
points <- data.frame(gcps_latlong)
ggplot(region.df, aes(x=long,y=lat,group=group))+
  geom_polygon(fill="lightgreen")+
  geom_path(colour="grey50")+
  geom_point(data=points,aes(x=coords.x1,y=coords.x2,group=NULL), color = 'darkgreen', size=2)+
  coord_fixed()


folderPaths <- list.files('data/Images_DrySeason', full.names = TRUE)
bandnames <- c("band1","band2","band3","band4","band5","band6","band7")
for (folder in folderPaths) {
  #simplify_raster(folder, shpDir)
  int <- get_intersection(folder, shpDir, buffState, plot=T)
  crop_files(folder, bandnames, int, bricksDir)
}

for (folder in folderPaths) {
  #simplify_raster(folder, shpDir)
  int <- get_intersection(folder, shpDir, buffState, plot=T)
  crop_files(folder, bandnames, int, tiffDir, saveAsTiff = TRUE)
}

# Compare path 167 with path 168
# Row: 52; bands 3, 4, 5
x = raster('data/Images_DrySeason/LC81670522014347/LC81670522014347LGN00_sr_band5.tif')
y = raster('data/Images_DrySeason/LC81680522014354/LC81680522014354LGN00_sr_band5.tif')

source('R/compareRasters.R')
substract_rasters(x = x,y = y, saveAsTiff = T, fn = "data/test/substraction5")

# Compare path 167 with each other
# Row: 52 and 53; bands 3, 4, 5
x = raster('data/Images_DrySeason/LC81670522014347/LC81670522014347LGN00_sr_band3.tif')
y = raster('data/Images_DrySeason/LC81670532014347/LC81670532014347LGN00_sr_band3.tif')

source('R/compareRasters.R')
substract_rasters(x = x,y = y, saveAsTiff = T, fn = "data/test/substraction3_167")

# Mosaicing: Perform mosaicRaster.R
