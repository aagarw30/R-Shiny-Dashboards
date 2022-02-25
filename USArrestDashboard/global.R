#### Load the required packages ####
library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(maps) # for USA states map
library(tidyr) # use gather() to convert from wide format to long format
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating


#### Dataset Manipulation ####
## create a states object from rownames 
states = rownames(USArrests)

## Add a new column variable state into the dataset
my_data <- USArrests %>% 
  mutate(state = states) 

str(my_data)
### get the choice for the selectInput filters that are used for visualization or map
# get the column names into a character vector
colname = my_data %>% 
  relocate("state", "UrbanPop", "Rape", "Murder", "Assault") %>% 
  names()


# Column names without state
v1 = colname[-1]

# Column names without state and UrbanPopulation
v2 = colname[-c(1,2)]


####Preparing data for Arrests Map ####
# map data for US states boundaries using the maps package
state_map <- map_data("state") 

# convert state to lower case
my_data1 = my_data %>% 
  mutate(state = tolower(state)) 

## Add the latitude, longitude and other info needed to draw the ploygon for the state map
# few NA's which will be removed during the mapping
merged_r =right_join(my_data1, state_map,  by=c("state" = "region"))

# Add State Abreviations and center locations of each states. Create a dataframe out of it
st = data.frame(abb = state.abb, stname=tolower(state.name), x=state.center$x, y=state.center$y)

# Join the state abbreviations and center location to the dataset
new_join = left_join(merged_r, st, by=c("state" = "stname"))





