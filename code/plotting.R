#plotting lake ontario microbial abundances 



#First install packages 
install.packages("tidyverse")
library(tidyverse)


#Load in data
sample_data <- read_csv(file = "sample_data.csv")

Sys.Date() #What is the date
getwd() #Where am I?

sum(2, 3)
?round
print(round(3.1415))

#What does our data look like?
View(sample_data)
str(sample_data)

#Point plot
ggplot(data = sample_data) +
  aes(x = temperature, y = cells_per_ml/1000000, color = env_group, size = chlorophyll) +
  labs(x = "Temp (C)", y = "Cell Abundance (millions/ml)", title = "Does temperature affect microbial abundance?", color = "Environmental group", size = "Chlorophyll (ug/L)") +
  geom_point()



# BUOY DATA
buoy_data <- read_csv(file = "buoy_data.csv")
dim(buoy_data)
glimpse(buoy_data)
unique(buoy_data$sensor)
length(unique(buoy_data$sensor))


# Line Plot
ggplot(data = buoy_data) +
  aes(x = day_of_year, y = temperature, group = sensor, color = depth) +
  geom_line()

# Facet plot - break up graphs based on buoy, y axis have their own appropriate scales 
ggplot(data = buoy_data) +
  aes(x = day_of_year, y = temperature, group = sensor, color = depth) +
  geom_line() +
  facet_wrap(~buoy, scales = "free_y")

# Facet grid - graphs share x axis 
ggplot(data = buoy_data) +
  aes(x = day_of_year, y = temperature, group = sensor, color = depth) +
  geom_line() + 
  facet_grid(rows = vars(buoy))

# Box plot with samples - Cell abundances by env group
ggplot(data = sample_data) +
  aes(x = env_group, y = cells_per_ml, color = env_group, fill = env_group) +
  geom_jitter(aes(size = chlorophyll)) +
  geom_boxplot(alpha = 0.3, outlier.shape = NA) +
  theme_bw()

# Saving
ggsave("Cells_per_env_group.png", width = 6, height = 4)


#Homework plot 1
ggplot(data = sample_data) +
  aes(x = total_nitrogen, y = cells_per_ml/1000000, size = temperature, color = env_group) +
  labs(x = "Total nitrogen (mg/L)", y = "Cell abundance (millions/mL)", title = "Does nitrogen affect microbial cell abundance?", color = "Environmental Group", size = "Temperature (C)") +
  geom_smooth(method = "lm", aes(group = 1), se = FALSE, show.legend = FALSE) +
  geom_point()

#Homework plot 2
ggplot(data = sample_data) +
  aes(x = total_phosphorus, y = cells_per_ml/1000000, size = temperature, color = env_group) +
  labs(x = "Total phosphorus (mg/L)", y = "Cell abundance (millions/mL)", title = "Does phosphorus affect microbial cell abundance?", color = "Environmental Group", size = "Temperature (C)") +
  geom_smooth(method = "lm", aes(group = 1), se = FALSE, show.legend = FALSE) +
  geom_point()

ggsave("phosphorus_vs_cell_abundance.png", width = 6, height = 4)


