library(rvest)
library(tidyverse)

theurl <- 'https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_I)'
file<-read_html(theurl)
tables<-html_nodes(file, "table")
tables[2]
baseStats <- as.data.frame(html_table(tables[1], fill = TRUE))


theurl <- 'https://bulbapedia.bulbagarden.net/wiki/Bulbasaur_(Pok%C3%A9mon)'
file<-read_html(theurl)
tables<-html_nodes(file, "table")
catch_rate <- as.character(as.data.frame(html_table(tables[18], fill = TRUE)))
gender_ratio <- as.character(as.data.frame(html_table(tables[17], fill = TRUE))[,1][2])
hatch_time <- as.character(as.data.frame(html_table(tables[21], fill = TRUE)))
height <- as.character(as.data.frame(html_table(tables[22], fill = TRUE))[,2][1])
weight <- as.character(as.data.frame(html_table(tables[23], fill = TRUE))[,2][1])
