## ----LoadPkg, eval=FALSE-------------------------------------------------
#  install.packages("devtools")
#  library(devtools)
#  install_github("leppott/ContDataQC")

## ----LoadDependancies, eval=FALSE----------------------------------------
#  # install all dependant libraries manually
#  # libraries to be installed
#  data.packages = c(
#                    "dataRetrieval"   # loads USGS data into R
#                    "zoo",
#                    "knitr",
#                    "survival",
#                    "doBy",
#                    "rmarkdown"
#                    )
#  
#  # install packages via a 'for' loop
#  for (i in 1:length(data.packages)) {
#    #install.packages("doBy",dependencies=TRUE)
#    install.packages(data.packages[i])
#  } # end loop
#  
#  print("Task complete.  Check statements above for errors.")
#  

## ----LoadPandoc, eval=FALSE----------------------------------------------
#  # Install Pandoc (for docx Reports)
#  # (if using recent version of RStudio do not have to install separately)
#  install.packages("installr") # not needed if already have this package.
#  require(installr)
#  install.pandoc()
#  # The above won't work if don't have admin rights on your computer.
#  # Alternative = Download the file below and have your IT dept install for you.
#  # https://github.com/jgm/pandoc/releases/download/1.16.0.2/pandoc-1.16.0.2-windows.msi
#  # For help for installing via command window:
#  # http://www.intowindows.com/how-to-run-msi-file-as-administrator-from-command-prompt-in-windows/

## ----LoadPkg_USGS, eval=FALSE--------------------------------------------
#  # inter-CRAN release hosted on USGS website
#  install.packages("dataRetrieval",repos="https://owi.usgs.gov/R")
#  # from GitHub
#  # install.packages("devtools")
#  # library(devtools)
#  # install_github("USGS-R/dataRetrieval")

## ----PkgVariables, eval=FALSE--------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original", "Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  
#  # Create data directories
#  myDir.create <- paste0("./",Selection.SUB[1])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[2])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[3])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[4])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[5])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  
#  # Save example data (assumes directory ./Data1_RAW/ exists)
#  myData <- data_raw_test2_AW_20130426_20130725
#    write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20130426_20130725.csv"))
#  myData <- data_raw_test2_AW_20130725_20131015
#    write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20130725_20131015.csv"))
#  myData <- data_raw_test2_AW_20140901_20140930
#    write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20140901_20140930.csv"))
#  myData <- data_raw_test4_AW_20160418_20160726
#    write.csv(myData,paste0("./",Selection.SUB[2],"/test4_AW_20160418_20160726.csv"))
#  myFile <- "config.TZ.Central.R"
#    file.copy(file.path(path.package("ContDataQC"),"extdata",myFile)
#              ,file.path(getwd(),Selection.SUB[2],myFile))

## ----GetGageData_base, echo=TRUE-----------------------------------------
library(ContDataQC)
# Parameters
Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
myDir.BASE <- getwd()
# Get Gage Data
myData.Operation    <- "GetGageData" #Selection.Operation[1]
myData.SiteID       <- "01187300" # Hubbard River near West Hartland, CT
myData.Type         <- "Gage" #Selection.Type[4] 
myData.DateRange.Start  <- "2013-01-01"
myData.DateRange.End    <- "2014-12-31"
myDir.import <- ""
myDir.export <- file.path(myDir.BASE,Selection.SUB[2])
ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
           , myData.DateRange.End, myDir.import, myDir.export)

## ----GetGageData_TZ, eval=FALSE------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # Get Gage Data (central time zone)
#  myData.Operation    <- "GetGageData" #Selection.Operation[1]
#  myData.SiteID       <- "07032000" # Mississippi River at Memphis, TN
#  myData.Type         <- Selection.Type[4] #"Gage"
#  myData.DateRange.Start  <- "2013-01-01"
#  myData.DateRange.End    <- "2014-12-31"
#  myDir.import <- ""
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[2])
#  myConfig            <- file.path(getwd(),Selection.SUB[2],"config.TZ.central.R") # include path if not in working directory
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, myDir.import, myDir.export, myConfig)

