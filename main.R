# Eline van Elburg
# 08-02-2016
# Thesis REG

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
eth <- bufferState('ETH','Afar',500, destFolder)

# Save to shapefile
writeOGR(eth,(file.path(shpDir, 'Afar')),'Afar',driver="ESRI Shapefile")
