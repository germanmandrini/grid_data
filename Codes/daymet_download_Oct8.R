rm(ls())
wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
# install.packages("daymetr")
library("daymetr")
# library('fasterize')
source('./Project.Grid/Grid/Codes/functions.grid.R')


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

all_combinations = expand.grid(variables, years)

download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>% 
                          .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/',all_combinations[,2],'/', file_name, sep = '')] %>%
                          .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', file_name)]

downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', all.files = FALSE,
                            full.names = FALSE, recursive = FALSE,
                            ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]

for(i in 1:nrow(download_ask)){
  status = try(httr::GET(url = download_ask$download_link[i], 
                         httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE), 
                         httr::progress()), silent = FALSE)
}



#DOWNLOAD THE MONTHLY DATA: 3 VARIABLES
# LINK EXAMPLES
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_prcp_monttl_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmin_monavg_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmax_monavg_1980_na.nc4

variables <- c('prcp_monttl', 'tmax_monavg', 'tmin_monavg')
years = 1980:2017

all_combinations = expand.grid(variables, years)



download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>% 
  .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/', file_name, sep = '')] %>%
  .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', file_name)]


downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', all.files = FALSE,
                           full.names = FALSE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]
download_ask$file_name[1:15]
for(i in 1){ #nrow(download_ask)
  status = try(httr::GET(url = download_ask$download_link[i], 
                         httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE), 
                         httr::progress()), silent = FALSE)
}


#MAKE THE FOR PRCP YEAR:1980
folder_name = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data' #CRPS
# folder_name = 'T:/germanm2/Grid/daymet/daily_data' #Dell

#list.files(folder_name)

grid5000.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000.sf.rds')
grid5000.dt <- readRDS('./Project.Grid/Grid/rds.files/grid5000.dt.rds')

