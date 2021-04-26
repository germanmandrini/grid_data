#setwd(wd)

source('/home/germanm2/Codes_useful/R.libraries.R')
source('~/grid_data_git/Codes/functions.grid_Dec10.R')

variables <- c('prcp', 'srad', 'tmax', 'tmin')
years <- 1980:2017
# 
all_combinations = expand.grid(variables, years)

folder_name = '/home/germanm2/Project.Grid/Grid/daymet/daily_data' #srv

#CREATE A FAST CLIPPING FILE: has the proj of the daymet raster and the extent of the grid5000_tiles.sf
if(FALSE){
  grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf5.rds")
  grid5000_wgs.sf <- st_transform(grid5000_tiles.sf, crs = raster::crs(file.brk)@projargs)
  saveRDS(grid5000_wgs.sf, './grid_data_box/files_rds/grid5000_wgs.sf.rds')
}
grid5000_wgs.spdf <- readRDS( './grid_data_box/files_rds/grid5000_wgs.spdf.rds')
grid5000_wgs.spdf <- grid5000_wgs.spdf[!is.na(grid5000_wgs.spdf@data$US_state),]
tiles_v <- unique(grid5000_wgs.spdf$id_tile)
for(row_n in 1:nrow(all_combinations)){
  # row_n = 1
  # start = Sys.time()
  year_n = as.character(all_combinations[row_n,2])
  var_n = as.character(all_combinations[row_n,1])
  print(paste(year_n, var_n))
  
  
  files.year.full <- list.files(path = folder_name, pattern = paste('*',var_n,'.*', year_n, sep=''), all.files = FALSE,
                                full.names = TRUE, recursive = FALSE,
                                ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  #Open the raw files
  file.brk <-  suppressWarnings(raster::brick(files.year.full))
  
  for(tile_n in tiles_v){
    
    print(tile_n)
    crop_file <- grid5000_wgs.spdf[grid5000_wgs.spdf@data$id_tile == tile_n,]
    nrow(crop_file)
  
    file_crop.brk <- raster::crop(file.brk, crop_file)
    file_monthly_brk <- if(var_n == 'prcp'){
      daymet_temporal_aggr(file_crop.brk, fun = 'sum')
    }else{ 
      daymet_temporal_aggr(file_crop.brk, fun = 'mean')
    }
    #plot(file_monthly_brk)
  
    filename = paste("/home/germanm2/grid_data_box/files_rds/daymet_monthly/", var_n,'_', year_n, '_tile_', tile_n, sep = '')
    writeRaster(file_monthly_brk, filename, format = 'raster', overwrite = TRUE)
  
  }#end state_n loop
} #end row_n loop 
