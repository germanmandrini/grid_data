# wd <- 'P:/'
# wd <- 'C:/Users/germa/Box Sync/My_Documents/Project.Grid' #Dell
#wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
#wd <- "/home/germanm2/Grid/CDL"

#setwd(wd)

source('/home/germanm2/Codes_useful/R.libraries.R')
source('./Codes_useful/R.libraries.R')
#install.packages('fasterize')
library('fasterize')

setwd("~/")
#Keep the rasters in the P drive for now
CDL08 <- raster('./Project.Grid/Grid/CDL/2008_30m_cdls/2008_30m_cdls.img')
# CDL08 <- raster('/2008_30m_cdls/2008_30m_cdls.img')
# CDL09 <- raster('./Grid/CDL/2009_30m_cdls/2009_30m_cdls.img')
# CDL10 <- raster('./Grid/CDL/2010_30m_cdls/2010_30m_cdls.img')
# CDL11 <- raster('./Grid/CDL/2011_30m_cdls/2011_30m_cdls.img')
# CDL12 <- raster('./Grid/CDL/2012_30m_cdls/2012_30m_cdls.img')
# CDL13 <- raster('./Grid/CDL/2013_30m_cdls/2013_30m_cdls.img')
# CDL14 <- raster('./Grid/CDL/2014_30m_cdls/2014_30m_cdls.img')
# CDL15 <- raster('./Grid/CDL/2015_30m_cdls/2015_30m_cdls.img')
# CDL16 <- raster('./Grid/CDL/2016_30m_cdls/2016_30m_cdls.img')
# CDL17 <- raster('./Grid/CDL/2017_30m_cdls/2017_30m_cdls.img')

# CDL08 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2008_30m_cdls/2008_30m_cdls.img')
# CDL09 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2009_30m_cdls/2009_30m_cdls.img')
# CDL10 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2010_30m_cdls/2010_30m_cdls.img')
# CDL11 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2011_30m_cdls/2011_30m_cdls.img')
# CDL12 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2012_30m_cdls/2012_30m_cdls.img')
# CDL13 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2013_30m_cdls/2013_30m_cdls.img')
# CDL14 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2014_30m_cdls/2014_30m_cdls.img')
# CDL15 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2015_30m_cdls/2015_30m_cdls.img')
# CDL16 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2016_30m_cdls/2016_30m_cdls.img')
# CDL17 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2017_30m_cdls/2017_30m_cdls.img')


plot(CDL08)

cult.layer <- raster('./Project.Grid/Grid/CDL/2017_Cultivated_Layer/2017_Cultivated_Layer.img')
cult.layer <- raster('P:/Grid/2017_Cultivated_Layer/2017_Cultivated_Layer.img')
cult.layer@data@attributes[[1]][1:3,]
names(cult.layer) <- 'cultivated.use'
plot(cult.layer)
# 
# cult.layer.info.dt <- cult.layer@data@attributes[[1]] %>% data.table() %>% .[COUNT >0] %>%
#   .[,.(id.use = ID, variable = Class_Names)] %>% .[,id.use := as.numeric(id.use)]
# 
# champaign.county <- raster('./Grid/CDL_2017_clip_Champaign/CDL_2017_clip_20180828122207_2094632874.tif')
# plot(champaign.county)
# champaign.county <- projectRaster(champaign.county, crs = crs(CDL17))

#----------------------------------------------------------------------
#                 CREATE A GOOD grid.5000.sf
# with id.tiles, id.5000 and NA if do not touch the us_states
#----------------------------------------------------------------------

# extent_target <- extent(CDL08)
# extent_target@xmin <- extent_target@xmin - 50000 
# # extent_target@xmax <- extent_target@xmax + 50000 
# extent_target@ymin <- extent_target@ymin - 100000 
# # extent_target@ymax <- extent_target@ymax + 100000 



