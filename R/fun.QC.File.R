#' Quality Control, File
#'
#' Subfunction for performing QC.  Needs to be called from ContDataQC().
#' Requires zoo().
#' The 'file' version works on a single (or vector) of files.
#
# Sourced Routine
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Quality Control (auto)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# make user script smaller and easier to understand
# not a true function, needs defined variables in calling script
# if change variable names in either file have to update the other
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20150921 (20151021, make into self standing function)
# 20151112, combine Auto and Manual QC
# 20170323, added 3 parameters (Cond, DO, and pH)
# 20170324, added 2 more parameters (Turbidity and Chlrophylla)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# assumes use of CSV.  If using TXT have to modify list.files(pattern), read.csv(), and write.csv()
#
# Basic Operations:
# load all files in data directory
# perform QC
# write QC report
# save QCed data file
#
# 20160208
# SensorDepth - Gross is only negative, Flat = remove
# 20160303
# Rolling SD.  Use "zoo" and rollapply.  Loop too slow for large/dense data sets.
# (will crash if less than 5 records so added "stop")
#
# library (load any required helper functions)
#library(zoo)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.myFile Single (or vector of) file name(s).
#' @param fun.myDir.import Directory for import data.
#' Default is current working directory.
#' @param fun.myDir.export Directory for export data.
#' Default is current working directory.
#' @param fun.myReport.format Report format (docx or html).
#' Default is specified in config.R (docx).Can be customized in config.R;
#' ContData.env$myReport.Format.
#' @param fun.myReport.Dir Report (rmd) template folder.
#' Default is the package rmd folder.  Can be customized in config.R;
#' ContData.env$myReport.Dir.
#' @param fun.CreateReport Boolean parameter to create reports or not.
#' Default = TRUE.
#' @param fun.AddDeployCol Boolean for adding column name.  Default = FALSE.
#' Can be customized in config.R; ContData.env$myName.LoggerDeployment.
#'
#' @return Returns a csv file to specified directory with QC flags.
#'
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#' myFile <- "test2_AW_20130426_20130725.csv"
#' #myFile <- c("test2_AW_20130426_20130725.csv"
#' #             , "test2_AW_20130725_20131015.csv"
#' #             , "test2_AW_20140901_20140930.csv")
#' myDir.import <- file.path(getwd(),"Data1_RAW")
#' myDir.export <- file.path(getwd(),"Data2_QC")
#' fun.QC.File(myFile, myDir.import, myDir.export)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
#QC
# library(ContDataQC)
# source(file.path(getwd(),"R","config.R"))
# source(file.path(getwd(),"R","fun.Helper.R"))
# source(file.path(getwd(),"R","fun.QC.R"))
# #
# myFile <- c("test2_AW_20130426_20130725.csv"
#              , "QC_test2_AW_20130725_20131015.csv"
#              , "QC_test2_AW_20140901_20140930.csv")
# myDir.import <- file.path(getwd(),"Data1_RAW")
# myDir.export <- file.path(getwd(),"Data2_QC")
# #
# fun.myFile <- myFile
# fun.myDir.import <- myDir.import
# fun.myDir.export <- myDir.export
# #
# fun.QC.File(myFile, myDir.import, myDir.export)
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~
#'@export
fun.QC.File <- function(fun.myFile
                       , fun.myDir.import = getwd()
                       , fun.myDir.export = getwd()
                       , fun.myReport.format
                       , fun.myReport.Dir
                       , fun.CreateReport = TRUE
                       , fun.AddDeployCol = FALSE
                       ) {##FUN.fun.QC.START
  boo_DEBUG <- FALSE
  #
  # # A. Data Prep ####
  # # Convert Data Type to proper case
  # fun.myData.Type <- paste(toupper(substring(fun.myData.Type,1,1))
  #       ,tolower(substring(fun.myData.Type,2,nchar(fun.myData.Type))),sep="")
  # #
  # data directories
  # myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="",""
  #      ,paste("/",fun.myDir.SUB.import,sep="")),sep="")
  # myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="",""
  #      ,paste("/",fun.myDir.SUB.export,sep="")),sep="")
  myDir.data.import <- fun.myDir.import
  myDir.data.export <- fun.myDir.export
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # # Verify input dates, if blank, NA, or null use all data
  # # if DateRange.Start is null or "" then assign it 1900-01-01
  # if (is.na(fun.myData.DateRange.Start)==TRUE||fun.myData.DateRange.Start==""){
  # fun.myData.DateRange.Start<-ContData.env$DateRange.Start.Default}
  # # if DateRange.End is null or "" then assign it today
  # if (is.na(fun.myData.DateRange.End)==TRUE||fun.myData.DateRange.End==""){
  # fun.myData.DateRange.End<-ContData.env$DateRange.End.Default}
  #
  # Read in list of files to work on, uses all files matching pattern
  #    ("\\.csv$")
  # ## if change formats will have to make modifications
  #    (pattern, import, export)
  # files2process = list.files(path=myDir.data.import, pattern=" *.csv")
  # head(files2process)
  files2process <- fun.myFile
  utils::head(files2process)
  #
  # Define Counters for the Loop
  intCounter <- 0
  intCounter.Stop <- length(files2process)
  intItems.Total <- intCounter.Stop
  print(paste("Total files to process = ",intItems.Total,sep=""))
  utils::flush.console()
  myItems.Complete  <- 0
  myItems.Skipped   <- 0
  # myFileTypeNum.Air <- 0
  # myFileTypeNum.Water <- 0
  #
  # Create Log file
  ##  List of all items (files)
  myItems.ALL <- as.vector(unique(files2process))
  # create log file for processing results of items
  #myItems.Log <- data.frame(cbind(myItems.ALL,NA),stringsAsFactors=FALSE)
  myItems.Log <- data.frame(ItemID = seq_len(intItems.Total)
                            , Status=NA
                            , ItemName=myItems.ALL)
  #

  # Error if no files to process or no files in dir

  # Start Time (used to determine run time at end)
  myTime.Start <- Sys.time()
  #
  # B. While Loop ####
  # Perform a data manipulation on the data as a new file
  # Could use for (n in files2process) but prefer the control of a counter
  while (intCounter < intCounter.Stop)
  {##while.START
    #
    # B.0. Increase the Counter
    intCounter <- intCounter+1
    #
    # B.1.0. File Name, Define
    strFile <- files2process[intCounter]
    strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))

    #QC, make sure file exists
    if(strFile %in% list.files(path=myDir.data.import)==FALSE) {##IF.file.START
      #
      print("ERROR; no such file exits.  Cannot QC the data.")
      print(paste("PATH = ",myDir.data.import,sep=""))
      print(paste("FILE = ",strFile,sep=""))
      utils::flush.console()
      #
      # maybe print similar files
      #
      stop("Bad file.")
      #
    }##IF.file.END

    # # 1.1. File Name, Parse
    # # QC Check - delimiter for strsplit
    # if(ContData.env$myDelim==".") {##IF.myDelim.START
    #   # special case for regex check to follow (20170531)
    #   myDelim.strsplit <- "\\."
    # } else {
    #   myDelim.strsplit <- ContData.env$myDelim
    # }##IF.myDelim.END
    # strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
    # strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)
    # strFile.SiteID     <- strFile.parts[[1]][1]
    # strFile.DataType   <- strFile.parts[[1]][2]
    # # Convert Data Type to proper case
    # strFile.DataType <- paste(toupper(substring(strFile.DataType,1,1))
    #   ,tolower(substring(strFile.DataType,2,nchar(strFile.DataType))),sep="")
    # strFile.Date.Start <- as.Date(strFile.parts[[1]][3],"%Y%m%d")
    # strFile.Date.End   <- as.Date(strFile.parts[[1]][4],"%Y%m%d")
    #
    # B.2. Check File and skip if doesn't match user defined parameters
    # B.2.1. Check File Size
    #if(file.info(paste(myDir.data.import,"/",strFile,sep=""))$size==0){
    if(file.info(file.path(myDir.data.import,strFile))$size==0){
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (file blank)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    # # B.2.2. Check SiteID
    # # if not in provided site list then skip
    # if(strFile.SiteID %in% fun.myData.SiteID == FALSE) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, SiteID)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #     utils::flush.console()
    #   # go to next Item
    #   next
    # }
    # # B.2.3. Check DataType
    # # if not equal go to next file (handles both Air and Water)
    # if (strFile.DataType %in% fun.myData.Type == FALSE){
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, DataType)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #     utils::flush.console()
    #   # go to next Item
    #   next
    # }
    # # B.2.4. Check Dates
    # # B.2.4.2.1. Check File.Date.Start (if file end < my Start then next)
    # if(strFile.Date.End<fun.myData.DateRange.Start) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, Start Date)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #     utils::flush.console()
    #   # go to next Item
    #   next
    # }
    # # B.2.4.2.2. Check File.Date.End (if file Start > my End then next)
    # if(strFile.Date.Start>fun.myData.DateRange.End) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, End Date)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #     utils::flush.console()
    #   # go to next Item
    #   next
    # }
    #
    # B.3.0. Import the data
    #data.import=read.table(strFile,header=F,varSep)
    #varSep = "\t" (use read.delim instead of read.table)
    # as.is = T so dates come in as text rather than factor
    #data.import <- utils::read.delim(strFile,as.is=TRUE,na.strings=c("","NA"))
    data.import <- utils::read.csv(file.path(myDir.data.import,strFile)
                                   ,as.is=TRUE
                                   ,na.strings=c("","NA"))
    #
    # QC required fields: SiteID & (DateTime | (Date & Time))
    fun.QC.ReqFlds(names(data.import),file.path(myDir.data.import,strFile))
    #
    # B.4.0. Columns
    # Kick out if missing minimum of fields
    #
    # Check for and add any missing columns (but not for missing data fields)
    # B.4.1. Date, Time, DateTime
    # list
    strCol.DT <- c(ContData.env$myName.Date
                   ,ContData.env$myName.Time,
                   ContData.env$myName.DateTime)
    # check for missing
    strCol.DT.Missing <- strCol.DT[strCol.DT %in% colnames(data.import)==FALSE]
    # go to next item if no date, time, or date/time field
    if(length(strCol.DT.Missing)==3) {
      myMsg <- "SKIPPED (Missing Fields, Date/Time)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    # go to next item if no (date or time) AND no date/time field
    #   (i.e., only 1 of date or time)
    if(length(strCol.DT.Missing)==2 &
       ContData.env$myName.DateTime %in% strCol.DT.Missing==TRUE) {
      myMsg <- "SKIPPED (Missing Fields, 'Date.Time' and one of 'Date' or 'Time')"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    #
    # add to df
    data.import[,strCol.DT.Missing] <- NA
    #
    # B.4.2.  Check for columns present and reorder columns
    # check for columns present
    strCol.Present <- ContData.env$myNames.Order[ContData.env$myNames.Order %in%
                                                   colnames(data.import)==TRUE]
    #
    myNames.DataFields.Present <- ContData.env$myNames.DataFields[
               ContData.env$myNames.DataFields %in% colnames(data.import)==TRUE]
    # kick out if no data fields
    if(length(myNames.DataFields.Present)==0){
      myMsg <- "SKIPPED (Missing Fields, DATA)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
    }

    # QC, LoggerDeploy, Add Column ----
    # if TRUE add default
    # if FALSE do nothing
    # for TRUE and character add the name to strCol.Present
    if (fun.AddDeployCol == TRUE) {
      data.import[, ContData.env$myName.LoggerDeployment] <- NA
      strCol.Present <- c(strCol.Present, ContData.env$myName.LoggerDeployment)
      # populate first and last row with start and end
      ## first and last non-NA value
      ### was "1" and nrow(data.import)
      DT_nonNA <- which(!is.na(data.import[, ContData.env$myName.DateTime]))
      DT_nonNA_first_rowid <- DT_nonNA[1]
      DT_nonNA_last_rowid  <- DT_nonNA[length(DT_nonNA)]
      ## Add
      data.import[DT_nonNA_first_rowid, ContData.env$myName.LoggerDeployment] <-
        ContData.env$myName.LoggerDeployment.start
      data.import[DT_nonNA_last_rowid, ContData.env$myName.LoggerDeployment] <-
        ContData.env$myName.LoggerDeployment.end
    } ## IF ~ fun.AddDeployCol ~ END

    #
    # reorder Columns (and drop extra columns)
    data.import <- data.import[,strCol.Present]
    # B.4.3. Add FLAGS
    strCol.Flags <- ContData.env$myNames.Flags[ContData.env$myNames.Cols4Flags
                                               %in% colnames(data.import)==TRUE]
    data.import[,strCol.Flags] <- ""
    #
    #
    # data columns for flags that are present (need for later)
    #myNames.Cols4Flags.Present <- myNames.Cols4Flags[myNames.Cols4Flags
    #    %in% colnames(data.import)==TRUE]
    #
    #
    #
    # B.5.  QC Date and Time fields ####
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # may have to tinker with for NA fields
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # get format - if all data NA then get an error
    #
    # backfill first?
    #
    # may have to add date and time (data) from above when add the missing field.
    #if does not exists then add field and data.
    #
    # if entire field is NA then fill from other fields
    # Date
    myField   <- ContData.env$myName.Date
    data.import[,myField][all(is.na(data.import[,myField]))] <- data.import[
      ,ContData.env$myName.DateTime]
    # Time
    myField   <- ContData.env$myName.Time
    data.import[,myField][all(is.na(data.import[,myField]))] <- data.import[
      ,ContData.env$myName.DateTime]
    # DateTime
    #myField   <- myName.DateTime
    # can't fill fill from others without knowing the format
    #
    # get current file date/time records so can set format
    # Function below gets date or time format and returns R format
    # date_time is split and then pasted together.
    # if no AM/PM then 24hr time is assumed
    format.Date     <- fun.DateTimeFormat(data.import[
      ,ContData.env$myName.Date],"Date")
    format.Time     <- fun.DateTimeFormat(data.import[
      ,ContData.env$myName.Time],"Time")
    #format.DateTime <- fun.DateTimeFormat(data.import[
    #    ,ContData.env$myName.DateTime],"DateTime")
    # get error if field is NA, need to fix
    # same for section below
    #
    # 20160322, new section, check for NA and fill if needed
    if (length(stats::na.omit(data.import[,ContData.env$myName.DateTime]))==0){
      # move 5.2.1 up here
      myField   <- ContData.env$myName.DateTime
      myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
      #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(data.import[,myName.Date][data.import[,myField]==""]
      #                                                                       ,data.import[,myName.Time][data.import[,myField]==""],sep="")
      #                                                                 ,format=myFormat,usetz=FALSE)
      data.import[,myField][is.na(data.import[,myField])] <- strftime(paste(data.import[,ContData.env$myName.Date][is.na(data.import[,myField])]
                                                                            ,data.import[,ContData.env$myName.Time][is.na(data.import[,myField])]
                                                                            ,sep=" ")
                                                                      ,format=myFormat,usetz=FALSE)
    }##IF.DateTime==NA.START
    format.DateTime <- fun.DateTimeFormat(data.import[,ContData.env$myName.DateTime],"DateTime")
    #
    # QC
    #  # format.Date <- "%Y-%m-%d"
    #   format.Time <- "%H:%M:%S"
    #   format.DateTime <- "%Y-%m-%d %H:%M"
    #
    # B.5. QC Date and Time
    # 5.1. Convert all Date_Time, Date, and Time formats to expected format (ISO 8601)
    # Should allow for users to use different time and date formats in original data
    # almost worked
    #data.import[!(is.na(data.import[,myName.DateTime])),][myName.DateTime] <- strftime(data.import[!(is.na(data.import[,myName.DateTime])),][myName.DateTime]
    #                                                                                   ,format="%Y-%m-%d")
    # have to do where is NOT NA because will fail if the first item is NA
    # assume all records have the same format.
    #
    # B.5.1.1. Update Date to "%Y-%m-%d" (equivalent to %F)
    myField   <- ContData.env$myName.Date
    myFormat.In  <- format.Date #"%Y-%m-%d"
    myFormat.Out <- ContData.env$myFormat.Date #"%Y-%m-%d"
    data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    # B.5.1.2. Update Time to "%H:%M:%S" (equivalent to %T) (uses different function)
    myField   <- ContData.env$myName.Time
    myFormat.In  <- format.Time #"%H:%M:%S"
    myFormat.Out <- ContData.env$myFormat.Time #"%H:%M:%S"
    data.import[,myField][!is.na(data.import[,myField])] <- format(as.POSIXct(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    # B.5.1.3. Update DateTime to "%Y-%m-%d %H:%M:%S" (equivalent to %F %T)
    myField   <- ContData.env$myName.DateTime
    myFormat.In  <- format.DateTime #"%Y-%m-%d %H:%M:%S"
    myFormat.Out <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    #   # strptime adds the timezome but drops it when added back to data.import (using format)
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #   # doesn't work anymore, worked when first line was NA
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #   data.import <- y
    #   x<-data.import[,myField][!is.na(data.import[,myField])]
    #   (z<-x[2])
    #   (a <- strptime(z,format=myFormat.In))
    #   (b <- strptime(x,format=myFormat.In))
    #   # works on single record but fails on vector with strftime
    #   # strptime works but adds time zone (don't like but it works)
    #
    #
    # B.5.2. Update DateTime, Date, and Time if NA based on other fields
    # B.5.2.1. Update Date_Time if NA (use Date and Time)
    myField   <- ContData.env$myName.DateTime
    myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(data.import[,myName.Date][data.import[,myField]==""]
    #                                                                       ,data.import[,myName.Time][data.import[,myField]==""],sep="")
    #                                                                 ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- strftime(paste(data.import[,ContData.env$myName.Date][is.na(data.import[,myField])]
                                                                          ,data.import[,ContData.env$myName.Time][is.na(data.import[,myField])]
                                                                          ,sep=" ")
                                                                    ,format=myFormat,usetz=FALSE)
    # B.5.2.2. Update Date if NA (use Date_Time)
    myField   <- ContData.env$myName.Date
    myFormat  <- ContData.env$myFormat.Date #"%Y-%m-%d"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Date]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- strftime(data.import[,ContData.env$myName.DateTime][is.na(data.import[,myField])]
                                                                    ,format=myFormat,usetz=FALSE)
    # B.5.2.3. Update Time if NA (use Date_Time)
    myField   <- ContData.env$myName.Time
    myFormat  <- ContData.env$myFormat.Time #"%H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Time]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- as.POSIXct(data.import[,ContData.env$myName.DateTime][is.na(data.import[,myField])]
                                                                      ,format=myFormat,usetz=FALSE)
    #
    # old code just for reference
    # B.5.5. Force Date and Time format
    #   data.import[,myName.Date] <- strftime(data.import[,myName.Date],format="%Y-%m-%d")
    #   data.import[,myName.Time] <- as.POSIXct(data.import[,myName.Time],format="%H:%M:%S")
    #   data.import[,myName.DateTime] <- strftime(data.import[,myName.DateTime],format="%Y-%m-%d %H:%M:%S")
    #
    #
    # Create Month and Day Fields
    # month
#     myField   <- "month"
#     data.import[,myField] <- data.import[,myName.Date]
#     myFormat  <- "%m"
#     data.import[,myField][!is.na(data.import[,myName.Date])] <- strftime(data.import[,myName.Date][!is.na(data.import[,myName.DateTime])]
#                                                                     ,format=myFormat,usetz=FALSE)
    data.import[,ContData.env$myName.Mo] <- as.POSIXlt(data.import[,ContData.env$myName.Date])$mon+1
    # day
#     myField   <- "day"
#     data.import[,myField] <- data.import[,myName.Date]
#     myFormat.In  <- myFormat.Date #"%Y-%m-%d"
#     myFormat.Out <- "%d"
#     data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
#                                                                    ,format=myFormat.Out)
    data.import[,ContData.env$myName.Day] <- as.POSIXlt(data.import[,ContData.env$myName.Date])$mday

    # year
    data.import[,ContData.env$myName.Yr] <- as.POSIXlt(data.import[,ContData.env$myName.Date])$year+1900

    # MonthDay (2021-01-27)
    data.import[,ContData.env$myName.MoDa] <- paste0(
      sprintf("%02d", data.import[,ContData.env$myName.Mo])
      , sprintf("%02d", data.import[,ContData.env$myName.Day]))

    #
#     # example of classes for POSIXlt
#     Sys.time()
#     unclass(as.POSIXlt(Sys.time()))
#     ?DateTimeClasses

    # 2020-12-21, Keep only 1st entry on duplicate date.time
    # fall for Daylight Savings Time
    data.import <- fun.DateTime.GroupBy.First(data.import)

    # QC, LoggerDeploy, Recheck last row ----
    # DST fix above can remove it
    # 2021-01-21
    if (fun.AddDeployCol == TRUE) {
      ## first and last non-NA value
      ### was "1" and nrow(data.import)
      DT_nonNA <- which(!is.na(data.import[, ContData.env$myName.DateTime]))
      DT_nonNA_first_rowid <- DT_nonNA[1]
      DT_nonNA_last_rowid  <- DT_nonNA[length(DT_nonNA)]
      # Add
      data.import[DT_nonNA_last_rowid, ContData.env$myName.LoggerDeployment] <-
        ContData.env$myName.LoggerDeployment.end
    } ## IF ~ fun.AddDeployCol ~ END

    # B.6. QC for each Data Type present ####
    # sub routine adds QC Calcs, QC Test Flags, Assigns overall Flag, and removes QC Calc Fields
    # cycle each data type (manually code)
    #
    # skip if not present
    # 20170512, move message inside of IF so user doesn't see it.
    #
    # _B.6.01. WaterTemp----
    myField <- ContData.env$myName.WaterTemp
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "WaterTemp"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.WaterTemp
                                       ,ContData.env$myThresh.Gross.Fail.Lo.WaterTemp
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp
                                       ,ContData.env$myThresh.Spike.Hi.WaterTemp
                                       ,ContData.env$myThresh.Spike.Lo.WaterTemp
                                       ,ContData.env$myThresh.RoC.SD.period.WaterTemp
                                       ,ContData.env$myThresh.RoC.SD.number.WaterTemp
                                       ,ContData.env$myThresh.Flat.Hi.WaterTemp
                                       ,ContData.env$myThresh.Flat.Lo.WaterTemp
                                       ,ContData.env$myThresh.Flat.Tolerance.WaterTemp)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.02. AirTemp----
    myField <- ContData.env$myName.AirTemp
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "AirTemp"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.AirTemp
                                       ,ContData.env$myThresh.Gross.Fail.Lo.AirTemp
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.AirTemp
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.AirTemp
                                       ,ContData.env$myThresh.Spike.Hi.AirTemp
                                       ,ContData.env$myThresh.Spike.Lo.AirTemp
                                       ,ContData.env$myThresh.RoC.SD.period.AirTemp
                                       ,ContData.env$myThresh.RoC.SD.number.AirTemp
                                       ,ContData.env$myThresh.Flat.Hi.AirTemp
                                       ,ContData.env$myThresh.Flat.Lo.AirTemp
                                       ,ContData.env$myThresh.Flat.Tolerance.AirTemp)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.03. WaterP----
    myField <- ContData.env$myName.WaterP
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "WaterP"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.WaterP
                                       ,ContData.env$myThresh.Gross.Fail.Lo.WaterP
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.WaterP
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.WaterP
                                       ,ContData.env$myThresh.Spike.Hi.WaterP
                                       ,ContData.env$myThresh.Spike.Lo.WaterP
                                       ,ContData.env$myThresh.RoC.SD.period.WaterP
                                       ,ContData.env$myThresh.RoC.SD.number.WaterP
                                       ,ContData.env$myThresh.Flat.Hi.WaterP
                                       ,ContData.env$myThresh.Flat.Lo.WaterP
                                       ,ContData.env$myThresh.Flat.Tolerance.WaterP)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.04. AirP----
    myField <- ContData.env$myName.AirBP
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "AirP"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.AirBP
                                       ,ContData.env$myThresh.Gross.Fail.Lo.AirBP
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.AirBP
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.AirBP
                                       ,ContData.env$myThresh.Spike.Hi.AirBP
                                       ,ContData.env$myThresh.Spike.Lo.AirBP
                                       ,ContData.env$myThresh.RoC.SD.period.AirBP
                                       ,ContData.env$myThresh.RoC.SD.number.AirBP
                                       ,ContData.env$myThresh.Flat.Hi.AirBP
                                       ,ContData.env$myThresh.Flat.Lo.AirBP
                                       ,ContData.env$myThresh.Flat.Tolerance.AirBP)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.05. SensorDepth----
    myField <- ContData.env$myName.SensorDepth
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "SensorDepth"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.SensorDepth
                                       ,ContData.env$myThresh.Gross.Fail.Lo.SensorDepth
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.SensorDepth
                                       ,ContData.env$myThresh.Spike.Hi.SensorDepth
                                       ,ContData.env$myThresh.Spike.Lo.SensorDepth
                                       ,ContData.env$myThresh.RoC.SD.period.SensorDepth
                                       ,ContData.env$myThresh.RoC.SD.number.SensorDepth
                                       ,ContData.env$myThresh.Flat.Hi.SensorDepth
                                       ,ContData.env$myThresh.Flat.Lo.SensorDepth
                                       ,ContData.env$myThresh.Flat.Tolerance.SensorDepth)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.06. Discharge----
    myField <- ContData.env$myName.Discharge
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "Discharge"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.Discharge
                                       ,ContData.env$myThresh.Gross.Fail.Lo.Discharge
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.Discharge
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.Discharge
                                       ,ContData.env$myThresh.Spike.Hi.Discharge
                                       ,ContData.env$myThresh.Spike.Lo.Discharge
                                       ,ContData.env$myThresh.RoC.SD.period.Discharge
                                       ,ContData.env$myThresh.RoC.SD.number.Discharge
                                       ,ContData.env$myThresh.Flat.Hi.Discharge
                                       ,ContData.env$myThresh.Flat.Lo.Discharge
                                       ,ContData.env$myThresh.Flat.Tolerance.Discharge)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
      #
    # _B.6.07. Conductivity----
    myField <- ContData.env$myName.Cond
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "Cond"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.Cond
                                       ,ContData.env$myThresh.Gross.Fail.Lo.Cond
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.Cond
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.Cond
                                       ,ContData.env$myThresh.Spike.Hi.Cond
                                       ,ContData.env$myThresh.Spike.Lo.Cond
                                       ,ContData.env$myThresh.RoC.SD.period.Cond
                                       ,ContData.env$myThresh.RoC.SD.number.Cond
                                       ,ContData.env$myThresh.Flat.Hi.Cond
                                       ,ContData.env$myThresh.Flat.Lo.Cond
                                       ,ContData.env$myThresh.Flat.Tolerance.Cond)
      }## IF ~ all(is.na())
      #
    }##IF.myField.END
    #
    # _B.6.08. Dissolved Oxygen, mg/L ----
    myField <- ContData.env$myName.DO
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "DO, mg/L"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.DO
                                       ,ContData.env$myThresh.Gross.Fail.Lo.DO
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.DO
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.DO
                                       ,ContData.env$myThresh.Spike.Hi.DO
                                       ,ContData.env$myThresh.Spike.Lo.DO
                                       ,ContData.env$myThresh.RoC.SD.period.DO
                                       ,ContData.env$myThresh.RoC.SD.number.DO
                                       ,ContData.env$myThresh.Flat.Hi.DO
                                       ,ContData.env$myThresh.Flat.Lo.DO
                                       ,ContData.env$myThresh.Flat.Tolerance.DO)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.09. Dissolved Oxygen, adjusted----
    myField <- ContData.env$myName.DO.adj
    if(myField %in% myNames.DataFields.Present==TRUE){
      #
      myMsg.data <- "DO, adj"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.DO.adj
                                       ,ContData.env$myThresh.Gross.Fail.Lo.DO.adj
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.DO.adj
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.DO.adj
                                       ,ContData.env$myThresh.Spike.Hi.DO.adj
                                       ,ContData.env$myThresh.Spike.Lo.DO.adj
                                       ,ContData.env$myThresh.RoC.SD.period.DO.adj
                                       ,ContData.env$myThresh.RoC.SD.number.DO.adj
                                       ,ContData.env$myThresh.Flat.Hi.DO.adj
                                       ,ContData.env$myThresh.Flat.Lo.DO.adj
                                       ,ContData.env$myThresh.Flat.Tolerance.DO.adj)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.10. Dissolved Oxygen, pct sat----
    myField <- ContData.env$myName.DO.pctsat
    if(myField %in% myNames.DataFields.Present==TRUE){
      #
      myMsg.data <- "DO, pct sat"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.DO.pctsat
                                       ,ContData.env$myThresh.Gross.Fail.Lo.DO.pctsat
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.DO.pctsat
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.DO.pctsat
                                       ,ContData.env$myThresh.Spike.Hi.DO.pctsat
                                       ,ContData.env$myThresh.Spike.Lo.DO.pctsat
                                       ,ContData.env$myThresh.RoC.SD.period.DO.pctsat
                                       ,ContData.env$myThresh.RoC.SD.number.DO.pctsat
                                       ,ContData.env$myThresh.Flat.Hi.DO.pctsat
                                       ,ContData.env$myThresh.Flat.Lo.DO.pctsat
                                       ,ContData.env$myThresh.Flat.Tolerance.DO.pctsat)  #run operation
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.11. pH----
    myField <- ContData.env$myName.pH
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "pH"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.pH
                                       ,ContData.env$myThresh.Gross.Fail.Lo.pH
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.pH
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.pH
                                       ,ContData.env$myThresh.Spike.Hi.pH
                                       ,ContData.env$myThresh.Spike.Lo.pH
                                       ,ContData.env$myThresh.RoC.SD.period.pH
                                       ,ContData.env$myThresh.RoC.SD.number.pH
                                       ,ContData.env$myThresh.Flat.Hi.pH
                                       ,ContData.env$myThresh.Flat.Lo.pH
                                       ,ContData.env$myThresh.Flat.Tolerance.pH)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.12. Turbidity----
    myField <- ContData.env$myName.Turbidity
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "Turbidity"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.Turbidity
                                       ,ContData.env$myThresh.Gross.Fail.Lo.Turbidity
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.Turbidity
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.Turbidity
                                       ,ContData.env$myThresh.Spike.Hi.Turbidity
                                       ,ContData.env$myThresh.Spike.Lo.Turbidity
                                       ,ContData.env$myThresh.RoC.SD.period.Turbidity
                                       ,ContData.env$myThresh.RoC.SD.number.Turbidity
                                       ,ContData.env$myThresh.Flat.Hi.Turbidity
                                       ,ContData.env$myThresh.Flat.Lo.Turbidity
                                       ,ContData.env$myThresh.Flat.Tolerance.Turbidity)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.13. Chlorophyll a----
    myField <- ContData.env$myName.Chlorophylla
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "Chlorophylla"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.Chlorophylla
                                       ,ContData.env$myThresh.Gross.Fail.Lo.Chlorophylla
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.Chlorophylla
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.Chlorophylla
                                       ,ContData.env$myThresh.Spike.Hi.Chlorophylla
                                       ,ContData.env$myThresh.Spike.Lo.Chlorophylla
                                       ,ContData.env$myThresh.RoC.SD.period.Chlorophylla
                                       ,ContData.env$myThresh.RoC.SD.number.Chlorophylla
                                       ,ContData.env$myThresh.Flat.Hi.Chlorophylla
                                       ,ContData.env$myThresh.Flat.Lo.Chlorophylla
                                       ,ContData.env$myThresh.Flat.Tolerance.Chlorophylla)
      }## IF ~ all(is.na())
    }##IF.myField.END

    # _B.6.14. Water Level----
    myField <- ContData.env$myName.WaterLevel
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "WaterLevel"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.WaterLevel
                                       ,ContData.env$myThresh.Gross.Fail.Lo.WaterLevel
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.WaterLevel
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.WaterLevel
                                       ,ContData.env$myThresh.Spike.Hi.WaterLevel
                                       ,ContData.env$myThresh.Spike.Lo.WaterLevel
                                       ,ContData.env$myThresh.RoC.SD.period.WaterLevel
                                       ,ContData.env$myThresh.RoC.SD.number.WaterLevel
                                       ,ContData.env$myThresh.Flat.Hi.WaterLevel
                                       ,ContData.env$myThresh.Flat.Lo.WaterLevel
                                       ,ContData.env$myThresh.Flat.Tolerance.WaterLevel)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    # _B.6.15. Salinity----
    myField <- ContData.env$myName.Salinity
    if(myField %in% myNames.DataFields.Present==TRUE){
      #
      myMsg.data <- "Salinity"
      myMsg <- paste("WORKING (QC Tests and Flags - ", myMsg.data, ")", sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter, 2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
      if(all(is.na(data.import[, myField]))) {
        # Flag Field
        data.import[, paste(ContData.env$myName.Flag, myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Gross", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Spike", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "RoC", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
        data.import[, paste(ContData.env$myName.Flag, "Flat", myField, sep = ".")] <- ContData.env$myFlagVal.NoData
      } else {
        # Calc Stats
        data.import <- fun.CalcQCStats(data.import
                                       ,myField
                                       ,ContData.env$myThresh.Gross.Fail.Hi.Salinity
                                       ,ContData.env$myThresh.Gross.Fail.Lo.Salinity
                                       ,ContData.env$myThresh.Gross.Suspect.Hi.Salinity
                                       ,ContData.env$myThresh.Gross.Suspect.Lo.Salinity
                                       ,ContData.env$myThresh.Spike.Hi.Salinity
                                       ,ContData.env$myThresh.Spike.Lo.Salinity
                                       ,ContData.env$myThresh.RoC.SD.period.Salinity
                                       ,ContData.env$myThresh.RoC.SD.number.Salinity
                                       ,ContData.env$myThresh.Flat.Hi.Salinity
                                       ,ContData.env$myThresh.Flat.Lo.Salinity
                                       ,ContData.env$myThresh.Flat.Tolerance.Salinity)
      }## IF ~ all(is.na())
    }##IF.myField.END
    #
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Names of columns for QC Calculations and Tests with Flags for each data column present
    # combine so can check for and remove later.
    myNames.DataFields.Present.QCCalcs <- as.vector(t(outer(myNames.DataFields.Present,ContData.env$myNames.QCCalcs,paste,sep=".")))
    myNames.Flags.QCTests <- paste("Flag.",as.vector(t(outer(ContData.env$myNames.QCTests,myNames.DataFields.Present,paste,sep="."))),sep="")
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # not sure if need this little bit anymore
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #
    #
    # B.7. QC Tests
    # incorporated into subroutine in step 6
    #
    # B.8. Generate QC File
    # incorporated into subroutine in step 6
    #
    # B.9. Generate Log File
    # incorporated into subroutine in step 6
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # save file then run QC Report in a separate Script
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     # 10.0. Output file (only works if DataType is Air OR Water *not* both)
#     # 10.1. Set Name
#     #File.Date.Start <- format(as.Date(myData.DateRange.Start,myFormat.Date),"%Y%m%d")
#     #File.Date.End   <- format(as.Date(myData.DateRange.End,myFormat.Date),"%Y%m%d")
#     strFile.Out <- paste("QCauto",strFile,sep="_")
#     # 10.2. Save to File the data (overwrites any existing file).
#     #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
#     #utils::flush.console()
#     write.csv(data.import,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
#     #

    # 2020-12-21, dup row check
    # DST can create issues with duplicate lines
    # if data is offset can create extra rows in above QC checks
    data.import <- unique(data.import)

    #*********************
    # START QC manual stuff
    #************************


    #data.import <- read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings=c("","NA"))
    #
    # B.4.0. Columns
    # B.4.1. Check for DataFields  (may have already been done)
    colsDataFields_NoDiscrete <- ContData.env$myNames.DataFields[!grepl(
      paste0("^", ContData.env$myPrefix.Discrete)
      , ContData.env$myNames.DataFields
      , perl = TRUE)]
    cols2check <- c(colsDataFields_NoDiscrete
                    , ContData.env$myNames.Flags)
    myNames.DataFields.Present <- cols2check[cols2check %in%
                                               colnames(data.import) == TRUE]
    # add Date.Time to names for modification
    myNames.DataFields2Mod <- c(ContData.env$myName.DateTime
                                , myNames.DataFields.Present)
    #
    # B.5.0. Add "RAW" and "Comment.MOD" fields ----
    # default values
    myName.Raw <- "RAW"
    myName.Comment.Mod <- "Comment.MOD"
    # 5.1. Cycle each present field
        for (j in myNames.DataFields2Mod) {##FOR.j.START
          #
          # A. Add comment field and leave blank
          data.import[,paste(myName.Comment.Mod, j, sep=".")] <- ""
          # B. Add data.RAW and populate with original data
          data.import[, paste(myName.Raw, j, sep=".")] <- data.import[, j]
          #
        }##FOR.j.END
        #

    # Remove "Comment.MOD.Flag.*" columns (2021-04-19), Issue #123
    ## easier to remove than to mod code to not add
    data.import <- data.import[, !grepl("^Comment\\.MOD\\.Flag\\."
                                        , names(data.import))]

#     # leave as a loop so get RAW and Comment together
#     j <- myNames.DataFields2Mod
#     # A. Add comment field and leave blank
#     data.import[,paste(myName.Comment.Mod,j,sep=".")] <- ""
#     # B. Add data.RAW and populate with original data
#     data.import[,paste(myName.Raw,j,sep=".")] <- data.import[,j]
    #
    # 6-9 #not here

    # B.5.1. Move "Comment.MOD" next to "Flag" ----
    # 2024-01-22
    boo_move_CM <- TRUE
    if (boo_move_CM) {
      # boo_DEBUG <- FALSE

      patt_flag_env <- ContData.env$myName.Flag
      patt_flag     <- paste0("^", patt_flag_env, ".")
      patt_cm_env   <- "Comment.MOD"
      patt_cm       <-  paste0("^", patt_cm_env, ".")
      patt_datetime <- c(ContData.env$myName.Date
                         , ContData.env$myName.Time
                         , ContData.env$myName.DateTime)
      patt_flag_datetime <- paste(patt_flag_env, patt_datetime, sep = ".")
      patt_cm_datetime   <- paste(patt_cm_env, patt_datetime, sep = ".")

      ## Names, all
      names_all <- names(data.import)
      if (boo_DEBUG) {
        names_all
      }## IF ~ boo_DEBUG

      ## Names, Flag
      names_flag <- names(data.import)[grepl(patt_flag, names(data.import))]
      if (boo_DEBUG) {
        names_flag
      }## IF ~ boo_DEBUG
      # Remove Discrete
      patt_discrete <- "Discrete."
      names_flag <- names_flag[!grepl(patt_discrete, names_flag)]

      ## Names, Comment.MOD
      names_cm <- names(data.import)[grepl(patt_cm, names(data.import))]
      # remove date time
      names_cm <- names_cm[!names_cm %in% patt_cm_datetime]
      if (boo_DEBUG) {
        names_cm
      }## IF ~ boo_DEBUG

      #ContData.env$myNames.QCTests <- c("Gross","Spike","RoC","Flat")
      myNames.QCTests <- c("Gross","Spike","RoC","Flat")
      patt_QCTests <- paste(myNames.QCTests, collapse = "|")
      # ONLY QC Test flags
      names_flag_qctests <- names_flag[grepl(patt_QCTests, names_flag)]
      # Non QC Test flags
      names_flag_overall <- names_flag[!grepl(patt_QCTests, names_flag)]
      # Non Discrete
      patt_discrete <- "Discrete."
      names_flag_overall <- names_flag_overall[!grepl(patt_discrete, names_flag_overall)]
      ## remove Date.Time
      names_flag_overall <- names_flag_overall[!names_flag_overall %in% patt_flag_datetime]

      #IF len not > 0 then quit

      # Names, Measurements
      names_flag_measurements <- sub(patt_flag, "", names_flag_overall)
      names_cm_measurements <- sub(patt_cm, "", names_cm)
      # remove Date.Time
      names_flag_measurements <- names_flag_measurements[!names_flag_measurements %in% patt_datetime]
      names_cm_measurements <- names_cm_measurements[!names_cm_measurements %in% patt_datetime]

      if (boo_DEBUG) {
        names_flag_qctests
        names_flag_overall
        names_flag_measurements
        names_cm_measurements
        names_cm
      }## IF ~ boo_DEBUG

      # names position
      colnums_flag_qctests <- match(names_flag_qctests, names(data.import))
      colnums_flag_overall <- match(names_flag_overall, names(data.import))
      colnums_cm <- match(names_cm, names(data.import))
      colnums_remove <- sort(c(colnums_flag_overall, colnums_flag_qctests, colnums_cm))

      colnums_orig <- seq_len(ncol(data.import))
      colnums_remove_all <- colnums_orig[-c(colnums_remove )]

      # measurements should be in the same order for flags and cm but not guaranteed!

      # at position of each names_flag_overall create new order
      # p <- names_flag_measurements[1] # testing

      for (p in names_flag_measurements) {

        if (boo_DEBUG) {
          print(p)
          print(names_flag_overall)
          print(colnums_flag_overall)
          print(colnums_cm)
        }## IF ~ boo_DEBUG

        # number for iterations
        p_num <- match(p, names_flag_measurements)
        if (boo_DEBUG) {
          p_num
        }## IF ~ boo_DEBUG

        # flag measure
        p_flag_msr <- p
        if (boo_DEBUG) {
          print(p_flag_msr)
        }## IF ~ boo_DEBUG

        # match flag measure with cm measure
        p_flag_msr_match_cm_msr <- match(p_flag_msr, names_cm_measurements)
        if (boo_DEBUG) {
          print(p_flag_msr_match_cm_msr)
        }## IF ~ boo_DEBUG

        # cm
        p_cm <- names_cm[p_flag_msr_match_cm_msr]
        if (boo_DEBUG) {
          print(p_cm)
        }## IF ~ boo_DEBUG

        # flag_overall
        p_flag_overall <- names_flag_overall[grepl(p, names_flag_overall)]
        if (boo_DEBUG) {
          print(p_flag_overall)
        }## IF ~ boo_DEBUG

        # flag_qctests
        p_flag_qctests <- names_flag_qctests[grepl(p, names_flag_qctests)]
        if (boo_DEBUG) {
          print(p_flag_qctests)
        }## IF ~ boo_DEBUG

        # Col Num, all
        if (p_num == 1) {
          colnums_mod <- colnums_remove_all
        }## IF ~ p_num == 1
        if (boo_DEBUG) {
          print(colnums_mod)
        }## IF ~ boo_DEBUG

        # 0. find measurement colnum
        # insert after it using append
        # 1. Flag overall
        # 2. Comment.MOD
        # 3. Other flags

        # Col Num, p (measurement)
        colnum_p_orig <- match(p, names_all)
        if (boo_DEBUG) {
          print(colnum_p_orig)
        }## IF ~ boo_DEBUG

        # Col Num, p_flag_overall
        colnum_p_flag_overall_orig <- match(p_flag_overall, names_all)
        if (boo_DEBUG) {
          print(colnum_p_flag_overall_orig)
        }## IF ~ boo_DEBUG

        # Col Num, p_cm
        colnum_p_cm_orig <- match(p_cm, names_all)
        # MIGHT CHANGE, could be out of order
        if (boo_DEBUG) {
          print(colnum_p_cm_orig)
        }## IF ~ boo_DEBUG

        # Col Num, p_flag_qctests
        colnum_p_flag_qctests_orig <- match(p_flag_qctests, names_all)
        # MIGHT CHANGE, could be out of order
        if (boo_DEBUG) {
          print(colnum_p_flag_qctests_orig)
        }## IF ~ boo_DEBUG

        # Col Num, insert
        colnum_p_insert <- c(colnum_p_flag_overall_orig
                             , colnum_p_cm_orig
                             , colnum_p_flag_qctests_orig)

        # new position in modified data frame
        colnum_p_new <- match(colnum_p_orig, colnums_mod)
        if (boo_DEBUG) {
          print(colnum_p_new)
        }## IF ~ boo_DEBUG

        # insert CM after Flag
        colnums_mod <- append(colnums_mod
                              , values = colnum_p_insert
                              , after = colnum_p_new)

      }## FOR ~ p ~ names_flag_overall

      # resort data frame on new columns
      data.import <- data.import[, colnums_mod]

    }## IF ~ boo_move_CM

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # save file then run QC Report in a separate Script
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # B.10.0. Output file
    # B.10.1. Set Name
    # File.Date.Start <- format(as.Date(strFile.Date.Start,ContData.env$myFormat.Date),"%Y%m%d")
    # File.Date.End   <- format(as.Date(strFile.Date.End,ContData.env$myFormat.Date),"%Y%m%d")
    strFile.Out.Prefix <- "QC"
    strFile.Out <- paste(paste(strFile.Out.Prefix,strFile.Base,sep=ContData.env$myDelim),"csv",sep=".")
    # 10.2. Save to File the data (overwrites any existing file).
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #utils::flush.console()
    #write.csv(data.import,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
    utils::write.csv(data.import,file=file.path(myDir.data.export,strFile.Out),quote=FALSE,row.names=FALSE)
    #
#     # B.11. Clean up
#     # B.11.1. Inform user of progress and update LOG
#     myMsg <- "COMPLETE"
#     myItems.Complete <- myItems.Complete + 1
#     myItems.Log[intCounter,2] <- myMsg
#     fun.write.log(myItems.Log,myDate,myTime)
#     fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
#     utils::flush.console()
#     # B.11.2. Remove data (import)
#     rm(data.import)


#*********************
    # end QC manual stuff
  #************************
    # Report ####
    # # QC, 20170929, Mixed vs. Upper Case
    # strFile.Report <- paste(paste(strFile.Base,sep=ContData.env$myDelim),"csv",sep=".")
    #

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # insert QC Report so runs without user intervention
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # run with same import and export directory
    ###
    # B.10.3. Report ####
    booDisableReport <- FALSE
    if (booDisableReport==TRUE) {##IF.boo.DisableReport.START
      myMsg <- "The reporting feature is disabled at this time.  A future verison may re-enable it."
      cat(myMsg)
      utils::flush.console()
    } else if (booDisableReport==FALSE) {
      if (fun.CreateReport==TRUE){##IF.CreateReport.START
        fun.Report.File(strFile
                        , fun.myDir.export
                        , fun.myDir.export
                        , strFile.Out.Prefix
                        , fun.myReport.format
                        , fun.myReport.Dir)
      }##IF.CreateReport.END
    }##IF.boo.DisableReport.END


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC
# ##
#                     fun.myData.SiteID           <- strFile.SiteID
#                     fun.myData.Type             <- strFile.DataType
#                     fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
#                     fun.myData.DateRange.End    <- fun.myData.DateRange.End
#                     fun.myDir.BASE              <- fun.myDir.BASE
#                     fun.myDir.SUB.import        <- fun.myDir.SUB.export
#                     fun.myDir.SUB.export        <- fun.myDir.SUB.export
#                     fun.myFile.Prefix           <- strFile.Out.Prefix
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # B.11. Clean up
    # B.11.1. Inform user of progress and update LOG
    myMsg <- "COMPLETE"
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.write.log(myItems.Log,myDate,myTime)
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    utils::flush.console()
    # 11.2. Remove data (import)
    rm(data.import)
    #
  }##while.END
  #
  # C. Return ####
  myTime.End <- Sys.time()
  print(paste("Task COMPLETE; ",round(difftime(myTime.End,myTime.Start,units="mins"),2)," min.",sep=""))
  utils::flush.console()
  #
  # return data table
  #return(data.import)  # don't want to return since are saving in the loop  (would only be last one anyway)
}##FUN.fun.QC.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# # #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # # # QC
# fun.data.import                 <- data.import
# fun.myField.Data                <- myName.SensorDepth
# fun.myThresh.Gross.Fail.Hi      <- myThresh.Gross.Fail.Hi.SensorDepth
# fun.myThresh.Gross.Fail.Lo      <- myThresh.Gross.Fail.Lo.SensorDepth
# fun.myThresh.Gross.Suspect.Hi   <- myThresh.Gross.Suspect.Hi.SensorDepth
# fun.myThresh.Gross.Suspect.Lo   <- myThresh.Gross.Suspect.Lo.SensorDepth
# fun.myThresh.Spike.Hi           <- myThresh.Spike.Hi.SensorDepth
# fun.myThresh.Spike.Lo           <- myThresh.Spike.Lo.SensorDepth
# fun.myThresh.RoC.SD.period      <- myThresh.RoC.SD.period.SensorDepth
# fun.myThresh.RoC.SD.number      <- myThresh.RoC.SD.number.SensorDepth
# fun.myThresh.Flat.Hi            <- myThresh.Flat.Hi.SensorDepth
# fun.myThresh.Flat.Lo            <- myThresh.Flat.Lo.SensorDepth
# fun.myThresh.Flat.Tolerance     <- myThresh.Flat.Tolerance.SensorDepth
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # FUNCTION
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # Generate QC Test Calculations, QC Test Flags, and Assign overall flags
# # input is a single data field and the thresholds
# # output is a data frame (assumes data.import)
# # reuses items from this script and calling script.  Not a stand alone function
# #
# ###
# # @param fun.data.import data frame to perform QC
# # @param fun.myField.Data data field
# # @param fun.myThresh.Gross.Fail.Hi Pertinent QC threshold; Gross, Fail, Hi
# # @param fun.myThresh.Gross.Fail.Lo Pertinent QC threshold; Gross, Fail, Lo
# # @param fun.myThresh.Gross.Suspect.Hi Pertinent QC threshold; Gross, Suspect, Hi
# # @param fun.myThresh.Gross.Suspect.Lo Pertinent QC threshold; Gross, Suspect, Lo
# # @param fun.myThresh.Spike.Hi Pertinent QC threshold; Spike, Fail, Hi
# # @param fun.myThresh.Spike.Lo Pertinent QC threshold; Spike, Fail, Lo
# # @param fun.myThresh.RoC.SD.period Pertinent QC threshold; Rate of Change, Standard Deviation, period
# # @param fun.myThresh.RoC.SD.number Pertinent QC threshold; Rate of Change, Standard Deviation, number
# # @param fun.myThresh.Flat.Hi Pertinent QC threshold; Flat, Hi
# # @param fun.myThresh.Flat.Lo Pertinent QC threshold; Flat, Hi
# # @param fun.myThresh.Flat.Tolerance Pertinent QC threshold; Flat, tolerance
# # @return Returns a data frame to calling function
# # @keywords continuous data, qc, quality control
# # @examples
# # #Not intended to be accessed indepedently.
# # @export
# fun.CalcQCStats <- function(fun.data.import
#                             ,fun.myField.Data
#                             ,fun.myThresh.Gross.Fail.Hi
#                             ,fun.myThresh.Gross.Fail.Lo
#                             ,fun.myThresh.Gross.Suspect.Hi
#                             ,fun.myThresh.Gross.Suspect.Lo
#                             ,fun.myThresh.Spike.Hi
#                             ,fun.myThresh.Spike.Lo
#                             ,fun.myThresh.RoC.SD.period
#                             ,fun.myThresh.RoC.SD.number
#                             ,fun.myThresh.Flat.Hi
#                             ,fun.myThresh.Flat.Lo
#                             ,fun.myThresh.Flat.Tolerance) {##FUN.fun.CalcQCStats.START
#   #
#   # AA. Offset timing check ####
#   # check for offset timing of Air and Water measurements, 20170509
#   #fun.myData.Type should inherit from calling script
#   # data fields present
#   fun.myField.Data.ALL <- names(fun.data.import)[names(fun.data.import) %in% ContData.env$myNames.DataFields]
#   boo.Offset <- fun.OffsetCollectionCheck(fun.data.import, fun.myField.Data.ALL, ContData.env$myName.DateTime)
#   if(boo.Offset==TRUE) {##IF.boo.Offset.START
#     # check time interval (na.omit removes all)
#     df.check <- na.omit(fun.data.import[,c(ContData.env$myName.DateTime,fun.myField.Data)])
#     # convert from Character to time if necessary (not necessary)
#     # if (is.character(df.check[,ContData.env$myName.DateTime])==TRUE){
#     #   myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
#     #   # df.check[,ContData.env$myName.DateTime] <- strftime(df.check[,ContData.env$myName.DateTime],
#     #   #                                                     format=myFormat,
#     #   #                                                     tz=ContData.env$myTZ)
#     # }
#     #x <- df.check[,ContData.env$myName.DateTime]
#     myT <- strptime(df.check[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime)
#     myTimeDiff.all <- difftime(myT[-1],myT[-length(myT)])
#     myTimeDiff <- median(as.vector(myTimeDiff.all),na.rm=TRUE)
#     # create time series
#     myTS <- seq(as.POSIXlt(min(myT),tz=ContData.env$myTZ),as.POSIXlt(max(myT),tz=ContData.env$myTZ),by="30 min") #by=paste0(myTimeDiff," min"))
#     length(myTS)
#     #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     # remove other data fields (and extra times) before proceeding
#     ### Fields to keep
#     myFlds.Keep <- c(ContData.env$myName.SiteID,
#                      ContData.env$myName.DateTime, ContData.env$myName.Date, ContData.env$myName.Time,
#                      ContData.env$myName.Mo, ContData.env$myName.Day, ContData.env$myName.Yr,
#                      fun.myField.Data, paste0(ContData.env$myName.Flag,".",fun.myField.Data))
#     ### Modify the DF
#     # keep only the relevant data field and remove all NA (case-wise)
#     fun.data.import.mod <- na.omit(fun.data.import[,myFlds.Keep])
#     #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     # Check length.  If different add in extra times
#     ## NA records would have been removed earlier
#     if (length(myTS) != nrow(df.check)){##IF.length.START
#       # add extra rows to new Time Series
#       ts.alltimes <- as.data.frame(as.character(myTS))
#       names(ts.alltimes) <- ContData.env$myName.DateTime
#       # merge (works with datetime as character but not as a POSIX field)
#       #df.check[,ContData.env$myName.DateTime] <- as.POSIXlt(df.check[,ContData.env$myName.DateTime],origin = "1900-01-01",tz=ContData.env$myTZ)
#       ts.alltimes.data <- merge(ts.alltimes, fun.data.import.mod, by=ContData.env$myName.DateTime)
#       # use new df moving forward
#       fun.data.import.mod <- ts.alltimes.data
#     }##IF.length.END
#     # then merge back at end
#   } else {
#     # rename fun.data.import (for non Offset)
#     fun.data.import.mod <- fun.data.import
#   }##IF.boo.Offset.END
#   #~~~~~~~~~~~~~~
#   # re-run boo.Offset at end to merge back into fun.data.import
#   #~~~~~~~~~~~~~~
#   #
#   # A. Time Calculations ####
#   # A.1. Calc, SD Time Interval
#   myCalc <- "SD.Time"
#   myField <- paste(fun.myField.Data,myCalc,sep=".")
#   # calculate as separate variable
#   #http://stackoverflow.com/questions/8857287/how-to-add-subtract-time-from-a-posixlt-time-while-keeping-its-class-in-r
#   # myT will be a POSIXt object
#   myT <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime)
#   myT$hour <- myT$hour - fun.myThresh.RoC.SD.period
#   # add back to dataframe
#   fun.data.import.mod[,myField] <- as.character(myT)
#   #
#   # alternate calculation, not used
#   #seq.POSIXt( from=Sys.time(), by="-25 hour", length.out=2 )[2]
#   #
#   # variable for following block
#   myField.T1 <- myField
#   #
#   # A.2. Calc, SD, calc SD of last 25 hours
#   myCalc <- "SD"
#   myField <- paste(fun.myField.Data,myCalc,sep=".")
#   #myField.T2 <- myName.DateTime
# #   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# #   # calc SD
# #   #
# #   #a <- fun.data.import.mod[,myName.WaterTemp]
# #   #b <- fun.data.import.mod[,myName.DateTime]
# #   #sd(a[b<="2014-04-22 10:00:00" & b>="2014-01-13 11:00:00"],na.rm=TRUE)
# #   #sd(a,na.rm=TRUE)
# #   #
# #   fun.data.import.mod[,myField] <- sd(fun.data.import.mod[,fun.myField.Data][fun.data.import.mod[,myName.DateTime]<="2014-04-22 10:00:00" & fun.data.import.mod[,myName.DateTime]>="2014-01-13 11:00:00"],na.rm=TRUE)
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   ## zoo version with rollapply
#   # need at least 5 records
#   if(nrow(fun.data.import.mod)<5) {##IF.nrow.START
#     myMsg <- paste("\n
#       The data file has less than 5 records.
#       The scripts will not work properly until you have more data."
#       ,sep="")
#     stop(myMsg)
#   }##IF.1.END
#   # get interval distance (will crash if less than 5 records)
#   # myT.diff <- difftime(fun.data.import.mod[5,ContData.env$myName.DateTime],fun.data.import.mod[4,ContData.env$myName.DateTime],units="mins")
#   # myT.diff[[1]]
#   # use median of all (no lower limit)
#   #x <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime)
#   #myT <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime)
#   myT.diff.all <- difftime(myT[-1],myT[-length(myT)], units="mins")
#   myT.diff <- median(as.vector(myT.diff.all),na.rm=TRUE)
#   # convert DateTime to POSIX object (already done above)
#   #myT <- strptime(fun.data.import.mod[,myName.DateTime],format=myFormat.DateTime)
#   # A.2. Use data "as is"
#   # create zoo object of data and date/time (use row num instead)
#   zoo.data <- zoo::zoo(fun.data.import.mod[,fun.myField.Data],seq(from=1,to=nrow(fun.data.import.mod),by=1))  # works
#   #
#   # B. Rolling SD
#   # time difference is in minutes and Threshold is in hours
#   # "By" in rollapply goes by # of records not by a set time.
#   RollBy <- fun.myThresh.RoC.SD.period/(myT.diff[[1]]/60)
#   # right align says the previous 50
#   # +1 is to include the record itself
#   #RollSD <- rollapply(data=zoo.merge,width=RollBy+1,FUN=sd,na.rm=TRUE,fill=NA,align="right")
#   RollSD <- zoo::rollapply(data=zoo.data,width=RollBy+1,FUN=sd,na.rm=TRUE,fill=NA,align="right")
#   # add to data frame
#   fun.data.import.mod[,myField] <- RollSD
#   # clean up
#   rm(myT)
#   rm(zoo.data)
#   rm(RollSD)
# #
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#
# #   #~~~~~~~~~~~~~
# #   # slow but works (~10 seconds for 5k records)
# #   # *******need to change to sapply***********
# #   for (m in 1:nrow(fun.data.import.mod)) {
# # #     print(m)
# # #     utils::flush.console()
# #     fun.data.import.mod[m,myField] <- sd(fun.data.import.mod[,fun.myField.Data][
# #         fun.data.import.mod[,myName.DateTime]<=fun.data.import.mod[m,myName.DateTime]
# #         & fun.data.import.mod[,myName.DateTime]>=fun.data.import.mod[m,myField.T1]
# #         ],na.rm=TRUE)
# #   }
# #   #
#   # A.3. Calc, NxSD, SD * n.per
#   myCalc.1 <- "SD"
#   myCalc.2 <- "SDxN"
#   myField.1 <- paste(fun.myField.Data,myCalc.1,sep=".")
#   myField.2 <- paste(fun.myField.Data,myCalc.2,sep=".")
#   fun.data.import.mod[,myField.2] <- fun.data.import.mod[,myField.1] * fun.myThresh.RoC.SD.number
#   #
#   # A.4. Calc, Diff (1:5) (5 is default but can be more)
#   for (i in 1:ContData.env$myThresh.Flat.MaxComp) {##FOR.i.START
#     myCalc <- paste("n",i,sep=".")
#     myField <- paste(fun.myField.Data,myCalc,sep=".")
#     fun.data.import.mod[-(1:i),myField] <- diff(as.numeric(fun.data.import.mod[,fun.myField.Data]),lag=i)
#     #
#   }##FOR.i.END
#   # only works as for loop, won't work as vector
#   #
#   #http://stackoverflow.com/questions/18862114/r-count-number-of-columns-by-a-condition-for-each-row
#   #
#   # A.5. Calc, flat.Hi, count n.1 etc if less than toler
#   myCalc <- "flat.Hi"
#   myField <- paste(fun.myField.Data,myCalc,sep=".")
#   myThresh <- fun.myThresh.Flat.Hi
#   # Fields to check
#   myFields.Match <- match(paste(fun.myField.Data,"n",1:myThresh,sep="."), names(fun.data.import.mod))
#   # use rowSums to count the fields
#   fun.data.import.mod[,myField] <- rowSums(abs(fun.data.import.mod[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
#   #
#   # A.6. Calc, flat.Lo, count if less than toler
#   myCalc <- "flat.Lo"
#   myField <- paste(fun.myField.Data,myCalc,sep=".")
#   myThresh <- fun.myThresh.Flat.Lo
#   # Fields to check
#   myFields.Match <- match(paste(fun.myField.Data,"n",1:myThresh,sep="."), names(fun.data.import.mod))
#   # use rowSums to count the fields
#   fun.data.import.mod[,myField] <- rowSums(abs(fun.data.import.mod[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
#   #
#   ## B. Generate Flags based on Calculation Fields ####
#   # B.1. Gross
#   myQCTest <- "Gross"
#   myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
#   # Assign Flags
#   # default value
#   fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
#   # data is NA then flag = 9 (missing data)
#   fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
#   # different test for water level, only if negative
#   if(fun.myField.Data==ContData.env$myName.SensorDepth) {##IF.Gross.SensorDepth.START
#     # data < 0 (i.e., negative) = 4 (fail)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] < 0] <- ContData.env$myFlagVal.Fail
#     # otherwise flag = 1 (pass)
#     fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   # different test for discharge
#   } else if(fun.myField.Data==ContData.env$myName.Discharge) {
#     # data < 0 (i.e., negative) = 4 (fail)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] < 0] <- ContData.env$myFlagVal.Fail
#     # otherwise flag = 1 (pass)
#     fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   } else {
#     # data >= Suspect.Hi then flag = 3 (suspect)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] >= fun.myThresh.Gross.Suspect.Hi] <- ContData.env$myFlagVal.Suspect
#     # data <= Suspect.Lo then flag = 3 (Suspect)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] <= fun.myThresh.Gross.Suspect.Lo] <- ContData.env$myFlagVal.Suspect
#     # data >= Fail.Hi then flag = 4 (fail)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] >= fun.myThresh.Gross.Fail.Hi] <- ContData.env$myFlagVal.Fail
#     # data <= Fail.Lo then flag = 4 (fail)
#     fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] <= fun.myThresh.Gross.Fail.Lo] <- ContData.env$myFlagVal.Fail
#     # otherwise flag = 1 (pass)
#     fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   }##IF.Gross.SensorDepth.END
#   # QC
#   #table(fun.data.import.mod[,myField])
#   #
#   # B.2. Spike
#   myQCTest <- "Spike"
#   myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
#   myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
#   # Assign Flags
#   # default value
#   fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
#   # diff 1 is NA then flag = 9 (missing data)
#   fun.data.import.mod[,myField][is.na(fun.data.import.mod[,myField.Calc.1])==TRUE] <- ContData.env$myFlagVal.NoData
#   # abs(diff 1) >= spike Lo then flag = 3 (suspect)
#   fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) >= fun.myThresh.Spike.Lo] <- ContData.env$myFlagVal.Suspect
#   # abs(diff 1) >= spike Hi then flag = 4 (fail)
#   fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) >= fun.myThresh.Spike.Hi] <- ContData.env$myFlagVal.Fail
#   # otherwise flag = 1 (pass)
#   fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   # QC
#   #table(fun.data.import.mod[,myField])
#   #
#   # B.3. RoC
#   myQCTest <- "RoC"
#   myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
#   myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
#   myField.Calc.2 <- paste(fun.myField.Data,"SDxN",sep=".")
#   # Assign Flags
#   # default value
#   fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
#   # data is NA then flag = 9 (missing data)
#   fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
#   # sd is NA then flag = 9 (missing data)
#   fun.data.import.mod[,myField][is.na(fun.data.import.mod[,myField.Calc.1])==TRUE] <- ContData.env$myFlagVal.NoData
#   # diff 1 > SD*N then flag = 3 (suspect)
#   fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) > fun.data.import.mod[,myField.Calc.2]] <- ContData.env$myFlagVal.Suspect
#   # otherwise flag = 1 (pass) [no 4/Fail]
#   fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   # QC
#   #table(fun.data.import.mod[,myField])
#   #
#   # B.4. Flat
#   myQCTest <- "Flat"
#   myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
#   myField.Calc.1 <- paste(fun.myField.Data,"flat.Hi",sep=".")
#   myField.Calc.2 <- paste(fun.myField.Data,"flat.Lo",sep=".")
#   # default value
#   fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
#   # Lo >= Thresh.Lo = 3 (suspect)
#   fun.data.import.mod[,myField][fun.data.import.mod[,myField.Calc.2] >= fun.myThresh.Flat.Lo] <- ContData.env$myFlagVal.Suspect
#   # Hi >= Thresh.Hi = 4 (fail)
#   fun.data.import.mod[,myField][fun.data.import.mod[,myField.Calc.1] >= fun.myThresh.Flat.Hi] <- ContData.env$myFlagVal.Fail
#   # otherwise flag = 1 (pass)
#   fun.data.import.mod[,myField][fun.data.import.mod[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
#   # QC
#   #table(fun.data.import.mod[,myField])
#   #
#   #
#   # C. Assign Overall Data Flag ####
#   myField <- paste(ContData.env$myName.Flag,fun.myField.Data,sep=".")
#   #myNames.QCTests
#   # get column numbers (match) for QCTest Flags for this data
#   myFields.Match <- match(paste("Flag",ContData.env$myNames.QCTests,fun.myField.Data,sep="."), names(fun.data.import.mod))
#   # Conditional rowSums for number of flag fields with specified flags
#   myFlags.Num.Pass    <- rowSums(fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.Pass)
#   myFlags.Num.Suspect <- rowSums(fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.Suspect )
#   myFlags.Num.Fail    <- rowSums(fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.Fail)
#   myFlags.Num.Missing <- rowSums(fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.NoData)
#   myFlags.Num.OK      <- rowSums(fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.Pass | fun.data.import.mod[,myFields.Match]==ContData.env$myFlagVal.NoData)
#   # Assign
#   # default value
#   fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
#   # any QC Test flags = 3 then flag = 3 (suspect)
#   fun.data.import.mod[,myField][myFlags.Num.Suspect > 0] <- ContData.env$myFlagVal.Suspect
#   # any QC Test flags = 4 then flag = 4 (fail)
#   fun.data.import.mod[,myField][myFlags.Num.Fail > 0] <- ContData.env$myFlagVal.Fail
#   # all QC Test flags = 1 then flag = 1 (pass)
#   fun.data.import.mod[,myField][myFlags.Num.Pass == length(ContData.env$myNames.QCTests)] <- ContData.env$myFlagVal.Pass
#   # all QC Test flags = 1 or 9 then flag = 1 (pass)
#   fun.data.import.mod[,myField][myFlags.Num.OK == length(ContData.env$myNames.QCTests)] <- ContData.env$myFlagVal.Pass
#     #fun.data.import.mod[,myField][fun.data.import.mod[,myField]==myFlagVal.NotEval] <- myFlagVal.Pass
#   # data is NA then flag = 9 (missing data)
#   fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
#   # QC
#   #table(fun.data.import.mod[,myField])
#
#
#   #
#   # D. Clean Up ####
#   # D.1. Remove QC Calc fields
#   # #myNames.QCCalcs <- c("SD.Time","SD","SDxN","n.1","n.2","n.3","n.4","n.5","flat.Lo","flat.Hi")
#   # #ContData.env$myNames.QCCalcs <- c("SD.Time","SD","SDxN",paste("n",1:ContData.env$myThresh.Flat.MaxComp,sep="."),"flat.Lo","flat.Hi")
#   # # get field column numbers
#   # myFields.Match <- match(paste(fun.myField.Data,ContData.env$myNames.QCCalcs,sep="."), names(fun.data.import.mod))
#   # # drop fields from data table
#   # fun.data.import.mod <- fun.data.import.mod[,-na.omit(myFields.Match)]
#   # ~~~~~ Keep new "flag" fields (20170515)
#   # Flag Fields (myField is current Flag.Parameter)
#   FlagFields.Keep <- c(myField, paste(ContData.env$myName.Flag,ContData.env$myNames.QCTests,fun.myField.Data,sep="."))
#   myFields.Drop <- match(paste(fun.myField.Data,ContData.env$myNames.QCCalcs,sep="."), names(fun.data.import.mod))
#   fun.data.import.mod <- fun.data.import.mod[,-na.omit(myFields.Drop)]
#   #
#   # D.2. Offset Timing Fix
#   ## Return a merged file if Offset is TRUE
#   if(boo.Offset==TRUE) {##IF.boo.Offset.START
#     # removed other data fields (and extra times) before above
#     # merge back
#     # all fields modified = ?????
#     #Fld.Mod <- c(ContData.env$myName.DateTime, fun.myField.Data)
#     # get fields added (20170512, add in Flag.Param)
#     Fld.Flag.Param <- match(myField, names(fun.data.import))
#     Fld.New <- names(fun.data.import.mod)[names(fun.data.import.mod) %in% names(fun.data.import)[-Fld.Flag.Param]==FALSE]
#     # merge on date time
#     DF.Return <- merge(fun.data.import[,-Fld.Flag.Param], fun.data.import.mod[,c(ContData.env$myName.DateTime, Fld.New)],
#                        by=ContData.env$myName.DateTime, all.x=TRUE)
#     } else {
#     DF.Return <- fun.data.import.mod
#   }##IF.boo.Offset.END
#   #
#   #
#   # E. Function output ####
#   return(DF.Return)
#   #
# }##FUN.fun.QC.END
# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Floating point math error in some cases (e.g., 0.15 != 0.15)
# http://stackoverflow.com/questions/9508518/why-are-these-numbers-not-equal
# instead of <= may have to use isTrue(all.equal(a,b))  where a<-0.1+0.05 and b<-0.15
# a <- 0.1 + 0.05
# b <- 0.15
# a==b
# a<=b
# b>=a
# isTRUE(all.equal(a,b))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# leave code "as is"
# Not removing data but flagging.
# Had found some cases with SensorDepth equal to 0.1 and not getting the correct T/F.
