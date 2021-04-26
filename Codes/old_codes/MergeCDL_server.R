# wd <- 'P:/'
# wd <- 'C:/Users/germa/Box Sync/My_Documents/Project.Grid' #Dell
wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
# wd <- "/home/germanm2/Grid/CDL"

setwd(wd)
source('/home/germanm2/Codes_useful/R.libraries.R')
source('./Codes_useful/R.libraries.R')
#install.packages('fasterize')
library('fasterize')

#LOAD grid5000.r
grid5000_tiles.sf <- readRDS("./grid_data_box/files_rds/grid5000_tiles.sf.rds")
grid_mapping.sf <- readRDS("./grid_data_box/files_rds/grid_mapping.sf.rds")
plot(grid_mapping.sf['count'])


#Keep the rasters in the P drive for now
# CDL08 <- raster('./Grid/CDL/2008_30m_cdls/2008_30m_cdls.img')
# CDL09 <- raster('./Grid/CDL/2009_30m_cdls/2009_30m_cdls.img')
# CDL10 <- raster('./Grid/CDL/2010_30m_cdls/2010_30m_cdls.img')
# CDL11 <- raster('./Grid/CDL/2011_30m_cdls/2011_30m_cdls.img')
# CDL12 <- raster('./Grid/CDL/2012_30m_cdls/2012_30m_cdls.img')
# CDL13 <- raster('./Grid/CDL/2013_30m_cdls/2013_30m_cdls.img')
# CDL14 <- raster('./Grid/CDL/2014_30m_cdls/2014_30m_cdls.img')
# CDL15 <- raster('./Grid/CDL/2015_30m_cdls/2015_30m_cdls.img')
# CDL16 <- raster('./Grid/CDL/2016_30m_cdls/2016_30m_cdls.img')
# CDL17 <- raster('./Grid/CDL/2017_30m_cdls/2017_30m_cdls.img')

CDL08 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2008_30m_cdls/2008_30m_cdls.img')
CDL09 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2009_30m_cdls/2009_30m_cdls.img')
CDL10 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2010_30m_cdls/2010_30m_cdls.img')
CDL11 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2011_30m_cdls/2011_30m_cdls.img')
CDL12 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2012_30m_cdls/2012_30m_cdls.img')
CDL13 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2013_30m_cdls/2013_30m_cdls.img')
CDL14 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2014_30m_cdls/2014_30m_cdls.img')
CDL15 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2015_30m_cdls/2015_30m_cdls.img')
CDL16 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2016_30m_cdls/2016_30m_cdls.img')
CDL17 <- raster('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/2017_30m_cdls/2017_30m_cdls.img')


plot(CDL17)


  # cult.layer <- raster('./Grid/2017_Cultivated_Layer/2017_Cultivated_Layer.img')
  # names(cult.layer) <- 'cultivated.use'
  # plot(cult.layer)
  # 
  # cult.layer.info.dt <- cult.layer@data@attributes[[1]] %>% data.table() %>% .[COUNT >0] %>%
  #   .[,.(id.use = ID, variable = Class_Names)] %>% .[,id.use := as.numeric(id.use)]
  # 
  # champaign.county <- raster('./Grid/CDL_2017_clip_Champaign/CDL_2017_clip_20180828122207_2094632874.tif')
  # plot(champaign.county)
  # champaign.county <- projectRaster(champaign.county, crs = crs(CDL17))


crops <- c('Corn', 'Soybeans', 'Winter Wheat','Fallow/Idle Cropland','Alfalfa','Spring Wheat',
  'Cotton','Sorghum', 'Dbl Crop WinWht/Soybeans', 'Rice', 'Barley', 'Dry Beans', 'Durum Wheat',
  'Canola', 'Oats','Peanuts','Almonds','Sunflower','Peas')
length(crops)

cdl.info.dt <- CDL08@data@attributes[[1]] %>% data.table() %>% .[COUNT >0] %>%
  .[,.(id.crop = ID, variable = Class_Names)] %>% .[variable %in% crops] %>% .[,id.crop := as.numeric(id.crop)] 

