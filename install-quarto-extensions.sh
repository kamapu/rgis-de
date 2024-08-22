# install extension for slides
quarto add --no-prompt https://gitlab.com/quarto-extensions/kamapu/-/archive/main/shorty-main.zip

# move extensions to examples
rm -rf Lernmaterial/Foliensatz/_extensions
mkdir -p Lernmaterial/Foliensatz/_extensions

mv _extensions/kamapu Lernmaterial/Foliensatz/_extensions/
