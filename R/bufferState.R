# Eline van Elburg
# 11-02-2016
# Thesis REG

# Needed imports
library(raster)
library(rgdal)

bufferState <- function(country, state, buffer, folder) {
  data <- download_data(country, folder)
  stateContour <- extract_state(data, state)
  plot(stateContour)
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

# Perform buffer