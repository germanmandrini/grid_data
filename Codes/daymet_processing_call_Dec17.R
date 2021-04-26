wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
# install.packages("daymetr")
#library("daymetr")

source('./grid_data_git/Codes/functions.grid_Dec10.R')

#DOWNLOAD THE DAILY DATA: 4 VARIABLES
# Catalogo: https://thredds.daac.ornl.gov/thredds/catalogs/daymet/daymet.html
# Catalogo2: https://thredds.daac.ornl.gov/thredds/catalogs/ornldaac/Regional_and_Global_Data/DAYMET_COLLECTIONS/DAYMET_COLLECTIONS.html
# User guide: https://daac.ornl.gov/DAYMET/guides/Daymet_V3_CFMosaics.html
# Projection System: Lambert Conformal Conic
# LINK EXAMPLES
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_tmin_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_prcp_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_tmax_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_srad_1980_na.nc4


variables <- c('prcp', 'srad', 'tmax', 'tmin')
years <- 1980:2018
# 
all_combinations = expand.grid(variables, years)

#MAKE THE FOR PRCP YEAR:1980
# folder_name = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daymet_monthly' #CRPS
# 
# #folder_name = './Project.Grid/Grid/daymet/daily_data' #Dell

#CREATE A NEW GRID FILE: grid5000_tiles.sf TAHT has the proj of the daymet raster 
if(FALSE){
  grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf6.rds")
  proj <- raster::crs(file.brk)
  grid5000_LLC.sf <- st_transform(grid5000_tiles.sf, proj@projargs)
  saveRDS(grid5000_LLC.sf, './grid_data_box/files_rds/grid5000_LLC.sf.rds')
  grid5000_LLC.spdf <- as(grid5000_LLC.sf, 'Spatial')
  saveRDS(grid5000_LLC.spdf, './grid_data_box/files_rds/grid5000_LLC.spdf.rds') # for the server, cannot use sf package
}

grid5000_LLC.sf <- readRDS('./grid_data_box/files_rds/grid5000_LLC.sf.rds')

tiles_seq <- unique(grid5000_LLC.sf$id_tile)

for(row_n in 1:nrow(all_combinations)){
  # row_n = 1
  start_time <- Sys.time()
  year_n = as.character(all_combinations[row_n,2])
  var_n =  as.character(all_combinations[row_n,1])
  print(paste(year_n, var_n))
  
  source('./grid_data_git/Codes/daymet_processing_paralel_Dec17.R', local=TRUE)
  filename <- paste('./grid_data_box/files_rds/weather_files/weather_', year_n,'_', var_n, '.rds', sep = '')  
  
  saveRDS(results, filename)
  print(Sys.time() - start_time)
}#end of tile_n loop


#DETECT MISSING FILES
files_names <- list.files('./grid_data_box/files_rds/weather_files', pattern = 'weather_')
files_names <- gsub('weather_','',files_names)
files_names <- gsub('.rds','',files_names)
files_names2 <- strsplit(files_names,"_")
files_names3 <- rbindlist(lapply(files_names2, as.data.frame.list))
names(files_names3) <- c('Var2', 'Var1')
setcolorder(files_names3, c('Var1', 'Var2'))
files_names3 <- files_names3[,Var2 := as.integer(as.character(Var2))]

class(all_combinations$Var1)
class(files_names3$Var1)
class(all_combinations$Var2)
class(files_names3$Var2)

missing <- fsetdiff(data.table(all_combinations), files_names3, all = FALSE)

files_names <- list.files('./grid_data_box/files_rds/weather_files', pattern = 'weather_', full.names = TRUE,include.dirs = FALSE)

# DO IT IN TWO PARTS-BECAUSE IT GETS TOO BIG
grid5000_weather.dt <- data.table()
for(filename in files_names[77:156]){
  # filename <- files_names[77]
  counter = which(files_names == filename)
  print(counter)
  file_tmp.dt <- readRDS(filename)
  grid5000_weather.dt <- rbind(grid5000_weather.dt, file_tmp.dt)
  #SAVE BATCHES OF 50 TILES
  # count_by_batch = 50
  # if(counter %% count_by_batch == 0 | counter == length(files_names)){
  #   batch_count = ceiling(counter/count_by_batch)
  #   batch_name = paste('./grid_data_box/files_rds/landuse_files/batches_for_merge/landuse_batch_', batch_count, '.rds', sep = '')   
  #   saveRDS(grid5000_landuse.dt, batch_name)
  #   grid5000_landuse.dt <- data.table()
  # }#end of the save batches
  
}#end of the filename loop


grid5000_landuse.dt
grid5000_weather.dt[,source := 'daymet']
grid5000_weather.dt <- rename(grid5000_weather.dt, variable = var)
grid5000_weather.dt[,source := 'daymet']
grid5000_weather.dt[variable == 'prcp',unit := 'mm/month']
grid5000_weather.dt[variable == 'tmin' | variable == 'tmax',unit := 'degrees C']
grid5000_weather.dt[variable == 'srad',unit := 'W/m2']
setcolorder(grid5000_weather.dt, c('id_tile', 'id_5000', 'source', 'variable','unit', 'year', 'month', 'value'))
grid5000_weather.dt <- grid5000_weather.dt[year > 1999]
saveRDS(grid5000_weather.dt, "./grid_data_box/files_rds/grid5000_weather_part2_dt.rds")
fwrite(grid5000_weather.dt, './Project.Grid/Grid/Deliverables/grid5000_weather_part2.csv')
 