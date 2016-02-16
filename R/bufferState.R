# Eline van Elburg
# 11-02-2016
# Thesis REG

# Needed imports
library(raster)
library(rgdal)
library(rgeos)

# Download data and extract state
getState <- function(country, state, buffer, folder) {
  data <- download_data(country, folder)
  stateContour <- extract_state(data, state)
  return(stateContour)
}

# Downloads data
download_data <- function(country, folder) {
  country <- getData('GADM',country=country, level=1, path = folder)
}

# Extracts the right state
extract_state <- function(data, state) {
  stateContour <- data[data$NAME_1 == state,]
}

bufferState <- function(state, buffDistance) {
  buffState <- gBuffer(state, width=buffDistance, byid=TRUE)
  return(buffState)
}