wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
# install.packages("daymetr")
library("daymetr")
# install.packages('nngeo')
library(nngeo)
# library('fasterize')
source('./grid_data_git/Codes/functions.grid.R')


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
source('./grid_data_git/Codes/functions.grid.R')

# folder_name = 'T:/germanm2/Grid/daymet/daily_data' #Dell

#list.files(folder_name)

grid5000.sf <- readRDS('./grid_data_box/files_rds/grid5000_allUS.sf.rds')
tm_shape(grid5000.sf) + tm_borders()
plot(grid5000.sf)

grid5000.dt <- readRDS('./grid_data_box/files_rds/grid5000.dt.rds')

grid5000.w.sf <- grid5000.sf
# OBJECTIVE: get two files
  # - pnt1000_results.sf = with the real value and the aggregated value (at 5x5) for each centroid of the daymet grid. Should have (id.1000, id,5000)  
  #   and 5 columns (variable, original_value, nn, local, krigging) for each of the the 38 years
  # - grid5000_results.sf = aggregated value (at 5x5) for each centroid of the daymet grid. Should have   
  #   and 5 columns (id.5000, variable, nn, buffer, local, krigging) for each of the the 38 years. Useful for mapping

#INPUT FILES FOR THE LOOP: they are heavy. We need to do it before
#The clip file comes from the grid.5000.sf. The crs is changed to the one of the daymet rasters: Projection System: Lambert Conformal Conic
clip_file <- st_transform(grid5000.sf, crs = "+proj=lcc +lon_0=-100 +lat_0=42.5 +x_0=0 +y_0=0 +a=6378137 +rf=298.257223563 +lat_1=25 +lat_2=60") %>% # Projection System: Lambert Conformal Conic
  st_union(.) %>% st_sf(.) %>% st_buffer(., 1)

