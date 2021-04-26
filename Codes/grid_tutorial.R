######################################
# SPATIAL DATABASE TUTORIAL
######################################
# written by German Mandrini on 12/20/2018

#--------------------------
# preparation
#--------------------------
#--- load libraries ---#
library(raster)
library(sf)
library(data.table)
library(tmap)

rm(list=ls())
# setwd('C:/Users/germa/Box Sync/My_Documents') #dell
# codes_folder <-'C:/Users/germa/Documents'#Dell
setwd('C:/Users/germanm2/Box Sync/My_Documents')#CPSC
codes_folder <-'C:/Users/germanm2/Documents'#CPSC
# setwd('~')#Server
# codes_folder <-'~' #Server


#-- Step 1: Open the spatial data. This is a file with all the 5x5 km grids where crops where found
grid5000_spatial.sf <- st_read("./grid_data_box/Deliverables/grid5000_spatial.shp")
nrow(grid5000_spatial.sf)

#-- Step 2: Open the tables with land use, weather and soils data
grid5000_landuse.dt <- fread('./grid_data_box/Deliverables/grid5000_landuse.csv')
grid5000_weather_part1.dt <- fread('./grid_data_box/Deliverables/grid5000_weather_part1.csv')
grid5000_weather_part2.dt <- fread('./grid_data_box/Deliverables/grid5000_weather_part2.csv')
grid5000_soils.dt <- fread('./grid_data_box/Deliverables/grid5000_soils.csv')

#===================================
# Examples of how to open and show the data
#===================================


# === Example 1: plot crop cell count in Illinois from crop frequency 2008-2017 === #

#filter the state of illinois
illinois.sf <- grid5000_spatial.sf[grid5000_spatial.sf$US_state == 'Illinois',]

#plot it
tm_shape(illinois.sf) + tm_polygons('cult_count') + 
  tm_layout(legend.text.size = 0.7,
          main.title = paste('Illinois - Crop Frequency 2008-2017'),
          main.title.position = "center",
          main.title.size = 1)

# === Example 2: Plot corn sensitivity using sd === #

# make a table with the right data
illinois_corn.dt <- grid5000_landuse.dt[id_5000 %in% illinois.sf$id_5000,] %>% .[variable == 'Corn']
corn_sensitivity.dt <- illinois_corn.dt[, .(count_sd = sd(value)),by=.(id_5000)]

# merge the table to the spatial data
illinois.sf <- dplyr::left_join(illinois.sf, corn_sensitivity.dt, by = 'id_5000')

#plot it
tm_shape(illinois.sf) + tm_polygons('count_sd') + 
  tm_layout(legend.text.size = 0.7,
            main.title = paste('Illinois - Corn Sensitivity'),
            main.title.position = "center",
            main.title.size = 1)

# === Example 3: Plot average precipitation 1999:2018 === #

# make a table with the right data
precipitation.dt <- grid5000_weather_part2.dt[variable == 'prcp', .(prcp = sum(value)), by = c('id_5000', 'year')] %>%
  .[, .(prcp = mean(prcp)), by = c('id_5000')]

# merge the table to the spatial data
illinois.sf <- dplyr::left_join(illinois.sf, precipitation.dt, by = 'id_5000')

#plot it
tm_shape(illinois.sf) + tm_polygons('prcp') + 
  tm_layout(legend.text.size = 0.7,
            main.title = paste('Illinois - Average annual Precipitation'),
            main.title.position = "center",
            main.title.size = 1)

# === Example 4: Plot corn sensitivity using sd === #

# make a table with the right data
illinois_clay.dt <- grid5000_soils.dt[id_5000 %in% illinois.sf$id_5000,] %>% .[variable == 'CLYPPT_M_sl3', .(id_5000, clay = value)]

# merge the table to the spatial data 
illinois.sf <- dplyr::left_join(illinois.sf, illinois_clay.dt, by = 'id_5000')

#plot it
tm_shape(illinois.sf) + tm_polygons('clay') + 
  tm_layout(legend.text.size = 0.7,
            main.title = paste('Illinois - Clay content'),
            main.title.position = "center",
            main.title.size = 1)

# === Example 5: Characterize a fields based on lat/long=== #
fields_dt <- data.table(field = 'A', latitude = 40.065326, longitude=-88.262700)

points_sf = st_as_sf(fields_dt, coords = c("longitude", "latitude"), 
                 crs = 4326, agr = "constant")

points_sf <- st_transform(points_sf, crs = st_crs(illinois.sf))

tm_shape(illinois.sf) + tm_polygons()   +
  tm_shape(points_sf) + tm_dots(size = 1)

points_sf <- st_join(points_sf, illinois.sf)  # spatial join to get intersection of points and poly
  
grid5000_landuse.dt[id_5000 %in% points_sf$id_5000]
grid5000_weather_part1.dt[id_5000 %in% points_sf$id_5000]
grid5000_weather_part2.dt[id_5000 %in% points_sf$id_5000]
grid5000_soils.dt[id_5000 %in% points_sf$id_5000]
  
