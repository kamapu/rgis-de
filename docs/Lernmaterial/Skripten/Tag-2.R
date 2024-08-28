# Wir arbeiten mit Vektoren ----
library(sf)

# Wir lesen ein Shapefile
Bochum <- st_read("data/Stadtbezirke.shp")

Bochum

# wkb: well-known-binary
# wkt: well-known-text

plot(Bochum)
plot(st_geometry(Bochum))
plot(Bochum["area.km.."])

names(Bochum)[3] <- "area"
names(Bochum)

plot(subset(Bochum, area > 20))

class(Bochum)
?plot.sf

Bochum$area_m <- Bochum$are * 1000 * 1000
names(Bochum)

# Als shapefile speichern
st_write(Bochum, "Bochum2.shp")

# Klassifizieren
Bochum$size <- "big"
Bochum$size[Bochum$area <= 20] <- "small"

summary(as.factor(Bochum$size))

Bochum$size <- factor(Bochum$size, levels = c("small", "big"))
summary(Bochum$size)

st_write(Bochum, "Bochum2.shp", append = FALSE)

# Image teilen
Bochum2 <- st_read("Bochum2.shp")
summary(Bochum)
summary(Bochum2)

saveRDS(Bochum, "Bochum2.rds")

# Image importieren
Bochum_mod <- readRDS("Bochum2.rds")

summary(Bochum)
summary(Bochum_mod)

# Straßennetz von Bochum
Bochum_str <- readRDS("data/roads.rds")
plot(Bochum_str["type"])

Bochum_str

# Straßennetz (Folge) ----
library(sf)
library(ggplot2)

# Objekten laden
Bochum <- st_read("data/Stadtbezirke.shp")

Bochum %>%
  ggplot(aes(fill = area.km.., label = Stadtbezir)) +
  geom_sf() +
  geom_sf_label() +
  xlab("") +
  ylab("")

# Straßennetz
(Bochum_str <- readRDS("data/roads.rds"))

aggregate(osm_id ~ lanes + surface + type, data = Bochum_str,
          FUN = length)

aggregate(osm_id ~ surface + type, data = Bochum_str,
          FUN = length)

subset(Bochum_str, lanes == 5)

# Wir schauen uns 5-spurigen Straßen
library(dplyr)
str_5 <- Bochum_str %>%
  filter(lanes == 5)

# Karte
Bochum %>%
  ggplot() +
  geom_sf(aes(fill = area.km..)) +
  #geom_sf_label(aes(label = Stadtbezir)) +
  geom_sf(data = str_5, aes(colour = "red", lwd = 4)) +
  geom_sf_label(data = str_5, aes(label = name))
  
Bochum_str %>%
  ggplot(aes(colour = lanes)) +
  geom_sf()

# Beispiel für OSM ----
library(sf)
library(osmdata)

# mit Extension
Box <- st_read("box.kml")
st_bbox(Box)

Singen <- opq(bbox = st_bbox(Box)) %>%
  add_osm_feature(key = "highway") %>%
  osmdata_sf()

Singen <- Singen$osm_lines %>%
  select(osm_id, name, surface, lanes, highway)

library(ggplot2)

Singen %>% ggplot(aes(colour = highway)) +
  geom_sf()
