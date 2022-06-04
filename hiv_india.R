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

hiv_tb <- read_delim("hiv_data.tsv", comment = "#", na = c("NA","na"),delim = "\t")

#Calculate Average of Urban + Rural values
hiv_tb <- hiv_tb %>% mutate(Total = (Urban+Rural)/2)

#Sort by alphabetic order
hiv_tb <- hiv_tb[order(hiv_tb$State_Name),]

#Subsetting the tibble
#1 - Comprehensive knowledge of HIV
hiv_know <- hiv_tb %>% filter(hiv_tb$Question == 1)
hiv_know_f <- hiv_know %>% filter(hiv_know$Gender == 'F')
hiv_know_m <- hiv_know %>% filter(hiv_know$Gender == 'M')
#2 - Condom use can reduce chance of HIV
con_use <- hiv_tb %>% filter(hiv_tb$Question == 2)
con_use_f <- con_use %>% filter(con_use$Gender == 'F')
con_use_m <- con_use %>% filter(con_use$Gender =='M' )

#importing Indian map shapefile

india_state <- sf::read_sf("India-State-and-Country-Shapefile-Updated-Jan-2020/India_State_Boundary.shp")

#sort by alphabetical order
india_state <- india_state[order(india_state$State_Name),]

#comparing the state name columns in our data tibbles and the shapefile tibble

ifelse(india_state$State_Name == con_use_f$State_Name, "Yes","No")
#The state names donot match
#Editing the column in india_state to match the others
india_state$State_Name <- con_use_f$State_Name

#merging the spatial dataframe with the data tibbles
india_state_con <- sp::merge(india_state, con_use)

india_state_hiv <- sp::merge(india_state, hiv_know)

india_state_o <- sp::merge(india_state, hiv_tb)

#Data visualization
india_state_o %>% filter(india_state_hiv$Gender == 'F' & india_state_o$Question == 1) %>% qtm("Urban")



