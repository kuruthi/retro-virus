# A data visualization project
# Visualizing data from the NFHS
library(tidyverse)
library(tmap)
library(sf)
library(tmaptools)
library(raster)
library(sp)
#########################

data_file <- "hiv_data.tsv"
state_shape <- "India_State_Boundary.shp"
setwd("~/retro-virus/")

hiv_t <- read_delim("hiv_data.tsv", comment = "#", na = c("NA","na"),delim = "\t")

#Calculate Average of Urban + Rural values
hiv_t <- hiv_t %>% mutate(Total = (Urban+Rural)/2)

#Sort by alphabetic order
hiv_t <- hiv_t[order(hiv_t$State_Name),]
hiv_tb <- hiv_t %>% filter(hiv_t$State_Name != "India")
hiv_tb <- hiv_tb[order(hiv_tb$State_Name),]

#Subsetting the tibble to use later
#1 - Comprehensive knowledge of HIV
#2 - Condom use can reduce chance of HIV
con_use_f <- hiv_tb %>% filter(hiv_tb$Gender == 'F' & hiv_tb$Question == 2)

#importing Indian map shapefile

india_state <- sf::read_sf("India-State-and-Country-Shapefile-Updated-Jan-2020/India_State_Boundary.shp")

#sort by alphabetical order
india_state <- india_state[order(india_state$State_Name),]

#comparing the state name columns in our data tibbles and the shapefile tibble
india_state_no_puducherry <- india_state %>% filter(!row_number() %in% c(28))
ifelse(india_state$State_Name == con_use_f$State_Name, "Yes","No")
ifelse(india_state_no_puducherry$State_Name == con_use_f$State_Name, "Yes","No")
#The state names donot match
#Editing the column in india_state to match the others

india_state$State_Name <- con_use_f$State_Name
india_state_no_puducherry$State_Name <- con_use_f$State_Name

#merging the spatial dataframe with the data tibbles
india_state_hiv <- sp::merge(india_state, hiv_tb)
india_state_hiv_no_puducherry <- sp::merge(india_state_no_puducherry, hiv_tb)

#Data visualization
#There are two puducherrys in the mapfile dropping one of them

india_state_hiv %>% filter(india_state_hiv$Gender == 'F' & india_state_hiv$Question == 1) %>% qtm("Rural")

india_state_hiv_no_puducherry %>% filter(india_state_hiv_no_puducherry$Question == 1) %>% tm_shape() +
  tm_fill("Urban", title = "Percentage of Urban women with comprehensive HIV knowledge", palette = "PuRd" ) +
  tm_borders(alpha = .5) +
  tm_text("State_Name", size = 0.5) +
  tm_style("classic")

india_state_hiv %>% filter(india_state_hiv$Question == 2) %>% tm_shape() +
  tm_fill("Urban", title = "Percentage of Urban women with comprehensive HIV knowledge", palette = "PuBu" ) +
  tm_borders(alpha = .5) +
  tm_text("State_Name", size = 0.5) +
  tm_style("classic")



