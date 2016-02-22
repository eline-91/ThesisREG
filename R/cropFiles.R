library(raster)
library(rgdal)
library(tools)

crop_files <- function(inputFolder, bandNames, extent, outputFolder) {
  print("-------------- New File: crop ----------------")
  print(inputFolder)
  fn_bare <- basename(inputFolder)
  fn <- paste(fn_bare, "LGN00_sr_band", sep = "")
  filePaths <- list.files(inputFolder, pattern = paste(fn,'[1-7].tif$',sep=""), full.names = TRUE)
  print(filePaths)
  st <- stack(filePaths)
  names(st) <- bandNames
  outFn <- paste(outputFolder,"/", fn_bare, "_cropped",".grd",sep="")
  print(outFn)
  crop(st, extent, filename=outFn, overwrite=TRUE)
  
  if (file.exists(outFn)) {
    print("Exists!")
  } else {
    print("Unfortunately there's nothing to crop.")
#     bri <- brick(st, filename = outFn, overwrite=TRUE)
#     
#     if (file.exists(outFn)) {
#       print("Now the file exists.")
#     } else {
#       print("The file still does not exists. There is another problem.")
#     }
  }
    
}