CDL.stk <- stack(CDL08, CDL09, CDL10, CDL11, CDL12, CDL13, CDL14, CDL15, CDL16, CDL17) #, cult.layer
  #CDL.stk <- crop(CDL.stk, grid5000.r)

template.r <- raster(CDL08)

start  <- Sys.time()
grid30to5000.r <- rasterize(grid5000_tiles.sf, template.r, field = 'id_5000') #Transfer values associated with 'object' type spatial data (points, lines, polygons) to raster cells
end <- Sys.time()
end - start
saveRDS(grid30to5000.r, "./grid_data_box/files_rds/grid30to5000.r.rds")

grid30to5000.r <- readRDS("~/Grid/rds.files/grid30to5000.r.rds")

plot(grid30to5000.r)

grid30to5000.dt <- data.table(grid30to5000.r)

grid5000.sf$N.cell30 = table(grid30to5000.r[])
plot(grid5000.sf['N.cell30'])
names(grid30to5000.rst) <- 'id.5000'
CDL.stk2 <- stack(CDL.stk, grid30to5000.r)
class(CDL.stk2)
2000*1667

crop.30m.10yr.dt <- data.table(CDL.stk2[]) #the id.crop for each cell of the 30x30 grid by year
crop.30m.10yr.dt[,id.5000 := as.numeric(id.5000)]
#now we will get in crop.30m.10yr.dt and count for each id.5000 the number of cells with each crop and make a long table
landuse.5k.10yr.dt <- data.table()
for(year.n in 1:10){
  # year.n =1
  year.real <- ifelse(year.n <11, year.n+2007, NA)
  tbl <- table(crop.30m.10yr.dt[,c(12,year.n), with = FALSE]) %>% data.table()
  names(tbl)[2:3] <- c('id.crop', 'value')
  tbl <- tbl[id.crop %in% cdl.info.dt$id.crop][,id.crop := as.numeric(id.crop)]
  tbl[,year := year.real]
  tbl[,source := 'crop.CDL']
  tbl[,unit := 'count30x30']
  tbl <- merge(tbl, cdl.info.dt, by = 'id.crop', all.x = TRUE)
  tbl[,id.crop := NULL]
  
  landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, tbl)
}
#add the cultivated.area.yearly.tgtcrops: this is mine. The total area by year used in the target crops
cultivated.area.yearly.tgtcrops <- landuse.5k.10yr.dt[,.(value = sum(value)),by=.(id.5000,year)]
cultivated.area.yearly.tgtcrops[,source := 'cultivated.area.yearly.tgtcrops']
cultivated.area.yearly.tgtcrops[,variable := NA]
cultivated.area.yearly.tgtcrops[,unit := 'count30x30']
landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, cultivated.area.yearly.tgtcrops)

#add the proportion of crop/cultivated.area.yearly.tgtcrops
numerator <- landuse.5k.10yr.dt[source == 'crop.CDL']
proportion <- merge(numerator, cultivated.area.yearly.tgtcrops[,.(id.5000, year, total = value)], by = c('id.5000', 'year'))
proportion[,prop := round(value/total,3)]
proportion[,source := 'prop.year.tgtcrops']
proportion <- proportion[,.(id.5000, year, source,  unit, variable, prop)]
setnames(proportion, 'prop', 'value')
landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, proportion)

#add the cultivated.area.10yr.allcrops: this is from USDA analysis, the total cells cultivated with any crop
cultivated.area.10yr.allcrops <- table(crop.30m.10yr.dt[,c(12,11), with = FALSE]) %>% data.table()
names(cultivated.area.10yr.allcrops)[2:3] <- c('id.use', 'value')
cultivated.area.10yr.allcrops <- cultivated.area.10yr.allcrops[id.use %in% cult.layer.info.dt$id.use][,id.use := as.numeric(id.use)]
cultivated.area.10yr.allcrops[,year := NA]
cultivated.area.10yr.allcrops[,source := 'cultivated.area.10yr.allcrops']
cultivated.area.10yr.allcrops[,unit := 'count30x30']
cultivated.area.10yr.allcrops <- merge(cultivated.area.10yr.allcrops, cult.layer.info.dt, by = 'id.use', all.x = TRUE)
cultivated.area.10yr.allcrops[,id.use := NULL]
landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, cultivated.area.10yr.allcrops)
setcolorder(landuse.5k.10yr.dt, c('id.5000','year', 'source', 'unit', 'variable','value'))

