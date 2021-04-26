wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
# wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
variables <- c('prcp', 'srad', 'tmax', 'tmin')
years <- 1980:2017
# 
all_combinations = expand.grid(variables, years)
grid5000_results.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000_results_july.sf.rds') 
pnt1000_results.sf <-  readRDS('./Project.Grid/Grid/rds.files/pnt1000_results_july.sf.rds')




# grid5000_results.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000_results.sf.rds') 
# pnt1000_results.sf <- readRDS('./Project.Grid/Grid/rds.files/pnt1000_results.sf.rds') 
# grid5000_results.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000_results_july.sf.rds') 
# pnt1000_results.sf <- readRDS('./Project.Grid/Grid/rds.files/pnt1000_results_july.sf.rds')

#### CREATE A GRID called grid1000_results.sf####
pnt1000_one_set.sf <- dplyr::filter(pnt1000_results.sf, year == 1980 & var == 'prcp')
pnt1000_one_set.sf <- pnt1000_one_set.sf %>% dplyr:: select(id.1000) %>% cbind(st_coordinates(pnt1000_one_set.sf))
crs <- st_crs(pnt1000_results.sf)
grid1000_one_set.r <- rasterFromXYZ(as.data.frame(pnt1000_one_set.sf)[, c("X", "Y", "id.1000")], crs = crs$proj4string)
plot(grid1000_one_set.r)

#Test: the one set should have one row by each id.1000
nrow(pnt1000_one_set.sf) == length(unique(grid1000_one_set.r$id.1000))

# Convert raster to sf. We need the polygons to intersect with the grid5000_results.sf
grid1000_one_set.sp <- as(grid1000_one_set.r, 'SpatialPolygonsDataFrame')
grid1000_one_set.sf <- st_as_sf(grid1000_one_set.sp) # convert polygons to 'sf' object
grid1000_one_set.sf$id.1000 <- as.character(grid1000_one_set.sf$id.1000)

    # pnt1000_originalv.sf <- pnt1000_results.sf %>% dplyr::select(id.1000, year, var, value_original)
    # st_geometry(pnt1000_originalv.sf) <- NULL
    # grid1000_originalv.df <- dplyr::left_join(pnt1000_originalv.sf, grid1000_one_set.sf, by = 'id.1000')
    # grid1000_originalv.sf <- st_as_sf(grid1000_originalv.df)
    # head(grid1000_originalv.sf)

#####   REGION IN CONTEXT OF THE US STATES######
one_set_plot <- grid5000_results.sf[grid5000_results.sf$year == 2008 & grid5000_results.sf$var == 'prcp',]
# install.packages('USAboundaries')
library(USAboundaries)
?usmap
us_counties <- us_counties()
one_set_plot <- st_transform(one_set_plot, st_crs(us_counties))


tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig11.tiff')
tm_shape(us_counties[us_counties$state_name == 'Illinois',]) + tm_polygons()+
  tm_shape(one_set_plot) + tm_polygons('value_local', legend.show = FALSE)+
  tm_legend(main.title = 'Area of Interest Location',
            main.title.position = "left",
            legend.outside = FALSE) 
dev.off() 
tm_shape(grid1000_one_set.sf) + tm_polygons()
###############################################


### 1) Effect in the difference ###
grid1000_one_set.sf
grid5000_one_set.df <- dplyr::filter(grid5000_results.sf, year == 1980 & var == 'prcp') %>% dplyr::select(id.5000, value_local)
grid_int.sf <- st_intersection(grid1000_one_set.sf, grid5000_one_set.df) %>% 
  dplyr::mutate(area_km = as.numeric(st_area(.))/1000000)
tm_shape(grid_int.sf) + tm_polygons('value_local')

tm_shape(grid5000_one_set.df) + tm_polygons('id.5000') + tm_text('id.5000', size = 0.5)  
ids_for_plot <- c(1,2,11,12)
plot1000_data <- dplyr::left_join(grid1000_one_set.sf, 
                                  data.table(pnt1000_results.sf) %>% .[,c('id.5000', 'id.1000')] %>% unique(), by = 'id.1000') %>%
  dplyr::filter(id.5000 %in% ids_for_plot)
                                                                                             
