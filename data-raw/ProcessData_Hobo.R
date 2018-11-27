# Prepare data for example for HoboWare
# 3 example files.
#
# Erik.Leppo@tetratech.com
# 20181127
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
wd <- getwd() # assume is package directory
#library(devtools)

# All 3 files for SiteID = Charlies

# 1. Get data and process#####
# 1.1. Import Data
myFile <- "Charlies_Air_20170726_20170926.csv"
  df.1 <- read.delim(file.path(wd,"data-raw", myFile))
myFile <- "Charlies_AW_20170726_20170926.csv"
  df.2 <- read.delim(file.path(wd,"data-raw", myFile))
myFile <- "Charlies_Water_20170726_20170926.csv"
  df.3 <- read.delim(file.path(wd,"data-raw", myFile))

# 1.2. Process Data
View(df.1)
View(df.2)
View(df.3)
# QC check
dim(df.1)
dim(df.2)
dim(df.3)
# structure
str(df.1)
str(df.2)
str(df.3)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2. Save as RDA for use in package####
#
data_raw_Charlies_Air_20170726_20170926 <- df.1
  devtools::use_data(data_raw_Charlies_Air_20170726_20170926, overwrite = TRUE)
data_raw_Charlies_AW_20170726_20170926 <- df.2
  devtools::use_data(data_raw_Charlies_AW_20170726_20170926, overwrite = TRUE)
data_raw_Charlies_Water_20170726_20170926 <- df.3
  devtools::use_data(data_raw_Charlies_Water_20170726_20170926, overwrite = TRUE)

