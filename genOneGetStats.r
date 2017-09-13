# genOneGetStats.r
# A script for pulling various data points for Generation I pokemon via Bulbapedia
# by Reuben Kandiah

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
baseStats <-as.data.frame(html_table(getNode('https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_VII-present)','//table')[2],
                                     fill = TRUE))

# Clean the baseStats table to remove odd data points
baseStats <- baseStats[!duplicated(baseStats$X.),]
names(baseStats)[names(baseStats) == "X."] = "id"
baseStats <- baseStats %>% select(-Var.2)

# Create a seperate custom function to return specific tabular data as a list from each
# pokemon's entry on bulbapedia
# The poketable function allows you to input a pokemon name, 
# and the appropriate bulbapedia page is crawled for html data
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
  data <- data[row,col]
  return(data)
}

# Replacing the initial loop function with lapply
#
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
catch_rate <- as.data.frame(unlist(lapply(baseStats$Pokémon, pokeTable, tableNo = 18,row=1,col=1)))

baseStats$hatch_time <- hatch_time[,1]
baseStats$height <- height[,1]
baseStats$weight <- weight[,1]
baseStats$type1 <- type1[,1]
baseStats$type2 <- type2[,1]
baseStats$catch_rate <- catch_rate[,1]

# Clean the imported baseStats data points
baseStats$height <- as.numeric(gsub(' m','',baseStats$height))
baseStats$weight <- as.numeric(gsub(' kg','',baseStats$weight))
baseStats$catch_rate_index <- as.numeric(gsub(' (.*)','',baseStats$catch_rate))

# Some sort of ggplot
# ggplot(data=baseStats,aes(x=reorder(type1,-HP,FUN=median),y=HP,fill=as.factor(type1))) + 
#   theme_minimal() +
#   stat_boxplot(geom="errorbar",width=0.5) + 
#   geom_boxplot(group=1) +
#   theme(legend.position="bottom",axis.text.x = element_text(angle=60, hjust=1)) +
#   ylim(low=0,high=150) +
#   labs(x="Type 1",y="HP Base Stats") +
#   ggtitle("Distribution of Base HP Stats by Type 1 (Gen I)")
#   geom_bar(data=baseStats,aes(x=reorder(type1,-HP,FUN=mean),y=median(HP)),stat="identity")

  


# Import the evolution table from pokemondb.net

evoTable <-as.data.frame(html_table(getNode('https://pokemondb.net/evolution/level','//table[@id="evolution"]'),
                                      fill = TRUE))
