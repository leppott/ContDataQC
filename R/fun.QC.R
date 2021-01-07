#' Quality Control
#'
#' Subfunction for performing QC.  Needs to be called from ContDataQC().
#' Requires zoo().
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
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type is "QC".
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @param fun.myReport.format Report format (docx or html).  Default is specified in config.R (docx).  Can be customized in config.R; ContData.env$myReport.Format.
#' @param fun.myReport.Dir Report (rmd) template folder.  Default is the package rmd folder.  Can be customized in config.R; ContData.env$myReport.Dir.
#' @param fun.CreateReport Boolean parameter to create reports or not.  Default = TRUE.
#'
#' @return Returns a csv file to specified directory with QC flags.
#'
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#
#'@export
fun.QC <- function(fun.myData.SiteID
                   , fun.myData.Type = "QC"
                   , fun.myData.DateRange.Start
                   , fun.myData.DateRange.End
                   , fun.myDir.import = ""
                   , fun.myDir.export = ""
                   , fun.myReport.format
                   , fun.myReport.Dir
                   , fun.CreateReport = TRUE) {##FUN.fun.QC.START
  #
  boo_DEBUG <- "FALSE"

  # A. Data Prep ####
  # Convert Data Type to proper case
  fun.myData.Type <- paste(toupper(substring(fun.myData.Type, 1, 1))
                           , tolower(substring(fun.myData.Type, 2
                                               , nchar(fun.myData.Type)))
                           , sep = "")
  #
  # data directories
  # myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import==""
  #,"",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  # myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export==""
  #,"",paste("/",fun.myDir.SUB.export,sep="")),sep="")
  myDir.data.import <- fun.myDir.import
  myDir.data.export <- fun.myDir.export
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # Verify input dates, if blank, NA, or null use all data
  # if DateRange.Start is null or "" then assign it 1900-01-01
  if (is.na(fun.myData.DateRange.Start)==TRUE || fun.myData.DateRange.Start=="") {
    fun.myData.DateRange.Start <- ContData.env$DateRange.Start.Default
    }
  # if DateRange.End is null or "" then assign it today
  if (is.na(fun.myData.DateRange.End)==TRUE || fun.myData.DateRange.End=="") {
    fun.myData.DateRange.End <- ContData.env$DateRange.End.Default
    }
  #
  # Read in list of files to work on, uses all files matching pattern ("\\.csv$")
  # ## if change formats will have to make modifications (pattern, import, export)
  files2process <- list.files(path=myDir.data.import, pattern=" *.csv")
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
  myFileTypeNum.Air <- 0
  myFileTypeNum.Water <- 0
  #
  # Create Log file
  ##  List of all items (files)
  myItems.ALL <- as.vector(unique(files2process))
  # create log file for processing results of items
  #myItems.Log <- data.frame(cbind(myItems.ALL,NA),stringsAsFactors=FALSE)
  myItems.Log <- data.frame(ItemID = seq_len(intItems.Total)
                            , Status = NA
                            , ItemName = myItems.ALL)
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
    # 1.1. File Name, Parse
    # QC Check - delimiter for strsplit
    if(ContData.env$myDelim==".") {##IF.myDelim.START
      # special case for regex check to follow (20170531)
      myDelim.strsplit <- "\\."
    } else {
      myDelim.strsplit <- ContData.env$myDelim
    }##IF.myDelim.END
    strFile.Base <- substr(strFile, 1, nchar(strFile) - nchar(".csv"))
    strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)
    strFile.SiteID     <- strFile.parts[[1]][1]
    strFile.DataType   <- strFile.parts[[1]][2]
    # Convert Data Type to proper case
    strFile.DataType <- paste(toupper(substring(strFile.DataType,1,1))
                              ,tolower(substring(strFile.DataType, 2
                                                 , nchar(strFile.DataType)))
                              ,sep="")
    strFile.Date.Start <- as.Date(strFile.parts[[1]][3], "%Y%m%d")
    strFile.Date.End   <- as.Date(strFile.parts[[1]][4], "%Y%m%d")
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
    # B.2.2. Check SiteID
    # if not in provided site list then skip
    if(strFile.SiteID %in% fun.myData.SiteID == FALSE) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, SiteID)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    # B.2.3. Check DataType
    # if not equal go to next file (handles both Air and Water)
    if (strFile.DataType %in% fun.myData.Type == FALSE){
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, DataType)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    # B.2.4. Check Dates
    # B.2.4.2.1. Check File.Date.Start (if file end < my Start then next)
    if(strFile.Date.End<fun.myData.DateRange.Start) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, Start Date)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    # B.2.4.2.2. Check File.Date.End (if file Start > my End then next)
    if(strFile.Date.Start>fun.myData.DateRange.End) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, End Date)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      # go to next Item
      next
    }
    #
    # B.3.0. Import the data
    #data.import=read.table(strFile,header=F,varSep)
    #varSep = "\t" (use read.delim instead of read.table)
    # as.is = T so dates come in as text rather than factor
    #data.import <- utils::read.delim(strFile,as.is=TRUE,na.strings="")
   # data.import <- utils::read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings=c("","NA"))
    data.import <- utils::read.csv(file.path(myDir.data.import,strFile),as.is=TRUE,na.strings=c("","NA"))
    #
    # QC required fields: SiteID & (DateTime | (Date & Time))
    fun.QC.ReqFlds(names(data.import),paste(myDir.data.import,strFile,sep="/"))
    #
    # B.4.0. Columns
    # Kick out if missing minimum of fields
    #
    # Check for and add any missing columns (but not for missing data fields)
    # B.4.1. Date, Time, DateTime
    # list
    strCol.DT <- c(ContData.env$myName.Date,ContData.env$myName.Time,ContData.env$myName.DateTime)
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
    # go to next item if no (date or time) AND no date/time field  (i.e., only 1 of date or time)
    if(length(strCol.DT.Missing)==2 & ContData.env$myName.DateTime%in%strCol.DT.Missing==TRUE) {
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
    strCol.Present <- ContData.env$myNames.Order[ContData.env$myNames.Order %in% colnames(data.import)==TRUE]
    #
    myNames.DataFields.Present <- ContData.env$myNames.DataFields[ContData.env$myNames.DataFields %in% colnames(data.import)==TRUE]
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
    #
    # reorder Columns (and drop extra columns)
    data.import <- data.import[,strCol.Present]
    # B.4.3. Add FLAGS
    strCol.Flags <- ContData.env$myNames.Flags[ContData.env$myNames.Cols4Flags %in% colnames(data.import)==TRUE]
    data.import[,strCol.Flags] <- ""
    #
    #
    # data columns for flags that are present (need for later)
    #myNames.Cols4Flags.Present <- myNames.Cols4Flags[myNames.Cols4Flags %in% colnames(data.import)==TRUE]
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
    data.import[,myField][all(is.na(data.import[,myField]))] <- data.import[,ContData.env$myName.DateTime]
    # Time
    myField   <- ContData.env$myName.Time
    data.import[,myField][all(is.na(data.import[,myField]))] <- data.import[,ContData.env$myName.DateTime]
    # DateTime
    #myField   <- myName.DateTime
    # can't fill fill from others without knowing the format
    #
    # get current file date/time records so can set format
    # Function below gets date or time format and returns R format
    # date_time is split and then pasted together.
    # if no AM/PM then 24hr time is assumed
    format.Date     <- fun.DateTimeFormat(data.import[,ContData.env$myName.Date],"Date")
    format.Time     <- fun.DateTimeFormat(data.import[,ContData.env$myName.Time],"Time")
    #format.DateTime <- fun.DateTimeFormat(data.import[,ContData.env$myName.DateTime],"DateTime")
    # get error if field is NA, need to fix
    # same for section below
    #
    # 20160322, new section, check for NA and fill if needed
    if (length(stats::na.omit(data.import[,ContData.env$myName.DateTime]))==0){##IF.DateTime==NA.START
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

    #
#     # example of classes for POSIXlt
#     Sys.time()
#     unclass(as.POSIXlt(Sys.time()))
#     ?DateTimeClasses


    # 2020-12-21, Keep only 1st entry on duplicate date.time
    # fall for Daylight Savings Time
    data.import <- fun.DateTime.GroupBy.First(data.import)


#
    # B.6. QC for each Data Type present ####
    # sub routine adds QC Calcs, QC Test Flags, Assigns overall Flag, and removes QC Calc Fields
    # cycle each data type (manually code)
    #
    # skip if not present
    # 20170512, move message inside of IF so user doesn't see it.
    #
    # 6.01. WaterTemp
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
      #
    }##IF.myField.END
    #
    # B.6.02. AirTemp
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
      #
    }##IF.myField.END
    #
    # B.6.03. WaterP
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
      #
    }##IF.myField.END
    #
    # B.6.04. AirP
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
      #
    }##IF.myField.END
    #
    # B.6.05. SensorDepth
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
      #
    }##IF.myField.END
    #
    # B.6.06. Discharge
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

    }##IF.myField.END
      #
    # B.6.07. Conductivity
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

    }##IF.myField.END
    #
    # B.6.08. Dissolved Oxygen
    myField <- ContData.env$myName.DO
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
      #
      myMsg.data <- "DO"
      myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
      myItems.Complete <- myItems.Complete + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      utils::flush.console()
      #
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
    }##IF.myField.END
    #
    # B.6.09. pH
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
    }##IF.myField.END
    #
    # B.6.10. Turbidity
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
    }##IF.myField.END
    #
    # B.6.11. Chlorophyll a
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
    }##IF.myField.END
    #
    # B.6.12. Water Level
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
    myNames.DataFields.Present <- ContData.env$myNames.DataFields[ContData.env$myNames.DataFields %in% colnames(data.import)==TRUE]
    # add Date.Time to names for modification
    myNames.DataFields2Mod <- c(ContData.env$myName.DateTime, myNames.DataFields.Present)
    #
    # B.5.0. Add "RAW" and "Comment.MOD" fields
    # default values
    myName.Raw <- "RAW"
    myName.Comment.Mod <- "Comment.MOD"
    # 5.1. Cycle each present field
        for (j in myNames.DataFields2Mod) {##FOR.j.START
          #
          # A. Add comment field and leave blank
          data.import[,paste(myName.Comment.Mod,j,sep=".")] <- ""
          # B. Add data.RAW and populate with original data
          data.import[,paste(myName.Raw,j,sep=".")] <- data.import[,j]
          #
        }##FOR.j.END
        #