grid5000.w.dt <- data.table()
for(year.n in as.character(year.start:year.end)){
  # year.n <- as.character(year.start:year.end)[2]
  print(year.n)
  year.n = '1980'

  files.year <- list.files(path = folder_name, pattern = year.n, all.files = FALSE,
             full.names = FALSE, recursive = FALSE,
             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  files.year.full <- list.files(path = folder_name, pattern = year.n, all.files = FALSE,
                           full.names = TRUE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  files.tmin <- files.year.full[grepl('tmin', files.year)]
  files.tmax <- files.year.full[grepl('tmax', files.year)]
  files.prcp <- files.year.full[grepl('prcp', files.year)]
  files.srad <- files.year.full[grepl('srad', files.year)]
  
  #Open the raw files
  tmin_365.brk <- suppressWarnings(raster::brick(files.tmin))
  tmax_365.brk <- suppressWarnings(raster::brick(files.tmax))
  prcp_365.brk <- suppressWarnings(raster::brick(files.prcp))
  srad_365.brk <- suppressWarnings(raster::brick(files.srad))
  
  #Crop them to make processing faster
  crop = TRUE
  if(crop){
    clip_LCC.sf <- st_transform(grid5000.sf, proj4string(prcp_365.brk)) # Projection System: Lambert Conformal Conic
    
    
    tmin_365.brk <- crop(tmin_365.brk, clip_LCC.sf)
    tmax_365.brk <- crop(tmax_365.brk, clip_LCC.sf)
    prcp_365.brk <- crop(prcp_365.brk, clip_LCC.sf)
    srad_365.brk <- crop(srad_365.brk, clip_LCC.sf)
    #plot(tmax_365.brk[[150:165]])
  }
  
  print(c(nlayers(tmin_365.brk), nlayers(tmax_365.brk), nlayers(prcp_365.brk), nlayers(srad_365.brk)))
  
  #MAKE IT MONTHLY
  tmin.brk <- daymet_grid_agg_fixed(file = tmin_365.brk, int = "season", fun = 'mean', internal = TRUE)
  tmax.brk <- daymet_grid_agg_fixed(file = tmax_365.brk, int = "season", fun = 'mean', internal = TRUE)
  prcp.brk <- daymet_grid_agg_fixed(file = prcp_365.brk, int = "season", fun = 'sum', internal = TRUE)
  srad.brk <- daymet_grid_agg_fixed(file = srad_365.brk, int = "season", fun = 'mean', internal = TRUE)
  
  nlayers(prcp.brk)
  prcp.brk[[1]][]
  
  #CALCULATE TMEAN. 
  #I think it could be better to have tmin and tmax instead of this average. 
  #tmax shows heat stress, tmin affects the season duration. If we average them we miss this information.
  minmax_stack = suppressWarnings(raster::stack(tmin.brk, tmax.brk))
  l = rep(1:(raster::nlayers(minmax_stack)/2), 2)
  tmean.brk = raster::stackApply(minmax_stack, indices = l, fun = mean, na.rm = TRUE)
  names(tmean.brk) <- names(tmin.brk)
  
  #MAKE SOME PLOTS
  layer_plot = 2
  par(mfrow = c(2, 3))
  plot(tmin.brk[[layer_plot]], main = 'tmin')
  plot(tmax.brk[[layer_plot]], main = 'tmax')
  plot(tmean.brk[[layer_plot]], main = 'tmean')
  plot(prcp.brk[[layer_plot]], main = 'prcp')
  plot(srad.brk[[layer_plot]], main = 'srad')
  
  plot(prcp.brk, main = 'prcp 12 months')
  
  #Stack the 4 rasters
  w.stk <- stack(tmin.brk, tmax.brk, prcp.brk, srad.brk)
  names(w.stk) <- c(paste('tmin', 1:nlayers(tmin.brk), sep = '_'),
                    paste('tmax', 1:nlayers(tmax.brk), sep = '_'),
                    paste('prcp', 1:nlayers(prcp.brk), sep = '_'),
                    paste('srad', 1:nlayers(srad.brk), sep = '_'))
  class(w.stk)
  res(w.stk)
  ncell(w.stk)
  nrow(grid5000.sf)
  #Change the projection and crop it to make it like grid5000
  crs.5000 <- st_crs(grid5000.sf)
  w.GRS80.brk <- projectRaster(w.stk, crs = crs.5000$proj4string)
  class(w.GRS80.brk)
  crs(w.GRS80.brk)
  
  w.GRS80.brk <- crop(w.GRS80.brk, grid5000.sf)
  
  #===# (1) Nearest neighbor resampling #===#
  rasterToPoints(grid5000.sf, spatial = TRUE)
  
  
  class(grid5000.sf)
  
  

  
  #Rasterize to the 5by5 km grid
  grid1to5.rst <- rasterize(grid5000.sf, w.GRS80.brk[[1]], field = 'id.5000') #Transfer values associated with 'object' type spatial data (points, lines, polygons) to raster cells
  names(grid1to5.rst) <- 'id.5000'
  unique(grid1to5.rst[])
  grid5000.sf$N.cell1 = table(grid1to5.rst[])
  plot(grid5000.sf['N.cell1'])
   
  #Plot it
  pnt <- rasterToPoints(w.GRS80.brk[[1]], spatial = TRUE)
  tm_shape(grid5000.sf) + tm_polygons('N.cell1') +
    tm_shape(pnt) + tm_dots()

  w.GRS80.brk2 <- stack(w.GRS80.brk, grid1to5.rst)
  
  class(w.GRS80.brk2)
  w.1000m.dt <- data.table(w.GRS80.brk2[]) #the id.5000 for each cell of the 1000x1000 grid by year
  # crop.30m.10yr.dt[,id.5000 := as.numeric(id.5000)]
  grid5000.w.tmp.dt <- w.1000m.dt[, lapply(.SD, mean, na.rm=TRUE), by=id.5000]
  grid5000.w.tmp.dt
  grid5000.w.tmp.long.dt = melt(grid5000.w.tmp.dt, id.vars = c('id.5000'))
  
  grid5000.w.tmp.long.dt[, c("v1","v2") := data.table(str_split_fixed(variable,"_",2))]
  grid5000.w.tmp.long.dt[,variable := NULL]
  setnames(grid5000.w.tmp.long.dt, c('v1','v2'), c('variable', 'month'))
  
  grid5000.w.tmp.long.dt[,year := year.n]
  grid5000.w.tmp.long.dt[,source := 'daymet']
  grid5000.w.tmp.long.dt[variable == 'tmean',unit := 'celsius.dayly.mean']
  grid5000.w.tmp.long.dt[variable == 'prcp',unit := 'mm.month']
  grid5000.w.tmp.long.dt[variable == 'srad',unit := 'nn.dayly.mean']
  
  grid5000.w.dt <- rbind(grid5000.w.dt, grid5000.w.tmp.long.dt)
  # now we will get in crop.30m.10yr.dt and count for each id.5000 the number of cells with each crop and make a long table
  
}#end year loop



# THE DAYMET CALENDAR 
# From https://daymet.ornl.gov/datasupport.html
# The Daymet calendar is based on a standard calendar year. All Daymet years have 1 - 365 days, including leap years. 
# For leap years, the Daymet database includes leap day. Values for December 31 are discarded from leap 
# years to maintain a 365-day year.


#ADD VARIABLES
grid5000.w.dt[variable == 'tmean' & month %in% 4:9 & id.5000 == 80]


tmean.4to9.dt <- grid5000.w.dt[variable == 'tmean' & month %in% 4:9, .(value = mean(value)),by=.(year, id.5000)]
tmean.4to9.dt[,variable := 'tmean']
tmean.4to9.dt[,source := 'daymet']
tmean.4to9.dt[,unit := 'celsius.4to9.mean']
grid5000.w.dt <- rbind(grid5000.w.dt, tmean.4to9.dt, fill = TRUE)

prcp.4to9.dt <- grid5000.w.dt[variable == 'prcp' & month %in% 4:9, .(value = sum(value)),by=.(year, id.5000)]
prcp.4to9.dt[,variable := 'prcp']
prcp.4to9.dt[,source := 'daymet']
prcp.4to9.dt[,unit := 'mm.4to9.sum']
grid5000.w.dt <- rbind(grid5000.w.dt, prcp.4to9.dt, fill = TRUE)

prcp.1to4.dt <- grid5000.w.dt[variable == 'prcp' & month %in% 1:4, .(value = sum(value)),by=.(year, id.5000)]
prcp.1to4.dt[,variable := 'prcp']
prcp.1to4.dt[,source := 'daymet']
prcp.1to4.dt[,unit := 'mm.1to4.sum']
grid5000.w.dt <- rbind(grid5000.w.dt, prcp.1to4.dt, fill = TRUE)

srad.4to9.dt <- grid5000.w.dt[variable == 'srad' & month %in% 4:9, .(value = mean(value)),by=.(year, id.5000)]
srad.4to9.dt[,variable := 'srad']
srad.4to9.dt
srad.4to9.dt[,unit := 'nn.4to9.mean']
grid5000.w.dt <- rbind(grid5000.w.dt, srad.4to9.dt, fill = TRUE)


grid5000.w.dt[,source := 'daymet']
grid5000.dt <- rbind(grid5000.dt, grid5000.w.dt, fill = TRUE)

saveRDS(grid5000.dt, './Project.Grid/Grid/rds.files/grid5000.dt.rds')