plot5000_data  <-  grid5000_one_set.df %>% dplyr::filter(id.5000 %in% ids_for_plot)
plot_int_data <- grid_int.sf %>% dplyr::filter(id.5000 %in% ids_for_plot) %>% 
  dplyr::mutate(w = round(area_km / sum(grid_int.sf$area_km),5))


plot1000 <- tm_shape(plot1000_data) + tm_borders() + 
  tm_legend(main.title = paste('Original 1x1 grid'),
            main.title.position = "left") 
plot5000 <- tm_shape(plot5000_data) + tm_borders(lwd = 3) +
  tm_legend(main.title = paste('New 5x5 grid'),
            main.title.position = "left")
plot_int <- tm_shape(plot_int_data) + tm_polygons('w', palette="Greys", alpha = 0.5) +
  tm_legend(main.title = paste('Intersected grid (i: 1,...,n)'),
            main.title.position = "left",
            legend.outside = FALSE) +
  tm_shape(plot5000_data) + tm_borders(lwd = 3)

tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig12.tiff', units="in", width=12, height=5, res=300, compression = 'lzw')
tmap_arrange(plot1000, plot5000, plot_int, nrow = 1, outer.margins = c(0,0,0,0))
dev.off()  

# areas <- grid_int.sf %>% group_by(id.5000) %>% summarize(area_total = sum(area_km))
# st_geometry(areas) <- NULL
# summary(areas$area_total)
# grid_int.sf <- dplyr::left_join(grid_int.sf, areas) %>% dplyr::mutate(w = area_km/area_total) %>%
#   dplyr::select(-area_total)

tm_shape(grid_int.sf)+ tm_polygons('area_km')

# COMPARE
grid_int_diff.dt <- data.table()
grid_int.dt <- grid_int.sf %>% data.table() %>% .[,-('geometry')]
for(i in 1:nrow(all_combinations)){
  #i=1
  print(i)
  year_n = all_combinations$Var2[i]
  var_n = all_combinations$Var1[i]
  pnt1000_results_tmp.sf <- pnt1000_results.sf %>% dplyr::filter(year == year_n & var == var_n)
  pnt1000_results_tmp.dt <- pnt1000_results_tmp.sf %>% data.table() %>% .[,-('geometry')]
  id.1000.values <- pnt1000_results_tmp.dt[,.(id.1000, value_original)]
  id.5000.values <- unique(pnt1000_results_tmp.dt[,.(id.5000, value_nn, value_local, value_krigg, value_buf, value_area)])
  
  grid_int_tmp.dt <- merge(grid_int.dt,id.1000.values, all.x = TRUE)
  grid_int_tmp.dt <- merge(grid_int_tmp.dt, id.5000.values, all.x = TRUE, by = 'id.5000')
  
  grid_int_diff_tmp.dt <- grid_int_tmp.dt %>% melt(id.vars = c("id.5000", "id.1000", "area_km", "value_original"), measure.vars = c("value_nn", "value_local", "value_krigg", 'value_buf', 'value_area'))
  setnames(grid_int_diff_tmp.dt, 'variable', 'method')
  grid_int_diff_tmp.dt[,var := var_n][, year := year_n]
  grid_int_diff.dt <- rbind(grid_int_diff.dt, grid_int_diff_tmp.dt)
}  

# saveRDS(grid_int_diff.dt, './Project.Grid/Grid/rds.files/grid_int_diff.dt.rds') 
#saveRDS(grid_int_diff.dt, './Project.Grid/Grid/rds.files/grid_int_diff.dt_july.rds') 
# grid_int_diff.dt<- readRDS('./Project.Grid/Grid/rds.files/grid_int_diff.dt.rds')
grid_int_diff.dt<- readRDS('./Project.Grid/Grid/rds.files/grid_int_diff.dt_july.rds')

#ONE SET IS ONE TIME THE WHOLE AREA
set <- unique(grid_int_diff.dt[,.(method, var, year)]) %>% .[,set_id := 1:nrow(.)]
grid_int_diff.dt <- merge(grid_int_diff.dt, set, by = c('method', 'var', 'year'))
area_set <- sum(grid_int_diff.dt[set_id == 1, area_km])

