library(sf)
library(terra)

# Lade Dateien ----
Bochum <- st_read("data/Stadtbezirke.shp")
DGM <- rast("data/dgm-200m.tif")

(bb <- st_bbox(Bochum))
DGM

Bochum_dgm <- crop(DGM, bb, snap = "out")

plot(Bochum_dgm)
plot(Bochum, add = TRUE, border = "yellow", col = NA)

# Höhe von Raster zu Vektor
Bochum2 <- extract(Bochum_dgm, vect(Bochum), fun = mean, bind = TRUE)
Bochum2

plot(st_as_sf(Bochum2)["dem"])

# Masking anstatt Cropping ----
# Bochum_dgm2 <- mask(DGM, vect(Bochum))
Bochum_dgm2 <- crop(DGM, vect(Bochum), snap = "in", mask = TRUE)

plot(Bochum_dgm2)
plot(Bochum, add = TRUE, border = "yellow", col = NA)

# Entfernung zu Wegen ----
library(dplyr)
library(ggplot2)

Autobahn <- readRDS("data/roads.rds") %>%
  filter(highway %in% c("motorway", "trunk", "primary")) %>%
  st_transform(crs = 25832)

plot(st_geometry(Autobahn))

Autobahn %>% ggplot() +
  geom_sf(aes(colour = highway))

Autobahn_r <- rasterize(vect(Autobahn), Bochum_dgm)
Autobahn_d <- distance(Autobahn_r)

plot(Autobahn_d)

Bochum_dgm
add(Bochum_dgm) <- Autobahn_d

names(Bochum_dgm) <- c("dgm", "distance_to_road")
plot(Bochum_dgm)

library(tidyterra)

plot(Bochum_dgm["dgm"])
#plot(Strassen, col = "yellow", add = TRUE)

# Rasters Projizieren ----
library(terra)
DGM <- rast("data/dgm-200m.tif")

t_names <- paste0("agbd-2022-tile", c(1:4), ".tif")
Biomasse <- vrt(file.path("data", t_names))

DGM
Biomasse

Biomasse_utm <- project(Biomasse, DGM,
                        filename = "Biomasse_proj.tif",
                        overwrite = TRUE)
add(DGM) <- Biomasse_utm
names(DGM) <- c("dgm", "tree_biomass")

plot(DGM)

writeRaster(DGM, "Sauerland.tif")

x <- rast("Sauerland.tif")
names(x)