## ----QCRaw_base, eval=FALSE----------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # QC Raw Data
#  myData.Operation <- "QCRaw" #Selection.Operation[2]
#  myData.SiteID    <- "test2"
#  myData.Type      <- Selection.Type[3] #"AW"
#  myData.DateRange.Start  <- "2013-01-01"
#  myData.DateRange.End    <- "2014-12-31"
#  myDir.import <- file.path(myDir.BASE,Selection.SUB[2]) #"Data1_RAW"
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#  myReport.format <- "docx"
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#             , myData.DateRange.End, myDir.import, myDir.export, myReport.format)

## ----QCRaw_timeoffset, eval=FALSE----------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # QC Raw Data (offset collection times for air and water sensors)
#  myData.Operation <- "QCRaw" #Selection.Operation[2]
#  myData.SiteID    <- "test4"
#  myData.Type      <- Selection.Type[3] #"AW"
#  myData.DateRange.Start  <- "2016-04-28"
#  myData.DateRange.End    <- "2016-07-26"
#  myDir.import <- file.path(myDir.BASE,Selection.SUB[2]) #"Data1_RAW"
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#  myReport.format <- "html"
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#             , myData.DateRange.End, myDir.import, myDir.export, myReport.format)

## ----Aggregate, eval=FALSE-----------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # Aggregate Data
#  myData.Operation <- "Aggregate" #Selection.Operation[3]
#  myData.SiteID    <- "test2"
#  myData.Type      <- Selection.Type[3] #"AW"
#  myData.DateRange.Start  <- "2013-01-01"
#  myData.DateRange.End    <- "2014-12-31"
#  myDir.import <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[4]) #"Data3_Aggregated"
#  #Leave off myReport.format and get default (docx).
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#             , myData.DateRange.End, myDir.import, myDir.export)
#  

## ----SummaryStats, eval=FALSE--------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # Summary Stats
#  myData.Operation <- "SummaryStats" #Selection.Operation[4]
#  myData.SiteID    <- "test2"
#  myData.Type      <- Selection.Type[3] #"AW"
#  myData.DateRange.Start  <- "2013-01-01"
#  myData.DateRange.End    <- "2014-12-31"
#  myDir.import <- file.path(myDir.BASE,Selection.SUB[4]) #"Data3_Aggregated"
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[5]) #"Data4_Stats"
#  #Leave off myReport.format and get default (docx).
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#             , myData.DateRange.End, myDir.import, myDir.export)

## ----ContDataQC_FileVersions, eval=FALSE---------------------------------
#  #~~~~~~~~~~~~~~
#  # File Versions
#  #~~~~~~~~~~~~~~
#  
#  # QC Data
#  myData.Operation <- "QCRaw" #Selection.Operation[2]
#  #myFile <- "test2_AW_20130426_20130725.csv"
#  myFile <- c("test2_AW_20130426_20130725.csv", "test2_AW_20130725_20131015.csv", "test2_AW_20140901_20140930.csv")
#  myDir.import <- file.path(".","Data1_RAW")
#  myDir.export <- file.path(".","Data2_QC")
#  myReport.format <- "docx"
#  ContDataQC(myData.Operation, fun.myDir.import=myDir.import, fun.myDir.export=myDir.export, fun.myFile=myFile, myReport.format)
#  
#  # Aggregate Data
#  myData.Operation <- "Aggregate" #Selection.Operation[3]
#  myFile <- c("QC_test2_AW_20130426_20130725.csv", "QC_test2_AW_20130725_20131015.csv", "QC_test2_AW_20140901_20140930.csv")
#  myDir.import <- file.path(".","Data2_QC")
#  myDir.export <- file.path(".","Data3_Aggregated")
#  myReport.format <- "html"
#  ContDataQC(myData.Operation, fun.myDir.import=myDir.import, fun.myDir.export=myDir.export, fun.myFile=myFile, myReport.format)
#  
#  # Summary Stats
#  myData.Operation <- "SummaryStats" #Selection.Operation[4]
#  myFile <- "QC_test2_AW_20130426_20130725.csv"
#  #myFile <- c("QC_test2_AW_20130426_20130725.csv", "QC_test2_AW_20130725_20131015.csv", "QC_test2_AW_20140901_20140930.csv")
#  myDir.import <- file.path(".","Data2_QC")
#  myDir.export <- file.path(".","Data4_Stats")
#  #Leave off myReport.format and get default (docx).
#  ContDataQC(myData.Operation, fun.myDir.import=myDir.import, fun.myDir.export=myDir.export, fun.myFile=myFile)
#  

