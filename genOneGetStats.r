# genOneGetStats.r
# A script for pulling various data points for Generation I pokemon via Bulbapedia

library(rvest)
library(tidyverse)

# Get Base Stats from Bulbapedia
url <- 'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_I)'
file<-read_html(url)
tables<-html_nodes(file, "table")
tables[2]
baseStats <- as.data.frame(html_table(tables[1], fill = TRUE))


# Loop through each pokemon to get table extraction
# while(i <= pokeCount){
#   url <- paste('https://bulbapedia.bulbagarden.net/wiki/',baseStats$Pokémon[i],'_(Pok%C3%A9mon)',sep='')
#   file<-read_html(url)
#   tables<-html_nodes(file, "table")
#   baseStats$catch_rate[i] <- as.character(as.data.frame(html_table(tables[18], fill = TRUE)))
#   baseStats$gender_ratio[i] <- as.character(as.data.frame(html_table(tables[17], fill = TRUE))[,1][2])
#   baseStats$hatch_time[i] <- as.character(as.data.frame(html_table(tables[21], fill = TRUE)))
#   baseStats$height[i] <- as.character(as.data.frame(html_table(tables[22], fill = TRUE))[,2][1])
#   baseStats$weight[i] <- as.character(as.data.frame(html_table(tables[23], fill = TRUE))[,2][1])
#   print(paste('Run ',i,' of ',pokeCount,' complete ',sep=''))
#   i <- i + 1
# }

pokeTable <- function(pkmn,tableNo){
  require(rvest)
  url <- paste('https://bulbapedia.bulbagarden.net/wiki/',pkmn,'_(Pok%C3%A9mon)',sep='')
  file<-read_html(url)
  tables<-html_nodes(file, "table")
  data <- as.list(as.data.frame(html_table(tables[tableNo], fill = TRUE)))
  return(data)
}

# Replacing the initial loop function with lapply
hatch_time <- lapply(baseStats$Pokémon,pokeTable,tableNo=21)
