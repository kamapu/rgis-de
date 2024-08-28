# Beöntigte Pakete ----
library(sf)
library(osmdata)
library(dplyr)
library(ggplot2)

# Referenz für die Untersuchungsfläche ----
Bezirke <- st_read("data/Stadtbezirke.shp") %>%
  st_transform(crs = st_crs(4326))

# Expanding bbox
bb <- st_bbox(Bezirke)
bb <- bb + c(-0.005, -0.005, 0.005, 0.005)

# Straßen und Wege ----
roads <- opq(bbox = bb) %>%
  add_osm_feature(key = 'highway') %>%
  osmdata_sf()

roads <- roads$osm_lines %>%
  select(osm_id, name, highway, lanes, surface)

# display
plot(roads["highway"])

# save
saveRDS(roads, "data/roads.rds")

# Krankenhäuser ----
hospital <- opq(bbox = bb) %>%
  add_osm_feature(key = "building", value = "hospital") %>%
  osmdata_sf()

plot(st_geometry(hospital$osm_polygons))

saveRDS(hospital$osm_polygons[c("osm_id", "name", "addr:city")],
        "data/hospitals.rds")
