# Laden von Paketen
library(sf)
library(ggplot2)
library(dplyr)
library(units)

# sf von data frame ----
(pos <- data.frame(y = 51.446997, x = 7.263522, lab = "Wir sind hier"))

pos <- st_as_sf(pos, coords = c("x", "y"), crs = 4326)
pos

# Vergleich in Stadtbezirke
Bochum <- st_read("data/Stadtbezirke.shp")

Bochum %>%
  ggplot() +
  geom_sf() +
  geom_sf(data = pos)

Bochum %>%
  ggplot() +
  geom_sf() +
  geom_sf_label(data = pos, aes(label = lab))

pos_utm <- st_transform(pos, crs = 25832)
st_coordinates(pos)
st_coordinates(pos_utm)

# Funktionen für geometrien ----
Bochum
Bochum$Stadt <- "Bochum"
Bochum

(Bochum_std <- st_union(Bochum))

plot(st_geometry(Bochum_std))

#Bochum$area2 <- st_area(Bochum)/(1000*1000)
Bochum$area2 <- st_area(Bochum)
Bochum$area2 <- set_units(Bochum$area2, km^2)

plot(area.km.. ~ area2, data = Bochum, pch = 16, col = "darkgreen")
abline(0, 1, lty = "dashed", col = "red")

# Jetz schauen uns die Straßen an ----
(Bochum_str <- readRDS("data/roads.rds"))

Bochum_summ <- Bochum_str %>%
  filter(highway %in% c("motorway", "trunk", "primary")) %>%
  group_by(highway) %>%
  summarise(number = length(osm_id))

# Eigentlich sollen wir die Länge messen
Bochum_str$length <- st_length(Bochum_str)
hist(Bochum_str$length)
boxplot(Bochum_str$length)

Bochum_length <- Bochum_str %>%
  filter(highway %in% c("motorway", "trunk", "primary")) %>%
  group_by(highway) %>%
  summarise(total_length = sum(length))

as.data.frame(Bochum_summ)
as.data.frame(Bochum_length)

# Importieren von GPX ----
st_layers("data/Troisdorf-Bochum.gpx")

Track <- st_read("data/Troisdorf-Bochum.gpx", "tracks")
plot(st_geometry(Track))
Track

Trackpoints <- st_read("data/Troisdorf-Bochum.gpx", "track_points")
plot(st_geometry(Trackpoints))
Trackpoints

# Mapview ----
library(mapview)

Trackpoints <- st_read("data/Troisdorf-Bochum.gpx", "track_points")

mapview(Trackpoints)

# Raster Datensätze ----
library(terra)

DGM <- rast("data/dgm-200m.tif")
DGM

plot(DGM)
plot(st_geometry(st_transform(pos, crs = 25832)), add = TRUE, col = "red",
     bg = "red")
