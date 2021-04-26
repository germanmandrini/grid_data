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

# cell_n = 17599

spatial_aggr <- function(cell_n){
  #--------------------------
	# preparation
	#--------------------------
	#--- load libraries ---#
  library(dplyr)
  library(data.table)
  library(raster)
  library(sf)
  one_cell.sf <- one_tile.sf[one_tile.sf$id_5000 == cell_n,]
  
  start <- Sys.time()
  ext.mt <- raster::extract(file.brk, one_cell.sf, fun = mean)
  ext_time <- Sys.time() - start
  start <- Sys.time()
  CDL.stk_cell <- crop(file.brk,one_cell.sf)
  CDL.stk_cell_mask <- mask(CDL.stk_cell, one_cell.sf)
  
  ext <- getValues(CDL.stk_cell_mask)
  get_time <- Sys.time() - start
  
  
  cell_weather.dt <- data.table(id_tile = tile_n,
                                  id_5000 = cell_n,
                                  var = var_n,
                                  year = year_n,
                                  month = colnames(ext.mt),
                                  value = ext.mt[1,])
  return(cell_weather.dt)
}

keep <- c('keep', 'spatial_aggr', 'one_tile.sf', 'file_monthly_brk', 'tile_n','var_n', 'year_n')

#rm(list = ls()[!ls() %in% keep])

clusterExport(cl, varlist = keep, envir=environment())

#spatial_aggr(ids_5000_seq[1])            
results_list <- parLapply(cl, ids_5000_seq, function(x) spatial_aggr(x))

results <- do.call("rbind", results_list) %>% data.table()

stopCluster(cl)


       

