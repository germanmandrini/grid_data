# wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC


setwd(wd)
source('./Codes_useful/R.libraries.R')
# source('/home/germanm2/Codes_useful/R.libraries.R')
# source('~/Project.Grid/Grid/Codes/functions_grid_Dec10.R')
source('./Project.Grid/Grid/Codes/functions_grid_Dec10.R')

variables <- c('prcp', 'srad', 'tmax', 'tmin')
# years <- 2009:2017
years <- 2018
# 
all_combinations = expand.grid(variables, years)

# folder_name = '/home/germanm2/Project.Grid/Grid/daymet/daily_data' #srv
# folder_name = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data/' #CPSC
# folder_name = 'S:/Bioinformatics Lab/germanm2/Grid/daymet/daily_data/'
# 
# folder_name = 'C:/Users/germanm2/Box Sync/My_Documents/Project.Grid/Grid/daymet/daily_data'
folder_name = 'C:/Users/germanm2/Documents/daily_data'

#CREATE A FAST CLIPPING FILE: has the proj of the daymet raster and the extent of the grid5000_tiles.sf
grid5000_LLC.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000_LLC.sf.rds')
tiles_v <- unique(grid5000_LLC.sf$id_tile)

for(row_n in 2:nrow(all_combinations)){
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
  source('./Project.Grid/Grid/Codes/daymet_make_monthly_paralel_Dec17.R')
  
} #end row_n loop 

# DELETE ALL FILES
# do.call(file.remove, list(list.files("/home/germanm2/Project.Grid/Grid/daymet/daymet_monthly", full.names = TRUE)))
