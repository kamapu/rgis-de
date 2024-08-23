# Step 1: Update Pakages
update.packages(ask = FALSE)

# Step 2: Install missing requirements
pkgs <- c("tidyr", "dplyr", "sf", "ggplot2", "terra", "stars", "osmdata",
"leaflet",  "mapview", "geodata")

missing_pkgs <- pkgs[!pkgs %in% installed.packages()]

if(length(missing_pkgs))
  install.packages(missing_pkgs)

# Step 3: Cross-check
missing_pkgs <- pkgs[!pkgs %in% installed.packages()]

if(!length(missing_pkgs)) {
  message("Success!")
} else {
   stop(paste0(c("Following packages were not installed:",
     paste0("  - ", missing_pkgs)), collapse = "\n"))
}
