location = c(83, -157, 80, -150)
start = 1980
end = 1980
param = "tmin"
frequency = "daily"
path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data'
silent = FALSE
force = FALSE
i=1980
j='tmin'

https://thredds.daac.ornl.gov/thredds/catalog/ornldaac/1328/1980/catalog.html?dataset=1328/1980/daymet_v3_tmin_1980_na.nc4

download_daymet_ncss <- function (location = c(34, -82, 33.75, -81.75), start = 1980, 
          end = 1980, param = "tmin", frequency = "daily", path = tempdir(), 
          silent = FALSE, force = FALSE){
  if (identical(path, tempdir())) {
    message("NOTE: data is stored in tempdir() ...")
  }
  base_url = "https://thredds.daac.ornl.gov/thredds/ncss/fileServer"
  frequency = tolower(frequency)
  if (frequency == "monthly") {
    base_url = sprintf("%s/%s", base_url, 1345)
  }else if (frequency == "annual") {
    base_url = sprintf("%s/%s", base_url, 1343)
  }else {
    base_url = sprintf("%s/%s", base_url, 1328)
  }
  if (length(location) != 4) {
    stop("check coordinates format: top-left / bottom-right c(lat,lon,lat,lon)")
  }
  if (!force) {
    max_year = as.numeric(format(Sys.time(), "%Y")) - 1
  }else {
    max_year = as.numeric(format(Sys.time(), "%Y"))
  }
  if (start < 1980) {
    stop("Start year preceeds valid data range!")
  }
  if (end > max_year) {
    stop("End year exceeds valid data range!")
  }
  year_range = seq(start, end, by = 1)
  if (any(grepl("ALL", toupper(param)))) {
    if (tolower(frequency) == "daily") {
      param = c("vp", "tmin", "tmax", "swe", "srad", "prcp", 
                "dayl")
    }else {
      param = c("vp", "tmin", "tmax", "prcp")
    }
  }
  if (!silent) {
    cat("Creating a subset of the Daymet data\n        be patient, this might take a while!\n")
  }
  for (i in year_range) {
    
    for (j in param) {
      if (frequency != "daily") {
        if (j != "prcp") {
          prefix = paste0(substr(frequency, 1, 3), "avg")
        }else {
          prefix = paste0(substr(frequency, 1, 3), "ttl")
        }
        url = sprintf("%s/daymet_v3_%s_%s_%s_na.nc4", 
                      base_url, j, prefix, i)
        daymet_file = file.path(path, paste0(j, "_", 
                                             prefix, "_", i, "_ncss.nc"))
      }else {
        url = sprintf("%s/%s/daymet_v3_%s_%s_na.nc4", 
                      base_url, i, j, i)
        daymet_file = file.path(path, paste0(j, "_daily_", 
                                             i, "_ncss.nc"))
      }
      query = list(var = "lat", var = "lon", var = j, north = location[1], 
                   west = location[2], east = location[4], south = location[3], 
                   time_start = paste0(start, "-01-01T12:00:00Z"), 
                   time_end = paste0(end, "-12-31T12:00:00Z"), timeStride = 1, 
                   accept = "netcdf")
      if (!silent) {
        cat(paste0("\nDownloading DAYMET subset: ", "year: ", 
                   i, "; product: ", j, "\n"))
      }
      if (silent) {
        status = try(utils::capture.output(httr::GET(url = url, 
                                                     query = query, httr::write_disk(path = daymet_file, 
                                                                                     overwrite = TRUE))), silent = TRUE)
      }else {
        url2 = 'https://thredds.daac.ornl.gov/thredds/ncss/grid/ornldaac/1328/1980/daymet_v3_tmin_1980_na.nc4/dataset.html'
        url3 = 'https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_tmin_1980_na.nc4'
        url
        url3
        status = try(httr::GET(url = url3, query = query, 
                               httr::write_disk(path = daymet_file, overwrite = TRUE), 
                               httr::progress()), silent = TRUE)
        
        status = try(httr::GET(url = url3, 
                               httr::write_disk(path = daymet_file,  overwrite = TRUE), 
                               httr::progress()), silent = TRUE)
        #https://thredds.daac.ornl.gov/thredds/catalog/ornldaac/1328/1980/catalog.html?dataset=1328/1980/daymet_v3_tmin_1980_na.nc4
        
      }
      if (inherits(status, "try-error")) {
        stop("Requested coverage exceeds 6GB file size limit!")
      }
    }
  }
}
# https://thredds.daac.ornl.gov/thredds/catalogs/ornldaac/Regional_and_Global_Data/DAYMET_COLLECTIONS/DAYMET_COLLECTIONS.html

r <- raster::stack('C:/Users/germanm2/AppData/Local/Temp/RtmpyEOHcu/srad_daily_1980_ncss.nc')
file:///

# C:\Users\germanm2\AppData\Local\Temp\RtmpyEOHcu