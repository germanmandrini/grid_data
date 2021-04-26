rm(list=ls())

# setwd('C:/Users/germa/Box Sync/My_Documents') #dell
# codes_folder <-'C:/Users/germa/Documents'#Dell
# setwd('C:/Users/germanm2/Box Sync/My_Documents')#CPSC
# codes_folder <-'C:/Users/germanm2/Documents'#CPSC
setwd('~')#Server
codes_folder <-'~' #Server


source('./Codes_useful/R.libraries.R')

# install.packages("daymetr")
library("daymetr")
# library('fasterize')
source('./Project.Grid/Grid/Codes/functions.grid.R')


grid5000.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000.sf.rds')
grid5000.dt <- readRDS('./Project.Grid/Grid/rds.files/grid5000.dt.rds')
daymet.folder <- '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/'
tm_shape(tile_outlines) + tm_polygons('TileID')

param.v = c('tmin','tmax', 'srad', 'prcp')
year.start = 1980
year.end = 2017

# (folder.name <- paste(daymet.folder, paste(param.v, collapse = '_'), 1980, '_', 2017, sep = ''))
(folder.name <- paste(daymet.folder, 'new_', paste(param.v, collapse = '_'), 1980, '_', 2017, sep = ''))

# dir.create(folder.name)

grid5000.sf.wgs <- st_transform(grid5000.sf,'+proj=longlat +datum=WGS84 +no_defs')
grid5000.wgs.bbox <- st_bbox(grid5000.sf.wgs)[c(4,1,2,3)]
class(grid5000.wgs.bbox)

daymetr()

# download_daymet_ncss(location = grid5000.wgs.bbox,
#                      start = year.start,
#                      end = year.end,
#                      path = folder.name,
#                      frequency = "monthly",
#                      silent = TRUE,
#                      param = param.v)


#DOWNLOAD ALL THE LINKS FROM THE MONTHLY CATALOG FOR PRCP AND TEMP
#I copied and pasted the links in excel and then I will open them in R
#https://thredds.daac.ornl.gov/thredds/catalog/ornldaac/1345/catalog.html

links_from_catalog.dt <- read_excel('C:/Users/germanm2/Box Sync/My_Documents/Project.Grid/Grid/daymet_processing/links_monthly_catalog.xlsx') %>% data.table()

links_from_catalog.dt[, daymet_names := as.character(lapply(strsplit(as.character(Links), split="[/]"), "[[", 9))]

links_from_catalog.dt[,daymet_files := file.path(folder.name, links_from_catalog.dt$daymet_names)]


