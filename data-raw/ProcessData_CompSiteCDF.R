# Prepare data for example for CompSiteCDF
# Water Temp Data by Date (x) and Sites (y)
#
# Erik.Leppo@tetratech.com
# 20170921
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
wd <- getwd() # assume is package directory
#library(devtools)

# 1. Get data and process#####
# 1.1. Import Data
myFile <- "CDF_WaterTemp_2014_MA.csv"
data.import <- read.csv(file.path(wd,"data-raw",myFile))
# 1.2. Process Data
View(data.import)
# QC check
dim(data.import)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Save as RDA for use in package####
#
data_CompSiteCDF <- data.import
devtools::use_data(data_CompSiteCDF, overwrite = TRUE)

# # # for quick naming
# data_raw_test4_mismatchtimes <- data.import
# devtools::use_data(data_raw_test4_mismatchtimes,overwrite=TRUE)

# # as part of help file
# myData <- data.import
# write.csv(myData,paste0("./",Selection.SUB[1],"/test4_AW_20160418_20160726.csv"))
