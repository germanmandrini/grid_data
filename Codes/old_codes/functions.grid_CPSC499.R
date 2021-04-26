#------ OPEN AND MERGE TILES FUNCTION ----------
open.aggr.merge.tiles <- function(files.names, fun.month = "mean"){
  # files.names <- files.prcp
  # fun.month = "mean"
  for(i in 1:length(files.names)){
    # i = 1
    i.file = files.names[i]
    tmp.agg.stk <- daymet_grid_agg_fixed(file = i.file, int = "monthly", fun = fun.month,
                                         internal = TRUE)
    nlayers(tmp.agg.stk)
    
    #Fix na values outside the raster when doing fun = sum
    data.clean <- suppressWarnings(raster::brick(i.file))
    data.clean2 <- data.clean[[1]]
    data.clean2[!is.na(data.clean2)] <- 1
    tmp.agg.clean.stk <- tmp.agg.stk * data.clean2
    nlayers(tmp.agg.stk)
    # plot(tmp.agg.clean.stk)
    
    # tmp.stk <- raster::stack(files.names[i])
    # tmp.stk2 <- raster::stack(files.names[2])
    
    if(i==1){
      merged.stk <- tmp.agg.clean.stk
    }else{
      merged.stk <- raster::merge(merged.stk,tmp.agg.clean.stk)
      # plot(merged.stk)
    }
  }
  
  names(merged.stk) <- names(tmp.agg.stk)
  nlayers(merged.stk)
  return(merged.stk)
}



open_project_crop <- function(file, target_file = grid5000.sf){
  #file= files.year.full
  #target_file = grid5000.sf
  file1.brk <- suppressWarnings(raster::brick(file))
  
  # for clipping first convert the target_file to the proj of the file and clip it (doing the opposite is 
  # more accurate but since file is large it takes a lot of time)
  
  clip_first <- st_transform(target_file, proj4string(file1.brk)) %>% # Projection System: Lambert Conformal Conic
    st_union(.) %>% st_sf(.) %>% st_buffer(., 2000)
  
  file2.brk <- crop(file1.brk, clip_first)
  
  crs.target_file <- st_crs(target_file)
  file3.brk <- projectRaster(file2.brk, crs = crs.target_file$proj4string)
  
  #Clipped again using the target file as it is
  file4.brk <- crop(file3.brk, target_file)
  
  return(file4.brk)
} 



test = FALSE
if(test){
  file = file.brk
  int = "july"
  fun = 'sum'
  internal = TRUE
}


