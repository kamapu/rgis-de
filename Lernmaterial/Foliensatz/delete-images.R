imgs <- list.files("Lernmaterial/Foliensatz/images")
imgs <- imgs[grepl("\\b\\w+\\.(jpg|png)\\b", imgs)]

qmds <- c(readLines("Lernmaterial/Foliensatz/course-intro.qmd"),
        readLines("Lernmaterial/Foliensatz/gis-intro.qmd"),
        readLines("Lernmaterial/Foliensatz/index.qmd"))

check <- logical(0)
for(i in imgs)
  check <- c(check, any(grepl(i, qmds)))

file.remove(file.path("Lernmaterial/Foliensatz/images", imgs[!check]))
