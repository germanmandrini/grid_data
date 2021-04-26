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
years <- 1980:2017
# 
all_combinations = expand.grid(variables, years)
# 
# download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>% 
#                           .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/',all_combinations[,2],'/', file_name, sep = '')] %>%
#                           .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', file_name)]
# 
# downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', all.files = FALSE,
#                             full.names = FALSE, recursive = FALSE,
#                             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
# download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]
# 
# for(i in 1:nrow(download_ask)){
#   status = try(httr::GET(url = download_ask$download_link[i], 
#                          httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE), 
#                          httr::progress()), silent = FALSE)
# }
# 
# 
# 
# #DOWNLOAD THE MONTHLY DATA: 3 VARIABLES
# # LINK EXAMPLES
# # https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_prcp_monttl_1980_na.nc4
# # https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmin_monavg_1980_na.nc4
# # https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmax_monavg_1980_na.nc4
# 
# variables <- c('prcp_monttl', 'tmax_monavg', 'tmin_monavg')
# years = 1980:2017
# 
# all_combinations = expand.grid(variables, years)
# 
# 
# 
# download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>% 
#   .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/', file_name, sep = '')] %>%
#   .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', file_name)]
# 
# 
# downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', all.files = FALSE,
#                            full.names = FALSE, recursive = FALSE,
#                            ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
# download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]
# download_ask$file_name[1:15]
# for(i in 1){ #nrow(download_ask)
#   status = try(httr::GET(url = download_ask$download_link[i], 
#                          httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE), 
#                          httr::progress()), silent = FALSE)
# }
# 


#MAKE THE FOR PRCP YEAR:1980
folder_name = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data' #CRPS

#folder_name = './Project.Grid/Grid/daymet/daily_data' #Dell

#CREATE A FAST CLIPPING FILE: has the proj of the daymet raster and the extent of the grid5000_tiles.sf
if(FALSE){
  grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf5.rds")
  grid5000_wgs.sf <- st_transform(grid5000_tiles.sf, crs = raster::crs(file.brk)@projargs)
  saveRDS(grid5000_wgs.sf, './grid_data_box/files_rds/grid5000_wgs.sf.rds')
  }
grid5000_wgs.sf <- readRDS( './grid_data_box/files_rds/grid5000_wgs.sf.rds')

for(row_n in 1:nrow(all_combinations)){
  # row_n = 148
  year_n = as.character(all_combinations[row_n,2])
  var_n = as.character(all_combinations[row_n,1])
  print(paste(year_n, var_n))

  
  files.year.full <- list.files(path = folder_name, pattern = paste('*',var_n,'.*', year_n, sep=''), all.files = FALSE,
                           full.names = TRUE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  #Open the raw files
  file.brk <-  suppressWarnings(raster::brick(files.year.full))
  
  #Process: All in paralel. Crop each tile. Time aggregate. Mask and extract by cell. 
  tiles_seq <- unique(grid5000_wgs.sf$id_tile)
  
  for(tile_n in tiles_seq){
    # tile_n =  113
    start_time <- Sys.time() 
    print(tile_n)
    one_tile.sf <- grid5000_wgs.sf[grid5000_wgs.sf$id_tile == tile_n, ]
    file.brk_tile <- crop(file.brk,one_tile.sf)
    #tm_shape(one_tile.sf) + tm_polygons('id_5000')
    #plot(file.brk_tile)
    #TIME AGGREGATION
    file_monthly_brk <- if(var_n == 'prcp'){
      daymet_temporal_aggr(file.brk_tile, fun = 'sum')
    }else{ 
      daymet_temporal_aggr(file.brk_tile, fun = 'mean')
    }
    #plot(file_monthly_brk)
    ids_5000_seq <- unique(one_tile.sf$id_5000)
    
    
    source('./grid_data_git/Codes/daymet_processing_paralel.R', local=TRUE)
    filename <- paste('./grid_data_box/files_rds/weather_files/weather_', year_n,'_', var_n,'_tile_', tile_n, '.rds', sep = '')  
    
    saveRDS(results, filename)
    print(Sys.time() - start_time)
  }#end of tile_n loop
    
  
}  
