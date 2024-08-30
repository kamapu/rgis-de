library(terra)
library(tidyterra)

landscape <- rast("data/dgm-200m.tif")

landscape$slope <- terrain(landscape$dem, "slope")

l_aspect <- terrain(landscape$dem, "aspect")
landscape$northness <- cos(l_aspect*pi/180)
landscape$eastness <- sin(l_aspect*pi/180)

win <- matrix(rep(1, 11*11), nrow = 11)
win[4:8, 4:8] <- NA

l_mean <- focal(landscape$dem, win, fun = mean)
plot(l_mean)

landscape$tpi <- landscape$dem - l_mean

# Bioclimatic layer
climate <- rast("data/worldclim_bio.tif")[[c("bio_1", "bio_12")]]

landscape$temp <- project(climate$bio_1, landscape)
landscape$prec <- project(climate$bio_12, landscape)

plot(landscape)

random_p <- spatSample(landscape, 1000, as.points = TRUE)
pairs(random_p)

# Predict ----
mod_1 <- lm(temp ~ dem, data = random_p)

plot(mod_1$model$temp,
     predict(mod_1), pch = 16, col = "darkgreen",
     xlab = "observed", ylab = "predicted")
abline(0, 1, lty = "dashed", col = "red")

mod_2 <- lm(temp ~ dem + tpi, data = random_p)

plot(mod_2$model$temp,
     predict(mod_2), pch = 16, col = "darkgreen",
     xlab = "observed", ylab = "predicted")
abline(0, 1, lty = "dashed", col = "red")

summary(mod_1)[c("r.squared", "adj.r.squared")]
summary(mod_2)[c("r.squared", "adj.r.squared")]

mod_3 <- lm(temp ~ dem + tpi + northness, data = random_p)

plot(mod_3$model$temp,
     predict(mod_3), pch = 16, col = "darkgreen",
     xlab = "observed", ylab = "predicted")
abline(0, 1, lty = "dashed", col = "red")

summary(mod_1)[c("r.squared", "adj.r.squared")]
summary(mod_2)[c("r.squared", "adj.r.squared")]
summary(mod_3)[c("r.squared", "adj.r.squared")]

# In the space
mod_3_rast <- predict(landscape, mod_3)
names(mod_3_rast) <- "predicted"
mod_3_rast$observed <- landscape$temp

plot(mod_3_rast)

plot(predicted ~ observed,
     data = spatSample(mod_3_rast, 1000),
     pch = 16)
abline(0, 1, col = "red", lty = "dashed")
