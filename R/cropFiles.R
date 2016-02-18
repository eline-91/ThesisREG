library(raster)
library(rgdal)
library(tools)

crop_files <- function(inputFolder, bandNames, extent, outputFolder) {
  print("-------------- New File ----------------")
  print(inputFolder)
  fn_bare <- strsplit(inputFolder,"/")[[1]][3]
  fn <- paste(fn_bare, "LGN00_band", sep = "")
  filePaths <- list.files(inputFolder, pattern = paste(fn,'[1-7].tif$',sep=""), full.names = TRUE)
  print(filePaths)
  st <- stack(filePaths)
  names(st) <- bandNames
  outFn <- paste(outputFolder,"/", fn_bare, "_cropped",".grd",sep="")
  print(outFn)
  crop(st, extent, filename=outFn, overwrite=TRUE)
  
}