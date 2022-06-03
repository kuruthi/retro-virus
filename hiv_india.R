# A data visualization project
# Visualizing data from the NFHS
library(tidyverse)

setwd("~/Downloads/data_visualization/")

hiv_tb <- read_tsv("hiv_data.csv", comment = "#", na = c("na"))
hiv_tb <- hiv_tb %>% mutate(Total = (Urban+Rural)/2)
#1 - Comprehensive knowledge of HIV
#2 - Condom use can reduce chance of HIV

hiv_know <- filter(hiv_tb,hiv_tb$Question == 1)
con_use <- hiv_tb %>% filter(hiv_tb$Question == 2)
write_tsv(hiv_tb,"hiv_data.tsv")