grid_int_diff.dt[,diff:= abs(value_original-value)]
# grid_int_diff.dt[,diff_r := round(diff/value_original,6)]
# grid_int_diff.dt[diff == 0 & value_original == 0, diff_r := 0] #correction for values that the diff is 0 and the original value is also 0
grid_int_diff.dt[diff != 0 & value_original == 0]
# grid_int_diff.dt <- grid_int_diff.dt[!(diff != 0 & value_original == 0)] #we eliminate those where the original value is 0 and the difference is higher because cannot be represetned as percentage
# grid_int_diff.dt[!is.finite(diff_r)]

grid_int_diff.dt[,w := round(area_km/ area_set,8)]
grid_int_diff.dt[,sum(w), by = .(method,var, year)] #test
# diff_w = is an intermediate step to obtain the diff_w_set. It just multiply the diff by the w
# grid_int_diff.dt[,diff_r_w := diff_r * w]
grid_int_diff.dt[,diff_w := diff * w]
# diff_w_set area weighted difference for the set. Instead of making the common average of the difference for each set,
# it is weighter by area. It can be read as average % difference

# diff_summary <- grid_int_diff.dt[,.(diff_w_set = sum(diff_w),
#                                     diff_r_w_set = sum(diff_r_w)), by = .(var, method, year, set_id)]

diff_summary <- grid_int_diff.dt[,.(diff_w_set = sum(diff_w)), by = .(var, method, year, set_id)]

understanding <- grid_int_diff.dt[id.5000 == 1 & var == 'prcp' & method %in% c('value_nn', 'value_area') & year == 1980]
understanding_wide <- dcast(understanding, id.1000 +area_km + value_original ~ method, value.var = c("value", "diff_abs_r", "diff_w"))
setnames(understanding_wide, c("value_value_nn","value_value_area","diff_abs_r_value_nn","diff_abs_r_value_area","diff_w_value_nn","diff_w_value_area"), c("value_nn","value_area","diff_abs_r_nn","diff_abs_r_area","diff_w_nn","diff_w_area"  ))
understanding_wide[,diff_w_nn:=round(diff_w_nn,5)][,diff_w_area:=round(diff_w_area,5)]
table(understanding_wide$value_original)

diff_summary_und <- understanding[,.(diff_w_set = sum(diff_w)), by = .(var, method, year, set_id)]
diff_table_und <- diff_summary_und[,.(diff_method = round(mean(diff_w_set),6)*100), by = .(var, method, year)][order(var, diff_method)]
diff_table_perc_diff_und <- dcast(diff_table_und, var + year ~ method, value.var = "diff_method")

# diff_method. This is the average of the diff_w_set for the same method over different years
diff_table <- diff_summary[,.(diff_method = round(mean(diff_w_set),6)), by = .(var, method)][order(var, diff_method)]
diff_table_diff <- dcast(diff_table, var ~ method, value.var = "diff_method")
diff_table_diff[]

#ORIGINAL STD DEVIATION
pnt1000_results.dt <- pnt1000_results.sf %>% data.table() %>% .[,geometry:=NULL]
pnt1000_results.dt[,sd(value_original), by = var]

#CORRELATION
#ORIGINAL CORRELATION BETWEEN VARIABLES. 
pnt1000_results.sf
original_correlation.dt <- pnt1000_results.sf %>% data.table() %>% .[,.(id.1000, year, var, value_original)]
original_correlation.wide.dt <- dcast(original_correlation.dt, id.1000 + year ~ var, value.var = "value_original")[order(year, as.numeric(id.1000))]
original_correlation.dt <- original_correlation.wide.dt[,.(prcp,srad,tmax,tmin)]


#MAKE PLOTS WITH ORIGINAL CORRELATIONS
variables

graphs_aes <- combn(variables, m = 2) 

data = original_correlation.wide.dt[sample(.N, .N/20)]

plot_cor <- list()
for(plot_n in 1:ncol(graphs_aes)){
  x_corr = data[,graphs_aes[1,plot_n], with = FALSE]
  y_corr = data[,graphs_aes[2,plot_n], with = FALSE]
  corr_tmp <- round(cor(x_corr, y_corr), 2)
  label_corr = c(max(x_corr)*0.85,  min(y_corr)*1.03)
  
  plot_cor[[plot_n]] <- ggplot(data, aes_(x = as.name(graphs_aes[1,plot_n]), y = as.name(graphs_aes[2,plot_n]), colour = as.name('year')))+
    geom_point() + theme(legend.position="none") +
    annotate(geom="text", x=label_corr[1], y=label_corr[2], 
             label=paste('corr = ', corr_tmp, sep = ''),
             size = 5,
             color="red")
}