#OPTION OF WORK: I could delete first the ones that landuse is non-cultivated and then aggregate cells

#CROP SENSITIVITY PROPORTION SD
unique(landuse.5k.10yr.dt$source)
crop.sensitivity.sd <- landuse.5k.10yr.dt[source == 'prop.year.tgtcrops']
# corn.sensitivity <- corn.sensitivity[variable == 'Corn']
crop.sensitivity.sd <- crop.sensitivity.sd[, .(value = sd(value)),by=.(id.5000, variable)]
crop.sensitivity.sd[,source := 'crop.sensitivity.sd']
crop.sensitivity.sd[,unit := 'prop.sd']
landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, crop.sensitivity.sd, fill = TRUE)

#CROP SENSITIVITY PROPORTION RANGE
crop.sensitivity.range <- landuse.5k.10yr.dt[source == 'prop.year.tgtcrops']
# corn.sensitivity <- corn.sensitivity[variable == 'Corn']
crop.sensitivity.range.max <- crop.sensitivity.range[, .(max = max(value)),by=.(id.5000, variable)]
crop.sensitivity.range.min <- crop.sensitivity.range[, .(min = min(value)),by=.(id.5000, variable)]
crop.sensitivity.range.diff <- merge(crop.sensitivity.range.max, crop.sensitivity.range.min, by = c('id.5000', 'variable'))
crop.sensitivity.range.diff[,value := max - min]
crop.sensitivity.range.diff <- crop.sensitivity.range.diff[,.(id.5000, variable, value)]
crop.sensitivity.range.diff[,source := 'crop.sensitivity.range']
crop.sensitivity.range.diff[,unit := 'prop.range']
landuse.5k.10yr.dt <- rbind(landuse.5k.10yr.dt, crop.sensitivity.range.diff, fill = TRUE)

setcolorder(landuse.5k.10yr.dt, c('id.5000','year', 'source', 'unit', 'variable','value'))

grid5000.dt <- landuse.5k.10yr.dt
saveRDS(grid5000.dt, './grid_data_box/files_rds/grid5000.dt.rds')








# grid30to5000.r
# summary(grid30to5000.r[])
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# ### CREATE AND ADD THE TILES
# tiles.r <- fasterize::raster(us_states_GRS80, res = 500000)
# tiles.sp <- as(tiles.r, 'SpatialPolygons')
# tiles.sf <- st_as_sf(tiles.sp) # convert polygons to 'sf' object
# tiles.sf$id.tile <- 1:nrow(tiles.sf)
# 
# tm_shape(grid5000_int.sf) + tm_borders() + 
#   tm_shape(tiles.sf) + tm_borders('red')
# 
# grid5000_tiles.sf <- st_join(grid5000_int.sf, tiles.sf, join = st_intersects, left = TRUE, largest = TRUE)
# nrow(grid5000_tiles.sf) == nrow(grid5000_int.sf)
# tm_shape(grid5000_tiles.sf) + tm_polygons('id.tile', palette = 'cat', style = 'pretty')
# unique(grid5000_tiles.sf$id.tile)
# 
# saveRDS(grid5000_tiles.sf,'./Grid/rds.files/grid5000_tiles.sf.rds')
# 
# 
# grid5000_tiles_tmp.sf <- grid5000_tiles.sf[grid5000_tiles.sf$id.tile == 2,]
# tm_shape(us_states_GRS80) + tm_polygons() +
#   tm_shape(grid5000_tiles_tmp.sf) + tm_polygons('id.5000', palette = 'cat', style = 'pretty')
# 
# crop_file <- st_union(grid5000_int.sf)
# tm_shape(us_states_GRS80) + tm_borders() + tm_shape(crop_file) + tm_polygons()
# 
# CDL_for_fasterize.r <- crop(CDL.stk[[1]], as(crop_file, "Spatial"))
# plot(crop_file)
# plot(CDL_for_fasterize.r, add = TRUE)
# 
# #?rasterize
# st_is_valid(grid5000_tiles_tmp.sf)
# grid5000_tiles_tmp.sf <- st_buffer(grid5000_tiles_tmp.sf,0)
# grid5000_tiles_tmp.sp <- as(grid5000_tiles_tmp.sf, "Spatial")
# write_sf(grid5000_tiles_tmp.sf, './Grid/rds.files/grid5000_tiles_tmp.shp')
# grid5000_tiles_tmp.sp <- readOGR('./Grid/rds.files/grid5000_tiles_tmp.shp')
# grid5000_tiles_tmp.sf <- st_as_sf(grid5000_tiles_tmp.sp)
# grid5000_tiles_tmp.sf$id <- grid5000_tiles_tmp.sf$id.5000
# CDL_for_fasterize.r2 <- raster(CDL_for_fasterize.r)
# 
# grid30to5000.r <- fasterize(grid5000_tiles_tmp.sf, CDL_for_fasterize.r2, field = 'id.5000') #Transfer values associated with 'object' type spatial data (points, lines, polygons) to raster cells
# plot(grid30to5000.r)
# grid30to5000.r
# summary(grid30to5000.r[])







































