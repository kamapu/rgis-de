# Nachmittags: Arbeit mit Geländemodellen ----
library(terra)
library(tidyterra)
library(ggplot2)

DGM <- rast("data/dgm-200m.tif")

# Verdeutlichen durch contour
plot(DGM)
contour(DGM, add = TRUE)

# Schatten (Rezept)
slope <- terrain(DGM, v = "slope", unit = "radians")
aspect <- terrain(DGM, v = "aspect", unit = "radians")
hill <- shade(slope, aspect, angle = 40, direction = -50)

plot(hill)

plot(hill, col = grey(0:100/100), legend = FALSE,
     mar = c(2, 2, 1, 4))
plot(DGM, add = TRUE, alpha = 0.5)

plot(DGM, col = topo.colors(1000))

plot(DGM, col = terrain.colors(1000))
contour(DGM, add = TRUE)

ggplot() +
  geom_spatraster(data = DGM) +
  geom_spatraster_contour(data = DGM)

# Landschaft -----
Landschaft <- rast("data/dgm-200m.tif")
add(Landschaft) <- terrain(Landschaft[[1]], "slope")
add(Landschaft) <- terrain(Landschaft[[1]], "aspect")
add(Landschaft) <- terrain(Landschaft[[1]], "TPI")

plot(Landschaft)

x <- values(Landschaft$aspect)
summary(x)

plot(x, cos(x*pi/180))
plot(x, sin(x*pi/180))

add(Landschaft) <- cos(Landschaft[["aspect"]]*pi/180)
names(Landschaft)[5] <- "northness"

add(Landschaft) <- sin(Landschaft[["aspect"]]*pi/180)
names(Landschaft)[6] <- "eastness"

plot(Landschaft)

# Moving windows ----
?focal

Fenster <- matrix(data = rep(1, 11*11), nrow = 11)
Fenster[6,6] <- NA
Fenster

TPI2 <- focal(Landschaft[[1]], w = Fenster, fun = mean)
TPI2 <- Landschaft[[1]] - TPI2
plot(TPI2)

add(Landschaft) <- TPI2
names(Landschaft)[7] <- "TPI2"

plot(Landschaft)

Klima <- rast("data/worldclim_bio.tif")
Klima

Landschaft$temp <- project(Klima$bio_1, Landschaft[[1]])
plot(Landschaft)

Landschaft_p <- spatSample(Landschaft, 1000, as.points = TRUE) 
head(Landschaft_p)

pairs(Landschaft_p)
