# Prepare data for example for test2
# 3 example files.
# 3rd file is a subset of the 2nd file
#
# Erik.Leppo@tetratech.com
# 20170509
# 20201203, devtools to usethis, resave files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
wd <- getwd() # assume is package directory
#library(devtools)

# df.1, date, time, and datetime
# df.2 only datetime (different format)
# df.3 subset (one month) of df.2

# 1. Get data and process#####
# 1.1. Import Data
myFile <- "test2_AW_20130426_20130725.csv"
df.1 <- read.csv(file.path(wd,"data-raw",myFile))
myFile <- "test2_AW_20130725_20131015.csv"
df.2 <- read.csv(file.path(wd,"data-raw",myFile))
myFile <- "test2_AW_20140901_20140930.csv"
df.3 <- read.csv(file.path(wd,"data-raw",myFile))


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
data_raw_test2_AW_20130426_20130725 <- df.1
usethis::use_data(data_raw_test2_AW_20130426_20130725,overwrite = TRUE)
data_raw_test2_AW_20130725_20131015 <- df.2
usethis::use_data(data_raw_test2_AW_20130725_20131015,overwrite = TRUE)
data_raw_test2_AW_20140901_20140930 <- df.3
usethis::use_data(data_raw_test2_AW_20140901_20140930,overwrite = TRUE)

