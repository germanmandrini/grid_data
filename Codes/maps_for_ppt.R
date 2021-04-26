wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
setwd(wd)
source('./Codes_useful/R.libraries.R')
grid5000.sf <- readRDS('./Project.Grid/Grid/rds.files/grid5000.sf.rds')
grid5000.dt <- readRDS('./Project.Grid/Grid/rds.files/grid5000.dt.rds')

#CORN PROPORTION BY YEAR
unique(grid5000.dt$source)
corn.area.map <- grid5000.dt[source == 'crop.CDL' & variable == 'Corn']
?dcast
corn.area.map.wide <- dcast(corn.area.map, id.5000 ~ year, value.var = "value") %>%
  .[,id.5000 := as.numeric(id.5000)]

grid5000.corn.area.sf <- dplyr::left_join(grid5000.sf, corn.area.map.wide, by = 'id.5000')
plot.cols <- names(grid5000.corn.area.sf)[2:11]
tm_shape(grid5000.corn.area.sf) + tm_polygons(plot.cols) +
  tm_legend(main.title = 'Champaign County - Corn count')

ggplot(corn.sens.map.wide, aes(x=prop.range, y=prop.sd)) + geom_point()

#CORN SENSITIVITY MAP
corn.sens.map <- grid5000.dt[(source == 'crop.sensitivity.range' | source == 'crop.sensitivity.sd') & variable == 'Corn']
?dcast
corn.sens.map.wide <- dcast(corn.sens.map, id.5000 ~ unit, value.var = "value") %>%
  .[,id.5000 := as.numeric(id.5000)]

grid5000.var.sf <- dplyr::left_join(grid5000.sf, corn.sens.map.wide, by = 'id.5000')
tm_shape(grid5000.var.sf) + tm_polygons(c('prop.range', 'prop.sd'), n = 5) +
  tm_legend(main.title = 'Champaign County - Corn Sensitivity')

ggplot(corn.sens.map.wide, aes(x=prop.range, y=prop.sd)) + geom_point()

#WEATHER
unique(grid5000.dt$source)

w.map <- grid5000.dt[source == 'daymet']
unique(w.map$unit)
w.map <- w.map[unit %in% c("mm.4to9.sum", "mm.1to4.sum","nn.4to9.mean") & year == 1982]
w.map[,.N,by = 'variable']

?dcast
w.map.wide <- dcast(w.map, id.5000 ~ variable, value.var = "value") %>%
  .[,id.5000 := as.numeric(id.5000)]

grid5000.w.sf <- dplyr::left_join(grid5000.sf, w.map.wide, by = 'id.5000')
plot.cols <- names(grid5000.corn.area.sf)[2:11]
tm_shape(grid5000.corn.area.sf) + tm_polygons(plot.cols) +
  tm_legend(main.title = 'Champaign County - Corn count')

ggplot(corn.sens.map.wide, aes(x=prop.range, y=prop.sd)) + geom_point()