#     # leave as a loop so get RAW and Comment together
#     j <- myNames.DataFields2Mod
#     # A. Add comment field and leave blank
#     data.import[,paste(myName.Comment.Mod,j,sep=".")] <- ""
#     # B. Add data.RAW and populate with original data
#     data.import[,paste(myName.Raw,j,sep=".")] <- data.import[,j]
    #
    # 6-9 #not here
    #
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # save file then run QC Report in a separate Script
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # B.10.0. Output file
    # B.10.1. Set Name
    File.Date.Start <- format(as.Date(strFile.Date.Start
                                      ,ContData.env$myFormat.Date)
                              ,"%Y%m%d")
    File.Date.End   <- format(as.Date(strFile.Date.End
                                      ,ContData.env$myFormat.Date)
                              ,"%Y%m%d")
    strFile.Out.Prefix <- "QC"
    strFile.Out <- paste(paste(strFile.Out.Prefix
                               ,strFile.SiteID
                               ,strFile.DataType
                               ,File.Date.Start
                               ,File.Date.End
                               ,sep=ContData.env$myDelim)
                         ,"csv"
                         ,sep=".")
    # 10.2. Save to File the data (overwrites any existing file).
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #utils::flush.console()
    #write.csv(data.import,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
    utils::write.csv(data.import,file = file.path(myDir.data.export, strFile.Out)
                     ,quote=FALSE
                     ,row.names=FALSE)
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
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # insert QC Report so runs without user intervention
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG, REPORT ####
    if(boo_DEBUG==TRUE){##IF~boo_DEBUG~START
      fun.myData.SiteID           <- strFile.SiteID
      fun.myData.Type             <- strFile.DataType
      fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
      fun.myData.DateRange.End    <- fun.myData.DateRange.End
      fun.myDir.BASE              <- fun.myDir.BASE
      fun.myDir.SUB.import        <- fun.myDir.SUB.export
      fun.myDir.SUB.export        <- fun.myDir.SUB.export
      fun.myFile.Prefix           <- strFile.Out.Prefix
    }##IF~boo_DEBUG~END
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # run with same import and export directory
    ###
    # B.10.3. Report ####
    if (fun.CreateReport==TRUE){##IF.CreateReport.START
      fun.Report(strFile.SiteID
                 , strFile.DataType
                 , strFile.Date.Start
                 , strFile.Date.End
                 , fun.myDir.export
                 , fun.myDir.export
                 , strFile.Out.Prefix
                 , fun.myReport.format
                 , fun.myReport.Dir
                 ) }##IF.CreateReport.END

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

# 20181205, move fun.CalcQCStats to fun.Helper.R


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
