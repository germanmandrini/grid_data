wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
# wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
# install.packages("daymetr")
library("daymetr")
# install.packages('nngeo')
library(nngeo)
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
source('C:/Users/germanm2/Box Sync/My_Documents/Project.Grid/Grid/Codes/functions.grid.R')
# folder_name = 'T:/germanm2/Grid/daymet/daily_data' #Dell

#list.files(folder_name)

grid5000.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000.sf.rds')

grid5000.dt <- readRDS('./Project.Grid/Grid/rds.files/grid5000.dt.rds')

grid5000.w.sf <- grid5000.sf
# OBJECTIVE: get two files
  # - pnt1000_results.sf = with the real value and the aggregated value (at 5x5) for each centroid of the daymet grid. Should have (id.1000, id,5000)  
  #   and 5 columns (variable, original_value, nn, local, krigging) for each of the the 38 years
  # - grid5000_results.sf = aggregated value (at 5x5) for each centroid of the daymet grid. Should have   
  #   and 5 columns (id.5000, variable, nn, buffer, local, krigging) for each of the the 38 years. Useful for mapping


for(row_n in 1:nrow(all_combinations)){
  # row_n = 2
  print(row_n)
  year_n = as.character(all_combinations[row_n,2])
  var_n = as.character(all_combinations[row_n,1])

  files.year.full <- list.files(path = folder_name, pattern = paste('*',var_n,'.*', year_n, sep=''), all.files = FALSE,
                           full.names = TRUE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  files_names_list <- lapply(variables, function(x) files.year.full[grepl(x, files.year.full)])
  
  names(files_names_list) <- variables
  # files_names_list <- list(files.tmin, files.tmax, files.prcp, files.srad)
  # names(files_names_list) <- c('tmin','tmax', 'prcp', 'srad')
  
  #Open the raw files
  brk_list <- lapply(files_names_list, function(x) open_project_crop(x))
  
  # THIS CODE THOUGHT ME TO USE LAPPLY BETTER 
  # x <- list(a=11,b=12,c=13) # Changed to list to address concerns in commments
  # lapply(seq_along(x), function(y, n, i) { paste(n[[i]], y[[i]]) }, y=x, n=names(x))
  
  #MAKE IT SEASON
  brk_season_list <- lapply(seq_along(brk_list), function(n, y, i) {
    if(n[[i]] == 'prcp'){
        daymet_grid_agg_fixed(y[[i]], int = "season", fun = 'sum', internal = TRUE)
    }else{ 
      daymet_grid_agg_fixed(y[[i]], int = "season", fun = 'mean', internal = TRUE)}
    }, n=names(brk_list), y=brk_list)
  
  names(brk_season_list) <- names(brk_list)

  tm_shape(brk_list[['prcp']][[161:170]]) + tm_raster()
  tm_shape(brk_season_list[['prcp']]) + tm_raster()
  
  #===# (1) Nearest neighbor resampling #===#
  #INPUTS: two rasters converted to points
  #First is the daymet data in 1x1 resolution. we get the centroids and make a points.sf
  pnt1000_results_tmp.sf <- st_as_sf(rasterToPoints(brk_season_list[[var.n]], spatial = TRUE)) %>%
    dplyr::mutate(id.1000 = rownames(.)) %>% st_join(grid5000.sf) %>% 
    dplyr::rename(value_original = index_in_season) %>% 
    dplyr::mutate(year = year.n, var = var.n)

  #Second input is the 5x5 grid. Also we get the centroids and make a point.sf
  grid5000_pnt.sf <- suppressWarnings(st_centroid(grid5000.sf))
  
  tm_shape(grid5000_pnt.sf)+tm_dots(shape = 3, col = 'red', size = 0.7)+
    tm_shape(pnt1000_results_tmp.sf)+tm_dots(shape = 1, col = 'black', size = 0.03)
  
  #PROCESSING
  #makes a list of the id.5000 and the corresponding k id.1000 
  nn <- st_nn(grid5000_pnt.sf, pnt1000_results_tmp.sf, k=5) 
  length(nn)
  #transform that list into a data.table
  index_join <- data.table(id.1000 = as.character(unlist(nn)),
                           id.5000 = rep(1:length(nn), each = 5)) 
  
  # join the 1x1 points with the corresponding id.5000
  nn.dt <- data.table(pnt1000_results_tmp.sf) %>% .[,-c('geometry', 'id.5000')] %>%
    merge(., index_join, by = 'id.1000')
  # calculate for each id.5000 the mean of the k nn
  nn_mean.dt <- nn.dt[,.(value_nn = mean(value_original)),by=id.5000]
  
  # join to the temporal results
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>% dplyr::left_join(nn_mean.dt, by = 'id.5000')

  grid5000_results_tmp.sf <- grid5000.sf %>%  dplyr::mutate(year = year.n, var = var.n) %>% 
    dplyr::left_join(nn_mean.dt, by = 'id.5000')
  
  tm_shape(grid5000_results_tmp.sf)+tm_polygons('value_nn')+
    tm_shape(pnt1000_results_tmp.sf)+tm_dots('value_original', size = 0.3)
  
  #===# (2) a local aggregation #===#
  #Point in Polygon operation: mean of the polygon
  local.dt <- data.table(pnt1000_results_tmp.sf) %>% .[,-'geometry'] %>%
    .[,.(value_local = mean(value_original)),by=id.5000]
  
  # join to the temporal results
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>% dplyr::left_join(local.dt, by = 'id.5000')
  
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>% 
    dplyr::left_join(local.dt, by = 'id.5000')
  
  
  #Maps comparing nn with local agregation
  tm_shape(grid5000_results_tmp.sf) + tm_polygons(c('value_nn','value_local'))
  
  #===# (3) an interpolation scheme #===#
  #gstat package work with spatial data, not sf
  prcp_pnt.spdf <- as(pnt1000_results_tmp.sf, "Spatial")
  data.var <- variogram(value_original ~ 1, data = prcp_pnt.spdf, width = 2000)#, cutoff = 600
  data.fit <- fit.variogram(data.var, model = vgm(1, 'Sph', 20000, 1))
  plot(data.var$dist, data.var$gamma,
       main = paste(var.n, " Variogram"),
       xlab = expression(bold("lag h")),
       ylab = (expression(bold(hat(gamma)*"(h)"))))
  text(data.var$dist, data.var$gamma, as.character(data.var$np), pos = 4, cex = 0.6)     

  grid5000_pnt.spdf <- as(grid5000_pnt.sf, "Spatial")
  grid5000_pnt_krigg.spdf <- krige(value_original ~ 1, prcp_pnt.spdf, grid5000_pnt.spdf,
                 model = data.fit)
  
  # join to the temporal results
  grid5000_results_tmp.sf <- st_join(grid5000_results_tmp.sf, st_as_sf(grid5000_pnt_krigg.spdf)) %>% 
    dplyr::select(-var1.var) %>% dplyr::rename(value_krigg = var1.pred)
  krigg.dt <- data.table(grid5000_results_tmp.sf) %>% .[,.(id.5000, value_krigg)]
  
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(krigg.dt, by = 'id.5000')
  
  #===# (4) a buffer area around centroids #===#
  buffer.sf <- st_buffer(grid5000_pnt.sf, 1500) %>% dplyr::rename(id.5000_buf = id.5000)
  tm_shape(buffer.sf) + tm_polygons() + tm_shape(pnt1000_results_tmp.sf) + tm_dots()
  buffer.dt <- data.table(st_join(pnt1000_results_tmp.sf, buffer.sf)) %>% 
    .[!is.na(id.5000_buf),c('id.5000_buf', 'value_original')] %>%
    .[,.(value_buf = mean(value_original)),by=id.5000_buf] %>%
    setnames('id.5000_buf', 'id.5000')
  
  # join to the temporal results
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>%  dplyr::left_join(buffer.dt, by = 'id.5000')
  
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(buffer.dt, by = 'id.5000')

  #===# (5) areal weighted #===#
  grid1000_tmp.sf <- st_as_sf(as(brk_season_list[[var.n]], 'SpatialPolygonsDataFrame')) %>% 
    dplyr::rename(original_value = index_in_season)
  
  area.gross.dt <- st_intersection(dplyr::select(grid5000_results_tmp.sf, id.5000), grid1000_tmp.sf) %>%
    dplyr::mutate(area_ha = round(as.numeric(st_area(.)/10000),2)) %>% data.table() %>% .[,-'geometry']
  
  area.gross.dt[,original_value_gross := original_value * area_ha]
  area.dt <- area.gross.dt[,.(area_ha_sum = sum(area_ha),
                              original_value_sum = sum(original_value_gross)), by=id.5000] %>%
    .[,value_area := original_value_sum/area_ha_sum] %>%
    .[,.(id.5000,value_area)]
  
  # join to the temporal results
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>%  dplyr::left_join(area.dt, by = 'id.5000')
  
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(area.dt, by = 'id.5000')
  
  
  #COMBINE THE RESULTS IN ONE BIG FILE
  first_time = !exists('pnt1000_results.sf')
  if(first_time){
    grid5000_results.sf <- grid5000_results_tmp.sf
    pnt1000_results.sf <- pnt1000_results_tmp.sf
  }else{
    grid5000_results.sf <- rbind(grid5000_results.sf, grid5000_results_tmp.sf) 
    pnt1000_results.sf <- rbind(pnt1000_results.sf, pnt1000_results_tmp.sf)
  }
  
  
  
  
  
  spplot(yield.krig["var1.pred"], 
         main = "Kriged Index at the 5x5 grid centroids")
  
  
  
  
  
  
  
  
 
  
  prcp_pnt_nn.sf <- prcp_pnt.sf[nn.vector,]
  
  tm_shape(grid5000_pnt.sf)+tm_dots(shape = 3, col = 'red', size = 0.7)+
    tm_shape(prcp_pnt_nn.sf)+tm_dots(shape = 1, col = 'black', size = 0.03)
  class(prcp.pnt)
  
  
  
  length(nn)
  nrow(grid5000_pnt.sf)
  nrow(prcp_pnt.sf)
  
  
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
