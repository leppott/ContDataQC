## ----FormatHobo, eval=FALSE---------------------------------------------------
#  # Packages
#  library(ContDataQC)
#  
#  # Parameters
#  # Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  # Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  # Selection.SUB <- c("Data0_Original"
#  #                   , "Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- tempdir()
#  
#  # Function Inputs
#  fn1 <- "Ellis--1.0m_Water_20180524_20180918.csv"
#  fn2 <- "Ellis--3.0m_Water_20180524_20180918.csv"
#  
#  myFiles <- c(fn1, fn2)
#  myDir.import <- file.path(myDir.BASE, "Data0_Original")
#  myDir.export <- file.path(myDir.BASE, "Data1_RAW")
#  
#  myFormat = "YMD"
#  
#  # Run Function (with default config)
#  formatHobo(myFiles, myDir.import, myDir.export, fun.HoboDateFormat=myFormat)

## ----QC, eval=FALSE-----------------------------------------------------------
#  # Packages
#  library(ContDataQC)
#  
#  # Parameters
#  Selection.Operation <- c("GetGageData"
#                           ,"QCRaw"
#                           , "Aggregate"
#                           , "SummaryStats")
#  Selection.Type <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original"
#                     , "Data1_RAW"
#                     , "Data2_QC"
#                     , "Data3_Aggregated"
#                     , "Data4_Stats")
#  myDir.BASE <-
#  
#  # Files
#  fn1 <- "Ellis--1.0m_Water_20180524_20180918.csv"
#  fn2 <- "Ellis--3.0m_Water_20180524_20180918.csv"
#  
#  # QC Data
#  myData.Operation <- "QCRaw" #Selection.Operation[2]
#  myFile <- c(fn1, fn2)
#  myDir.import <- file.path(myDir.BASE, "Data1_RAW")
#  myDir.export <- file.path(myDir.BASE, "Data2_QC")
#  myReport.format <- "html"
#  ContDataQC(myData.Operation
#             , fun.myDir.import = myDir.import
#             , fun.myDir.export = myDir.export
#             , fun.myFile = myFile
#             , fun.myReport.format = myReport.format)
#  

## ----Agg, eval=FALSE----------------------------------------------------------
#  # Packages
#  library(ContDataQC)
#  
#  myDir.BASE <- tempdir()
#  
#  # Files
#  myFile <- c("QC_Ellis--1.0m_Water_20180524_20180918.csv"
#              , "QC_Ellis--3.0m_Water_20180524_20180918.csv")
#  
#  # Aggregate Data
#  myData.Operation <- "Aggregate" #Selection.Operation[3]
#  myFile <- c("QC_Ellis--1.0m_Water_20180524_20180918.csv"
#              , "QC_Ellis--3.0m_Water_20180524_20180918.csv")
#  myDir.import <- file.path(myDir.BASE, "Data2_QC")
#  myDir.export <- file.path(myDir.BASE, "Data3_Aggregated")
#  myReport.format <- "html"
#  ContDataQC(myData.Operation
#             , fun.myDir.import = myDir.import
#             , fun.myDir.export = myDir.export
#             , fun.myFile = myFile
#             , fun.myReport.format = myReport.format)

## ----ParseID, eval=FALSE------------------------------------------------------
#  myDir.BASE <- tempdir()
#  
#  # Parse ID string and save
#  dir_files <- file.path(myDir.BASE, "Data3_Aggregated")
#  setwd(dir_files)
#  
#  fun.myFileName.In <- "DATA_QC_Ellis--1.0m_Water_20180524_20180918_Append_2.csv"
#  fun.myFileName.Out <- "Ellis_FixedID.csv"
#  fun.ColName.ID <- "SiteID"
#  fun.Delim <- "--"
#  
#  fun.ParseID(fun.myFileName.In
#              , fun.myFileName.Out
#              , fun.ColName.ID
#              , fun.Delim)

## ----Example_Temp_Depth-------------------------------------------------------
# Example code to Plot data
library(ggplot2)

# Read file
df_Ellis <- read.csv(file.path(system.file("extdata", package="ContDataQC")
                               , "Ellis.csv"))
df_Ellis[, "Date.Time"] <- as.POSIXct(df_Ellis[, "Date.Time"])

# Plot, Create
p <- ggplot(df_Ellis, aes(x = Date.Time, y = Water.Temp.C, group = ID_Depth)) +
  geom_point(aes(color = ID_Depth)) +
  scale_color_continuous(trans = "reverse") +
  scale_x_datetime(date_labels = "%Y-%m")

# Plot, Show
print(p)

