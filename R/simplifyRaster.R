library(raster)

simplify_raster <- function(inputFolder, destFolder) {
  print("-------------- New File: simplify ----------------")
  print(paste("The input folder is:", inputFolder))
  fn <- basename(inputFolder)
  dest <- file.path(destFolder, fn)
  dir.create(dest, showWarnings = FALSE)
  destFn <- paste(file.path(dest, fn), "_contour.tif", sep="")
  
  filePaths <- list.files(inputFolder, pattern = paste(paste(fn, "LGN00_sr_band", sep = ""),'[3].tif$',sep=""), full.names = TRUE)
  ras <- raster(filePaths[[1]])
  ras[ras != is.na(ras)] <- 1
  writeRaster(ras, destFn, format='GTiff', overwrite=TRUE)
}