## ----Config, comment="", eval=TRUE, echo=FALSE---------------------------
fn <- file.path(system.file("extdata", "config.ORIG.R", package="ContDataQC"))
cat(readLines(fn), sep="\n")

## ----PeriodStats, eval=FALSE---------------------------------------------
#  # Save example file
#  df.x <- DATA_period_test2_Aw_20130101_20141231
#  write.csv(df.x,"DATA_period_test2_Aw_20130101_20141231.csv")
#  
#  # function inputs
#  myDate <- "2013-09-30"
#  myDate.Format <- "%Y-%m-%d"
#  myPeriod.N <- c(30, 60, 90, 120, 1)
#  myPeriod.Units <- c("d", "d", "d", "d", "y")
#  myFile <- "DATA_period_test2_Aw_20130101_20141231.csv"
#  myDir.import <- getwd()
#  myDir.export <- getwd()
#  myParam.Name <- "Water.Temp.C"
#  myDateTime.Name <- "Date.Time"
#  myDateTime.Format <- "%Y-%m-%d %H:%M:%S"
#  myThreshold <- 20
#  myConfig <- ""
#  myReport.format <- "docx"
#  
#  # Run Function
#  ## default report format (html)
#  PeriodStats(myDate
#            , myDate.Format
#            , myPeriod.N
#            , myPeriod.Units
#            , myFile
#            , myDir.import
#            , myDir.export
#            , myParam.Name
#            , myDateTime.Name
#            , myDateTime.Format
#            , myThreshold
#            , myConfig)

## ----IHA_dataprep, eval=FALSE--------------------------------------------
#  # 1.  Get Gage Data
#  #
#  # 1.A. Use ContDataQC and Save (~1min for download)
#  myData.Operation    <- "GetGageData" #Selection.Operation[1]
#  myData.SiteID       <- "01187300" # Hubbard River near West Hartland, CT
#  myData.Type         <- "Gage"
#  myData.DateRange.Start  <- "2015-01-01"
#  myData.DateRange.End    <- "2016-12-31"
#  myDir.import <- getwd()
#  myDir.export <- getwd()
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type
#             , myData.DateRange.Start, myData.DateRange.End
#             , myDir.import, myDir.export)
#  #
#  # 1.B. Use saved data
#  myFile <- "01187300_Gage_20150101_20161231.csv"
#  myCol.DateTime <- "Date.Time"
#  myCol.Discharge <- "Discharge.ft3.s"
#  #
#  # 2. Prep Data
#  myData.IHA <- Export.IHA(myFile
#                           , fun.myCol.DateTime = myCol.DateTime
#                           , fun.myCol.Parameter = myCol.Discharge
#                           )

## ----IHA_getPkg, eval=FALSE----------------------------------------------
#  # Install Libraries (if needed)
#  install.packages("devtools")
#  library(devtools)
#  install_github("jasonelaw/IHA")
#  install.packages("XLConnect")

