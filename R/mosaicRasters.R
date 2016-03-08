library(gdalUtils)
library(raster)

# Path 167
file3 <- 'data/tiff/LC81670522014347_cropped.tif'
file2 <- 'data/tiff/LC81670532014347_cropped.tif'
file1 <- 'data/tiff/LC81670542014347_cropped.tif'
charvec <- c(file1,file2, file3)

mos167 <- mosaic_rasters(charvec, dst_dataset = 'data/tiff/path_167.tif', output_Raster = TRUE)
class(mos167)
names(mos167) <- c("band1","band2","band3","band4","band5","band6","band7")
writeRaster(mos167, filename = 'data/bricks/path_167.grd', overwrite = TRUE)
plot(mos167)
writeRaster(mos167, filename = 'data/img/path_167.img', format = 'HFA', overwrite = TRUE)


# Path 168
file3 <- 'data/tiff/LC81680522014354_cropped.tif'
file2 <- 'data/tiff/LC81680532014354_cropped.tif'
file1 <- 'data/tiff/LC81680542014354_cropped.tif'
charvec <- c(file1,file2, file3)

mos168 <- mosaic_rasters(charvec, dst_dataset = 'data/tiff/path_168.tif', output_Raster = TRUE)
class(mos168)
names(mos168) <- c("band1","band2","band3","band4","band5","band6","band7")
writeRaster(mos168, filename = 'data/bricks/path_168.grd')
plot(mos168)
writeRaster(mos168, filename = 'data/img/path_168.img', format = 'HFA', overwrite = TRUE)


# mosaic both together for rasterization purposes
file3 <- 'data/tiff/LC81670522014347_cropped.tif'
file2 <- 'data/tiff/LC81670532014347_cropped.tif'
file1 <- 'data/tiff/LC81670542014347_cropped.tif'
file6 <- 'data/tiff/LC81680522014354_cropped.tif'
file5 <- 'data/tiff/LC81680532014354_cropped.tif'
file4 <- 'data/tiff/LC81680542014354_cropped.tif'
charvec <- c(file1,file2, file3, file4, file5, file6)
mos_tot <- mosaic_rasters(charvec, dst_dataset = 'data/tiff/path_167_168.tif', output_Raster = TRUE)
class(mos_tot)
names(mos_tot) <- c("band1","band2","band3","band4","band5","band6","band7")
writeRaster(mos168, filename = 'data/bricks/path_167_168.grd')