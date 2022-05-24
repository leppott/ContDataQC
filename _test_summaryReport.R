# Test new Site Summary Notebook
# Erik.Leppo@tetratech.com
# 2022-05-20
#
# Use fun.Report.File() to launch
# \inst\rmd\Report_SiteSummary.rmd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Packages
library(ContDataQC)

# Copy Example file to Temp Directory
myFile <- "DATA_test2_Aw_20130101_20141231.csv"
file.copy(file.path(path.package("ContDataQC"), "extdata", myFile)
          , file.path(tempdir(), myFile))

# Open Directory
shell.exec(tempdir())

# Create Notebook
# fun.Report.File(
#   fun.myFile = myFile,
#   fun.myDir.import = tempdir(),
#   fun.myDir.export = tempdir(),
#   fun.myFile.Prefix = "SUMMARY",
#   fun.myReport.format = "HTML",
#   fun.myReport.Dir = path.package("ContDataQC"), "extdata", "rmd")
# )

fun.myFile = myFile
fun.myDir.import = tempdir()
fun.myDir.export = tempdir()
fun.myFile.Prefix = "SUMMARY"
fun.myReport.format = "HTML"
# fun.myReport.Dir = file.path(path.package("ContDataQC"), "rmd")
fun.myReport.Dir = file.path("inst", "rmd")

myRMD <- "Report_SiteSummary.rmd"

# Config file
source(file.path(path.package("ContDataQC"), "extdata", "config.ORIG.R"))
data.import <- read.csv(file.path(tempdir(), myFile))

# RMD needs
strFile <- myFile
strFile.SiteID <- "testSiteID"
# strFile.DataType <- "DATA"  # not needed, comment out
fun.myData.DateRange.Start <- "20130101"
fun.myData.DateRange.End <- "20141231"
myName.Date <- "Date"

#
strFile.RMD <- file.path(fun.myReport.Dir, myRMD)
strFile.RMD.format <- fun.myReport.format
strFile.out <- paste0("test.", fun.myReport.format)

# Render RMD
rmarkdown::render(strFile.RMD
                  , output_format = strFile.RMD.format
                  , output_file = strFile.out
                  , output_dir = fun.myDir.export
                  , quiet = TRUE)

