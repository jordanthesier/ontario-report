#Data analysis

#Load packages 
library(tidyverse)

#Grab data for analysis
sample_data <- read_csv("data/sample_data.csv")
glimpse(sample_data)

#Summarize 
summarize(sample_data, avg_cells = mean(cells_per_ml))

#Syntax
#This is the same as the line of code above
sample_data %>%
  #Group the data 
  group_by(env_group) %>%
  #Calculate mean
  summarize(avg_cells = mean(cells_per_ml))
