library(geodata)

# Download names for Germany and rename layers
bio <- worldclim_country("Germany", var = "bio", res = 0.5, path = "rasters")
names(bio) <- paste0("bio_", c(1:19))

# Crop the data set
bb <- ext(c(6.7, 7.9, 51.1, 51.6))
bio <- crop(bio, bb)

# Write the raster
writeRaster(bio, "data/worldclim_bio.tif")