## ----IHA_run_ExcelSave, eval=FALSE---------------------------------------
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # 3. Run IHA
#  # Example using returned DF with IHA
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # User info
#  SiteID <- myData.SiteID
#  Notes.User <- Sys.getenv("USERNAME")
#  #~~~~~
#  # Library (load)
#  require(IHA)
#  require(XLConnect)
#  #~~~~~
#  # IHA
#  myYr <- "calendar" # "water" or "calendar"
#  # IHA Metrics
#  ## IHA parameters group 1; Magnitude of monthly water conditions
#  Analysis.Group.1 <- group1(myData.IHA, year=myYr)
#  ## IHA parameters group 2: Magnitude of monthly water condition and include 12 parameters
#  Analysis.Group.2 <- group2(myData.IHA, year=myYr)
#  Analysis.Group.3 <- group3(myData.IHA, year=myYr)
#  ## IHA parameters group 4; Frequency and duration of high and low pulses
#  # defaults to 25th and 75th percentiles
#  Analysis.Group.4 <- group4(myData.IHA, year=myYr)
#  ## IHA parameters group 5; Rate and frequency of water condition changes
#  Analysis.Group.5 <- group5(myData.IHA, year=myYr)
#  #~~~~~
#  # Save Results to Excel (each group on its own worksheet)
#  Group.Desc <- c("Magnitude of monthly water conditions"
#                  ,"Magnitude of monthly water condition and include 12 parameters"
#                  ,"Timing of annual extreme water conditions"
#                  ,"Frequency and duration of high and low pulses"
#                  ,"Rate and frequency of water condition changes")
#  df.Groups <- as.data.frame(cbind(paste0("Group",1:5),Group.Desc))
#  #
#  myDate <- format(Sys.Date(),"%Y%m%d")
#  myTime <- format(Sys.time(),"%H%M%S")
#  # Notes section (add min/max dates)
#  Notes.Names <- c("Dataset (SiteID)","IHA.Year","Analysis.Date (YYYYMMDD)","Analysis.Time (HHMMSS)","Analysis.User")
#  Notes.Data <- c(SiteID, myYr, myDate, myTime, Notes.User)
#  df.Notes <- as.data.frame(cbind(Notes.Names,Notes.Data))
#  Notes.Summary <- summary(myData.IHA)
#  # Open/Create file
#  myFile.XLSX <- paste("IHA", SiteID, myYr, myDate, myTime, "xlsx", sep=".")
#  wb <- loadWorkbook(myFile.XLSX, create = TRUE) # load workbook, create if not existing
#  # create sheets
#  createSheet(wb, name = "NOTES")
#  createSheet(wb, name = "Group1")
#  createSheet(wb, name = "Group2")
#  createSheet(wb, name = "Group3")
#  createSheet(wb, name = "Group4")
#  createSheet(wb, name = "Group5")
#  # write to worksheet
#  writeWorksheet(wb, df.Notes, sheet = "NOTES", startRow=1)
#  writeWorksheet(wb, Notes.Summary, sheet = "NOTES", startRow=10)
#  writeWorksheet(wb, df.Groups, sheet="NOTES", startRow=25)
#  writeWorksheet(wb, Analysis.Group.1, sheet = "Group1")
#  writeWorksheet(wb, Analysis.Group.2, sheet = "Group2")
#  writeWorksheet(wb, Analysis.Group.3, sheet = "Group3")
#  writeWorksheet(wb, Analysis.Group.4, sheet = "Group4")
#  writeWorksheet(wb, Analysis.Group.5, sheet = "Group5")
#  # save workbook
#  saveWorkbook(wb, myFile.XLSX)

## ----RarifyTaxa, eval=FALSE----------------------------------------------
#  # library(BioMonTools)
#  
#  # Subsample to 500 organisms (from over 500 organisms) for 12 samples.
#  
#  # load bio data
#  df_biodata <- data_bio2rarify
#  dim(df_biodata)
#  View(df_biodata)
#  
#  # subsample
#  mySize <- 500
#  Seed_OR <- 18590214
#  Seed_WA <- 18891111
#  Seed_US <- 17760704
#  bugs_mysize <- BioMonTools::rarify(inbug=df_biodata, sample.ID="SampleID"
#                       ,abund="N_Taxa",subsiz=mySize, mySeed=Seed_US)
#  
#  # view results
#  dim(bugs_mysize)
#  View(bugs_mysize)
#  
#  # Compare pre- and post- subsample counts
#  df_compare <- merge(df_biodata, bugs_mysize, by=c("SampleID", "TaxaID")
#                      , suffixes = c("_Orig","_500"))
#  df_compare <- df_compare[,c("SampleID", "TaxaID", "N_Taxa_Orig", "N_Taxa_500")]
#  View(df_compare)
#  
#  # compare totals
#  tbl_totals <- aggregate(cbind(N_Taxa_Orig, N_Taxa_500) ~ SampleID, df_compare, sum)
#  View(tbl_totals)
#  
#  ## Not run:
#  # save the data
#  write.table(bugs_mysize, paste("bugs",mySize,"txt",sep="."),sep="\t")
#  ## End(Not run)

