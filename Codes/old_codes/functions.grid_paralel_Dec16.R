#===================================
# prepare clusters
#===================================


no_cores <- detectCores() - 1
cl <- makeCluster(no_cores,type='SOCK')

#===================================
# parallelized simulations 
#===================================

# tile_n=1


daymet_temporal_aggr <- function (tile_n){
  library(raster)
  
  fun <- ifelse(var_n == 'prcp', 'sum', 'mean')
  
  crop_file <- grid5000_wgs.spdf[grid5000_wgs.spdf@data$id_tile == tile_n,]
  nrow(crop_file)
  file.brk2 <- file.brk[[200]]
  plot(file.brk2)
  file_crop.brk <- raster::crop(file.brk2, crop_file)
  plot(file_crop.brk)
  
  # ?crop
  # 
  # e <- extent(file.brk[[1]])
  # big_r_e <- as(e, 'SpatialPolygons')
  # 
  # e <- extent(file_crop.brk[[1]])
  # small_r_e <- as(e, 'SpatialPolygons')
  # 
  # e <- extent(crop_file)
  # spdf_e <- as(e, 'SpatialPolygons')
  # 
  # plot(big_r_e)
  # plot(spdf_e, lwd=5, border='green', add = TRUE)
  # 
  # plot(small_r_e, lwd=5, border='red', add = TRUE)
  # plot(crop_file, lwd=3, border='blue', add=TRUE)
  
  if (raster::nlayers(file_crop.brk) < 365) {
    stop("Provided data isn't at a daily time step...")
  }
  dates <- as.Date(sub(pattern = "X", replacement = "", 
                           x = names(file_crop.brk)), format = "%Y.%m.%d")
  yr <- strsplit(as.character(dates), "-")[[1]][1]
  
  #ind <- months(dates)
  
  ind <- format(as.Date(dates), "%m")
  
  #=== Add by German to fix an error in the dates from daymet
  if(length(unique(ind)) < 12){
      if(nlayers(file_crop.brk) == 365){
        ind <- c(rep(1, 31), rep(2, 28), rep(3, 31), rep(4, 30),
                 rep(5, 31), rep(6, 30), rep(7, 31), rep(8, 31),
                 rep(9, 30), rep(10, 31), rep(11, 30), rep(12, 31))
      }
      if(nlayers(file_crop.brk) == 366){
        ind <- c(rep(1, 31), rep(2, 29), rep(3, 31), rep(4, 30),
                 rep(5, 31), rep(6, 30), rep(7, 31), rep(8, 31),
                 rep(9, 30), rep(10, 31), rep(11, 30), rep(12, 31))
      }#=== end
      
    }
  ind <- as.numeric(ind)
  result <- raster::stackApply(x = file_crop.brk, indices = ind, fun = fun, 
                               na.rm = TRUE)
  
  names(result) <- c('January', 'February', 'March', 'April', 'May', 'June', 'July', 
                     'August', 'September', 'October', 'November', 'December')
  
  filename = paste("/home/germanm2/Project.Grid/Grid/daymet/daymet_monthly/", var_n,'_', year_n, '_tile_', tile_n, sep = '')
  
  writeRaster(result, filename, format = 'raster', overwrite = TRUE)

  
}

keep <- c('keep', 'daymet_temporal_aggr', 'grid5000_wgs.spdf', 'file.brk','var_n', 'year_n', 'cl','tiles_v')

#rm(list = ls()[!ls() %in% keep])
#ids_5000_seq2 <- ids_5000_seq[10:12]

clusterExport(cl, varlist = keep, envir=environment())

results_list <- parLapply(cl, tiles_v, function(x) daymet_temporal_aggr(x))

stopCluster(cl)


