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
taxon_dirty <- read_csv("data/taxon_abundance.csv", skip = 2) #skip first 2 lines
head(taxon_dirty)

#Only pick to the cyano
taxon_clean <-
  taxon_dirty %>%
  select(sample_id:Cyanobacteria)
  
#What are the wide format dimensions? 71 rows by 7 columns
dim(taxon_clean)

#Pivot_lobger() - Shape data from wide into long format
taxon_long <-
  taxon_clean %>%
    #from Prot to Cyan, new column name Phylum for titles, new column name Abundance for values
    pivot_longer(cols = Proteobacteria:Cyanobacteria, names_to = "Phylum", values_to = "Abundance")

#Check dimensions - 426 by 3
dim(taxon_long)

#calculate avg abundance of each phylum
taxon_long %>%
  group_by(Phylum) %>%
  summarize(avg_abund = mean(Abundance))

#plot data
taxon_long %>%
  ggplot(aes(x = sample_id, y = Abundance, fill = Phylum)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90))

#Joining data frames
sample_data %>%
  head(6)

taxon_clean %>%
  head(6)

#inner_join() - joining what each file has in common 
sample_data %>%
  inner_join(., taxon_clean, by = "sample_id") %>%
  dim()

#Intuition checking - something's not right - Sep vs September
length(unique(taxon_clean$sample_id))
length(unique(sample_data$sample_id))

#Anti-join - which rows aren't joining?
sample_data %>%
  anti_join(., taxon_clean, by = "sample_id")

#fixing september samples
taxon_clean_goodSept <-
  taxon_clean %>%
  #replace sample_id column with fixed september names
  mutate(sample_id = str_replace(sample_id, pattern = "Sep", replacement = "September"))

#Check dimensions
dim(taxon_clean_goodSept)

#Inner joing
sample_and_taxon <-
  sample_data %>%
  inner_join(., taxon_clean_goodSept, by = "sample_id")

#Intuition check
dim(sample_and_taxon)

#test
stopifnot(nrow(sample_and_taxon) ==nrow(sample_data))

#Write out clean data to a new file
write_csv(sample_and_taxon, "data/sample_and_taxon.csv")

#Quick plot of Chloroflexi
sample_and_taxon %>%
  ggplot(aes(x = depth, y = Chloroflexi)) +
  geom_point() +
  #add a stat model
  geom_smooth()