## ----PlotDailyMeans, eval=FALSE------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data0_Original","Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  # Summary Stats
#  myData.Operation <- "SummaryStats" #Selection.Operation[4]
#  myData.SiteID    <- "test2"
#  myData.Type      <- Selection.Type[3] #"AW"
#  myData.DateRange.Start  <- "2013-01-01"
#  myData.DateRange.End    <- "2014-12-31"
#  myDir.import <- file.path(myDir.BASE,Selection.SUB[4]) #"Data3_Aggregated"
#  myDir.export <- file.path(myDir.BASE,Selection.SUB[5]) #"Data4_Stats"
#  ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, myDir.import, myDir.export)

## ----StreamThermal_dataprep, eval=FALSE----------------------------------
#  # Install Libraries (if needed)
#  install.packages("devtools")
#  library(devtools)
#  install_github("tsangyp/StreamThermal")

## ----StreamThermal_run, echo=TRUE----------------------------------------
# 1.1. Get USGS data
# code from StreamThermal T_frequency example
ExUSGSStreamTemp<-dataRetrieval::readNWISdv("01382310","00010","2011-01-01","2011-12-31"
                                            ,c("00001","00002","00003"))
sitedata<-subset(ExUSGSStreamTemp, select=c("site_no","Date","X_00010_00001","X_00010_00002","X_00010_00003"))
names(sitedata)<-c("siteID","Date","MaxT","MinT","MeanT")
knitr::kable(head(sitedata))

## ----StreamThermal_SummaryStats_Data, echo=TRUE--------------------------
# 1.2. Use Unsummarrized data
myFile <- "DATA_test2_Aw_20130101_20141231.csv"
myData <- read.csv(file.path(path.package("ContDataQC"),"extdata",myFile), stringsAsFactors=FALSE)
# Subset
Col.Keep <- c("SiteID", "Date", "Water.Temp.C")
sitedata <- myData[,Col.Keep]
sitedata <- Export.StreamThermal(myData)
# Show data table
knitr::kable(head(sitedata))

## ----StreamThermal_PeriodStats_Data, echo=TRUE---------------------------
# 1.3. Use user data that has been QCed
myData <- DATA_period_test2_Aw_20130101_20141231
sitedata <- Export.StreamThermal(myData)
knitr::kable(head(sitedata))

## ----StreamThermal_sitedata, eval=FALSE----------------------------------
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # 3. Run StreamThermal
#  # Example using returned DF with StreamThermal
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Library (load)
#  require(StreamThermal)
#  #~~~~~
#  # StreamThermal
#  ST.freq <- T_frequency(sitedata)
#  ST.mag  <- T_magnitude(sitedata)
#  ST.roc  <- T_rateofchange(sitedata)
#  ST.tim  <- T_timing(sitedata)
#  ST.var  <- T_variability(sitedata)

