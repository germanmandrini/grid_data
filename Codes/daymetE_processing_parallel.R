######################################
# Parallelized Simulations
######################################

#===================================
# prepare clusters
#===================================


no_cores <- detectCores() - 1
cl <- makeCluster(no_cores,type='SOCK')

#===================================
# parallelized simulations 
#===================================

# tile_n = 1

spatial_aggr <- function(tile_n){
  #--------------------------
	# preparation
	#--------------------------
	#--- load libraries ---#
  library(dplyr)
  library(data.table)
  library(raster)
  library(sf)

  # server_folder <- '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daymet_monthly/' #CPSC
  # server_folder <- 'Z:/Grid/daymet/monthly_data/'
  # server_folder <- 'C:/Users/germanm2/Documents/monthly_data/'
  # server_folder = 'Y:/Grid/daymet/monthly_data/' #Dell
  monthly_folder <- 'grid_data_box/monthly_data/'
  
  monthly_grid_filename <- paste(monthly_folder,
                                 var_n, '_', year_n, '_tile_', tile_n, sep = '') 

  #Open the raw files
  file.brk <-  suppressWarnings(raster::brick(monthly_grid_filename))
  
  #Process: All in paralel. Crop each tile. Time aggregate. Mask and extract by cell. 
  one_tile.sf <- grid5000_LLC.sf[grid5000_LLC.sf$id_tile == tile_n,]
  cell_seq <- unique(one_tile.sf$id_5000)
  all_cells_weather.dt <- data.table()
  for(cell_n in cell_seq){
    # cell_n = 14
    one_cell.sf <- one_tile.sf[one_tile.sf$id_5000 == cell_n,]
    #tm_shape(one_cell.sf)+tm_polygons()
    file.brk_cell <- crop(file.brk,one_cell.sf)
    file.brk_cell <- mask(file.brk_cell, one_cell.sf)
    ext.mt <-getValues(file.brk_cell)
    ext.mt2 <- colMeans(ext.mt, na.rm = TRUE)
    
    cell_weather.dt <- data.table(id_tile = tile_n,
                                    id_5000 = cell_n,
                                    var = var_n,
                                    year = year_n,
                                    month = names(ext.mt2),
                                    value = ext.mt2)
    all_cells_weather.dt <- rbind(all_cells_weather.dt, cell_weather.dt)
  }#end of cell_n loop
  return(all_cells_weather.dt)
}

keep <- c('keep', 'spatial_aggr', 'grid5000_LLC.sf','var_n', 'year_n')

#rm(list = ls()[!ls() %in% keep])

clusterExport(cl, varlist = keep, envir=environment())

#spatial_aggr(ids_5000_seq[1])            
results_list <- parLapply(cl, tiles_seq, function(x) spatial_aggr(x))

results <- do.call("rbind", results_list) %>% data.table()

stopCluster(cl)

