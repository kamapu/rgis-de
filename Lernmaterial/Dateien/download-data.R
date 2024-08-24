# Load necessary libraries
library(rvest)

# Specify the URL of the online folder
url <- "http://example.com/your-folder/"

# Read the HTML content of the page
page <- read_html(url)

# Extract links to files (assuming they are in <a> tags)
file_links <- page %>%
  html_nodes("a") %>%
  html_attr("href")

# Filter for specific file types if needed (e.g., .csv)
file_links <- file_links[grepl("\\.csv$", file_links)]

# Specify the local directory to save files
local_dir <- "path/to/your/local/folder/"

# Download each file
for (file in file_links) {
  # Create the full URL for the file
  full_url <- paste0(url, file)
  
  # Specify the destination file path
  destfile <- file.path(local_dir, file)
  
  # Download the file
  download.file(full_url, destfile, mode = "wb")
}
