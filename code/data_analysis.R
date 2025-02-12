#Data analysis

#Load packages 
library(tidyverse)

#Grab data for analysis
sample_data <- read_csv("data/sample_data.csv")
glimpse(sample_data)

#Summarize() - summary stats on metadata
summarize(sample_data, avg_cells = mean(cells_per_ml))

#Syntax
#This is the same as the line of code above
sample_data %>%
  #Group the data 
  group_by(env_group) %>%
  #Calculate mean
  summarize(avg_cells = mean(cells_per_ml))

#Filter() - subset data by rows based on some value 
sample_data %>% 
  #subset samples only from the deep
    #We will subset based on a logical, TRUE == 1
  filter(temperature < 5) %>%
  #filter(env_group == "Deep") %>%
  #calculate the mean cell abundances 
  summarize(avg_cells = mean(cells_per_ml))

#Mutate() - create a new column
sample_data %>%
  #calc new column with the TN:TP ratio
  mutate(tn_tp_ratio = total_nitrogen/total_phosphorus) %>%
  #visualize
  view()

#Select() - subset by entire columns
sample_data %>%
  #pick specific columns 
  #select(sample_id, depth)
  #pick columns over a range
  #select(sample_id:temperature)
  #entire sample data remove a particular column
  #select(-diss_org_carbon)
  #remove multiple columns
  select(-c(diss_org_carbon, chlorophyll))

#Clean up data

