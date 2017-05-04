#' Quality Control
#'
#' Subfunction for performing QC.  Needs to be called from ContDataQC().
#' Requires zoo().
#
# Sourced Routine
##################
# Quality Control (auto)
#########################
# make user script smaller and easier to understand
# not a true function, needs defined variables in calling script
# if change variable names in either file have to update the other
##################
# Erik.Leppo@tetratech.com (EWL)
# 20150921 (20151021, make into self standing function)
# 20151112, combine Auto and Manual QC
# 20170323, added 3 parameters (Cond, DO, and pH)
# 20170324, added 2 more parameters (Turbidity and Chlrophylla)
##################
# assumes use of CSV.  If using TXT have to modify list.files(pattern), read.csv(), and write.csv()
#
# Basic Operations:
# load all files in data directory
# perform QC
# write QC report
# save QCed data file
#
# 20160208
# WaterLevel - Gross is only negative, Flat = remove
# 20160303
# Rolling SD.  Use "zoo" and rollapply.  Loop too slow for large/dense data sets.
# (will crash if less than 5 records so added "stop")
#
# library (load any required helper functions)
#library(zoo)
#############################################
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type is "QC".
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.BASE Root directory for data.  If blank will use current working directory.
#' @param fun.myDir.SUB.import Subdirectory for import data.  If blank will use root directory.
#' @param fun.myDir.SUB.export Subdirectory for export data.  If blank will use root directory.
#' @return Returns a csv file to specified directory with QC flags.
#' @keywords continuous data, qc, quality control
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#
#'@export
fun.QC <- function(fun.myData.SiteID
                   ,fun.myData.Type="QC"
                   ,fun.myData.DateRange.Start
                   ,fun.myData.DateRange.End
                   ,fun.myDir.BASE=getwd()
                   ,fun.myDir.SUB.import=""
                   ,fun.myDir.SUB.export="") {##FUN.fun.QC.START
  #
  # Convert Data Type to proper case
  fun.myData.Type <- paste(toupper(substring(fun.myData.Type,1,1)),tolower(substring(fun.myData.Type,2,nchar(fun.myData.Type))),sep="")
  #
  # data directories
  myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="","",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="","",paste("/",fun.myDir.SUB.export,sep="")),sep="")
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # Verify input dates, if blank, NA, or null use all data
  # if DateRange.Start is null or "" then assign it 1900-01-01
  if (is.na(fun.myData.DateRange.Start)==TRUE||fun.myData.DateRange.Start==""){fun.myData.DateRange.Start<-ContData.env$DateRange.Start.Default}
  # if DateRange.End is null or "" then assign it today
  if (is.na(fun.myData.DateRange.End)==TRUE||fun.myData.DateRange.End==""){fun.myData.DateRange.End<-ContData.env$DateRange.End.Default}
  #
  # Read in list of files to work on, uses all files matching pattern ("\\.csv$")
  # ## if change formats will have to make modifications (pattern, import, export)
  files2process = list.files(path=myDir.data.import, pattern=" *.csv")
  head(files2process)
  #
  #
  # Define Counters for the Loop
  intCounter <- 0
  intCounter.Stop <- length(files2process)
  intItems.Total <- intCounter.Stop
  print(paste("Total files to process = ",intItems.Total,sep=""))
    flush.console()
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
  myItems.Log <- data.frame(ItemID=1:intItems.Total,Status=NA,ItemName=myItems.ALL)
  #


  # Error if no files to process or no files in dir


  # Start Time (used to determine run time at end)
  myTime.Start <- Sys.time()
  #
  # Perform a data manipulation on the data as a new file
  # Could use for (n in files2process) but prefer the control of a counter
  while (intCounter < intCounter.Stop)
  {##while.START
    #
    # 0. Increase the Counter
    intCounter <- intCounter+1
    #
    # 1.0. File Name, Define
    strFile = files2process[intCounter]
    # 1.1. File Name, Parse
    strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
    strFile.parts <- strsplit(strFile.Base, ContData.env$myDelim)
    strFile.SiteID     <- strFile.parts[[1]][1]
    strFile.DataType   <- strFile.parts[[1]][2]
    # Convert Data Type to proper case
    strFile.DataType <- paste(toupper(substring(strFile.DataType,1,1)),tolower(substring(strFile.DataType,2,nchar(strFile.DataType))),sep="")
    strFile.Date.Start <- as.Date(strFile.parts[[1]][3],"%Y%m%d")
    strFile.Date.End   <- as.Date(strFile.parts[[1]][4],"%Y%m%d")
    #
    # 2. Check File and skip if doesn't match user defined parameters
    # 2.1. Check File Size
    if(file.info(paste(myDir.data.import,"/",strFile,sep=""))$size==0){
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (file blank)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
        flush.console()
      # go to next Item
      next
    }
    # 2.2. Check SiteID
    # if not in provided site list then skip
    if(strFile.SiteID %in% fun.myData.SiteID == FALSE) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, SiteID)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
        flush.console()
      # go to next Item
      next
    }
    # 2.3. Check DataType
    # if not equal go to next file (handles both Air and Water)
    if (strFile.DataType %in% fun.myData.Type == FALSE){
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, DataType)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
        flush.console()
      # go to next Item
      next
    }
    # 2.4. Check Dates
    # 2.4.2.1. Check File.Date.Start (if file end < my Start then next)
    if(strFile.Date.End<fun.myData.DateRange.Start) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, Start Date)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
        flush.console()
      # go to next Item
      next
    }
    # 2.4.2.2. Check File.Date.End (if file Start > my End then next)
    if(strFile.Date.Start>fun.myData.DateRange.End) {
      # inform user of progress and update LOG
      myMsg <- "SKIPPED (Non-Match, End Date)"
      myItems.Skipped <- myItems.Skipped + 1
      myItems.Log[intCounter,2] <- myMsg
      fun.write.log(myItems.Log,myDate,myTime)
      fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
        flush.console()
      # go to next Item
      next
    }
    #
    # 3.0. Import the data
    #data.import=read.table(strFile,header=F,varSep)
    #varSep = "\t" (use read.delim instead of read.table)
    # as.is = T so dates come in as text rather than factor
    #data.import <- read.delim(strFile,as.is=TRUE,na.strings="")
    data.import <- read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings="")
    #
    # QC required fields: SiteID & (DateTime | (Date & Time))
    fun.QC.ReqFlds(names(data.import),paste(myDir.data.import,strFile,sep="/"))
    #
    # 4.0. Columns
    # Kick out if missing minimum of fields
    #
    # Check for and add any missing columns (but not for missing data fields)
    # 4.1. Date, Time, DateTime
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
      flush.console()
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
      flush.console()
      # go to next Item
      next
    }
    #
    # add to df
    data.import[,strCol.DT.Missing] <- NA
    #
    # 4.2.  Check for columns present and reorder columns
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
      flush.console()
      # go to next Item
    }
    #
    # reorder Columns (and drop extra columns)
    data.import <- data.import[,strCol.Present]
    # 4.3. Add FLAGS
    strCol.Flags <- ContData.env$myNames.Flags[ContData.env$myNames.Cols4Flags %in% colnames(data.import)==TRUE]
    data.import[,strCol.Flags] <- ""
    #
    #
    # data columns for flags that are present (need for later)
    #myNames.Cols4Flags.Present <- myNames.Cols4Flags[myNames.Cols4Flags %in% colnames(data.import)==TRUE]
    #
    #
    #
    # 5.  QC Date and Time fields
    #
    ############
    # may have to tinker with for NA fields
    ##############
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
    #format.DateTime <- fun.DateTimeFormat(data.import[,myName.DateTime],"DateTime")
    # get error if field is NA, need to fix
    # same for section below
    #
    # 20160322, new section, check for NA and fill if needed
    if (length(na.omit(data.import[,ContData.env$myName.DateTime]))==0){##IF.DateTime==NA.START
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
    # 5. QC Date and Time
    # 5.1. Convert all Date_Time, Date, and Time formats to expected format (ISO 8601)
    # Should allow for users to use different time and date formats in original data
    # almost worked
    #data.import[!(is.na(data.import[,myName.DateTime])),][myName.DateTime] <- strftime(data.import[!(is.na(data.import[,myName.DateTime])),][myName.DateTime]
    #                                                                                   ,format="%Y-%m-%d")
    # have to do where is NOT NA because will fail if the first item is NA
    # assume all records have the same format.
    #
    # 5.1.1. Update Date to "%Y-%m-%d" (equivalent to %F)
    myField   <- ContData.env$myName.Date
    myFormat.In  <- format.Date #"%Y-%m-%d"
    myFormat.Out <- ContData.env$myFormat.Date #"%Y-%m-%d"
    data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    # 5.1.2. Update Time to "%H:%M:%S" (equivalent to %T) (uses different function)
    myField   <- ContData.env$myName.Time
    myFormat.In  <- format.Time #"%H:%M:%S"
    myFormat.Out <- ContData.env$myFormat.Time #"%H:%M:%S"
    data.import[,myField][!is.na(data.import[,myField])] <- format(as.POSIXct(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    # 5.1.3. Update DateTime to "%Y-%m-%d %H:%M:%S" (equivalent to %F %T)
    myField   <- ContData.env$myName.DateTime
    myFormat.In  <- format.DateTime #"%Y-%m-%d %H:%M:%S"
    myFormat.Out <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
                                                                   ,format=myFormat.Out)
    #   # strptime adds the timezome but drops it when added back to data.import (using format)
    #   #######################################################
    #   # doesn't work anymore, worked when first line was NA
    #   #######################################################
    #   data.import <- y
    #   x<-data.import[,myField][!is.na(data.import[,myField])]
    #   (z<-x[2])
    #   (a <- strptime(z,format=myFormat.In))
    #   (b <- strptime(x,format=myFormat.In))
    #   # works on single record but fails on vector with strftime
    #   # strptime works but adds time zone (don't like but it works)
    #
    #
    # 5.2. Update DateTime, Date, and Time if NA based on other fields
    # 5.2.1. Update Date_Time if NA (use Date and Time)
    myField   <- ContData.env$myName.DateTime
    myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(data.import[,myName.Date][data.import[,myField]==""]
    #                                                                       ,data.import[,myName.Time][data.import[,myField]==""],sep="")
    #                                                                 ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- strftime(paste(data.import[,ContData.env$myName.Date][is.na(data.import[,myField])]
                                                                          ,data.import[,ContData.env$myName.Time][is.na(data.import[,myField])]
                                                                          ,sep=" ")
                                                                    ,format=myFormat,usetz=FALSE)
    # 5.2.2. Update Date if NA (use Date_Time)
    myField   <- ContData.env$myName.Date
    myFormat  <- ContData.env$myFormat.Date #"%Y-%m-%d"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Date]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- strftime(data.import[,ContData.env$myName.DateTime][is.na(data.import[,myField])]
                                                                    ,format=myFormat,usetz=FALSE)
    # 5.2.3. Update Time if NA (use Date_Time)
    myField   <- ContData.env$myName.Time
    myFormat  <- ContData.env$myFormat.Time #"%H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Time]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    data.import[,myField][is.na(data.import[,myField])] <- as.POSIXct(data.import[,ContData.env$myName.DateTime][is.na(data.import[,myField])]
                                                                      ,format=myFormat,usetz=FALSE)
    #
    # old code just for reference
    # 5.5. Force Date and Time format
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
#
    # 6. QC for each Data Type present
    # sub routine adds QC Calcs, QC Test Flags, Assigns overall Flag, and removes QC Calc Fields
    # cycle each data type (manually code)
    #
    # skip if not present
    #
    # 6.01. WaterTemp
    myField <- ContData.env$myName.WaterTemp
    myMsg.data <- "WaterTemp"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.02. AirTemp
    myField <- ContData.env$myName.AirTemp
    myMsg.data <- "AirTemp"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.03. WaterP
    myField <- ContData.env$myName.WaterP
    myMsg.data <- "WaterP"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.04. AirBP
    myField <- ContData.env$myName.AirBP
    myMsg.data <- "AirBP"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.05. WaterLevel
    myField <- ContData.env$myName.WaterLevel
    myMsg.data <- "WaterLevel"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
      #
    }##IF.myField.END
    #
    # 6.06. Discharge
    myField <- ContData.env$myName.Discharge
    myMsg.data <- "Discharge"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.07. Conductivity
    myField <- ContData.env$myName.Cond
    myMsg.data <- "Cond"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.08. Dissolved Oxygen
    myField <- ContData.env$myName.DO
    myMsg.data <- "DO"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.09. pH
    myField <- ContData.env$myName.pH
    myMsg.data <- "pH"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.10. Turbidity
    myField <- ContData.env$myName.Turbidity
    myMsg.data <- "Turbidity"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    # 6.11. Chlorophyll a
    myField <- ContData.env$myName.Chlorophylla
    myMsg.data <- "Chlorophylla"
    myMsg <- paste("WORKING (QC Tests and Flags - ",myMsg.data,")",sep="")
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    if(myField %in% myNames.DataFields.Present==TRUE){##IF.myField.START
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
    #
    #
    #############################
    # Names of columns for QC Calculations and Tests with Flags for each data column present
    # combine so can check for and remove later.
    myNames.DataFields.Present.QCCalcs <- as.vector(t(outer(myNames.DataFields.Present,ContData.env$myNames.QCCalcs,paste,sep=".")))
    myNames.Flags.QCTests <- paste("Flag.",as.vector(t(outer(ContData.env$myNames.QCTests,myNames.DataFields.Present,paste,sep="."))),sep="")
    #################################
    # not sure if need this little bit anymore
    ################################
    #
    #
    # 7. QC Tests
    # incorporated into subroutine in step 6
    #
    # 8. Generate QC File
    # incorporated into subroutine in step 6
    #
    # 9. Generate Log File
    # incorporated into subroutine in step 6
    #
    ###########################
    # save file then run QC Report in a separate Script
    ###############
#     # 10.0. Output file (only works if DataType is Air OR Water *not* both)
#     # 10.1. Set Name
#     #File.Date.Start <- format(as.Date(myData.DateRange.Start,myFormat.Date),"%Y%m%d")
#     #File.Date.End   <- format(as.Date(myData.DateRange.End,myFormat.Date),"%Y%m%d")
#     strFile.Out <- paste("QCauto",strFile,sep="_")
#     # 10.2. Save to File the data (overwrites any existing file).
#     #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
#     #flush.console()
#     write.csv(data.import,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
#     #


    #*********************
    # START QC manual stuff
    #************************


    #data.import <- read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings="")
    #
    # 4.0. Columns
    # 4.1. Check for DataFields  (may have already been done)
    myNames.DataFields.Present <- ContData.env$myNames.DataFields[ContData.env$myNames.DataFields %in% colnames(data.import)==TRUE]
    # add Date.Time to names for modification
    myNames.DataFields2Mod <- c(ContData.env$myName.DateTime, myNames.DataFields.Present)
    #
    # 5.0. Add "RAW" and "Comment.MOD" fields
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
    ###########################
    # save file then run QC Report in a separate Script
    ###############
    # 10.0. Output file
    # 10.1. Set Name
    File.Date.Start <- format(as.Date(strFile.Date.Start,ContData.env$myFormat.Date),"%Y%m%d")
    File.Date.End   <- format(as.Date(strFile.Date.End,ContData.env$myFormat.Date),"%Y%m%d")
    strFile.Out.Prefix <- "QC"
    strFile.Out <- paste(paste(strFile.Out.Prefix,strFile.SiteID,strFile.DataType,File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
    # 10.2. Save to File the data (overwrites any existing file).
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #flush.console()
    write.csv(data.import,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
    #
#     # 11. Clean up
#     # 11.1. Inform user of progress and update LOG
#     myMsg <- "COMPLETE"
#     myItems.Complete <- myItems.Complete + 1
#     myItems.Log[intCounter,2] <- myMsg
#     fun.write.log(myItems.Log,myDate,myTime)
#     fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
#     flush.console()
#     # 11.2. Remove data (import)
#     rm(data.import)


#*********************
    # end QC manual stuff
  #************************


    ##################
    # insert QC Report so runs without user intervention
    ##################
    # run with same import and export directory
    ###

    fun.Report(strFile.SiteID
                 ,strFile.DataType
                 ,strFile.Date.Start
                 ,strFile.Date.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.export
                 ,fun.myDir.SUB.export
                 ,strFile.Out.Prefix)
    ##########
    # QC
    ######
#                     fun.myData.SiteID           <- strFile.SiteID
#                     fun.myData.Type             <- strFile.DataType
#                     fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
#                     fun.myData.DateRange.End    <- fun.myData.DateRange.End
#                     fun.myDir.BASE              <- fun.myDir.BASE
#                     fun.myDir.SUB.import        <- fun.myDir.SUB.export
#                     fun.myDir.SUB.export        <- fun.myDir.SUB.export
#                     fun.myFile.Prefix           <- strFile.Out.Prefix
    ######################

    ######################

    # 11. Clean up
    # 11.1. Inform user of progress and update LOG
    myMsg <- "COMPLETE"
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.write.log(myItems.Log,myDate,myTime)
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    # 11.2. Remove data (import)
    rm(data.import)
    #
  }##while.END
  #
  myTime.End <- Sys.time()
  print(paste("Task COMPLETE; ",round(difftime(myTime.End,myTime.Start,units="mins"),2)," min.",sep=""))
  flush.console()
  #
  # return data table
  #return(data.import)  # don't want to return since are saving in the loop  (would only be last one anyway)
}##FUN.fun.QC.END
######################################################################



# # # ######################################################################
# # # # QC
# fun.data.import                 <- data.import
# fun.myField.Data                <- myName.WaterLevel
# fun.myThresh.Gross.Fail.Hi      <- myThresh.Gross.Fail.Hi.WaterLevel
# fun.myThresh.Gross.Fail.Lo      <- myThresh.Gross.Fail.Lo.WaterLevel
# fun.myThresh.Gross.Suspect.Hi   <- myThresh.Gross.Suspect.Hi.WaterLevel
# fun.myThresh.Gross.Suspect.Lo   <- myThresh.Gross.Suspect.Lo.WaterLevel
# fun.myThresh.Spike.Hi           <- myThresh.Spike.Hi.WaterLevel
# fun.myThresh.Spike.Lo           <- myThresh.Spike.Lo.WaterLevel
# fun.myThresh.RoC.SD.period      <- myThresh.RoC.SD.period.WaterLevel
# fun.myThresh.RoC.SD.number      <- myThresh.RoC.SD.number.WaterLevel
# fun.myThresh.Flat.Hi            <- myThresh.Flat.Hi.WaterLevel
# fun.myThresh.Flat.Lo            <- myThresh.Flat.Lo.WaterLevel
# fun.myThresh.Flat.Tolerance     <- myThresh.Flat.Tolerance.WaterLevel
# # # ####################################################################

########################
# FUNCTION
########################
# Generate QC Test Calculations, QC Test Flags, and Assign overall flags
# input is a single data field and the thresholds
# output is a data frame (assumes data.import)
# reuses items from this script and calling script.  Not a stand alone function
#
####
# @param fun.data.import data frame to perform QC
# @param fun.myField.Data data field
# @param fun.myThresh.Gross.Fail.Hi Pertinent QC threshold; Gross, Fail, Hi
# @param fun.myThresh.Gross.Fail.Lo Pertinent QC threshold; Gross, Fail, Lo
# @param fun.myThresh.Gross.Suspect.Hi Pertinent QC threshold; Gross, Suspect, Hi
# @param fun.myThresh.Gross.Suspect.Lo Pertinent QC threshold; Gross, Suspect, Lo
# @param fun.myThresh.Spike.Hi Pertinent QC threshold; Spike, Fail, Hi
# @param fun.myThresh.Spike.Lo Pertinent QC threshold; Spike, Fail, Lo
# @param fun.myThresh.RoC.SD.period Pertinent QC threshold; Rate of Change, Standard Deviation, period
# @param fun.myThresh.RoC.SD.number Pertinent QC threshold; Rate of Change, Standard Deviation, number
# @param fun.myThresh.Flat.Hi Pertinent QC threshold; Flat, Hi
# @param fun.myThresh.Flat.Lo Pertinent QC threshold; Flat, Hi
# @param fun.myThresh.Flat.Tolerance Pertinent QC threshold; Flat, tolerance
# @return Returns a data frame to calling function
# @keywords continuous data, qc, quality control
# @examples
# #Not intended to be accessed indepedently.
# @export
fun.CalcQCStats <- function(fun.data.import
                            ,fun.myField.Data
                            ,fun.myThresh.Gross.Fail.Hi
                            ,fun.myThresh.Gross.Fail.Lo
                            ,fun.myThresh.Gross.Suspect.Hi
                            ,fun.myThresh.Gross.Suspect.Lo
                            ,fun.myThresh.Spike.Hi
                            ,fun.myThresh.Spike.Lo
                            ,fun.myThresh.RoC.SD.period
                            ,fun.myThresh.RoC.SD.number
                            ,fun.myThresh.Flat.Hi
                            ,fun.myThresh.Flat.Lo
                            ,fun.myThresh.Flat.Tolerance) {##FUN.fun.CalcQCStats.START
  #
  # A.1. Calc, SD Time Interval
  myCalc <- "SD.Time"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  # calculate as separate variable
  #http://stackoverflow.com/questions/8857287/how-to-add-subtract-time-from-a-posixlt-time-while-keeping-its-class-in-r
  # myT will be a POSIXt object
  myT <- strptime(fun.data.import[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime)
  myT$hour <- myT$hour - fun.myThresh.RoC.SD.period
  # add back to dataframe
  fun.data.import[,myField] <- as.character(myT)
  #
  # alternate calculation, not used
  #seq.POSIXt( from=Sys.time(), by="-25 hour", length.out=2 )[2]
  #
  # variable for following block
  myField.T1 <- myField
  #
  # A.2. Calc, SD, calc SD of last 25 hours
  myCalc <- "SD"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  #myField.T2 <- myName.DateTime
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   # calc SD
#   #
#   #a <- fun.data.import[,myName.WaterTemp]
#   #b <- fun.data.import[,myName.DateTime]
#   #sd(a[b<="2014-04-22 10:00:00" & b>="2014-01-13 11:00:00"],na.rm=TRUE)
#   #sd(a,na.rm=TRUE)
#   #
#   fun.data.import[,myField] <- sd(fun.data.import[,fun.myField.Data][fun.data.import[,myName.DateTime]<="2014-04-22 10:00:00" & fun.data.import[,myName.DateTime]>="2014-01-13 11:00:00"],na.rm=TRUE)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## zoo version with rollapply
  # need at least 5 records
  if(nrow(fun.data.import)<5) {##IF.nrow.START
    myMsg <- paste("\n
      The data file has less than 5 records.
      The scripts will not work properly until you have more data."
      ,sep="")
    stop(myMsg)
  }##IF.1.END
  # get interval distance (will crash if less than 5 records)
  # myT.diff <- difftime(fun.data.import[5,ContData.env$myName.DateTime],fun.data.import[4,ContData.env$myName.DateTime],units="mins")
  # myT.diff[[1]]
  # use median of all (no lower limit)
  myT.diff.all <- difftime(fun.data.import[,ConData.env$myName.DateTime],fun.data.import[,ContData.env$myName.DateTime],units="mins")
  myT.diff <- median(as.vector(myT.diff.all))
  # convert DateTime to POSIX object (already done above)
  #myT <- strptime(fun.data.import[,myName.DateTime],format=myFormat.DateTime)
  # A.2. Use data "as is"
  # create zoo object of data and date/time (use row num instead)
  zoo.data <- zoo::zoo(fun.data.import[,fun.myField.Data],seq(from=1,to=nrow(fun.data.import),by=1))  # works
  #
  # B. Rolling SD
  # time difference is in minutes and Threshold is in hours
  # "By" in rollapply goes by # of records not by a set time.
  RollBy <- fun.myThresh.RoC.SD.period/(myT.diff[[1]]/60)
  # right align says the previous 50
  # +1 is to include the record itself
  #RollSD <- rollapply(data=zoo.merge,width=RollBy+1,FUN=sd,na.rm=TRUE,fill=NA,align="right")
  RollSD <- zoo::rollapply(data=zoo.data,width=RollBy+1,FUN=sd,na.rm=TRUE,fill=NA,align="right")
  # add to data frame
  fun.data.import[,myField] <- RollSD
  # clean up
  rm(myT)
  rm(zoo.data)
  rm(RollSD)
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#   #~~~~~~~~~~~~~
#   # slow but works (~10 seconds for 5k records)
#   # *******need to change to sapply***********
#   for (m in 1:nrow(fun.data.import)) {
# #     print(m)
# #     flush.console()
#     fun.data.import[m,myField] <- sd(fun.data.import[,fun.myField.Data][
#         fun.data.import[,myName.DateTime]<=fun.data.import[m,myName.DateTime]
#         & fun.data.import[,myName.DateTime]>=fun.data.import[m,myField.T1]
#         ],na.rm=TRUE)
#   }
#   #
  # A.3. Calc, NxSD, SD * n.per
  myCalc.1 <- "SD"
  myCalc.2 <- "SDxN"
  myField.1 <- paste(fun.myField.Data,myCalc.1,sep=".")
  myField.2 <- paste(fun.myField.Data,myCalc.2,sep=".")
  fun.data.import[,myField.2] <- fun.data.import[,myField.1] * fun.myThresh.RoC.SD.number
  #
  # A.4. Calc, Diff (1:5) (5 is default but can be more)
  for (i in 1:ContData.env$myThresh.Flat.MaxComp) {##FOR.i.START
    myCalc <- paste("n",i,sep=".")
    myField <- paste(fun.myField.Data,myCalc,sep=".")
    fun.data.import[-(1:i),myField] <- diff(as.numeric(fun.data.import[,fun.myField.Data]),lag=i)
    #
  }##FOR.i.END
  # only works as for loop, won't work as vector
  #
  #http://stackoverflow.com/questions/18862114/r-count-number-of-columns-by-a-condition-for-each-row
  #
  # A.5. Calc, flat.Hi, count n.1 etc if less than toler
  myCalc <- "flat.Hi"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  myThresh <- fun.myThresh.Flat.Hi
  # Fields to check
  myFields.Match <- match(paste(fun.myField.Data,"n",1:myThresh,sep="."), names(fun.data.import))
  # use rowSums to count the fields
  fun.data.import[,myField] <- rowSums(abs(fun.data.import[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
  #
  # A.6. Calc, flat.Lo, count if less than toler
  myCalc <- "flat.Lo"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  myThresh <- fun.myThresh.Flat.Lo
  # Fields to check
  myFields.Match <- match(paste(fun.myField.Data,"n",1:myThresh,sep="."), names(fun.data.import))
  # use rowSums to count the fields
  fun.data.import[,myField] <- rowSums(abs(fun.data.import[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
  #
  ## B. Generate Flags based on Calculation Fields
  # B.1. Gross
  myQCTest <- "Gross"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  # Assign Flags
  # default value
  fun.data.import[,myField] <- ContData.env$myFlagVal.NotEval
  # data is NA then flag = 9 (missing data)
  fun.data.import[,myField][is.na(fun.data.import[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
  # different test for water level, only if negative
  if(fun.myField.Data==ContData.env$myName.WaterLevel) {##IF.Gross.WaterLevel.START
    # data < 0 (i.e., negative) = 4 (fail)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] < 0] <- ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  # different test for discharge
  } else if(fun.myField.Data==ContData.env$myName.Discharge) {
    # data < 0 (i.e., negative) = 4 (fail)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] < 0] <- ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  } else {
    # data >= Suspect.Hi then flag = 3 (suspect)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] >= fun.myThresh.Gross.Suspect.Hi] <- ContData.env$myFlagVal.Suspect
    # data <= Suspect.Lo then flag = 3 (Suspect)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] <= fun.myThresh.Gross.Suspect.Lo] <- ContData.env$myFlagVal.Suspect
    # data >= Fail.Hi then flag = 4 (fail)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] >= fun.myThresh.Gross.Fail.Hi] <- ContData.env$myFlagVal.Fail
    # data <= Fail.Lo then flag = 4 (fail)
    fun.data.import[,myField][fun.data.import[,fun.myField.Data] <= fun.myThresh.Gross.Fail.Lo] <- ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  }##IF.Gross.WaterLevel.END
  # QC
  #table(fun.data.import[,myField])
  #
  # B.2. Spike
  myQCTest <- "Spike"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
  # Assign Flags
  # default value
  fun.data.import[,myField] <- ContData.env$myFlagVal.NotEval
  # diff 1 is NA then flag = 9 (missing data)
  fun.data.import[,myField][is.na(fun.data.import[,myField.Calc.1])==TRUE] <- ContData.env$myFlagVal.NoData
  # abs(diff 1) >= spike Lo then flag = 3 (suspect)
  fun.data.import[,myField][abs(fun.data.import[,myField.Calc.1]) >= fun.myThresh.Spike.Lo] <- ContData.env$myFlagVal.Suspect
  # abs(diff 1) >= spike Hi then flag = 4 (fail)
  fun.data.import[,myField][abs(fun.data.import[,myField.Calc.1]) >= fun.myThresh.Spike.Hi] <- ContData.env$myFlagVal.Fail
  # otherwise flag = 1 (pass)
  fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import[,myField])
  #
  # B.3. RoC
  myQCTest <- "RoC"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
  myField.Calc.2 <- paste(fun.myField.Data,"SDxN",sep=".")
  # Assign Flags
  # default value
  fun.data.import[,myField] <- ContData.env$myFlagVal.NotEval
  # data is NA then flag = 9 (missing data)
  fun.data.import[,myField][is.na(fun.data.import[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
  # sd is NA then flag = 9 (missing data)
  fun.data.import[,myField][is.na(fun.data.import[,myField.Calc.1])==TRUE] <- ContData.env$myFlagVal.NoData
  # diff 1 > SD*N then flag = 3 (suspect)
  fun.data.import[,myField][abs(fun.data.import[,myField.Calc.1]) > fun.data.import[,myField.Calc.2]] <- ContData.env$myFlagVal.Suspect
  # otherwise flag = 1 (pass) [no 4/Fail]
  fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import[,myField])
  #
  # B.4. Flat
  myQCTest <- "Flat"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"flat.Hi",sep=".")
  myField.Calc.2 <- paste(fun.myField.Data,"flat.Lo",sep=".")
  # default value
  fun.data.import[,myField] <- ContData.env$myFlagVal.NotEval
  # Lo >= Thresh.Lo = 3 (suspect)
  fun.data.import[,myField][fun.data.import[,myField.Calc.2] >= fun.myThresh.Flat.Lo] <- ContData.env$myFlagVal.Suspect
  # Hi >= Thresh.Hi = 4 (fail)
  fun.data.import[,myField][fun.data.import[,myField.Calc.1] >= fun.myThresh.Flat.Hi] <- ContData.env$myFlagVal.Fail
  # otherwise flag = 1 (pass)
  fun.data.import[,myField][fun.data.import[,myField]==ContData.env$myFlagVal.NotEval] <- ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import[,myField])
  #
  #
  # C. Assign Overall Data Flag
  myField <- paste("Flag",fun.myField.Data,sep=".")
  #myNames.QCTests
  # get column numbers (match) for QCTest Flags for this data
  myFields.Match <- match(paste("Flag",ContData.env$myNames.QCTests,fun.myField.Data,sep="."), names(fun.data.import))
  # Conditional rowSums for number of flag fields with specified flags
  myFlags.Num.Pass    <- rowSums(fun.data.import[,myFields.Match]==ContData.env$myFlagVal.Pass)
  myFlags.Num.Suspect <- rowSums(fun.data.import[,myFields.Match]==ContData.env$myFlagVal.Suspect )
  myFlags.Num.Fail    <- rowSums(fun.data.import[,myFields.Match]==ContData.env$myFlagVal.Fail)
  myFlags.Num.Missing <- rowSums(fun.data.import[,myFields.Match]==ContData.env$myFlagVal.NoData)
  myFlags.Num.OK      <- rowSums(fun.data.import[,myFields.Match]==ContData.env$myFlagVal.Pass | fun.data.import[,myFields.Match]==ContData.env$myFlagVal.NoData)
  # Assign
  # default value
  fun.data.import[,myField] <- ContData.env$myFlagVal.NotEval
  # any QC Test flags = 3 then flag = 3 (suspect)
  fun.data.import[,myField][myFlags.Num.Suspect > 0] <- ContData.env$myFlagVal.Suspect
  # any QC Test flags = 4 then flag = 4 (fail)
  fun.data.import[,myField][myFlags.Num.Fail > 0] <- ContData.env$myFlagVal.Fail
  # all QC Test flags = 1 then flag = 1 (pass)
  fun.data.import[,myField][myFlags.Num.Pass == length(ContData.env$myNames.QCTests)] <- ContData.env$myFlagVal.Pass
  # all QC Test flags = 1 or 9 then flag = 1 (pass)
  fun.data.import[,myField][myFlags.Num.OK == length(ContData.env$myNames.QCTests)] <- ContData.env$myFlagVal.Pass
    #fun.data.import[,myField][fun.data.import[,myField]==myFlagVal.NotEval] <- myFlagVal.Pass
  # data is NA then flag = 9 (missing data)
  fun.data.import[,myField][is.na(fun.data.import[,fun.myField.Data])==TRUE] <- ContData.env$myFlagVal.NoData
  # QC
  #table(fun.data.import[,myField])
  #
  # D. Remove QC Calc fields
  #myNames.QCCalcs <- c("SD.Time","SD","SDxN","n.1","n.2","n.3","n.4","n.5","flat.Lo","flat.Hi")
  # get field column numbers
  myFields.Match <- match(paste(fun.myField.Data,ContData.env$myNames.QCCalcs,sep="."), names(fun.data.import))
  # drop fields from data table
  fun.data.import <- fun.data.import[,-na.omit(myFields.Match)]
  #
  # function output
  return(fun.data.import)
  #
}##FUN.fun.QC.END
########################


#############################
# Floating point math error in some cases (e.g., 0.15 != 0.15)
# http://stackoverflow.com/questions/9508518/why-are-these-numbers-not-equal
# instead of <= may have to use isTrue(all.equal(a,b))  where a<-0.1+0.05 and b<-0.15
# a <- 0.1 + 0.05
# b <- 0.15
# a==b
# a<=b
# b>=a
# isTRUE(all.equal(a,b))
############################
# leave code "as is"
# Not removing data but flagging.
# Had found some cases with WaterLevel equal to 0.1 and not getting the correct T/F.