## ----StreamThermal_Excel, eval=FALSE-------------------------------------
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Save Results to Excel (each group on its own worksheet)
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  library(XLConnect)
#  # Descriptions
#  #
#  Desc.freq <- "Frequency metrics indicate numbers of days in months or seasons
#  that key events exceed user-defined temperatures. "
#  #
#  Desc.mag <- "Magnitude metrics characterize monthly and seasonal averages and
#  the maximum and minimum from daily temperatures as well as 3-, 7-, 14-, 21-,
#  and 30-day moving averages for mean and maximum daily temperatures."
#  #
#  Desc.roc <- "Rate of change metrics include monthly and seasonal rate of
#  change, which indicates the difference in magnitude of maximum and minimum
#  temperatures divided by number of days between these events."
#  #
#  Desc.tim <- "Timing metrics indicate Julian days of key events including
#  mean, maximum, and minimum temperatures; they also indicate Julian days of
#  mean, maximum, and minimum values over moving windows of specified size."
#  #
#  Desc.var <- "Variability metrics summarize monthly and seasonal range in
#  daily mean temperatures as well as monthly coefficient of variation of daily
#  mean, maximum, and minimum temperatures. Variability metrics also include
#  moving averages for daily ranges and moving variability in extreme
#  temperatures, calculated from differences in average high and low
#  temperatures over various time periods"
#  #
#  Group.Desc <- c(Desc.freq, Desc.mag, Desc.roc, Desc.tim, Desc.var)
#  df.Groups <- as.data.frame(cbind(c("freq","mag","roc","tim","var"),Group.Desc))
#  #
#  SiteID <- sitedata[1,1]
#  myDate <- format(Sys.Date(),"%Y%m%d")
#  myTime <- format(Sys.time(),"%H%M%S")
#  Notes.User <- Sys.getenv("USERNAME")
#  # Notes section (add min/max dates)
#  Notes.Names <- c("Dataset (SiteID)", "Analysis.Date (YYYYMMDD)"
#                   , "Analysis.Time (HHMMSS)", "Analysis.User")
#  Notes.Data <- c(SiteID, myDate, myTime, Notes.User)
#  df.Notes <- as.data.frame(cbind(Notes.Names, Notes.Data))
#  Notes.Summary <- summary(sitedata)
#  # Open/Create file
#  ## New File Name
#  myFile.XLSX <- paste("StreamThermal", SiteID, myDate, myTime, "xlsx", sep=".")
#  ## Copy over template with Metric Definitions
#  file.copy(file.path(path.package("ContDataQC"),"extdata","StreamThermal_MetricList.xlsx")
#            , myFile.XLSX)
#  ## load workbook, create if not existing
#  wb <- loadWorkbook(myFile.XLSX, create = TRUE)
#  # create sheets
#  createSheet(wb, name = "NOTES")
#  createSheet(wb, name = "freq")
#  createSheet(wb, name = "mag")
#  createSheet(wb, name = "roc")
#  createSheet(wb, name = "tim")
#  createSheet(wb, name = "var")
#  # write to worksheet
#  writeWorksheet(wb, df.Notes, sheet = "NOTES", startRow=1)
#  writeWorksheet(wb, df.Groups, sheet="NOTES", startRow=10)
#  writeWorksheet(wb, Notes.Summary, sheet = "NOTES", startRow=20)
#  writeWorksheet(wb, ST.freq, sheet = "freq")
#  writeWorksheet(wb, ST.mag, sheet = "mag")
#  writeWorksheet(wb, ST.roc, sheet = "roc")
#  writeWorksheet(wb, ST.tim, sheet = "tim")
#  writeWorksheet(wb, ST.var, sheet = "var")
#  # save workbook
#  saveWorkbook(wb, myFile.XLSX)

## ----CompSiteCDF_table, echo=FALSE---------------------------------------
library(ContDataQC)
knitr::kable(head(data_CompSiteCDF))

## ----CompSiteCDF_plot, echo=FALSE,fig.width=7, fig.height=7--------------
# fig size in inches