grid5000.r <- raster::raster(cult.layer)
res(grid5000.r) <- 5000
values(grid5000.r) <- 1:ncell(grid5000.r)

# ### CREATE AND ADD THE TILES
tiles.r <- raster::raster(cult.layer)
res(tiles.r) <- 100000
values(tiles.r) <- 1:ncell(tiles.r)
tiles.sp <- rasterToPolygons(tiles.r, fun=NULL, n=4, na.rm=TRUE, digits=12, dissolve=FALSE)
names(tiles.sp) <- 'id_tile'
plot(tiles.sp)
tiles.sf <- st_as_sf(tiles.sp) # convert polygons to 'sf' object

grid5000_tiles.r <- fasterize(tiles.sf, grid5000.r, field = 'id_tile') #Transfer values associated with 'object' type spatial data (points, lines, polygons) to raster cells
#writeRaster(grid5000_tiles.r, "./grid_data_box/files_rds/grid5000_tiles", format = 'GTiff', overwrite = TRUE)

length(which(is.na(grid5000_tiles.r[])))/ncell(grid5000_tiles.r)

#The grid5000.r is slightly larger than tiles.sf. We will put all the not assinged cells to another tile
grid5000_tiles.r[which(is.na(grid5000_tiles.r[]))] <- ncell(tiles.r)+1

tiles_key.df <- data.frame(id_5000 = grid5000.r[],
                           id_tile = grid5000_tiles.r[])

grid5000.sp <- rasterToPolygons(grid5000.r, fun=NULL, n=4, na.rm=TRUE, digits=12, dissolve=FALSE)
names(grid5000.sp@data) <- 'id_5000'
grid5000.sf <- st_as_sf(grid5000.sp) # convert polygons to 'sf' object
grid5000_tiles.sf <- dplyr::left_join(grid5000.sf, tiles_key.df)
head(grid5000_tiles.sf)
saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf1.rds")

max(grid5000_tiles.sf$id_tile)
grid5000_tiles.sf$crops_tile <- NA
grid5000_tiles.sf$crops_cell <- NA

#CLEAN TILES WITHOUT CROPS
for(tile_n in unique(grid5000_tiles.sf$id_tile)){
  #tile_n=801
  print(tile_n)
  one_tile.sf <- grid5000_tiles.sf[grid5000_tiles.sf$id_tile == tile_n,]
  cult.layer_one_tile.r <- crop(cult.layer,one_tile.sf)
  ext <- getValues(cult.layer_one_tile.r)
  count_crops_tile = sum(ext == 2) #this gives how many cells have crop
  
  grid5000_tiles.sf[grid5000_tiles.sf$id_tile == tile_n, 'crops_tile'] <- count_crops_tile
  
  if(count_crops_tile > 0){
    #CLEAN CELLS WITHOUT CROPS
    for(cell_n in unique(one_tile.sf$id_5000)){
      #cell_n=315102 
      #print(cell_n)
      one_cell.sf <- one_tile.sf[one_tile.sf$id_5000 == cell_n,]
      cult.layer_one_cell.r <- crop(cult.layer_one_tile.r,one_cell.sf)
      ext <- getValues(cult.layer_one_cell.r)
      count_crops_cell = sum(ext == 2) #this gives how many cells have crop
      
      grid5000_tiles.sf[grid5000_tiles.sf$id_5000 == cell_n, 'crops_cell'] <- count_crops_cell
    }  
    
    test <- grid5000_tiles.sf[grid5000_tiles.sf$id_tile == tile_n,] 
    print(sum(test$crops_cell) == count_crops_tile)
    
    
  }
  
  
}

saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf2.rds")
grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf2.rds")

#DELETE CELLS WITHOUT CROPS
grid5000_tiles.sf <- grid5000_tiles.sf[grid5000_tiles.sf$crops_tile > 0,]
grid5000_tiles.sf <- grid5000_tiles.sf[!is.na(grid5000_tiles.sf$crops_cell),]
grid5000_tiles.sf <- grid5000_tiles.sf[grid5000_tiles.sf$crops_cell > 0,]


saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf3.rds")
grid5000_tiles.sf <- readRDS("~/grid_data_box/files_rds/grid5000_tiles.sf3.rds")
grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf3.rds")

#SIMPLIFICATION: DELETE CELLS THAT HAVE LESS THAN 500 30x30 cells assigned to crops
hist(grid5000_tiles.sf$crops_cell)
max(grid5000_tiles.sf$crops_cell)

hist(grid5000_tiles.sf$crops_cell[grid5000_tiles.sf$crops_cell < 1000])
nrow(grid5000_tiles.sf)
nrow(grid5000_tiles.sf[grid5000_tiles.sf$crops_cell < 500,])
ha_elim <- sum(grid5000_tiles.sf$crops_cell[grid5000_tiles.sf$crops_cell < 500])*30*30/10000
ha_total <- sum(grid5000_tiles.sf$crops_cell)*30*30/10000
ha_elim/ha_total

grid5000_tiles.sf <- grid5000_tiles.sf[grid5000_tiles.sf$crops_cell > 500,]


#ADD GEOGRAPHIC DATA

crs_cdl <- st_crs(grid5000_tiles.sf)
us_states_GRS80_sf <- st_transform(us_states, crs_cdl$proj4string)
us_states_GRS80_sf <- us_states_GRS80_sf %>% dplyr::select(US_state = NAME, US_region = REGION)
check <- nrow(grid5000_tiles.sf)
grid5000_tiles.sf <- st_join(grid5000_tiles.sf, us_states_GRS80_sf, join = st_intersects, left = TRUE, largest = TRUE)
check == nrow(grid5000_tiles.sf)
saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf4.rds")
#grid5000_tiles.sf <- st_intersection(grid5000_tiles.sf,us_states_GRS80_sf)


#MAKE IDS SEQUENTIAL
grid5000_tiles.sf <- grid5000_tiles.sf[order(grid5000_tiles.sf$id_tile, grid5000_tiles.sf$id_5000),]#order
grid5000_tiles.sf <- dplyr::mutate(grid5000_tiles.sf, id_5000 = 1:nrow(grid5000_tiles.sf))

grid5000_tiles.sf <- grid5000_tiles.sf[order(grid5000_tiles.sf$id_tile, grid5000_tiles.sf$id_5000),]#order again just in case

each_tile <- table(grid5000_tiles.sf$id_tile)
tiles_c <- rep(1:length(unique(grid5000_tiles.sf$id_tile)), times = each_tile)
table(tiles_c)[1:10]
each_tile[1:10]

grid5000_tiles.sf <- dplyr::mutate(grid5000_tiles.sf, id_tile = tiles_c)
table(grid5000_tiles.sf$id_tile)[1:10]

#ORDER AND CLEAN ROW NAMES

grid5000_tiles.sf <- grid5000_tiles.sf[order(grid5000_tiles.sf$id_tile, grid5000_tiles.sf$id_5000),]#order
rownames(grid5000_tiles.sf) <- 1:nrow(grid5000_tiles.sf)

