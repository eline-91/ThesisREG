library(raster)

substract_rasters <- function(x, y, saveAsTiff = F, fn = NULL) {
  if (class(x) != class(y)) {
    return(sprintf("Class of x (%s) is not equal to class of y (%s).", class(x), class(y)))
  }
  
  if (class(x)[1] == "RasterLayer") {
    difference = x - y
    if (saveAsTiff == TRUE) {
      fn = paste(fn, ".tif", sep = "")
      writeRaster(difference, filename = fn, format = "GTiff", overwrite=TRUE)
    } else {
      return(difference)
    }
  }
#   } else if (class(x)[1] == "RasterBrick") {  Still to be implemented
#     
#   }
}