# Load Data
myDF <- data_CompSiteCDF
# X Label
myXlab <- "Temperature, Water (deg C)"
ParamName.xlab <- myXlab
# get code from function
data.import <- myDF
# Site Names (Columns)
  Col.Sites <- names(data.import)[!(names(data.import) %in% "Date")]
  #
  # Add columns for time periods
  # add Year, Month, Season, YearSeason (names are in config.R)
  # assume Date is POSIXct
  #
  # add time period fields
  data.import[,"Year"]   <- format(as.Date(data.import[,"Date"]),format="%Y")
  data.import[,"Month"]   <- format(as.Date(data.import[,"Date"]),format="%m")
  data.import[,"YearMonth"] <- format(as.Date(data.import[,"Date"]),format="%Y%m")
  data.import[,"MonthDay"] <- format(as.Date(data.import[,"Date"]),format="%m%d")
  
    # Remove bad date records
  data.import <- data.import[!is.na(data.import[,"Year"]),]
  
  
  # ## add Season fields
  data.import[,"Season"] <- NA
  data.import[,"Season"][as.numeric(data.import[,"MonthDay"])>=as.numeric("0101") & as.numeric(data.import[,"MonthDay"])<as.numeric("0301")] <- "Winter"
  data.import[,"Season"][as.numeric(data.import[,"MonthDay"])>=as.numeric("0301") & as.numeric(data.import[,"MonthDay"])<as.numeric("0601")] <- "Spring"
  data.import[,"Season"][as.numeric(data.import[,"MonthDay"])>=as.numeric("0601") & as.numeric(data.import[,"MonthDay"])<as.numeric("0901")] <- "Summer"
  data.import[,"Season"][as.numeric(data.import[,"MonthDay"])>=as.numeric("0901") & as.numeric(data.import[,"MonthDay"])<as.numeric("1201")] <- "Fall"
  data.import[,"Season"][as.numeric(data.import[,"MonthDay"])>=as.numeric("1201") & as.numeric(data.import[,"MonthDay"])<=as.numeric("1231")] <- "Winter"
  data.import[,"YearSeason"] <- paste(data.import[,"Year"],data.import[,"Season"],sep="")

  # rectify December as part of winter of year + 1
  mySelection <- data.import[,"Month"]=="12"
  if(sum(mySelection) != 0){##IF.sum.START
    data.import[,"YearSeason"][mySelection] <- paste(as.numeric(data.import[,"Year"])+1,data.import[,"Season"],sep="")
  }##IF.sum.END
  #
  #View(data.import)
  #
  # Color Blind Palatte
  # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
  # The palette with grey:
  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  # The palette with black:
  #cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  #
  myColors <- cbPalette #rainbow(length(Col.Sites))
  #
  # Season Names
  SeasonNames <- c("Fall", "Winter", "Spring","Summer")
  #
  #~~~~~~~~PLOT CODE~~~~~~~~~~~
  CreatePlots <- function(...) {##FUNCTION.CreatePlots.START
    # PLOT 1
    for (i in 1:length(Col.Sites)){##FOR.j.START
      # subset out NA
      data.i <- data.plot[,Col.Sites[i]]
      # different first iteration
      if (i==1) {##IF.j==1,START
        # need ylim
        myYlim.max <- 0
        for (ii in 1:length(Col.Sites)) {
          myYlim.max <- max(hist(data.plot[,Col.Sites[ii]],plot=FALSE)$density, myYlim.max)
        }
        myYlim <- c(0,myYlim.max)
        #
        hist(data.plot[,Col.Sites[i]], prob=TRUE, border="white"
             ,main=myMain, xlab=ParamName.xlab, ylab="Proportion = value"
             ,ylim=myYlim)
        box()
      }##IF.j==1.END
      # plot lines
      lines(density(data.i, na.rm=TRUE), col=myColors[i], lwd=2)
    }##FOR.j.END
    legend("topright",Col.Sites,fill=myColors)
    #
    # Plot 2
    myLWD <- 1.5
    for (j in 1:length(Col.Sites)){##FOR.i.START
      if(j==1){##IF.i==1.START
        plot(ecdf(data.plot[,Col.Sites[j]]), col=myColors[j], verticals=TRUE, lwd=myLWD, do.p=FALSE #pch=19, cex=.75 #do.p=FALSE
             #, col.01line="white"
             , main=myMain, xlab=ParamName.xlab, ylab="Proportion <= value" )
      } else {
        plot(ecdf(data.plot[,Col.Sites[j]]), col=myColors[j], verticals=TRUE, lwd=myLWD, do.p=FALSE, add=T)
      }##IF.i==1.END
    }##FOR.i.END
    legend("bottomright",Col.Sites,fill=myColors)
  }##FUNCTION.CreatePlots.END
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  # 2 plots per page
    #par(mfrow=c(1,2))
    #
    # ALL
    myMain <- "All Data"
    data.plot <- data.import
    CreatePlots()