#SAVE FINAL VERSION
saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf5.rds")
st_write(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.shp", delete_dsn=TRUE)

st_write(grid5000_tiles.sf, "./Project.Grid/Grid/Deliverables/grid5000_tiles.shp", delete_layer = TRUE) # overwrites

# nrow(grid5000_tiles.sf)
# nrow(grid5000_tiles.sf[grid5000_tiles.sf$crops_cell < 20,])
# 
# 
# 15*((30*30)/10000)/(5000*5000)
# 
# #MAKE id_tile SEQUENTIAL
# 
# seq_id_tile <- data.table(id_tile = as.numeric(grid5000_tiles.sf$id_tile),
#                           id_tile_c = 1:length(unique(grid5000_tiles.sf$id_tile)))
# 
# #MAKE id_5000 SEQUENTIAL
# seq_id_5000 <- data.table(id_5000 = as.numeric(grid5000_tiles.sf$id_5000),
#                           id_5000_c = 1:length(unique(grid5000_tiles.sf$id_5000)))
# 
# grid5000_tiles.sf <- dplyr::left_join(grid5000_tiles.sf, seq_id_tile, by = 'id_tile')
# grid5000_tiles.sf <- dplyr::left_join(grid5000_tiles.sf, seq_id_5000, by = 'id_5000')
# saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf4.rds")
# grid5000_tiles.sf <- dplyr::select(grid5000_tiles.sf, -c('id_tile', 'id_5000', 'crops_tile'))
# grid5000_tiles.sf <- dplyr::rename(grid5000_tiles.sf, id_tile = id_tile_c , id_5000 = id_5000_c)
# grid5000_tiles.sf <- dplyr::select(grid5000_tiles.sf, -c('crops_tile'))
# #writeOGR(obj=grid5000_tiles.sf, dsn="./Project.Grid/Grid/rds.files", layer="grid5000_tiles", driver="ESRI Shapefile")
# st_write(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.gpkg")
# 
# grid5000_tiles.sf <- st_simplify(grid5000_tiles.sf, preserveTopology = FALSE, dTolerance = 0.01)
# writeOGR(obj=grid5000_tiles.sf, dsn="./Project.Grid/Grid/rds.files", layer="grid5000_tiles_simp", driver="ESRI Shapefile")
# 
# saveRDS(grid5000_tiles.sf, "./grid_data_box/files_rds/grid5000_tiles.sf5.rds")
# 
# head(grid5000_tiles.sf)
# 
# #============
# # Read shapefile attributes
# df = data.frame(myshp)
# 
# # Simplify geometry using rgeos
# simplified = gSimplify(myshp, tol = 1000, topologyPreserve=FALSE)
# 
# # Create a spatial polygon data frame (includes shp attributes)
# spdf = SpatialPolygonsDataFrame(simplified, df)
# 
# # Write to shapefile
# writeOGR(spdf, layer = 'myshp_simplified', 'C:/temp', driver="ESRI Shapefile")
# #===============
# 
# 
# 
# crs_cdl <- crs(CDL08)
# us_states_GRS80_sf <- st_transform(us_states, crs_cdl@projargs)
# us_border_GRS80_sf <- st_union(us_states_GRS80_sf)
# inter <- st_intersects(grid5000_tiles.sf,us_border_GRS80_sf, sparse = FALSE)
# grid5000_tiles.sf$US_state <- as.numeric(inter)
# 
# tm_shape(us_states_GRS80_sf) + tm_borders() + 
#   tm_shape(tiles.sf) + tm_borders() + tm_text('id_tile', size = 0.5)
# 
# 
# # tiles_with_na <- grid5000_tiles.sf %>% group_by(id_tile) %>% summarise(na_count = sum(is.na(id_tile)))
# # tm_shape(tiles_with_na) + tm_polygons('na_count')
# 
# 
# grid5000_tiles.dt <- data.table(grid5000_tiles.sf) %>% .[,geometry := NULL]
# 
# tiles_in <- table(grid5000_tiles.dt[,.(id_tile, US_state)]) %>% data.table() %>%
#   .[US_state == 1 & N > 0] %>% .[,id_tile] %>% as.numeric() %>% sort()
# 
# 
# 
# grid_mapping.sf <- grid5000_tiles.sf %>% group_by(id_tile) %>% summarise(count = sum(!is.na(id_5000)))
# grid_mapping.sf <- st_buffer(grid_mapping.sf, 0)
# unique(grid_mapping.sf$count)
# all(st_is_valid(grid_mapping.sf))
# 
# saveRDS(grid_mapping.sf, "./grid_data_box/files_rds/grid_mapping.sf.rds")
# plot(grid_mapping.sf['count'])


