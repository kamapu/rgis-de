# Karten mit leaflet ----
library(sf)
library(leaflet)
library(dplyr)

Bochum <- st_read("data/Stadtbezirke.shp") %>%
  rename(
    id = Gemeind_ID,
    Stadtbezirk = Stadtbezir,
    area_km2 = area.km..) %>%
  st_transform(crs = 4326)

Bochum %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons()

Bochum %>%
  leaflet() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addProviderTiles("WaymarkedTrails.cycling") %>%
  addPolygons() %>%
  addScaleBar(position = "topright") %>%
  addMiniMap(position = "bottomright")

# Rasterdaten in leaflet ----
library(terra)

Klima <- rast("data/worldclim_bio.tif")

pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"),
                    values(Klima$bio_1),
                    na.color = "transparent")

pal <- colorNumeric(c("#0014e2", "#aa691e", "#b80000"),
                    values(Klima$bio_1),
                    na.color = "transparent")

leaflet() %>%
  addTiles() %>%
  addRasterImage(Klima$bio_1, colors = pal,
                 opacity = 0.7) %>%
  addLegend(pal = pal, values = values(Klima$bio_1),
            title = "temp")

# Text processing ----

x <- c("8", "- 44 - ")
sub("- ", "", x, fixed = TRUE)
gsub("- ", "", x, fixed = TRUE)

gsub("[^0-9]+", "", x)

# Bilder Vorbereiten ----

plot(Klima$bio_1)
dev.copy(png, filename = "test.png", width = 800, height = 500,
         res = 150)
dev.off()


# Alternative für ggplot
library(ggplot2)
library(tidyterra)

ggplot() +
  geom_spatraster(data = Klima, aes(fill = bio_1))
ggsave("raster-from-ggplot.png")


temp_map <- leaflet() %>%
  addTiles() %>%
  addRasterImage(Klima$bio_1)

temp_map

library(mapview)
mapshot2(temp_map, file = "raster-from-leaflet.png")
