######################################
# Parallelized Simulations
######################################

#===================================
# prepare clusters
#===================================


no_cores <- detectCores() - 1
cl <- makeCluster(no_cores,type='SOCK')

#===================================
# parallelized processing 
#===================================

# cell_n = 100

soil_aggr <- function(cell_n){
  #--------------------------
  # preparation
  #--------------------------
  #--- load libraries ---#
  library(dplyr)
  library(data.table)
  library(raster)
  library(sf)
  
    # cell_n = 14
    one_cell.sf <- grid5000_WGS84_sf[grid5000_WGS84_sf$id_5000 == cell_n,]
    #tm_shape(one_cell.sf)+tm_polygons()
    file.brk_cell <- crop(soil_variable_tmp_crop.r,one_cell.sf)
    file.brk_cell <- mask(file.brk_cell, one_cell.sf)
    ext.mt <-getValues(file.brk_cell)
    ext.mt2 <- mean(ext.mt, na.rm = TRUE)
    
    cell_soil.dt <- data.table(id_tile = one_cell.sf$id_tile,
                                    id_5000 = cell_n,
                                    value = ext.mt2)
  return(cell_soil.dt)
}

keep <- c('keep', 'soil_aggr', 'grid5000_WGS84_sf', 'soil_variable_tmp_crop.r')

#rm(list = ls()[!ls() %in% keep])

clusterExport(cl, varlist = keep, envir=environment())

cell_seq <- grid5000_WGS84_sf$id_5000          
results_list <- parLapply(cl, cell_seq, function(x) soil_aggr(x))

results <- do.call("rbind", results_list) %>% data.table()

stopCluster(cl)

