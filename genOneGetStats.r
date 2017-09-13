# genOneGetStats.r
# A script for pulling various data points for Generation I pokemon via Bulbapedia

# In the first instance we will need to create a dataframe of the Base Stats for Generation I pkmn
# This can be done using the rvest package which I will call using the custom function "GetNode"

library(tidyverse)

# Initialise getNode function
getNode <- function(url, xPathValue) {
  library(rvest)
  x <- read_html(url) %>% html_nodes(xpath = xPathValue)
  return(x)
}

# Get Base Stats from Bulbapedia (first table on specified url)
base.stats <-as.data.frame(html_table(getNode('https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_I)','//table')[1],
    fill = TRUE))

# Create a seperate custom function to return specific tabular data as a list from each pokemon's entry on bulbapedia
# The poketable function allows you to input a pokemon name, and the appropriate bulbapedia page is crawled for html data
# 
pokeTable <- function(pkmn, tableNo,row,col) {
  require(rvest)
  url <-
    paste('https://bulbapedia.bulbagarden.net/wiki/',
          pkmn,
          '_(Pok%C3%A9mon)',
          sep = '')
  file <- read_html(url)
  tables <- html_nodes(file, "table")
  data <-
   as.data.frame(html_table(tables[tableNo], fill = TRUE))
  return <- data[row,col]
  return(return)
}

# Replacing the initial loop function with lapply
print("Running hatch_time lapply")
hatch_time <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 21,row=1,col=1)))
print("Running height lapply")
height <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 22,row=1,col=2)))
print("Running weight lapply")
weight <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 23,row=1,col=2)))
print("Running type1 lapply")
type1 <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 10,row=1,col=1)))
print("Running type2 lapply")
type2 <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 10,row=1,col=2)))

# Add the stat collection to the baseStats dataframe
baseStats$hatch_time <- hatch_time[,1]
baseStats$height <- height[,1]
baseStats$weight <- weight[,1]
baseStats$type1 <- type1[,1]
baseStats$type2 <- type2[,1]
