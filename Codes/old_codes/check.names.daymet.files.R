
files.year.full <- list.files(path = folder.name, all.files = FALSE,
                              full.names = TRUE, recursive = FALSE,
                              ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
files.year <- list.files(path = folder.name, all.files = FALSE,
                         full.names = FALSE, recursive = FALSE,
                         ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

class(files.year.full)

check.names <- data.table()
for(i in 1:length(files.year.full)){
  # i=1
  print(round(i/length(files.year.full)*100),1)
  i.file <- files.year.full[i]
  data <- suppressWarnings(raster::brick(i.file))
  names(data)
  dates <- as.Date(sub(pattern = "X", replacement = "", 
                       x = names(data)), format = "%Y.%m.%d")
  ind <- months(dates)
  months <- length(unique(ind))
  if(months < 12){
  check.names <- rbind(check.names, data.table(file = files.year[i], unique = months))
  }
}