daymet_grid_agg_fixed <- function (file = NULL, int = "seasonal", fun = "mean", internal = FALSE, 
          path = tempdir()){
  # if (is.null(file)) {
  #   stop("File not provided...")
  # }
  # if (!file.exists(file)) {
  #   stop("File does not exist...")
  # }
  # ext <- tools::file_ext(file)
  # data <- suppressWarnings(raster::brick(file))
  ext <- "nc4"
  data <- file
  if (raster::nlayers(data) < 365) {
    stop("Provided data isn't at a daily time step...")
  }
  if (ext == "tif" | ext == "nc4") {
    if (ext == "nc4") {
      dates <- as.Date(sub(pattern = "X", replacement = "", 
                           x = names(data)), format = "%Y.%m.%d")
      yr <- strsplit(as.character(dates), "-")[[1]][1]
    } else {
      dy <- as.numeric(as.vector(t(as.data.frame(strsplit(names(data), 
                                                          "[.]"))[2, ])))
      yr <- strsplit(names(data), "_")[[1]][3]
      dates <- as.Date(x = dy, origin = sprintf("%s-01-01", 
                                                yr))
    }
  } else {
    stop("Unable to read dates.\n\n         Files must be outputs from daymetr functions in tif or nc format.")
  }
  if (int == "monthly" | int == "season" | int == "july_week1"| int == "july") {
    ind <- months(dates)
    
    #=== Add by German to fix an error in the dates from daymet
    if(length(unique(ind)) < 12){
      if(nlayers(data) == 365){
        ind <- c(rep('January', 31), rep('February', 28), rep('March', 31), rep('April', 30),
                  rep('May', 31), rep('June', 30), rep('July', 31), rep('August', 31),
                  rep('September', 30), rep('October', 31), rep('November', 30), rep('December', 31))
      }
      if(nlayers(data) == 366){
        ind <- c(rep('January', 31), rep('February', 29), rep('March', 31), rep('April', 30),
                rep('May', 31), rep('June', 30), rep('July', 31), rep('August', 31),
                rep('September', 30), rep('October', 31), rep('November', 30), rep('December', 31))
      }#=== end
    
    }
  }
  if (int == "season"  ) {
    season_months = c('April', 'May', 'June','July','August','September')
    ind = sapply(ind, function(x) ifelse(x %in% season_months, 'in_season', 'out_of_season'), USE.NAMES = FALSE) 
  } 
  
  if (int == "july_week1"  ) {
    july_week1 <- which(ind == 'July')[1:7]
    ind <-rep('out_of_season', length(ind))
    ind[july_week1] <- 'in_season'
  } 
  
  if (int == "july"  ) {
    season_months = c('July')
    ind = sapply(ind, function(x) ifelse(x %in% season_months, 'in_season', 'out_of_season'), USE.NAMES = FALSE) 
  }
  
  # if (int == "annual") {
  #   ind <- as.numeric(substring(dates, 1, 4))
  # }
  # if (int == "seasonal") {
  #   spring_equinox <- as.Date(sprintf("%s.03.20", yr), format = "%Y.%m.%d")
  #   summer_solstice <- as.Date(sprintf("%s.06.21", yr), format = "%Y.%m.%d")
  #   fall_equinox <- as.Date(sprintf("%s.09.22", yr), format = "%Y.%m.%d")
  #   winter_solstice <- as.Date(sprintf("%s.12.21", yr), format = "%Y.%m.%d")
  #   year_start <- utils::head(dates, n = 1)
  #   year_end <- utils::tail(dates, n = 1)
  #   winter_start <- seq(from = year_start, to = (spring_equinox - 
  #                                                  1), by = "days")
  #   spring <- seq(from = spring_equinox, to = (summer_solstice - 
  #                                                1), by = "days")
  #   summer <- seq(from = summer_solstice, to = (fall_equinox - 
  #                                                 1), by = "days")
  #   fall <- seq(from = fall_equinox, to = (winter_solstice - 
  #                                            1), by = "days")
  #   winter_end <- seq(from = winter_solstice, to = year_end, 
  #                     by = "days")
  #   winter_start_lab <- rep("winter", times = length(winter_start))
  #   spring_lab <- rep("spring", times = length(spring))
  #   summer_lab <- rep("summer", times = length(summer))
  #   fall_lab <- rep("fall", times = length(fall))
  #   winter_end_lab <- rep("winter", times = length(winter_end))
  #   ind <- c(winter_start_lab, spring_lab, summer_lab, fall_lab, 
  #            winter_end_lab)
  # }
  result <- raster::stackApply(x = data, indices = ind, fun = fun, 
                               na.rm = TRUE)
  if(int == 'season' | int == 'july_week1' | int == 'july'){
    result <- result[['index_in_season']]
  }
  
  if (internal == FALSE) {
    input_file <- tools::file_path_sans_ext(basename(file))
    param <- strsplit(input_file, "_")[[1]][1]
    year <- strsplit(input_file, "_")[[1]][3]
    output_file <- file.path(normalizePath(path), sprintf("%s_agg_%s_%s%s.tif", 
                                                          param, year, int, fun))
    raster::writeRaster(x = result, filename = output_file, 
                        overwrite = TRUE)
  }
  else {
    return(result)
  }
}