## ----RBI-----------------------------------------------------------------
# Get Gage Data via the dataRetrieval package from USGS 01187300 2013
data.gage <- dataRetrieval::readNWISdv("03238500", "00060", "1974-10-01", "1975-09-30")
head(data.gage)
# flow data
data.Q <- data.gage[,4]
# remove zeros
data.Q[data.Q==0] <- NA
RBIcalc(data.Q)

## ----SummarStats_NonContDataQC_Data, eval=FALSE--------------------------
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Summary Stats from Other Data
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Get Data, e.g., USGS gage data
#  # Get Gage Data via the dataRetrieval package from USGS 01187300 2013 (~4 seconds)
#  data.gage <- dataRetrieval::readNWISuv("01187300", "00060", "2013-01-01", "2014-12-31")
#  head(data.gage)
#  # Rename fields
#  myNames <- c("Agency", "SiteID", "Date.Time", "Discharge.ft3.s", "Code", "TZ")
#  names(data.gage) <- myNames
#  # Add Date and Time
#  data.gage[,"Date"] <- as.Date(data.gage[,"Date.Time"])
#  data.gage[,"Time"] <-  strftime(data.gage[,"Date.Time"], format="%H:%M:%S")
#  # Add "flag" fields that are added by QC function.
#  Names.Flags <- paste0("Flag.",c("Date.Time", "Discharge.ft3.s"))
#  data.gage[,Names.Flags] <- "P"
#  # Save File
#  myFile <- "01187300_Gage_20130101_20141231.csv"
#  write.csv(data.gage, myFile, row.names=FALSE)
#  # Run Stats (File)
#  myData.Operation <- "SummaryStats"
#  myDir.import <- getwd()
#  myDir.export <- getwd()
#  ContDataQC(myData.Operation
#             , fun.myDir.import=myDir.import
#             , fun.myDir.export=myDir.export
#             , fun.myFile=myFile)

## ----formatHobo, eval=FALSE----------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB       <- c("Data0_Original", "Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE          <- getwd()
#  
#  # Create data directories
#  myDir.create <- paste0("./",Selection.SUB[1])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[2])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[3])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[4])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[5])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  
#  # Save example data (assumes directory ./Data0_Original/ exists)
#  fn_1 <- "Charlies_Air_20170726_20170926.csv"
#  fn_2 <- "Charlies_AW_20170726_20170926.csv"
#  fn_3 <- "Charlies_Water_20170726_20170926.csv"
#  fn_4 <- "ECO66G12_AW_20160128_20160418.csv"
#  lapply(c(fn_1, fn_2, fn_3, fn_4), function(x)
#         file.copy(system.file("extdata", x, package="ContDataQC")
#         , file.path(myDir.BASE, Selection.SUB[1], x)))
#  
#  # Function Inputs
#  myFiles <- c("Charlies_Air_20170726_20170926.csv"
#               , "Charlies_AW_20170726_20170926.csv"
#               , "Charlies_Water_20170726_20170926.csv")
#  myDir.import <- file.path(getwd(), "Data0_Original")
#  myDir.export <- file.path(getwd(), "Data1_RAW")
#  
#  # Run Function (with default config)
#  formatHobo(myFiles, myDir.import, myDir.export)
#  
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # QC the generated file with ContDataQC
#  myData.Operation <- "QCRaw" #Selection.Operation[2]
#  myFile <- myFiles
#  myDir.import <- file.path(".","Data1_RAW")
#  myDir.export <- file.path(".","Data2_QC")
#  myReport.format <- "html"
#  ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#            , fun.myDir.export=myDir.export, fun.myFile=myFile
#            , fun.myReport.format=myReport.format)
#  
#  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  # Example with unmodified dates
#  myFiles <- "ECO66G12_AW_20160128_20160418.csv"
#  myDir.import <- file.path(getwd(), "Data0_Original")
#  myDir.export <- file.path(getwd(), "Data1_RAW")
#  HoboDateFormat <- "MDY"
#  
#  # Run Function (with default config)
#  formatHobo(myFiles, myDir.import, myDir.export, HoboDateFormat)

