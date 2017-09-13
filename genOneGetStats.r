# genOneGetStats.r
# A script for pulling various data points for Generation I pokemon via Bulbapedia

# Initialise tidyverse package
library(tidyverse)

# In the first instance we will need to create a dataframe of the Base Stats for Generation I pkmn
# This can be done using the rvest package which I will call using the custom function "getNode"
# Initialise getNode function
getNode <- function(url, xPathValue) {
  library(rvest)
  x <- read_html(url) %>% html_nodes(xpath = xPathValue)
  return(x)
}

# Get Base Stats from Bulbapedia (first table on specified url)
base.stats <-
  as.data.frame(html_table(
    getNode(
      'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_I)',
      '//table'
    )[1],
    fill = TRUE
  ))

# Create a seperate custom function to return specific tabular data as a list from each pokemon's entry on bulbapedia
pokeTable <- function(pkmn, tableNo) {
  require(rvest)
  url <-
    paste('https://bulbapedia.bulbagarden.net/wiki/',
          pkmn,
          '_(Pok%C3%A9mon)',
          sep = '')
  file <- read_html(url)
  tables <- html_nodes(file, "table")
  data <-
    as.list(as.data.frame(html_table(tables[tableNo], fill = TRUE)))
  return(data)
}

# Replacing the initial loop function with lapply
hatch_time <- lapply(baseStats$Pokémon, pokeTable, tableNo = 21)
