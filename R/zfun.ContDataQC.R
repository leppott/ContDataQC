#' @title  Master Script
#'
#' @description  Calls all other functions for the ContDataQC library.
#'
#' @details Below are the default data directories assumed to exist in the working directory.  These can be created with code in the example.
#'
#' ./Data0_Original/ = Unmodified data logger files.
#'
#' ./Data1_RAW/ = Data logger files modified for use with library.  Modifications for extra rows and file and column names.
#'
#' ./Data2_QC/ = Repository for library output for QCed files.
#'
#' ./Data3_Aggregated/ = Repository for library output for aggregated (or split) files.
#'
#' ./Data4_Stats/ = Repository for library output for statistical summary files.
#'
#' It is possible to call the Aggregate file portion of the script to meld together files
#' from multiple sites (e.g., all sites in a watershed or from different depths on a lake).
#' The file will be named by the first file named with "Append_x" where "x" is the
#' number of files that were aggregated.  The purpose is to allow users to analyze the
#' data in these files from a single file.
#'
# Master Continuous Data Script
# Will prompt user for what to do
# Erik.Leppo@tetratech.com
# 20151118
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Master Functions Script that is invoked from a calling the master script
# The master will have different versions but will all call this one.
#
# Source all helper scripts
# If change location of scripts have to change here.
#myDir.Scripts <- "Scripts"
# as package don't need this section
# myFiles.Source <- paste(myDir.BASE,myDir.Scripts,c("fun.UserDefinedValues.R"
#                                                    ,"fun.DateFormat.R"
#                                                    ,"fun.Helper.R"
#                                                    ,"fun.QC.R"
#                                                    ,"fun.Report.R"
#                                                    ,"fun.AggregateData.R"
#                                                    ,"fun.GageData.R"
#                                                    ,"fun.Stats.R"
#                                                   ),sep="/")
# sapply(myFiles.Source,source,.GlobalEnv)
#
# source(paste(myDir.BASE,myDir.Scripts,"fun.UserDefinedValues.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.DateFormat.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.Helper.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.QC.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.QCReport.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.AggregateData.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.GageData.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.Stats.R",sep="/"))
#' @param fun.myData.Operation Operation to be performed; c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type; c("Air","Water","AW","Gage","AWG","AG","WG")
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
# @param fun.myDir.BASE Root directory for data.  If blank will use current working directory.
# @param fun.myDir.SUB.import Subdirectory for import data.  If blank will use root directory.
# @param fun.myDir.SUB.export Subdirectory for export data.  If blank will use root directory.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
# @param fun.myFile.Prefix Valid prefixes are "QC", "DATA", or "STATS".  This determines the RMD to use for the output.
#' @param fun.myConfig Configuration file to use for this data analysis.  The default is always loaded first so only "new" values need to be included.  This is the easiest way to control time zones.
#' @param fun.myFile Single file (or vector of files) to perform functions.  SiteID, Type, and Date Range not used when file name(s) provided.
#' @param fun.myReport.format Report format (docx or html).  Default is specified in config.R (docx).  Can be customized in config.R; ContData.env$myReport.Format.
#' @param fun.myReport.Dir Report (rmd) template folder.  Default is the package rmd folder.  Can be customized in config.R; ContData.env$myReport.Dir.
#' @param fun.CreateReport Boolean parameter to create reports or not.  Default = TRUE.
#'
#' @return Returns a csv into the specified export directory with additional columns for calculated statistics.
#'
#' @examples
#' # Install Pandoc (for docx Reports)
#' # (if using recent version of RStudio do not have to install separately)
#' install.packages("installr") # not needed if already have this package.
#' require(installr)
#' install.pandoc()
#' # The above won't work if don't have admin rights on your computer.
#' # Alternative = Download the file below and have your IT dept install for you.
#' # https://github.com/jgm/pandoc/releases/download/1.16.0.2/pandoc-1.16.0.2-windows.msi
#' # For help for installing via command window:
#' # http://www.intowindows.com/how-to-run-msi-file-as-administrator-from-command-prompt-in-windows/
#'
#'
#' # Examples of each operation
#'
#' # Parameters
#' Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#' Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#' Selection.SUB <- c("Data0_Original", "Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#' myDir.BASE <- getwd()
#'
#' # Create data directories
#' myDir.create <- paste0("./",Selection.SUB[1])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[2])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[3])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[4])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[5])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#'
#' # Save example data (assumes directory ./Data1_RAW/ exists)
#' myData <- data_raw_test2_AW_20130426_20130725
#'   write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20130426_20130725.csv"))
#' myData <- data_raw_test2_AW_20130725_20131015
#'   write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20130725_20131015.csv"))
#' myData <- data_raw_test2_AW_20140901_20140930
#'   write.csv(myData,paste0("./",Selection.SUB[2],"/test2_AW_20140901_20140930.csv"))
#' myData <- data_raw_test4_AW_20160418_20160726
#'   write.csv(myData,paste0("./",Selection.SUB[2],"/test4_AW_20160418_20160726.csv"))
#' myFile <- "config.TZ.Central.R"
#'   file.copy(file.path(path.package("ContDataQC"),"extdata",myFile)
#'             ,file.path(getwd(),Selection.SUB[2],myFile))
#'
#' # Get Gage Data
#' myData.Operation    <- "GetGageData" #Selection.Operation[1]
#' myData.SiteID       <- "01187300" # Hubbard River near West Hartland, CT
#' myData.Type         <- Selection.Type[4] #"Gage"
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' myDir.import <- ""
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[2])
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'           , myData.DateRange.End, myDir.import, myDir.export)
#'
#' # Get Gage Data (central time zone)
#' myData.Operation    <- "GetGageData" #Selection.Operation[1]
#' myData.SiteID       <- "07032000" # Mississippi River at Memphis, TN
#' myData.Type         <- Selection.Type[4] #"Gage"
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' myDir.import <- ""
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[2])
#' # include path if not in working directory
#' myConfig            <- file.path(getwd(),Selection.SUB[2],"config.TZ.central.R")
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'            , myData.DateRange.End, myDir.import, myDir.export, myConfig)
#'
#' # QC Raw Data
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' myDir.import <- file.path(myDir.BASE,Selection.SUB[2]) #"Data1_RAW"
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#' myReport.format <- "docx"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'            , myData.DateRange.End, myDir.import, myDir.export
#'            , fun.myReport.format=myReport.format)
#'
#' # QC Raw Data (offset collection times for air and water sensors)
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' myData.SiteID    <- "test4"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myData.DateRange.Start  <- "2016-04-28"
#' myData.DateRange.End    <- "2016-07-26"
#' myDir.import <- file.path(myDir.BASE,Selection.SUB[2]) #"Data1_RAW"
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#' myReport.format <- "html"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'            , myData.DateRange.End, myDir.import, myDir.export
#'            , fun.myReport.format=myReport.format)
#'
#' # Aggregate Data
#' myData.Operation <- "Aggregate" #Selection.Operation[3]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' myDir.import <- file.path(myDir.BASE,Selection.SUB[3]) #"Data2_QC"
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[4]) #"Data3_Aggregated"
#' #Leave off myReport.format and get default (docx).
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'            , myData.DateRange.End, myDir.import, myDir.export)
#'
#' # Summary Stats
#' myData.Operation <- "SummaryStats" #Selection.Operation[4]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' myDir.import <- file.path(myDir.BASE,Selection.SUB[4]) #"Data3_Aggregated"
#' myDir.export <- file.path(myDir.BASE,Selection.SUB[5]) #"Data4_Stats"
#' #Leave off myReport.format and get default (docx).
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start
#'           , myData.DateRange.End, myDir.import, myDir.export)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # File Versions
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#'
#' # QC Data
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' #myFile <- "test2_AW_20130426_20130725.csv"
#' myFile <- c("test2_AW_20130426_20130725.csv", "test2_AW_20130725_20131015.csv"
#'            , "test2_AW_20140901_20140930.csv")
#' myDir.import <- file.path(".","Data1_RAW")
#' myDir.export <- file.path(".","Data2_QC")
#' myReport.format <- "docx"
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'           , fun.myDir.export=myDir.export, fun.myFile=myFile
#'           , fun.myReport.format=myReport.format)
#'
#' # Aggregate Data
#' myData.Operation <- "Aggregate" #Selection.Operation[3]
#' myFile <- c("QC_test2_Aw_20130426_20130725.csv", "QC_test2_Aw_20130725_20131015.csv"
#'            , "QC_test2_Aw_20140901_20140930.csv")
#' myDir.import <- file.path(".","Data2_QC")
#' myDir.export <- file.path(".","Data3_Aggregated")
#' myReport.format <- "html"
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'            , fun.myDir.export=myDir.export, fun.myFile=myFile
#'            , fun.myReport.format=myReport.format)
#'
#' # Summary Stats
#' myData.Operation <- "SummaryStats" #Selection.Operation[4]
#' myFile <- "QC_test2_AW_20130426_20130725.csv"
#' #myFile <- c("QC_test2_AW_20130426_20130725.csv", "QC_test2_AW_20130725_20131015.csv"
#'             , "QC_test2_AW_20140901_20140930.csv")
#' myDir.import <- file.path(".","Data2_QC")
#' myDir.export <- file.path(".","Data4_Stats")
#' #Leave off myReport.format and get default (docx).
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'           , fun.myDir.export=myDir.export, fun.myFile=myFile)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Summary Stats from Other Data
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Get Data, e.g., USGS gage data
#' # Get Gage Data via the dataRetrieval package from USGS 01187300 2013 (~4 seconds)
#' data.gage <- dataRetrieval::readNWISuv("01187300", "00060", "2013-01-01", "2014-12-31")
#' head(data.gage)
#' # Rename fields
#' myNames <- c("Agency", "SiteID", "Date.Time", "Discharge.ft3.s", "Code", "TZ")
#' names(data.gage) <- myNames
#' # Add Date and Time
#' data.gage[,"Date"] <- as.Date(data.gage[,"Date.Time"])
#' data.gage[,"Time"] <-  strftime(data.gage[,"Date.Time"], format="%H:%M:%S")
#' # Add "flag" fields that are added by QC function.
#' Names.Flags <- paste0("Flag.",c("Date.Time", "Discharge.ft3.s"))
#' data.gage[,Names.Flags] <- "P"
#' # Save File
#' myFile <- "01187300_Gage_20130101_20141231.csv"
#' write.csv(data.gage, myFile, row.names=FALSE)
#' # Run Stats (File)
#' myData.Operation <- "SummaryStats"
#' myDir.import <- getwd()
#' myDir.export <- getwd()
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'                      , fun.myDir.export=myDir.export, fun.myFile=myFile)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Lake Data, Aggregate
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Save example data (assumes directory exists)
#' myFile <- c("QC_Ellis~1.0m_Water_20180524_20180918.csv", "QC_Ellis~3.0m_Water_20180524_20180918.csv")
#' file.copy(file.path(system.file("extdata", package="ContDataQC"), myFile)
#' , file.path(getwd(), Selection.SUB[3], myFile))
#'
#' # Aggregate Data
#' myData.Operation <- "Aggregate" #Selection.Operation[3]
#' #myFile <- c("QC_Ellis~1.0m_Water_20180524_20180918.csv", "QC_Ellis~3.0m_Water_20180524_20180918.csv")
#' myDir.import <- file.path(".","Data2_QC")
#' myDir.export <- file.path(".","Data3_Aggregated")
#' myReport.format <- "html"
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'            , fun.myDir.export=myDir.export, fun.myFile=myFile
#'            , fun.myReport.format=myReport.format)
#'
# ~~~QC~~~~
# fun.myData.Operation       <- myData.Operation
# fun.myData.SiteID          <- myData.SiteID
# fun.myData.Type            <- myData.Type
# fun.myData.DateRange.Start <- myData.DateRange.Start
# fun.myData.DateRange.End   <- myData.DateRange.End
# fun.myDir.import           <- myDir.import
# fun.myDir.export           <- myDir.export
# fun.myConfig               <- ""
# #fun.myFile                 <- ""
# fun.myFile                 <- myFile
# fun.myReport.format        <- myReport.format
# fun.myReport.Dir           <- ""
# source(file.path(getwd(), "inst", "extdata", "config.ORIG.R"))
# source(file.path(getwd(), "R", "fun.Helper.R"))
#
#' @export
ContDataQC <- function(fun.myData.Operation
                       , fun.myData.SiteID
                       , fun.myData.Type
                       , fun.myData.DateRange.Start
                       , fun.myData.DateRange.End
                       , fun.myDir.import=getwd()
                       , fun.myDir.export=getwd()
                       , fun.myConfig=""
                       , fun.myFile=""
                       , fun.myReport.format=""
                       , fun.myReport.Dir=""
                       , fun.CreateReport=TRUE) {##FUN.fun.Master.START
  # DEBUG ####
  boo_DEBUG <- FALSE
  if(boo_DEBUG==TRUE){##IF~boo_DEBUG~START
    fun.myData.Operation       <- myData.Operation
    fun.myData.SiteID          <- myData.SiteID
    fun.myData.Type            <- myData.Type
    fun.myData.DateRange.Start <- myData.DateRange.Start
    fun.myData.DateRange.End   <- myData.DateRange.End
    fun.myDir.import           <- myDir.import
    fun.myDir.export           <- myDir.export
    fun.myConfig               <- ""
    #fun.myFile                 <- ""
    fun.myFile                 <- myFile
    fun.myReport.format        <- myReport.format
    fun.myReport.Dir           <- ""
    source(file.path(getwd(), "inst", "extdata", "config.ORIG.R"))
    source(file.path(getwd(), "R", "fun.Helper.R"))
  }##IF~boo_DEBUG~END

  # config file load, 20170517
  if (fun.myConfig!="") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #
  # 20171115
  # Error Check, Report Format
  if(fun.myReport.format==""){
    fun.myReport.format <- ContData.env$myReport.Format
  }
  fun.myReport.format <- tolower(fun.myReport.format)
  #
  # 20180212
  # Error Check, Report Directory
  if(fun.myReport.Dir==""){
    fun.myReport.Dir <- ContData.env$myReport.Dir
  }
  #
  ## dont need check if using "files" version
  if(fun.myFile[1]==""){##IF.fun.myFile.START
    # Error checking.  If any null then kick back
    ## (add later)
    # 20160204, Check for required fields
    #   Add to individual scripts as need to load the file first
    # QC Check - delimiter in site ID
    if(ContData.env$myDelim==".") {##IF.myDelim.START
      # special case for regex check to follow (20170531)
      myDelim2Check <- "\\."
    } else {
      myDelim2Check <- ContData.env$myDelim
    }##IF.myDelim.END
    #
    QC.SiteID.myDelim <- grepl(myDelim2Check, fun.myData.SiteID) #T/F
    #
    if(QC.SiteID.myDelim==TRUE){##IF.QC.SiteID.myDelim.START
      #
      myMsg <- paste("\n
              SiteID (",fun.myData.SiteID,") contains the same delimiter (",ContData.env$myDelim,") as in your file names.
              \n
              Scripts will not work properly while this is true.
              \n
              Change SiteID names so they do not include the same delimiter.
              \n
              Or change file names and the variable 'myDelim' in the configuration script 'config.R' (or in the file specified by the user).",sep="")
      stop(myMsg)
      #
    }##IF.QC.SiteID.myDelim.END
  }##IF.fun.myFile.END
  #
  # 20151202, default directories
  ## Run different functions if fun.myFile is provided (20170607)
  #
  # Run different functions based on "fun.myOperation"
  if (fun.myData.Operation=="GetGageData"){##IF.fun.myOperation.START
    # Gage ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.1Raw}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.1Raw}
    fun.myData.Type <- "Gage"
    # does not need import directory so one less input than the others
    fun.GageData(fun.myData.SiteID
                 , fun.myData.Type
                 , fun.myData.DateRange.Start
                 , fun.myData.DateRange.End
                 , fun.myDir.export)
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="QCRaw"){
    # QCRaw ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.1Raw}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.2QC}
    if(fun.myFile[1]==""){##IF.fun.myFile.START
      #normal version
      fun.QC(fun.myData.SiteID
             , fun.myData.Type
             , fun.myData.DateRange.Start
             , fun.myData.DateRange.End
             , fun.myDir.import
             , fun.myDir.export
             , fun.myReport.format
             , fun.myReport.Dir
             , fun.CreateReport)
    }  else {
      #file version
      fun.QC.File(fun.myFile
                  , fun.myDir.import
                  , fun.myDir.export
                  , fun.myReport.format
                  , fun.myReport.Dir
                  , fun.CreateReport)
    }##IF.fun.myFile.END
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="ReportQC") {
    # ReportQC ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.2QC}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.2QC}
    myProcedure.Step <- "QC"
    if(fun.myFile[1]==""){##IF.fun.myFile.START
      #normal version
      fun.Report(fun.myData.SiteID
                 , fun.myData.Type
                 , fun.myData.DateRange.Start
                 , fun.myData.DateRange.End
                 , fun.myDir.import
                 , fun.myDir.export
                 , myProcedure.Step
                 , fun.myReport.format
                 , fun.myReport.Dir)
    } else {
      #file version
      fun.Report.File(fun.myFile
                      , fun.myDir.export
                      , fun.myDir.export
                      , myProcedure.Step
                      , fun.myReport.format
                      , fun.myReport.Dir)
    }##IF.fun.myFile.END
    #
  } else if (fun.myData.Operation=="Aggregate") {
    # Aggregate ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.2QC}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.3Agg}
    if(fun.myFile[1]==""){##IF.fun.myFile.START
      #normal version
      fun.AggregateData(fun.myData.SiteID
                        , fun.myData.Type
                        , fun.myData.DateRange.Start
                        , fun.myData.DateRange.End
                        , fun.myDir.import
                        , fun.myDir.export
                        , fun.myReport.format
                        , fun.myReport.Dir
                        , fun.CreateReport)
    } else {
      #file version
      fun.AggregateData.File(fun.myFile
                             , fun.myDir.import
                             , fun.myDir.export
                             , fun.myReport.format
                             , fun.myReport.Dir
                             , fun.CreateReport)
    }##IF.fun.myFile.END
    #
  } else if (fun.myData.Operation=="ReportAggregate") {
    # ReportAggregate ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.3Agg}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.3Agg}
    myProcedure.Step <- "DATA"
    if(fun.myFile[1]==""){##IF.fun.myFile.START
      #normal version
      fun.Report(fun.myData.SiteID
                 , fun.myData.Type
                 , fun.myData.DateRange.Start
                 , fun.myData.DateRange.End
                 , fun.myDir.import
                 , fun.myDir.export
                 , myProcedure.Step
                 , fun.myReport.format
                 , fun.myReport.Dir)
    } else {
      #file version
      fun.Report.File(fun.myFile
                      , fun.myDir.export
                      , fun.myDir.export
                      , myProcedure.Step
                      , fun.myReport.format
                      , fun.myReport.Dir)
    }##IF.fun.myFile.END
    #
  } else if (fun.myData.Operation=="SummaryStats") {
    # SummaryStats ####
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.3Agg}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.4Stats}
    myProcedure.Step <- "STATS"
    fun.myFile.Prefix <- "DATA"
    if(fun.myFile[1]==""){##IF.fun.myFile.START
      #normal version
      fun.Stats(fun.myData.SiteID
                , fun.myData.Type
                , fun.myData.DateRange.Start
                , fun.myData.DateRange.End
                , fun.myDir.import
                , fun.myDir.export
                , myProcedure.Step
                , fun.myFile.Prefix
                , fun.myReport.format
                , fun.myReport.Dir)
    } else {
      #file version
      fun.Stats.File(fun.myFile
                     , fun.myDir.import
                     , fun.myDir.export
                     , fun.myReport.format
                     , fun.myReport.Dir)
    }##IF.fun.myFile.END
    #
  } else {
    myMsg <- "No operation provided."
    stop(myMsg)
  }##IF.fun.myOperation.END
  #
}##FUN.fun.Master.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# fun.myData.SiteID <- myData.SiteID
# fun.myData.Type <- myData.Type
# fun.myData.DateRange.Start <- myData.DateRange.Start
# fun.myData.DateRange.End <- myData.DateRange.End
# fun.myDir.BASE <- myDir.BASE
# fun.myDir.SUB.import <- myDir.SUB.import
# fun.myDir.SUB.export <- myDir.SUB.export
#
# rm(myData.SiteID)
# rm(myData.Type)
# rm(myData.DateRange.Start)
# rm(myData.DateRange.End)
# rm(myDir.SUB.import)
# rm(myDir.SUB.export)









