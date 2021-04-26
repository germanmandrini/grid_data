#===================================
# prepare clusters
#===================================


no_cores <- detectCores() - 1
cl <- makeCluster(no_cores,type='SOCK')

#===================================
# parallelized simulations 
#===================================

# cell_n=126887


process_cells <- function(cell_n){
  library(data.table)
  library(raster)
  library(sf)
  library(dplyr)
  one_cell.sf <- grid5000_tiles.sf[grid5000_tiles.sf$id_5000 == cell_n,]
  one_cell.sf <- one_cell.sf[!is.na(one_cell.sf$id_5000),]
  #tm_shape(one_cell.sf)+tm_polygons()
  CDL.stk_cell <- crop(CDL.stk,one_cell.sf)
  CDL.stk_cell_mask <- mask(CDL.stk_cell, one_cell.sf)
  
  ext<-getValues(CDL.stk_cell_mask)
  
  grid5000_landuse_10yr_onetile.dt <- data.table()
  for(year.n in 1:10){
    # year.n =1
    year.real <- ifelse(year.n <11, year.n+2007, NA)
    tbl <- table(ext[,year.n]) %>% data.table()
    names(tbl) <- c('id.crop', 'value')
    tbl <- tbl[id.crop %in% cdl.info.dt$id.crop][,id.crop := as.numeric(id.crop)]
    tbl[,year := year.real]
    tbl[,source := 'crop.CDL']
    tbl[,unit := 'count30x30']
    tbl <- merge(tbl, cdl.info.dt, by = 'id.crop', all.x = TRUE)
    tbl[,id.crop := NULL]
    tbl[,id_5000 := one_cell.sf$id_5000]
    tbl[,id_tile := one_cell.sf$id_tile]
    setcolorder(tbl, c('id_tile', 'id_5000', 'year', 'source', 'unit', 'variable', 'value'))
    grid5000_landuse_10yr_onetile.dt <- rbind(grid5000_landuse_10yr_onetile.dt, tbl)
  }#end of 10 years loop
  return(grid5000_landuse_10yr_onetile.dt)
}
keep <- c('keep', 'process_cells', 'grid5000_tiles.sf', 'cdl.info.dt', 'CDL.stk', 'cl','ids_5000_seq')

#rm(list = ls()[!ls() %in% keep])
#ids_5000_seq2 <- ids_5000_seq[10:12]

clusterExport(cl, varlist = keep, envir=environment())

         
results_list <- parLapply(cl, ids_5000_seq, function(x) process_cells(x))

results <- do.call("rbind", results_list) %>% data.table()

stopCluster(cl)
