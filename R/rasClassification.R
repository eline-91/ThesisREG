# Method: rasClass
library(rasclass)
library(raster)
library(rgdal)

# Make a sample raster dataset for each band (already with numeric codes)
makeSampleRaster <- function(samplePolygons, rasterMosaic, cropRaster, filename, outputAsRaster = TRUE) {
  # Rasterize polygons
  classes <- rasterize(samplePolygons, rasterMosaic, field='Code')
  # crop rasterized layer
  if (outputAsRaster == TRUE) {
    croppedClasses <- crop(classes, cropRaster, filename = filename, overwrite = TRUE)
    return(croppedClasses)
  } else {
    crop(classes, cropRaster, filename = filename, overwrite = TRUE)
    return(NULL)
  }
}




# Rasterize polygons for path 167 en path 168 and convert them to .asc to put in the asc files.
sam <- readOGR('data/test', layer = 'samples_Merge')
sam@data$Code <- as.numeric(sam@data$Class)

mosaicRas <- brick('data/tiff/path_167_168.tif')[[4]]
listRasters <- list(brick('data/tiff/path_167.tif'), brick('data/tiff/path_168.tif'))
fnList <- list('data/bricks/sampleRaster_167_1003', 'data/bricks/sampleRaster_168_1003')
ascList <- list('data/ascFiles/path_167/path_167_sample.asc', 'data/ascFiles/path_168/path_168_sample.asc')

for (i in 1:length(listRasters)) {
  r <- makeSampleRaster(sam, mosaicRas, listRasters[[i]], fnList[[i]], outputAsRaster = TRUE)
  raster::writeRaster(r, ascList[[i]], format = 'ascii', overwrite = TRUE)
}







