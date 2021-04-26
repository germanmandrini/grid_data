test = FALSE
if(test){
  file = file_crop.brk
  fun = 'sum'
}


daymet_temporal_aggr <- function (file = NULL, fun = "mean"){
  data <- file
  if (raster::nlayers(data) < 365) {
    stop("Provided data isn't at a daily time step...")
  }
  dates <- as.Date(sub(pattern = "X", replacement = "", 
                           x = names(data)), format = "%Y.%m.%d")
  yr <- strsplit(as.character(dates), "-")[[1]][1]
  
  #ind <- months(dates)
  
  ind <- format(as.Date(dates), "%m")
  
  #=== Add by German to fix an error in the dates from daymet
  if(length(unique(ind)) < 12){
      if(nlayers(data) == 365){
        ind <- c(rep(1, 31), rep(2, 28), rep(3, 31), rep(4, 30),
                 rep(5, 31), rep(6, 30), rep(7, 31), rep(8, 31),
                 rep(9, 30), rep(10, 31), rep(11, 30), rep(12, 31))
      }
      if(nlayers(data) == 366){
        ind <- c(rep(1, 31), rep(2, 29), rep(3, 31), rep(4, 30),
                 rep(5, 31), rep(6, 30), rep(7, 31), rep(8, 31),
                 rep(9, 30), rep(10, 31), rep(11, 30), rep(12, 31))
      }#=== end
      
    }
  ind <- as.numeric(ind)
  result <- raster::stackApply(x = data, indices = ind, fun = fun, 
                               na.rm = TRUE)
  
  names(result) <- c('January', 'February', 'March', 'April', 'May', 'June', 'July', 
                     'August', 'September', 'October', 'November', 'December')
  return(result)
  
}