plot(grid5000.sf['ncell'])

grid_center <- coordinates(CDL.stk[[1]]) #Determine centroids of grid cells 
class(grid_center)

CDL.stk.points <- st_as_sf(rasterToPoints(CDL.stk[[1]], spatial = T))

centers<- st_as_sf(SpatialPoints(grid_center, proj4string = CRS(proj4string(CDL.stk[[1]]))))
plot(centers,add=T)

#Count within each big black cell the number of small cells 
# I think I cannot do it with raster so I need to convert to sf

CDL_bycrop.ha.l = list()
for(i in 1:length(crops.id$ID)){
  #i=1
  id.crop <- crops.id$ID[i]
  
  crop.stk <- aggregate(CDL.stk == id.crop, 167, sum)
  ?overlay
  
  crop.stk.ha <- crop.stk * 900/10000
  names(crop.stk.ha) <- paste(as.character(crops.id$Crop[i]), 2008:2017, 'ha', sep='_')
  nlayers(crop.stk.ha)
  plot(crop.stk.ha)
  CDL_bycrop.ha.l[[i]] <- crop.stk.ha
}
CDL_bycrop.ha.stk <- stack(CDL_bycrop.ha.l)
nlayers(CDL_bycrop.ha.stk)

names(CDL_bycrop.ha.stk)

# #Save the stack file by layer
# d2 <- unstack(CDL_bycrop.ha.stk)
# dir <- '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/CDL/results_5000m/'
# outputnames <- paste(dir, seq_along(d2), ".tif",sep="")
# d2[[1]]
# for(i in seq_along(d2)){writeRaster(d2[[i]], file=outputnames[i], format = 'GTiff', overwrite=TRUE)}
# 
# #Upload the stack file in the same order
# current.list <- list.files(path=dir, pattern =".tif$", full.names=FALSE)
# current.list2 <- sort(as.numeric((gsub(".tif","",current.list))))
# current.list3 <- paste(dir, current.list2, ".tif",sep="")
# CDL_bycrop.ha.stk<- stack(current.list3)
# nlayers(CDL_bycrop.ha.stk)

#Change the resolution
CDL.stk.countcells <- CDL.stk[[1]]
# values(CDL.stk.countcells) <- 1:ncell(CDL.stk.countcells) 
grid5000.r <- CDL.stk[[1]]
res(grid5000.r) <- 5000
values(grid5000.r) <- 1:ncell(grid5000.r)





# values(CDL.stk.countcells) <- 1

e <- intersect(extent(grid5000.r), extent(CDL.stk.countcells))
grid5000.r <- crop(grid5000.r, e)

grid5000.pol <- spPolygons(grid5000.r)

tm_shape(CDL.stk.countcells) + tm_raster() +
  tm_shape(grid5000.pol) + tm_borders()