tiff('C:/Users/germanm2/Dropbox/CPSC499/Project/figures/fig13.tiff', units="in", width=12, height=5, res=300, compression = 'lzw')

grid.arrange(plot_cor[[1]], plot_cor[[2]], plot_cor[[3]],
             plot_cor[[4]], plot_cor[[5]], plot_cor[[6]], ncol=3)

dev.off() 

#NEW CORRELATION BETWEEN VARIABLES. 
grid5000_results.sf

correlation_data.lst <- list(original_correlation.dt) #save the results
names(correlation_data.lst) <- 'original'
for(method_n in c('value_nn', 'value_local', 'value_krigg', 'value_buf', 'value_area')){
  # method_n <- 'value_nn'
  methodX_correlation.dt <- grid5000_results.sf %>% data.table() %>% .[,c('id.5000', 'year', 'var', method_n), with = FALSE]
  methodX_correlation.wide.dt <- dcast(methodX_correlation.dt, id.5000 + year ~ var, value.var = method_n)[order(year, as.numeric(id.5000))]
  methodX_correlation.dt <- methodX_correlation.wide.dt[,.(prcp,srad,tmax,tmin)] 
  
  correlation_data.lst[[method_n]] <- methodX_correlation.dt
}

correlation_matrix.lst <- lapply(correlation_data.lst, cor)

correlation_diff.lst <- lapply(correlation_matrix.lst, function(x) as.matrix(x - correlation_matrix.lst[[1]]))
correlation_diff.lst[[1]] <- correlation_matrix.lst[[1]]
lapply(correlation_diff.lst, function(x) round(x,3))
correlation_diff.mean <- sapply(correlation_diff.lst, function(x) mean(abs(x)))
sort(correlation_diff.mean)

original_correlation.wide.dt[,(cor = cor(prcp, srad))]




original_correlation.wide.dt[,x:= list(list(cor(original_correlation.wide.dt[,vars])))]


mtcars[order(gear, cyl), lapply(.SD, mean), by = .(gear, cyl), .SDcols = cols_chosen]


vars = c('prcp','srad','tmax','tmin')
corr_mt <- original_correlation.wide.dt[, x := .(list(cor(.SD))),  .SDcols = vars]

cor(pnt1000_correlation.dt[var == 'prcp', value_original], pnt1000_correlation.dt[var == 'srad', value_original])




pnt1000_correlation.dt[var == 'srad', value_original]

cor(pnt1000_correlation.dt$value_original, pnt1000_correlation.dt$value_nn)


pnt1000_correlation.dt[, x := .(list(cor(.SD))), by = var, .SDcols = 5:9]























diff_summary[,.(min = min(diff_w)), by = .(var)]


diff_summary[,diff_w_imp := diff_w - min(diff_w), by = .(var)]



grid_int_diff.dt[,.(diff_max = max(diff)), by = .(var, method)][order(var, diff_max)]



install.packages('esquisse')
install.packages('remotes')
devtools::install_github("dreamRs/esquisse")

esquisse::esquisser()
pnt1000_diff.dt <- pnt1000_diff.dt[,.(year, var, diff_nn, diff_local, diff_krigg, diff_buf, diff_area)] 
pnt1000_diff.dt[, .(diff_nn = sum(diff_nn),
                    diff_krigg = sum(diff_krigg),
                    diff_buf = sum(diff_buf),
                    diff_area = sum(diff_area)), by = .(var)]



?anova


pnt1000_results.prcp.dt <- pnt1000_results.dt[var == 'prcp'] %>% .[,-'var']

cols <- names(pnt1000_results.prcp.dt)[sapply(pnt1000_results.prcp.dt,is.character)]
pnt1000_results.prcp.dt[,id.1000:= as.numeric(id.1000)]
pnt1000_results.prcp.dt[,year:= as.numeric(year)]

pnt1000_results.prcp.dt[,(cols) := as.numeric(.SD), .SDcols=cols]

round(cor(pnt1000_results.prcp.dt),2)
pca1 = prcomp(pnt1000_results.prcp.dt, scale. = TRUE)

varco
nrow(pnt1000_results.sf)  









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
