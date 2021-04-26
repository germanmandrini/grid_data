rm(list=ls())

# setwd('C:/Users/germa/Box Sync/My_Documents') #dell
# codes_folder <-'C:/Users/germa/Documents'#Dell
setwd('C:/Users/germanm2/Box Sync/My_Documents')#CPSC
codes_folder <-'C:/Users/germanm2/Documents'#CPSC
# setwd('~')#Server
# codes_folder <-'~' #Server


source('./Codes_useful/R.libraries.R')
# Source: https://files.isric.org/soilgrids/data/recent/

files_list <- list.files('S:/Bioinformatics Lab/germanm2/Grid/soils', full.names = TRUE)
files_info <- fread('./grid_data_box/soilgrid_gsif_code.csv')

grid5000_WGS84_sf <- readRDS('./grid_data_box/files_rds/grid5000_WGS84.sf.rds')


for(filename_long in files_list){
  # filename_long <- files_list[1]
  start_time <- Sys.time()
  print(filename_long) 

  filename_short <- gsub("S:/Bioinformatics Lab/germanm2/Grid/soils/", "",filename_long)
  soil_variable_tmp.r <- raster::raster(filename_long)
  soil_variable_info <- files_info[FileName == filename_short]
  soil_variable_tmp_crop.r <- raster::crop(soil_variable_tmp.r, grid5000_WGS84_sf)
  
  source(paste0(codes_folder, '/grid_data_git/Codes/soilsB_processing_paralel.R'), local=TRUE)
  "C:/Users/germanm2/Documents/grid_data_git/Codes/soilsB_processing_paralel.R"
  "./grid_data_git/Codes/soilsB_processing_paralel.R"
  
  grid5000_landuse.dt
  results[,source := 'soilgrid']
  results[,variable := soil_variable_info$ATTRIBUTE_LABEL]
  results[,unit := soil_variable_info$ATTRIBUTE_TITLE]
  setcolorder(results, c('id_tile', 'id_5000', 'source', 'variable','unit', 'value'))
  filename <- paste('./grid_data_box/files_rds/soil_files/',soil_variable_info$ATTRIBUTE_LABEL, '.rds', sep = '')  
  saveRDS(results, filename)
  print(Sys.time() - start_time)
}  
  
#MERGE THE FILES 
files_names <- list.files('./grid_data_box/files_rds/soil_files', full.names = TRUE,include.dirs = FALSE)

grid5000_soils.dt <- data.table()
for(filename in files_names){
  #filename <- files_names[1]
  counter = which(files_names == filename)
  print(counter)
  file_tmp.dt <- readRDS(filename)
  grid5000_soils.dt <- rbind(grid5000_soils.dt, file_tmp.dt)
  #SAVE BATCHES OF 50 TILES
  # count_by_batch = 50
  # if(counter %% count_by_batch == 0 | counter == length(files_names)){
  #   batch_count = ceiling(counter/count_by_batch)
  #   batch_name = paste('./grid_data_box/files_rds/landuse_files/batches_for_merge/landuse_batch_', batch_count, '.rds', sep = '')   
  #   saveRDS(grid5000_landuse.dt, batch_name)
  #   grid5000_landuse.dt <- data.table()
  # }#end of the save batches
  
}#end of the filename loop

saveRDS(grid5000_soils.dt, "./grid_data_box/files_rds/grid5000_soils.dt.rds")
fwrite(grid5000_soils.dt, './grid_data_box/Deliverables/grid5000_soils.csv') 
