library(raster)
library(tools)
# Create folder to store asc files
mainDir <- getwd()
dir.create(file.path(mainDir, 'data', 'ascFiles'), showWarnings = FALSE)

# Write seperate files for each layer of the mosaic
image <- brick('data/bricks/path_167.grd')
suff <- names(image)
destDir <- 'data/ascFiles/path_167'
destFn <- file.path(destDir, "path_167")
writeRaster(image, destFn, format = 'raster', bylayer = TRUE, suffix = suff)

filePaths <- list.files(destDir, pattern = '*.grd$', full.names = TRUE)

for (file in filePaths) {
  fn <- paste(file_path_sans_ext(file), "asc", sep = ".")
  layer <- raster(file)
  writeRaster(layer, fn, format = 'ascii', overwrite = TRUE)
}

# Write seperate files for each layer of the mosaic
image <- brick('data/bricks/path_168.grd')
suff <- names(image)
destDir <- 'data/ascFiles/path_168'
destFn <- file.path(destDir, "path_168")
writeRaster(image, destFn, format = 'raster', bylayer = TRUE, suffix = suff)

filePaths <- list.files(destDir, pattern = '*.grd$', full.names = TRUE)

for (file in filePaths) {
  fn <- paste(file_path_sans_ext(file), "asc", sep = ".")
  layer <- raster(file)
  writeRaster(layer, fn, format = 'ascii', overwrite = TRUE)
}