grid5000.clean <- overlay(grid5000.r, CDL.stk.countcells, fun = cellsFromExtent)

?overlay

# example RasterLayer
r <- CDL.stk.countcells
# this step may help in speed if your polygon is small relative to the raster
pol <- spPolygons(grid5000.r)
r <- crop(r, pol)

x <- rasterize(pol, r, 1)
cellStats(x, 'sum')
#[1] 1106



grid5000.pol <- rasterToPolygons(grid5000.r)

tm_shape(CDL.stk[[1]]) + tm_raster() +
  tm_shape(grid5000.pol) + tm_borders()

plot(rasterToPolygons(champaign.county), axes=FALSE, box=FALSE)
plot(rasterToPolygons(grid5000.r), add=TRUE, border='black', lwd=1) 

# resample(CDL_bycrop.ha.stk, grid5000.r, sum)

# CDL.167.stk <- stack(rst_l)
CDL.5000.brick <- raster::resample(CDL_bycrop.ha.stk, grid5000.r, method = 'ngb')

nlayers(CDL.5000.brick)
plot(CDL_bycrop.ha.stk[[1]], gridded = TRUE)
plot(CDL.5000.brick[[1]], alpha = 0.3, add = TRUE, col = 'red')

b <- brick(r, sqrt(r))
bf <- writeRaster(b, filename="multi.grd", bandorder='BIL', overwrite=TRUE)


plot(CDL_bycrop.ha.stk[[1]])

par(mfrow=c(1,2))
# plot(CDL_bycrop.ha.stk[[1]], col=c(topo.colors(200)), axes=FALSE, box=FALSE)
plot(CDL_bycrop.ha.stk[[1]], axes=FALSE, box=FALSE)
plot(rasterToPolygons(CDL.5000.brick[[1]]), add=TRUE, border='black', lwd=1) 
plot(CDL.5000.brick[[1]])

names(CDL.5000.brick)

# 
  
plot(CDL08.small)
plot(rst17, box=FALSE, axes=FALSE, add = TRUE)  

plot(CDL08.small)
image(rst17, add = TRUE)

  
# saveRDS(CDL.stk, './Grid/CDL/CDL.stk.rds')
CDL.stk <- readRDS('./Grid/CDL/CDL.stk.rds')
writeRaster(CDL.stk, './Grid/CDL/CDL.tif', format = 'GTiff')
?writeRaster
ncell(CDL.stk)
nlayers(CDL.stk)
#CDL.brk <- brick(CDL.stk, filename='./Grid/CDL/CDL.grd')
extent(CDL17)
projection(CDL17)
grid5000.r <- CDL17
res(grid5000.r) <- 5000
extent(grid5000.r)
extent(CDL17)
values(grid5000.r) <- 1:ncell(grid5000.r)
# plot(grid5000.r)
resample(CDL17, grid5000.r, sum)
?resample


# 
# 
# 
# em = merge(extent(CDL17),extent(new.r))
# plot(em, type="n")
# plot(CDL17,add=TRUE, legend=FALSE)
# plot(new.r, add=TRUE, legend=FALSE)

unique(getValues(CDL17, 56523))

?getValues
nrow(CDL17)
ncol(CDL17)
cells <- cellFromRowCol(CDL17, median(nrow(CDL17)))
extract(CDL17, cells)
CDL17@data

plot(CDL08)
brick(CDL.stk, values=TRUE, nl = 10, filename='./Grid/CDL/CDL.grd')
brick(CDL.stk, values=TRUE, nl = 10, filename='./Grid/CDL/CDL.grd')
CDL.brk <- brick(CDL.stk, values=TRUE, nl = 10, filename='./Grid/CDL/CDL.grd')
b <- brick(system.file("external/rlogo.grd", package="raster"))
?brick

tm_shape(DEM) + tm_raster()
DEM <- raster('./Grid/CDL_2017_clip_Champaign/CDL_2017_clip_20180828122207_2094632874.tif')
DEM.spdf <- as(DEM, "SpatialPolygonsDataFrame")
tm_shape(DEM.spdf) + tm_polygons()
