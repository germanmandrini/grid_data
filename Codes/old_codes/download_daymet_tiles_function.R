location = c(18.9103, -114.6109)
location = c(34, -82, 33.75, -81.75)
start = 1980
end = 1980
param = "srad"
frequency = "monthly"
tiles = NULL
path = tempdir()
silent = FALSE
force = FALSE

?download_daymet_tiles
download_daymet_tiles <- function (location = c(18.9103, -114.6109), tiles = NULL, start = 1980, 
          end = 1980, path = tempdir(), param = "ALL", silent = FALSE, 
          force = FALSE){
  if (identical(path, tempdir())) {
    message("NOTE: data is stored in tempdir() ...")
  }
  base_url = "https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/tiles"
  projection = sp::CRS(sp::proj4string(daymetr::tile_outlines))
  if (!is.null(tiles)) {
    tile_selection = as.vector(unlist(tiles))
  }else if (length(location) == 2) {
    location = sp::SpatialPoints(list(location[2], location[1]), 
                                 projection)
    tile_selection = sp::over(location, daymetr::tile_outlines)$TileID
    if (is.na(tile_selection)) {
      stop("Your defined range is outside DAYMET coverage,\n               check your coordinate values!")
    }
  }else if (length(location) == 4) {
    rect_corners = cbind(c(location[2], rep(location[4], 
                                            2), location[2]), c(rep(location[3], 2), rep(location[1], 
                                                                                         2)))
    ROI = sp::SpatialPolygons(list(sp::Polygons(list(sp::Polygon(list(rect_corners))), 
                                                "bb")), proj4string = projection)
    tile_selection = unique(sp::over(ROI, daymetr::tile_outlines, 
                                     returnList = TRUE)[[1]]$TileID)
    if (!length(tile_selection)) {
      stop("Your defined range is outside DAYMET coverage,\n               check your coordinate values!")
    }
  }else {
    stop("check the coordinates: specifiy a single location,\n\n             top-left bottom-right or provide a tile selection \n")
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
    param = c("vp", "tmin", "tmax", "swe", "srad", "prcp", 
              "dayl")
  }
  for (i in year_range) {
    # i=1980
    for (j in tile_selection) {
      #j=9753
      for (k in param) {
        #  k='srad'
        url = sprintf("%s/%s/%s_%s/%s.nc", base_url, 
                      i, j, i, k)
        daymet_file = paste0(path, "/", k, "_", i, "_", 
                             j, ".nc")
        if (!silent) {
          cat(paste0("\nDownloading DAYMET data for tile: ", 
                     j, "; year: ", i, "; product: ", k, "\n"))
        }
        if (silent) {
          status = try(utils::capture.output(httr::GET(url = url, 
                                                       httr::write_disk(path = daymet_file, overwrite = TRUE))), 
                       silent = TRUE)
        }else {
          status = try(httr::GET(url = url, httr::write_disk(path = daymet_file, 
                                                             overwrite = TRUE), httr::progress()), silent = TRUE)
        }
        if (inherits(status, "try-error")) {
          cat("download failed ... (check warning messages)")
        }
      }
    }
  }
}
<bytecode: 0x00000000356390f8>
  <environment: namespace:daymetr>
  
r <- raster::stack('C:/Users/germanm2/AppData/Local/Temp/RtmpyEOHcu/srad_1980_11210.nc')  
