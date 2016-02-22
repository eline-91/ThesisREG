library(rgeos)


get_intersection <- function(imageFolder, shpFolder, polygon, plot=FALSE) {
  print("-------------- New File: intersect ----------------")
  print(paste("The image folder is:", imageFolder))
  
  inputFolder <- file.path(shpFolder, basename(imageFolder))
  inputShp <- paste(inputFolder, "/", basename(imageFolder), "_contour", sep="")
  
  ras_polygon <- readOGR(inputFolder, layer=basename(inputShp))
  
  int <- gIntersection(ras_polygon, polygon, byid=T)
  if (plot==TRUE) {
    plot(int, main = basename(imageFolder))
  }
  
  return(int)
}