downloaded.dt <- list.files(path = folder.name, all.files = FALSE,
                            full.names = FALSE, recursive = FALSE,
                            ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

links_from_catalog_missing.dt <- links_from_catalog.dt[!links_from_catalog.dt$daymet_names %in% downloaded.dt]

for(i in 1:nrow(links_from_catalog_missing.dt)){
  status = try(httr::GET(url = links_from_catalog_missing.dt$Links[i], 
                         httr::write_disk(path = links_from_catalog_missing.dt$daymet_files[i], overwrite = TRUE), 
                         httr::progress()), silent = TRUE)
}

#DOWNLOAD ALL THE LINKS FROM THE DAILY CATALOG FOR SRAD (IT WAS NOT IN THE MONTHLY ONE)
#I copied and pasted the links in excel and then I will open them in R
#https://thredds.daac.ornl.gov/thredds/catalog/ornldaac/1328/catalog.html










download_daymet_ncss(location = grid5000.wgs.bbox,
                     start = 1980,
                     end = 1980,
                     path = folder.name,
                     frequency = "monthly",
                     silent = TRUE,
                     param = 'tmin')



status = try(httr::GET(url = url, query = query, 
                       httr::write_disk(path = daymet_file, overwrite = TRUE), 
                       httr::progress()), silent = TRUE)




#DOWNLOAD DATA OF THE WHOLE COUNTRY
sure.US = FALSE
if(sure.US){
  downloaded.dt <- data.table(raw.name = list.files(path = folder.name, all.files = FALSE,
                                                          full.names = FALSE, recursive = FALSE,
                                                          ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE) )
  
  downloaded.dt[, c("v1","v2","v3") := data.table(str_split_fixed(raw.name,"_",3))]
  downloaded.dt[,v4 := gsub("\\..*","",v3)]
  downloaded.dt <- downloaded.dt[,.(tile = v4, param = v1)] %>% .[,present := 1]
  
  downloaded.dt[,.N, by = param]
  downloaded.dt[,.N, by = tile]
  
  needs.dt <- data.table(expand.grid(tile = tile_outlines$TileID, param = param.v, stringsAsFactors = FALSE))
  cols <- c('tile', 'param')
  needs.dt[, (cols) := lapply(.SD, as.character), .SDcols = cols]
  
  class(needs.dt$tile)
  class(needs.dt$param)
  
  missing.files.dt <- merge(needs.dt, downloaded.dt, by = c('tile', 'param'), all.x = TRUE) %>% .[is.na(present)] %>%
    .[,present := NULL]
  
  for(i in 1:nrow(missing.files.dt)){
    # i=1
    print(i)
    
    download_daymet_tiles(tiles = missing.files.dt$tile[i], start = year.start, end = year.end,
                        path = folder.name, silent = FALSE, param = missing.files.dt$param[i])
  }
}#end or sure.us statement


#DOWNLOAD DATA FOR CHAMPAIGN
sure.CHA = TRUE
if(sure.CHA){
  download_daymet_tiles(location = grid5000.wgs.bbox,
                        start = 1981,
                        end = 1981,
                        path = folder.name,
                        silent = FALSE,
                        param = param.v)
  }


#--------------------------------------------------#

grid5000.w.dt <- data.table()
for(year.n in as.character(year.start:year.end)){
  # year.n <- as.character(year.start:year.end)[2]
  print(year.n)

  files.year <- list.files(path = folder.name, pattern = year.n, all.files = FALSE,
             full.names = FALSE, recursive = FALSE,
             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  files.year.full <- list.files(path = folder.name, pattern = year.n, all.files = FALSE,
                           full.names = TRUE, recursive = FALSE,
                           ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  files.tmin <- files.year.full[grepl('tmin', files.year)]
  files.tmax <- files.year.full[grepl('tmax', files.year)]
  files.prcp <- files.year.full[grepl('prcp', files.year)]
  files.srad <- files.year.full[grepl('srad', files.year)]
  
  print(c(length(files.tmin), length(files.tmax), length(files.prcp), length(files.srad)))
  
  tmin.brk <- open.aggr.merge.tiles(files.tmin, fun.month = "mean")
  tmax.brk <- open.aggr.merge.tiles(files.tmax, fun.month = "mean")
  prcp.brk <- open.aggr.merge.tiles(files.prcp, fun.month = "sum")
  srad.brk <- open.aggr.merge.tiles(files.srad, fun.month = "mean")
  
  minmax_stack = suppressWarnings(raster::stack(tmin.brk, tmax.brk))
  l = rep(1:(raster::nlayers(minmax_stack)/2), 2)
  tmean.brk = raster::stackApply(minmax_stack, indices = l, fun = mean, na.rm = TRUE)
  names(tmean.brk) <- names(tmin.brk)
  nlayers(tmean.brk)
  
  # tmean.sum4to9.r <- calc(tmean.brk[[4:9]], fun=mean)
  # prcp.sum1to4.r <- calc(prcp.brk[[1:4]], fun=sum) #initial water
  # prcp.sum4to9.r <- calc(prcp.brk[[4:9]], fun=sum) #for season characterization
  # srad.sum4to9.r <- calc(srad.brk[[4:9]], fun=mean)
  # 
  # compareRaster(tmean.sum4to9.r, prcp.sum1to4.r, prcp.sum4to9.r, srad.sum4to9.r, extent=TRUE, rowcol=TRUE, crs=TRUE, res=TRUE, orig=TRUE,
  #               rotation=TRUE, values=FALSE, stopiffalse=TRUE, showwarning=FALSE)
  # 
  # #Stack the 3 rasters
  # w.stk <- stack(tmean.sum4to9.r, prcp.sum1to4.r, prcp.sum4to9.r, srad.sum4to9.r)
  # names(w.stk) <- c('tmean', 'prcp.in', 'prcp.s', 'srad')
  # res(tmean.sum4to9.r)
  # ncell(tmean.sum4to9.r)
  # nrow(grid5000.sf)
  
  #Stack the 3 rasters
  w.stk <- stack(tmean.brk, prcp.brk, srad.brk)
  names.layers <- c(paste('tmean', 1:12, sep = '_'),
                    paste('prcp', 1:12, sep = '_'),
                    paste('srad', 1:12, sep = '_'))
  names(w.stk) <- names.layers
  
  res(w.stk)
  ncell(w.stk)
  nrow(grid5000.sf)
  
  #Change the projection and crop it to make it like grid5000
  crs.5000 <- st_crs(grid5000.sf)
  w.GRS80.brk <- projectRaster(w.stk, crs = crs.5000$proj4string)
  crs(w.GRS80.brk)
  w.GRS80.brk <- crop(w.GRS80.brk, grid5000.sf)
  
  #Rasterize to the 5by5 km grid
  grid1to5.rst <- rasterize(grid5000.sf, w.GRS80.brk[[1]], field = 'id.5000') #Transfer values associated with 'object' type spatial data (points, lines, polygons) to raster cells
  names(grid1to5.rst) <- 'id.5000'
  unique(grid1to5.rst[])
  grid5000.sf$N.cell1 = table(grid1to5.rst[])
  # plot(grid5000.sf['N.cell1'])
  
  #Plot it
  # w.GRS80.sp <- as(w.GRS80.brk[[1]], 'SpatialPoints')
  # w.GRS80.sf <- st_as_sf(w.GRS80.sp) # convert to 'sf' object
  #  tm_shape(w.GRS80.sf) + tm_dots() +
  #    tm_shape(grid5000.sf) + tm_polygons('N.cell1', alpha = 0.3)
  # 
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
