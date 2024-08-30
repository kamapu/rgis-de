library(terra)
library(tidyterra)
library(ggplot2)

# Diverse Methoden für die gleich Funktion
?stats::filter
?dplyr::filter
?tidyterra::filter

# zufällige Probenahme ----
DGM <- rast("data/dgm-200m.tif")

ggplot() +
  geom_spatraster(data = DGM)

summary(DGM, size = Inf)

random_p <- spatSample(DGM, size = 1000)
head(random_p)
summary(random_p)

random_p <- spatSample(DGM, size = 1000, as.points = TRUE)

ggplot() +
  geom_spatraster(data = DGM) +
  geom_spatvector(data = random_p)

regular_p <- spatSample(DGM, size = 1000, as.points = TRUE,
                        method = "regular")

ggplot() +
  geom_spatraster(data = DGM) +
  geom_spatvector(data = random_p, colour = "grey") +
  geom_spatvector(data = regular_p, colour = "red")

# Stratified ----
library(sf)
Bochum <- st_read("data/Stadtbezirke.shp")

ggplot() +
  geom_sf(data = Bochum)

head(Bochum)

#Bochum_rast <- rasterize(vect(Bochum), DGM, field = "Gemeind_ID")
#Bochum_rast <- crop(Bochum_rast, vect(Bochum), snap = "out")

Bochum_rast <- rasterize(vect(Bochum), DGM,
                         field = "Gemeind_ID") %>%
  crop(y = vect(Bochum), snap = "out")

plot(Bochum_rast)

random_p_str <- spatSample(Bochum_rast, size = 100, as.points = TRUE,
                           method = "stratified")

ggplot() +
  geom_spatraster(data = Bochum_rast) +
  geom_spatvector(data = random_p_str, colour = "red")

head(random_p_str)
summary(as.factor(random_p_str$Gemeind_ID))

# Extrahieren von Höhenangaben -----
sample_elevation <- extract(DGM, random_p_str, bind = TRUE)
head(sample_elevation)

boxplot(dem ~ Gemeind_ID, data = sample_elevation)

# Bezirknamen
library(dplyr)

sample_elevation <- sample_elevation %>%
  mutate(name = Bochum$Stadtbezir[match(Gemeind_ID,
                                        Bochum$Gemeind_ID)]) %>%
  rename(id = Gemeind_ID,
         dgm = dem)

sample_elevation %>%
  ggplot(aes(fill = name, x = dgm)) +
  geom_boxplot()

head(sample_elevation)

# Noch ein Beispiel
Klima <- rast("data/worldclim_bio.tif")
plot(Klima)
Klima

dim(Klima)
ncell(Klima)

DGM

random_p2 <- spatSample(Klima, size = ncell(Klima)*0.01,
                        as.points = TRUE)
head(random_p2)
pairs(random_p2)

random_p3 <- spatSample(
  Klima[[c("bio_1", "bio_4", "bio_8", "bio_9", "bio_12")]],
  size = ncell(Klima)*0.1, as.points = TRUE) %>%
  rename(temp_mean = bio_1,
         temp_season = bio_4,
         temp_wettest = bio_8,
         temp_driest = bio_9,
         prec = bio_12)

pairs(random_p3, pch = 16, col = "red")
