wd <- 'C:/Users/germanm2/Box Sync/My_Documents' #CPSC
wd <- 'C:/Users/germa/Box Sync/My_Documents' #Dell
setwd(wd)

source('./Codes_useful/R.libraries.R')
# install.packages("daymetr")
#library("daymetr")

<<<<<<< HEAD
source('./grid_data_git/Codes/functions.grid_Dec10.R')
=======
source('./Project.Grid/Grid/Codes/functions_grid_Dec10.R')
>>>>>>> e3b507728326d262c2de25734ae8149503c51fd2

#DOWNLOAD THE DAILY DATA: 4 VARIABLES
# Catalogo: https://thredds.daac.ornl.gov/thredds/catalogs/daymet/daymet.html
# Catalogo2: https://thredds.daac.ornl.gov/thredds/catalogs/ornldaac/Regional_and_Global_Data/DAYMET_COLLECTIONS/DAYMET_COLLECTIONS.html
# User guide: https://daac.ornl.gov/DAYMET/guides/Daymet_V3_CFMosaics.html
# Projection System: Lambert Conformal Conic
# LINK EXAMPLES
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_tmin_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_prcp_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_tmax_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/1980/daymet_v3_srad_1980_na.nc4


variables <- c('prcp', 'srad', 'tmax', 'tmin')
years <- 1980:2017
# 
all_combinations = expand.grid(variables, years)
# 
# download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>% 
#                           .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1328/',all_combinations[,2],'/', file_name, sep = '')] %>%
#                           .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', file_name)]
# 
# downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/daily_data', all.files = FALSE,
#                             full.names = FALSE, recursive = FALSE,
#                             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
# download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]
# 
# for(i in 1:nrow(download_ask)){
#   status = try(httr::GET(url = download_ask$download_link[i], 
#                          httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE), 
#                          httr::progress()), silent = FALSE)
# }
# 
# 
# 
# #DOWNLOAD THE MONTHLY DATA: 3 VARIABLES
# LINK EXAMPLES
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_prcp_monttl_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmin_monavg_1980_na.nc4
# https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/daymet_v3_tmax_monavg_1980_na.nc4

# variables <- c('prcp_monttl', 'tmax_monavg', 'tmin_monavg')
# years = 1980:2017
# 
# all_combinations = expand.grid(variables, years)
# 
# 
# 
# download_ask <- data.table(file_name = paste('daymet_v3_', all_combinations[,1], '_', all_combinations[,2], '_na.nc4', sep='')) %>%
#   .[,download_link := paste('https://thredds.daac.ornl.gov/thredds/fileServer/ornldaac/1345/', file_name, sep = '')] %>%
#   .[,file_path := file.path('//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', file_name)]
# 
# 
# downloaded.c <- list.files(path = '//ad.uillinois.edu/aces/CPSC/share/Bioinformatics Lab/germanm2/Grid/daymet/monthly_data', all.files = FALSE,
#                            full.names = FALSE, recursive = FALSE,
#                            ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
# download_ask <- download_ask[!download_ask$file_name %in% downloaded.c]
# download_ask$file_name[1:15]
# for(i in 1){ #nrow(download_ask)
#   status = try(httr::GET(url = download_ask$download_link[i],
#                          httr::write_disk(path = download_ask$file_path[i], overwrite = TRUE),
#                          httr::progress()), silent = FALSE)
# }