for(row_n in 1:nrow(all_combinations)){
  # row_n = 1
  year_n = as.character(all_combinations[row_n,2])
  var_n = as.character(all_combinations[row_n,1])
  print(paste(year_n, var_n))

  
  files.year.full <- list.files(path = folder_name, pattern = paste('*',var_n,'.*', year_n, sep=''), all.files = FALSE,
                           full.names = TRUE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  #Open the raw files
  file.brk <- open_crop(files.year.full, target_file = clip_file)
  # THIS CODE THOUGHT ME TO USE LAPPLY BETTER 
  # x <- list(a=11,b=12,c=13) # Changed to list to address concerns in commments
  # lapply(seq_along(x), function(y, n, i) { paste(n[[i]], y[[i]]) }, y=x, n=names(x))
  
  #MAKE IT SEASON
  only_july = TRUE
  if(!only_july){
    file_season_brk <- if(var_n == 'prcp'){
                      daymet_grid_agg_fixed(file.brk, int = "season", fun = 'sum', internal = TRUE)
                       }else{ 
                      daymet_grid_agg_fixed(file.brk, int = "season", fun = 'mean', internal = TRUE)
                       }
  }else{
    
    file_season_brk <- if(var_n == 'prcp'){
                      daymet_grid_agg_fixed(file.brk, int = "july", fun = 'sum', internal = TRUE)
                       }else{ 
                      daymet_grid_agg_fixed(file.brk, int = "july", fun = 'mean', internal = TRUE)
                       }
  }
  
      # tm_shape(file.brk[[161:164]]) + tm_raster() +
      #   tm_layout(legend.text.size = 0.7,
      #             main.title = paste('Original Input: 365 rasters'),
      #             main.title.position = "center",
      #             main.title.size = 1.5)
      # 
      # tm_shape(file_season_brk) + tm_raster(title = paste(year_n, '\'s Season - ', var_n, sep = ''))+
      #   tm_layout(legend.text.size = 0.7,
      #             main.title = paste('Processing 1: Season summary. 1 raster'),
      #             main.title.position = "center",
      #             main.title.size = 1.5)
  
  #===# (1) Nearest neighbor resampling #===#
  #INPUTS: two rasters converted to points
  #First is the daymet data in 1x1 resolution. we get the centroids and make a points.sf
  pnt1000_results_tmp.sf <- st_as_sf(rasterToPoints(file_season_brk, spatial = TRUE)) %>%
    dplyr::mutate(id.1000 = rownames(.)) %>% st_join(grid5000.sf) %>% 
    dplyr::rename(value_original = index_in_season) %>% 
    dplyr::mutate(year = year_n, var = var_n)

  #Second input is the 5x5 grid. Also we get the centroids and make a point.sf
  grid5000_pnt.sf <- suppressWarnings(st_centroid(grid5000.sf))
  
  # Explanatory map NN
        # fig1 <- tm_shape(grid5000_pnt.sf)+tm_dots(shape = 3, col = 'red', size = 0.7)+
        #       tm_shape(pnt1000_results_tmp.sf)+tm_dots(shape = 1, col = 'black', size = 0.03) +
        #       tm_layout(legend.text.size = 0.7,
        #                 main.title = paste('Nearest neighbor resampling'),
        #                 main.title.position = "center",
        #                 main.title.size = 2)
        # 
        # tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig1.tiff')
        # fig1
        # dev.off()    
  
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

  grid5000_results_tmp.sf <- grid5000.sf %>%  dplyr::mutate(year = year_n, var = var_n) %>% 
    dplyr::left_join(nn_mean.dt, by = 'id.5000')
  
  # Cool maps
      # tm_shape(grid5000_results_tmp.sf)+tm_polygons('value_nn', title = var_n) + tm_layout(legend.text.size = 0.7,
      #                                                                       main.title = paste('Nearest neighbor resampling'),
      #                                                                       main.title.position = "center",
      #                                                                       main.title.size = 2)
      # tm_shape(grid5000_results_tmp.sf)+tm_polygons('value_nn')+
      #   tm_shape(pnt1000_results_tmp.sf)+tm_dots('value_original', size = 0.3)
  
  #===# (2) a local aggregation #===#
  #Point in Polygon operation: mean of the polygon
  local.dt <- data.table(pnt1000_results_tmp.sf) %>% .[,-'geometry'] %>%
    .[,.(value_local = mean(value_original)),by=id.5000]
  
  # join to the temporal results
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>% dplyr::left_join(local.dt, by = 'id.5000')
  
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>% 
    dplyr::left_join(local.dt, by = 'id.5000')
  
  # Explanatory map
      # fig2 <- tm_shape(grid5000_results_tmp.sf)+ tm_borders()+
      #   tm_shape(pnt1000_results_tmp.sf) + tm_dots('id.5000', shape = 1, col = 'black', size = 0.03) + #+tm_dots('value_original', size = 0.05) + #
      #   tm_layout(legend.text.size = 0.7,
      #             main.title = paste('Local Aggegration'),
      #             main.title.position = "center",
      #             main.title.size = 3)
      # 
      # tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig2.tiff')
      # fig2
      # dev.off()    
  
  #===# (3) an interpolation scheme #===#
  #gstat package work with spatial data, not sf
  pnt1000.spdf <- as(pnt1000_results_tmp.sf, "Spatial")
  data.var <- variogram(value_original ~ 1, data = pnt1000.spdf, width = 2000)#, cutoff = 600
  
  if(!only_july){
    settings = data.table(variables = c('prcp', 'srad', 'tmax', 'tmin'),
                          range = c(30000, 20000, 30000, 30000),
                          model = c('Sph', 'Sph', 'Gau', 'Gau'))
  }else{
    settings = data.table(variables = c('prcp', 'srad', 'tmax', 'tmin'),
                          range = c(30000, 20000, 30000, 30000),
                          model = c('Exp', 'Sph', 'Gau', 'Gau'))
  }
  
  settings_n = settings[variables == var_n]
  
  data.fit <- fit.variogram(data.var, model = vgm(1, model = settings_n$model, range = settings_n$range, 1))
  
      # tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig3.tiff')
      #   plot(data.var$dist, data.var$gamma,
      #      main = paste('Interpolation scheme - ', var_n, " Variogram"),
      #      xlab = expression(bold("lag h")),
      #      ylab = (expression(bold(hat(gamma)*"(h)"))))
      #   text(data.var$dist, data.var$gamma, as.character(data.var$np), pos = 4, cex = 0.6)
      # 
      # dev.off() 
      
  grid5000_pnt.spdf <- as(grid5000_pnt.sf, "Spatial")
  grid5000_pnt_krigg.spdf <- krige(value_original ~ 1, pnt1000.spdf, grid5000_pnt.spdf, model = data.fit)
  
  # join to the temporal results
  grid5000_results_tmp.sf <- st_join(grid5000_results_tmp.sf, st_as_sf(grid5000_pnt_krigg.spdf)) %>% 
    dplyr::select(-var1.var) %>% dplyr::rename(value_krigg = var1.pred)
  
  krigg.dt <- data.table(grid5000_results_tmp.sf) %>% .[,.(id.5000, value_krigg)] 
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(krigg.dt, by = 'id.5000')
  
  #===# (4) a buffer area around centroids #===#
  buffer.sf <- st_buffer(grid5000_pnt.sf, 1500) %>% dplyr::rename(id.5000_buf = id.5000)
  
        #EXPLANATORY MAP
        # fig4 <- tm_shape(buffer.sf) + tm_polygons() + tm_shape(pnt1000_results_tmp.sf) + tm_dots()+
        #       tm_layout(legend.text.size = 0.7, main.title = paste('1500 m buffer'), main.title.position = "center", 
        #                 main.title.size = 3)
        # 
        # tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig4.tiff')
        # fig4
        # dev.off() 
  
  
  buffer.dt <- data.table(st_join(pnt1000_results_tmp.sf, buffer.sf)) %>% 
    .[!is.na(id.5000_buf),c('id.5000_buf', 'value_original')] %>%
    .[,.(value_buf = mean(value_original)),by=id.5000_buf] %>%
    setnames('id.5000_buf', 'id.5000')
  
  # join to the temporal results
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>%  dplyr::left_join(buffer.dt, by = 'id.5000')
  
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(buffer.dt, by = 'id.5000')

  #===# (5) area weighted #===#
  grid1000_tmp.sf <- st_as_sf(as(file_season_brk, 'SpatialPolygonsDataFrame')) %>% 
    dplyr::rename(original_value = index_in_season)
  
  area.gross.sf <- st_intersection(dplyr::select(grid5000_results_tmp.sf, id.5000), grid1000_tmp.sf) %>%
    dplyr::mutate(area_ha = round(as.numeric(st_area(.)/10000),2)) %>% dplyr::mutate(id.gross = 1:nrow(.))
      # summary(area.gross.sf$area_ha)
      # hist(area.gross.sf$area_ha)

  area.gross.dt <- area.gross.sf %>% data.table() %>% .[,-'geometry']
  area.gross.dt2 <- merge(area.gross.dt, area.gross.dt[, .(area_total = sum(area_ha)), by = id.5000], by = 'id.5000')
  area.gross.dt2[,w := area_ha/area_total]
  area.gross.dt2[,.(w_sum = sum(w)), by = id.5000]
  
  area.gross.dt2[,original_value_w := original_value * w]
  area.dt <- area.gross.dt2[,.(value_area = sum(original_value_w)), by = id.5000] 
  
  # join to the temporal results
  grid5000_results_tmp.sf <- grid5000_results_tmp.sf %>%  dplyr::left_join(area.dt, by = 'id.5000')
  
  pnt1000_results_tmp.sf <-  pnt1000_results_tmp.sf %>%  dplyr::left_join(area.dt, by = 'id.5000')
  
      # # Explanatory map
      #     area.gross.sf2 <- area.gross.sf %>% dplyr::left_join(area.gross.dt2[,.(id.gross, w)], by = 'id.gross')
      #     nrow(area.gross.sf2)
      #     area.gross.sf3 <- area.gross.sf2 %>% dplyr::filter(id.5000 == unique(area.gross.sf2$id.5000)[1])
      # 
      #     fig5 <- tm_shape(area.gross.sf3) + tm_polygons('w') +
      #             tm_layout(legend.text.size = 2,
      #                       main.title = paste('Area-weighted Aggregation'),
      #                       main.title.position = "center",
      #                       main.title.size = 2)
      # 
      # 
      # 
      # tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig5.tiff')
      # fig5
      # dev.off() 
      # 
      # tm_shape(grid5000_results_tmp.sf) + tm_polygons(c("value_nn","value_local", "value_krigg", "value_buf","value_area"))
      # 
      # 
      # maps_names <- c("value_nn","value_local", "value_krigg", "value_buf","value_area")
      # titles = c('NN', 'Local', 'Krigging', 'Buffer', 'Area W')
      # for(i in seq_along(maps_names)){
      #   fig_name <- paste('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig',5+i,'.tiff', sep = '')
      #   tiff(fig_name)
      #   print(tm_shape(grid5000_results_tmp.sf) + tm_polygons(maps_names[i])+ 
      #           tm_layout(main.title = titles[i],
      #                     main.title.position = "center",
      #                     main.title.size = 2))
      #   dev.off() 
      # }
  
  #COMBINE THE RESULTS IN ONE BIG FILE
  first_time = !exists('pnt1000_results.sf')
  if(first_time){
    grid5000_results.sf <- grid5000_results_tmp.sf
    pnt1000_results.sf <- pnt1000_results_tmp.sf
  }else{
    grid5000_results.sf <- rbind(grid5000_results.sf, grid5000_results_tmp.sf) 
    pnt1000_results.sf <- rbind(pnt1000_results.sf, pnt1000_results_tmp.sf)
  }
} #end of all combinations loop 
  
# saveRDS(grid5000_results.sf, './grid_data_box/files_rds/grid5000_results.sf.rds') 
# saveRDS(pnt1000_results.sf, './grid_data_box/files_rds/pnt1000_results.sf.rds') 
# saveRDS(grid5000_results.sf, './grid_data_box/files_rds/grid5000_results_july_wk1.sf.rds') 
# saveRDS(pnt1000_results.sf, './grid_data_box/files_rds/pnt1000_results_july_wk1.sf.rds')
# saveRDS(grid5000_results.sf, './grid_data_box/files_rds/grid5000_results_july.sf.rds') 
# saveRDS(pnt1000_results.sf, './grid_data_box/files_rds/pnt1000_results_july.sf.rds')
