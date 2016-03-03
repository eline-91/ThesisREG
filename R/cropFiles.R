library(raster)
library(rgdal)
library(tools)

crop_files <- function(inputFolder, bandNames, extent, outputFolder, saveAsTiff = FALSE) {
  print("-------------- New File: crop ----------------")
  print(inputFolder)
  
  fn_bare <- basename(inputFolder)
  fn <- paste(fn_bare, "LGN00_sr_band", sep = "")
  filePaths <- list.files(inputFolder, pattern = paste(fn,'[1-7].tif$',sep=""), full.names = TRUE)
  print(filePaths)
  st <- stack(filePaths)
  names(st) <- bandNames
  
  if (saveAsTiff == TRUE) {
    outFn <- paste(outputFolder,"/", fn_bare, "_cropped",".tif",sep="")
    print(outFn)
    crop(st, extent, filename=outFn, overwrite=TRUE, format = "GTiff")
  } else {
    outFn <- paste(outputFolder,"/", fn_bare, "_cropped",".grd",sep="")
    print(outFn)
    crop(st, extent, filename=outFn, overwrite=TRUE)
  }
    
}