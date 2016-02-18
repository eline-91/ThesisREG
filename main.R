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

# Used folders
mainDir <- getwd()
dataDir <- 'data'
shpDir <- 'data/shpFiles'
bricksDir <- 'data/bricks'
outputDir <- 'output'
gcpFolder <- "data/GCP_Coordinates"
im_dry <- "data/Images_DrySeason"
im_wet <- "data/Images_WetSeason"

# Create data structure
dirList <- list(dataDir, bricksDir, shpDir, outputDir)
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

# Buffer the state with a distance of 10 km (to contain all points)
buffState <- bufferState(afar,5250)
plot(buffState)
plot(afar, add=TRUE)

# Save buffer to shapefile
writeOGR(buffState,(file.path(shpDir, 'Afar')),'Afar_buffer',driver="ESRI Shapefile")

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


# één voor één openen om geheugen te beperken
file1 <- file.path(im_dry, "LC81670542014347", "LC81670542014347LGN00_band2.tif")
file2 <- file.path(im_dry, "LC81670542014347", "LC81670542014347LGN00_band3.tif")
file3 <- file.path(im_dry, "LC81670542014347", "LC81670542014347LGN00_band4.tif")

source('R/cropFiles.R')
folderPaths <- list.files('data/Images_DrySeason', full.names = TRUE)
e_buffer <- extent(buffState)
bandnames <- c("band1","band2","band3","band4","band5","band6","band7")
for (folder in folderPaths) {
  crop_files(folder, bandnames, e_buffer, bricksDir)
}



filelist <- list(file1,file2, file3)
bri <- brick(filelist)
plot(bri)

brick_intersect <- intersect(bri,buffState)

plot(brick_intersect)
writeRaster(brick_intersect, filename = "data/test/test_167_54_trueColor.tif", format = "GTiff", overwrite=TRUE)



