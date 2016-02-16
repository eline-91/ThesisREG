# Eline van Elburg
# 08-02-2016
# Thesis REG

# Load needed R packages
library(sp)

# Load R files
source('R/bufferState.R')

# Create data structure
mainDir <- 'C:/Users/Eline/Documents/Thesis_REG/Project/ThesisREG'
dataDir <- 'data'
shpDir <- 'data/shpFiles'
bricksDir <- 'data/bricks'
outputDir <- 'output'
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
