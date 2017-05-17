#' Master Script
#'
#' Calls all other functions for the ContDataQC library.
#'
#' Below are the default data directories assumed to exist in the working directory.  These can be created with code in the example.
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
#source(paste(myDir.BASE,myDir.Scripts,"fun.Stats.R",sep="/"))
#' @param fun.myData.Operation Operation to be performed; c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type; c("Air","Water","AW","Gage","AWG","AG","WG")
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.BASE Root directory for data.  If blank will use current working directory.
#' @param fun.myDir.SUB.import Subdirectory for import data.  If blank will use root directory.
#' @param fun.myDir.SUB.export Subdirectory for export data.  If blank will use root directory.
#' @param fun.myFile.Prefix Valid prefixes are "QC", "DATA", or "STATS".  This determines the RMD to use for the outpu.
#' @return Returns a csv into the specified export directory with additional columns for calculated statistics.
#' @keywords continuous data, aggregate
#' @examples
#' # Install Pandoc
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
#' myData.DateRange.Start  <- "2013-01-01"
#' myData.DateRange.End    <- "2014-12-31"
#' Selection.SUB <- c("Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#' myDir.SUB.import <- ""
#' myDir.SUB.export <- ""
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
#'
#' # Save example data (assumes directory ./Data1_RAW/ exists)
#' myData <- data_raw_test2_AW_20130426_20130725
#'   write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20130426_20130725.csv"))
#' myData <- data_raw_test2_AW_20130725_20131015
#'   write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20130725_20131015.csv"))
#' myData <- data_raw_test2_AW_20140901_20140930
#'   write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20140901_20140930.csv"))
#' myData <- data_raw_test4_AW_20160418_20160726
#'   write.csv(myData,paste0("./",Selection.SUB[1],"/test4_AW_20160418_20160726.csv"))
#'
#'
#' # Get Gage Data
#' myData.Operation    <- "GetGageData" #Selection.Operation[1]
#' myData.SiteID       <- "01187300"
#' myData.Type         <- Selection.Type[4] #"Gage"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, getwd(), "", "")
#'
#' # QC Raw Data
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myDir.SUB.import <- Selection.SUB[1] #"Data1_RAW"
#' myDir.SUB.export <- Selection.SUB[2] #"Data2_QC"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, getwd(), "", "")
#'
#' # Aggregate Data
#' myData.Operation <- "Aggregate" #Selection.Operation[3]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myDir.SUB.import <- Selection.SUB[2] #"Data2_QC"
#' myDir.SUB.export <- Selection.SUB[3] #"Data3_Aggregated"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, getwd(), "", "")
#'
#' # Summary Stats
#' myData.Operation <- "SummaryStats" #Selection.Operation[4]
#' myData.SiteID    <- "test2"
#' myData.Type      <- Selection.Type[3] #"AW"
#' myDir.SUB.import <- Selection.SUB[3] #"Data3_Aggregated"
#' myDir.SUB.export <- Selection.SUB[4] #"Data4_Stats"
#' ContDataQC(myData.Operation, myData.SiteID, myData.Type, myData.DateRange.Start, myData.DateRange.End, getwd(), "", "")
#
# Function - Master
# Run different scripts depending upon user input
#' @export
ContDataQC <- function(fun.myData.Operation
                      ,fun.myData.SiteID
                      ,fun.myData.Type
                      ,fun.myData.DateRange.Start
                      ,fun.myData.DateRange.End
                      ,fun.myDir.BASE=getwd()
                      ,fun.myDir.SUB.import=""
                      ,fun.myDir.SUB.export="")
  {##FUN.fun.Master.START
  #
  # Error checking.  If any null then kick back
  ## (add later)
  # 20160204, Check for required fields
  #   Add to individual scripts as need to load the file first
  # QC Check - delimiter in site ID
  QC.SiteID.myDelim <- grepl(ContData.env$myDelim,fun.myData.SiteID) #T/F
  if(QC.SiteID.myDelim==TRUE){##IF.QC.SiteID.myDelim.START
    myMsg <- paste("\n
              SiteID (",fun.myData.SiteID,") contains the same delimiter (",ContData.env$myDelim,") as in your file names.
              \n
              Scripts will not work properly while this is true.
              \n
              Change SiteID names so they do not include the same delimiter.
              \n
              Or change file names and the variable 'myDelim' in the script 'UserDefinedValue.R'.",sep="")
    stop(myMsg)
    #
  }##IF.QC.SiteID.myDelim.END
  #
  # 20151202, default directories
  #
  # Run different functions based on "fun.myOperation"
  if (fun.myData.Operation=="GetGageData"){##IF.fun.myOperation.START
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.1Raw}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.1Raw}
    fun.myData.Type <- "Gage"
    fun.GageData(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export)
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="QCRaw"){
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.1Raw}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.2QC}
    fun.QC(fun.myData.SiteID
           ,fun.myData.Type
           ,fun.myData.DateRange.Start
           ,fun.myData.DateRange.End
           ,fun.myDir.BASE
           ,fun.myDir.SUB.import
           ,fun.myDir.SUB.export)
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="ReportQC") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.2QC}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.2QC}
    myProcedure.Step <- "QC"
    fun.Report(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export
                 ,myProcedure.Step)
  } else if (fun.myData.Operation=="Aggregate") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.2QC}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.3Agg}
    fun.AggregateData(fun.myData.SiteID
                      ,fun.myData.Type
                      ,fun.myData.DateRange.Start
                      ,fun.myData.DateRange.End
                      ,fun.myDir.BASE
                      ,fun.myDir.SUB.import
                      ,fun.myDir.SUB.export)
  } else if (fun.myData.Operation=="ReportAggregate") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.3Agg}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.3Agg}
    myProcedure.Step <- "DATA"
    fun.Report(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export
                 ,myProcedure.Step)
  } else if (fun.myData.Operation=="SummaryStats") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=ContData.env$myName.Dir.3Agg}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=ContData.env$myName.Dir.4Stats}
    myProcedure.Step <- "STATS"
    fun.myFile.Prefix <- "DATA"
    fun.Stats(fun.myData.SiteID
              ,fun.myData.Type
              ,fun.myData.DateRange.Start
              ,fun.myData.DateRange.End
              ,fun.myDir.BASE
              ,fun.myDir.SUB.import
              ,fun.myDir.SUB.export
              ,myProcedure.Step
              ,fun.myFile.Prefix)
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









