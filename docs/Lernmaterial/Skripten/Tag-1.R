# Einstieg in R ----

## Unnützliche Kommandozeilen ----

# Dieser Befehl zeigt den Arbeitsverzeichnis
getwd()
# setwd()

5 + 10

M <- 30
A <- 25
M - A
m <- 5

# Vektoren
meinObjekt <- c(1:100)
class(meinObjekt)
length(meinObjekt)

# Indizieren
meinObjekt[5]
meinObjekt[-5]
meinObjekt[c(1,3,10)]

# Klassen ----

## numeric ----
v_num <- meinObjekt/10

## logical ----
v_log <- meinObjekt < 10
v_log

class(v_log)
is.logical(v_log)
is(v_log, "logical")
as.numeric(v_log)

## character ----
Gruesse <- c("Hallo", "Tschüss")
Antwort <- "Wer hat \"Hallo\" gesagt"
Antwort
cat(Antwort)

## factor ----
Gender <- sample(c("male", "female", "other"), size = 150, # Der Befehl folgt...
                 replace = TRUE)
Gender <- as.factor(Gender)
summary(Gender)

5 +        100 # Leerzeichen tuen nichts

# Direkter...
Gender <- as.factor(sample(c("male", "female", "other"), 150, TRUE))

# data.frames/Datensatz ----
data()
data(iris)

head(iris)
tail(iris)

str(iris)
iris

# Indizieren
iris$Sepal.Length
iris$Sepal.Length[6]
iris[6,1]
iris[6,"Sepal.Length"]

iris[[1]]
iris[["Sepal.Length"]]

summary(iris)

# Pakete ----
install.packages("readr")

library(readr)

# Dateine herunterladen ----
install.packages("rvest")

library(rvest)
url_data <- "kamapu/rgis-de/blob/main/Lernmaterial/Dateien/data"
page <- read_html(file.path("https://github.com", url_data))
file_links <- page %>%
  html_nodes("a") %>%
  html_attr("href")
file_links <- unique(file_links[grepl(url_data, file_links) &
                                  file_links != url_data])
file_links <- sub("/blob/", "/", file_links)
dir.create("data")
for(i in paste0("https://raw.githubusercontent.com", file_links))
  download.file(i, file.path("data", basename(i)), method = "curl")

# Tabellen lesen ----
Boden <- read.csv("data/soil_properties.csv")

head(Boden)

# csv vs csv2
write.csv2(Boden, "soil_de.csv")
Boden2 <- read.csv("soil_de.csv")

# Data Frame vs Tibbles ----
Boden <- read.csv("data/soil_properties.csv")
Boden <- subset(Boden, depthpos == "t")
Boden <- Boden[ , c("smmp_id", "x_smmp", "y_smmp", "fc_vol_perc")]

pairs(Boden)

# Tibbles und Pipes
library(readr)
library(dplyr)

Boden_t <- read_csv("data/soil_properties.csv") %>%
  filter(depthpos == "t") %>%
  select(smmp_id, x_smmp, y_smmp, fc_vol_perc)

Boden_t

head(read.csv("data/soil_properties.csv"))

# Plot Funktionen ----
?plot
pairs(iris)

plot(iris$Petal.Length, iris$Petal.Width, col = iris$Species,
     pch = 19)

plot(Petal.Width ~ Petal.Length, data = iris, col = Species, pch = 19)
text(2, 1, labels = "Ich kann Text in Graphiken einfügen! Juhu!",
     col = "red")
text(Petal.Width ~ Petal.Length, data = iris, labels = Species,
     col = as.integer(Species), pos = 4)

boxplot(Petal.Width ~ Species, data = iris)

library(ggplot2)

ggplot(iris, aes(x = Petal.Length, y = Petal.Width, colour = Species)) +
  geom_point()

G1 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Species)) +
  geom_point()

G1

G1 +
  facet_wrap(vars(Species))

ggplot(iris, aes(x = Species, Sepal.Length, fill = Species)) +
  geom_boxplot()

iris %>%
  filter(Species %in% c("setosa", "virginica")) %>%
  ggplot(aes(x = Species, Sepal.Length, fill = Species)) +
  #geom_boxplot(outliers = FALSE)
  geom_boxplot()

# Datum ----
jetzt <- Sys.time()

for(i in 1:1000000)
  n <- i

jetzt - Sys.time()

class(jetzt)

as.Date(jetzt)

Sys.Date()
as.Date(0)
as.Date(-1)

Sys.Date() - as.Date("1978-10-27")

as.Date("15.09.2022")

?strptime

Stichtag <- as.Date(strptime("15.09.2022", format = "%d.%m.%Y"))

format(Stichtag, format = "%A")
as.integer(format(Stichtag, format = "%U"))


