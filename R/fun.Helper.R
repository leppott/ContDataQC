# Helper Functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20150805
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Status Message
#
# Reports progress back to the user in the console.
# @param fun.status Date, Time, or DateTime data
# @param fun.item.num.current current item
# @param fun.item.num.total total items
# @param fun.item.name name of current item
#
# @return Returns a message to the console
#
# @keywords internal
#
# @examples
# #Not intended to be accessed independently.
#
## for informing user of progress
# @export
fun.Msg.Status <- function(fun.status
                           , fun.item.num.current
                           , fun.item.num.total
                           , fun.item.name) {
  ## FUNCTION.START
  print(paste("Processing item "
              ,fun.item.num.current
              ," of "
              ,fun.item.num.total
              ,", "
              ,fun.status
              ,", "
              ,fun.item.name
              ,"."
              ,sep=""))
} ## FUNCTION.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Log write
#
# Writes status information to a log file.
#
# @param fun.Log information to write to log
# @param fun.Date current date (YYYYMMDD)
# @param fun.Time current time (HHMMSS)
# @param fun.item.name item name
#
# @return Returns a message to the console
#
# @keywords internal
#
# @examples
# #Not intended to be accessed independently.
#
## write log file
# @export
fun.write.log <- function(fun.Log, fun.Date, fun.Time) {#FUNCTION.START
  utils::write.table(fun.Log
                     , file=paste("LOG.Items."
                                  , fun.Date
                                  , "."
                                  , fun.Time
                                  ,".tab"
                                  , sep="")
                     , sep="\t"
                     , row.names=FALSE
                     , col.names=TRUE)
}#FUNCTION.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Required field check
#
# Checks a data frame for required fields.  Gives an error message and stops the
# process if fields are not present.
#
# @param fun.names required names
# @param fun.File file to check
#
# @keywords internal
#
# @examples
# #Not intended to be accessed independently.
#
## QC check for variables in data (20160204)
# referenced in calling script right after data is imported.
# Required fields: myName.SiteID & (myName.DateTime |
# myName.Date & myName.Time))
# @export
fun.QC.ReqFlds <- function(fun.names, fun.File) {##FUNCTION.fun.QC.ReqFlds.START
  ### QC
#   fun.names <- names(data.import)
#   fun.File <- paste(myDir.data.import,strFile,sep="/")
  ####
  # SiteID
  if(ContData.env$myName.SiteID %in% fun.names == FALSE) {##IF.1.START
    myMsg <- paste("\n
      The SiteID column name (",ContData.env$myName.SiteID,") is mispelled or
      missing from your data file.
      The scripts will not work properly until you change the SiteID variable
      'myName.SiteID' in the script 'UserDefinedValue.R' or modify your file.
       \n
      File name and path:
      \n
      ",fun.File,"
      \n
      Column names in current file are below.
      \n"
      ,list(fun.names),sep="")
    stop(myMsg)
  }##IF.1.END
  #
  # Date.Time | (Date & Time)
  if(ContData.env$myName.DateTime%in%fun.names==FALSE &
     (ContData.env$myName.Date%in%fun.names==FALSE |
       ContData.env$myName.Time%in%fun.names==FALSE)) {##IF.2.START
    myMsg <- paste("\n
      The DateTime (",ContData.env$myName.DateTime,") and/or Date ("
      ,ContData.env$myName.Date,") and/or Time (",ContData.env$myName.Time
      ,") column names are mispelled or missing from your data file.
      Either 'Date.Time' or both of 'Date' and 'Time' are required.
      The scripts will not work properly until you change the variables
      'myName.DateTime' and/or 'myName.Date' and/or 'myName.Time' in the script
      'UserDefinedValue.R' or modify your file.
      \n
      File name and path:
      \n
      ",fun.File,"
      \n
      Column names in current file are below.
      \n"
      ,list(fun.names),sep="")
    stop(myMsg)
  }##IF.2.END
  #
}##FUNCTION.fun.QC.ReqFlds.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Date and Time QC
#
# Subroutine to check a data frame for dates
#
# @param fun.df data frame to check
# @keywords internal
# @examples
# #Not intended to be accessed independently.
#
## QC check of date and time fields (20170115)
# Excel can mess up date formats in CSV files
#    even when don't intentionally change.
# borrow code from fun.QC.R, fun.QC, step 5 ~ line 245
# Access this code after QC for the date and time fields in the
#         Aggregate and Summary Operations
# takes as input a data frame and returns it with changes
###
# QC
#fun.df <- data.import
####
# @export
fun.QC.datetime <- function(fun.df){##FUNCTION.fun.QC.datetime.START
  #
  # 5.  QC Date and Time fields
  #
  ###
  # may have to tinker with for NA fields
  ###
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
  fun.df[,myField][all(is.na(fun.df[,myField]))] <- fun.df[
                                                , ContData.env$myName.DateTime]
  # Time
  myField   <- ContData.env$myName.Time
  fun.df[,myField][all(is.na(fun.df[,myField]))] <- fun.df[
                                                , ContData.env$myName.DateTime]
  # DateTime
  #myField   <- myName.DateTime
  # can't fill fill from others without knowing the format
  #
  # get current file date/time records so can set format
  # Function below gets date or time format and returns R format
  # date_time is split and then pasted together.
  # if no AM/PM then 24hr time is assumed
  format.Date     <- fun.DateTimeFormat(fun.df[, ContData.env$myName.Date]
                                        ,"Date")
  format.Time     <- fun.DateTimeFormat(fun.df[,ContData.env$myName.Time]
                                        ,"Time")
  #format.DateTime <- fun.DateTimeFormat(data.import[,myName.DateTime]
                                                           #,"DateTime")
  # get error if field is NA, need to fix
  # same for section below
  #
  # 20160322, new section, check for NA and fill if needed
  if (length(stats::na.omit(fun.df[,ContData.env$myName.DateTime]))==0) {
    ##IF.DateTime==NA.START
    # move 5.2.1 up here
    myField   <- ContData.env$myName.DateTime
    myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(
    #data.import[,myName.Date][data.import[,myField]==""]
    #   ,data.import[,myName.Time][data.import[,myField]==""],sep="")
    #         ,format=myFormat,usetz=FALSE)
    fun.df[,myField][is.na(fun.df[,myField])] <- strftime(paste(fun.df[
      ,ContData.env$myName.Date][is.na(fun.df[,myField])]
      ,fun.df[,ContData.env$myName.Time][is.na(fun.df[,myField])]
      ,sep=" ")
      ,format=myFormat,usetz=FALSE)
  }##IF.DateTime==NA.START
  format.DateTime <- fun.DateTimeFormat(fun.df[,ContData.env$myName.DateTime]
                                        ,"DateTime")
  #
  # QC
  #  # format.Date <- "%Y-%m-%d"
  #   format.Time <- "%H:%M:%S"
  #   format.DateTime <- "%Y-%m-%d %H:%M"
  #
  # 5. QC Date and Time
  # 5.1. Convert all Date_Time, Date, and Time formats
  #             to expected format (ISO 8601)
  # Should allow for users to use different time and date formats in original
  # data
  # almost worked
  #data.import[!(is.na(data.import[,myName.DateTime])),][myName.DateTime] <-
  # strftime(data.import[!(is.na(data.import[,myName.DateTime]))
  # ,][myName.DateTime]
  #   ,format="%Y-%m-%d")
  # have to do where is NOT NA because will fail if the first item is NA
  # assume all records have the same format.
  #
  # 5.1.1. Update Date to "%Y-%m-%d" (equivalent to %F)
  myField   <- ContData.env$myName.Date
  myFormat.In  <- format.Date #"%Y-%m-%d"
  myFormat.Out <- ContData.env$myFormat.Date #"%Y-%m-%d"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(strptime(fun.df[,myField]
                                  [!is.na(fun.df[,myField])],format=myFormat.In)
                                                          ,format=myFormat.Out)
  # 5.1.2. Update Time to "%H:%M:%S" (equivalent to %T)
  # (uses different function)
  myField   <- ContData.env$myName.Time
  myFormat.In  <- format.Time #"%H:%M:%S"
  myFormat.Out <- ContData.env$myFormat.Time #"%H:%M:%S"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(as.POSIXct(fun.df[
    ,myField][!is.na(fun.df[,myField])],format=myFormat.In)
                                     ,format=myFormat.Out)
  # 5.1.3. Update DateTime to "%Y-%m-%d %H:%M:%S" (equivalent to %F %T)
  myField   <- ContData.env$myName.DateTime
  myFormat.In  <- format.DateTime #"%Y-%m-%d %H:%M:%S"
  myFormat.Out <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(strptime(fun.df[
    ,myField][!is.na(fun.df[,myField])],format=myFormat.In)
                        ,format=myFormat.Out)
  #   # strptime adds the timezome but drops it when added back to data.import
  # (using format)
  #   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   # doesn't work anymore, worked when first line was NA
  #   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
  #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(
  #data.import[,myName.Date][data.import[,myField]==""]
  #              ,data.import[,myName.Time][data.import[,myField]==""],sep="")
  #           ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- strftime(paste(fun.df[
    ,ContData.env$myName.Date][is.na(fun.df[,myField])]
                    ,fun.df[,ContData.env$myName.Time][is.na(fun.df[,myField])]
                    ,sep=" ")
              ,format=myFormat,usetz=FALSE)
  # 5.2.2. Update Date if NA (use Date_Time)
  myField   <- ContData.env$myName.Date
  myFormat  <- ContData.env$myFormat.Date #"%Y-%m-%d"
  #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[
  # ,myName.DateTime][data.import[,myName.Date]==""]
  #                  ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- strftime(fun.df[
    ,ContData.env$myName.DateTime][is.na(fun.df[,myField])]
                           ,format=myFormat,usetz=FALSE)
  # 5.2.3. Update Time if NA (use Date_Time)
  myField   <- ContData.env$myName.Time
  myFormat  <- ContData.env$myFormat.Time #"%H:%M:%S"
  #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[
  # ,myName.DateTime][data.import[,myName.Time]==""]
  #              ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- as.POSIXct(fun.df[
    ,ContData.env$myName.DateTime][is.na(fun.df[,myField])]
    ,format=myFormat,usetz=FALSE)
  #
  # old code just for reference
  # 5.5. Force Date and Time format
  #   data.import[,myName.Date] <- strftime(data.import[,myName.Date]
  # ,format="%Y-%m-%d")
  #   data.import[,myName.Time] <- as.POSIXct(data.import[,myName.Time]
  # ,format="%H:%M:%S")
  #   data.import[,myName.DateTime] <- strftime(data.import[,myName.DateTime]
  # ,format="%Y-%m-%d %H:%M:%S")
  #
  #
  # Create Month and Day Fields
  # month
  #     myField   <- "month"
  #     data.import[,myField] <- data.import[,myName.Date]
  #     myFormat  <- "%m"
  #     data.import[,myField][!is.na(data.import[,myName.Date])] <- strftime(
  # data.import[,myName.Date][!is.na(data.import[,myName.DateTime])]
  #                              ,format=myFormat,usetz=FALSE)
  fun.df[,ContData.env$myName.Mo] <- as.POSIXlt(fun.df$Date)$mon+1
  # day
  #     myField   <- "day"
  #     data.import[,myField] <- data.import[,myName.Date]
  #     myFormat.In  <- myFormat.Date #"%Y-%m-%d"
  #     myFormat.Out <- "%d"
  #     data.import[,myField][!is.na(data.import[,myField])] <- format(
  # strptime(data.import[,myField][!is.na(data.import[,myField])]
  # ,format=myFormat.In)
  #                         ,format=myFormat.Out)
  fun.df[,ContData.env$myName.Day] <- as.POSIXlt(fun.df$Date)$mday
  #
  #     # example of classes for POSIXlt
  #     Sys.time()
  #     unclass(as.POSIXlt(Sys.time()))
  #     ?DateTimeClasses
  #
  return(fun.df)
  #
}##FUNCTION.fun.QC.datetime.END
#
# check for offset data collection times
#
# Checks if data (e.g., air and water) are recorded at different timings (e.g.,
# air at 08:12 and water at 08:17).
# Checks for single data types.  Then if case-wise remove NA and have no records
#  Uses all data fields.
# Returns a boolean value (0=FALSE, no offset times or 1=TRUE, offset times).
# @param myDF data frame to check
# @param myDataType type of data (Air, Water, AW, Gage, AWG, AG, WG)
              #Removed 20170512.
# @param myFld.Data data fields to check
# @param myFld.DateTime date time field;
# defaults to ContData.env$myName.DateTime
# @return A boolean value (0=FALSE, no offset times or 1=TRUE, offset times).
# @keywords internal
# @examples
# myDF <- test4_AW_20160418_20160726
# myDataType <- "AW"
# myFld.Data <- names(myDF)[names(myDF) %in% ContData.env$myNames.DataFields]
# fun.OffsetCollectionCheck(myDF, myDataType, myFld.Data)
fun.OffsetCollectionCheck <- function(myDF
                                      , myFld.Data
                                      , myFld.DateTime =
                                             ContData.env$myName.DateTime) {
  ##FUNCTION.fun.OffsetCollectionCheck.START
  # Return value
  boo.return <- 0 #FALSE, no issue (default)
  # Skip if a single data type
  #if (tolower(myDataType) %in% c("air","water","gage") == FALSE) {##IF.START
    # data fields
    #myDataFields <- c("Water.BP.psi", "Water.Temp.C", "Air.BP.psi",
  # "Water.Level.ft", "Air.Temp.C" )
    myDF.NAomit <- as.data.frame(stats::na.omit(myDF[,myFld.Data]))
    if (nrow(myDF.NAomit)==0) {##IF.nrow.START
      boo.return <- 1 #TRUE, there is an issue
      #print("Offset collection times between data fields.  Need different
      # analysis routine for this data.")
      #utils::flush.console()
    }##IF.nrow.END
    #
  #}##IF.END
  #
  return(boo.return)
  #
}##FUNCTION.fun.OffsetCollectionCheck.END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# FUNCTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
# @param fun.myThresh.Gross.Suspect.Hi Pertinent QC threshold; Gross, Suspect
# , Hi
# @param fun.myThresh.Gross.Suspect.Lo Pertinent QC threshold; Gross, Suspect
# , Lo
# @param fun.myThresh.Spike.Hi Pertinent QC threshold; Spike, Fail, Hi
# @param fun.myThresh.Spike.Lo Pertinent QC threshold; Spike, Fail, Lo
# @param fun.myThresh.RoC.SD.period Pertinent QC threshold; Rate of Change
# , Standard Deviation, period
# @param fun.myThresh.RoC.SD.number Pertinent QC threshold; Rate of Change
# , Standard Deviation, number
# @param fun.myThresh.Flat.Hi Pertinent QC threshold; Flat, Hi
# @param fun.myThresh.Flat.Lo Pertinent QC threshold; Flat, Hi
# @param fun.myThresh.Flat.Tolerance Pertinent QC threshold; Flat, tolerance
# @return Returns a data frame to calling function
# @keywords continuous data, qc, quality control
# @examples
# #Not intended to be accessed independently.
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
                            ,fun.myThresh.Flat.Tolerance) {
  ##FUN.fun.CalcQCStats.START
  #
  # AA. Offset timing check ####
  # check for offset timing of Air and Water measurements, 20170509
  #fun.myData.Type should inherit from calling script
  # data fields present
  fun.myField.Data.ALL <- names(fun.data.import)[names(fun.data.import) %in%
                                              ContData.env$myNames.DataFields]
  boo.Offset <- fun.OffsetCollectionCheck(fun.data.import
                                          , fun.myField.Data.ALL
                                          , ContData.env$myName.DateTime)
  if(boo.Offset==TRUE) {##IF.boo.Offset.START
    # check time interval (na.omit removes all)
    df.check <- stats::na.omit(fun.data.import[,c(ContData.env$myName.DateTime
                                                  ,fun.myField.Data)])
    # convert from Character to time if necessary (not necessary)
    # if (is.character(df.check[,ContData.env$myName.DateTime])==TRUE){
    #   myFormat  <- ContData.env$myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    #   # df.check[,ContData.env$myName.DateTime] <- strftime(df.check[
    # ,ContData.env$myName.DateTime],
    #   #                                                     format=myFormat,
    #   #                                             tz=ContData.env$myTZ)
    # }
    #x <- df.check[,ContData.env$myName.DateTime]
    myT <- strptime(df.check[,ContData.env$myName.DateTime],format=
                      ContData.env$myFormat.DateTime)
    myTimeDiff.all <- difftime(myT[-1],myT[-length(myT)])
    myTimeDiff <- stats::median(as.vector(myTimeDiff.all),na.rm=TRUE)
    # create time series
    myTS <- seq(as.POSIXlt(min(myT)
                           ,tz=ContData.env$myTZ)
                ,as.POSIXlt(max(myT)
                            ,tz=ContData.env$myTZ),by="30 min")
                #by=paste0(myTimeDiff," min"))
    length(myTS)
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # remove other data fields (and extra times) before proceeding
    ### Fields to keep
    myFlds.Keep <- c(ContData.env$myName.SiteID
                     , ContData.env$myName.DateTime
                     , ContData.env$myName.Date
                     , ContData.env$myName.Time
                     , ContData.env$myName.Mo
                     , ContData.env$myName.Day
                     , ContData.env$myName.Yr
                     , fun.myField.Data
                     , paste0(ContData.env$myName.Flag, ".", fun.myField.Data))
    ### Modify the DF
    # keep only the relevant data field and remove all NA (case-wise)
    fun.data.import.mod <- stats::na.omit(fun.data.import[,myFlds.Keep])
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Check length.  If different add in extra times
    ## NA records would have been removed earlier
    if (length(myTS) != nrow(df.check)){##IF.length.START
      # add extra rows to new Time Series
      ts.alltimes <- as.data.frame(as.character(myTS))
      names(ts.alltimes) <- ContData.env$myName.DateTime
      # merge (works with datetime as character but not as a POSIX field)
      #df.check[,ContData.env$myName.DateTime] <- as.POSIXlt(df.check[
      # ,ContData.env$myName.DateTime],origin = "1900-01-01"
      # ,tz=ContData.env$myTZ)
      ts.alltimes.data <- merge(ts.alltimes
                                , fun.data.import.mod
                                , by = ContData.env$myName.DateTime)
      # use new df moving forward
      fun.data.import.mod <- ts.alltimes.data
    }##IF.length.END
    # then merge back at end
  } else {
    # rename fun.data.import (for non Offset)
    fun.data.import.mod <- fun.data.import
  }##IF.boo.Offset.END
  #~~~~~~~~~~~~~~
  # re-run boo.Offset at end to merge back into fun.data.import
  #~~~~~~~~~~~~~~
  #
  # A. Time Calculations ####
  # A.1. Calc, SD Time Interval
  myCalc <- "SD.Time"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  # calculate as separate variable
  #http://stackoverflow.com/questions/8857287/how-to-add-subtract-time-from-a-posixlt-time-while-keeping-its-class-in-r
  # myT will be a POSIXt object
  myT <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime]
                  ,format=ContData.env$myFormat.DateTime)
  myT$hour <- myT$hour - fun.myThresh.RoC.SD.period
  # add back to dataframe
  fun.data.import.mod[,myField] <- as.character(myT)
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
  #   #a <- fun.data.import.mod[,myName.WaterTemp]
  #   #b <- fun.data.import.mod[,myName.DateTime]
  #   #sd(a[b<="2014-04-22 10:00:00" & b>="2014-01-13 11:00:00"],na.rm=TRUE)
  #   #sd(a,na.rm=TRUE)
  #   #
  #   fun.data.import.mod[,myField] <- sd(fun.data.import.mod[,fun.myField.Data]
  # [fun.data.import.mod[,myName.DateTime]<="2014-04-22 10:00:00" &
  # fun.data.import.mod[,myName.DateTime]>="2014-01-13 11:00:00"],na.rm=TRUE)


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## zoo version with rollapply
  # need at least 5 records
  if(nrow(fun.data.import.mod)<5) {##IF.nrow.START
    myMsg <- paste("\n
                   The data file has less than 5 records.
                   The scripts will not work properly until you have more data."
                   ,sep="")
    stop(myMsg)
  }##IF.1.END
  # get interval distance (will crash if less than 5 records)
  # myT.diff <- difftime(fun.data.import.mod[5,ContData.env$myName.DateTime]
  #       ,fun.data.import.mod[4,ContData.env$myName.DateTime],units="mins")
  # myT.diff[[1]]
  # use median of all (no lower limit)
  #x <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime]
  #  ,format= ContData.env$myFormat.DateTime)
  #myT <- strptime(fun.data.import.mod[,ContData.env$myName.DateTime]
  # ,format=ContData.env$myFormat.DateTime)
  myT.diff.all <- difftime(myT[-1],myT[-length(myT)], units="mins")
  myT.diff <- stats::median(as.vector(myT.diff.all),na.rm=TRUE)
  # convert DateTime to POSIX object (already done above)
  #myT <- strptime(fun.data.import.mod[,myName.DateTime],format=
  # myFormat.DateTime)
  # A.2. Use data "as is"
  # create zoo object of data and date/time (use row num instead)
  zoo.data <- zoo::zoo(fun.data.import.mod[,fun.myField.Data]
                       ,seq(from=1
                            ,to=nrow(fun.data.import.mod)
                            ,by=1))  # works
  #
  # B. Rolling SD
  # time difference is in minutes and Threshold is in hours
  # "By" in rollapply goes by # of records not by a set time.
  RollBy <- fun.myThresh.RoC.SD.period/(myT.diff[[1]]/60)
  # right align says the previous 50
  # +1 is to include the record itself
  #RollSD <- rollapply(data=zoo.merge,width=RollBy+1,FUN=sd,na.rm=TRUE,fill=NA
  # ,align="right")
  RollSD <- zoo::rollapply(data=zoo.data
                           ,width=RollBy+1
                           ,FUN=stats::sd
                           ,na.rm=TRUE
                           ,fill=NA
                           ,align="right")
  # add to data frame
  fun.data.import.mod[,myField] <- RollSD
  # clean up
  rm(myT)
  rm(zoo.data)
  rm(RollSD)
  #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  #   #~~~~~~~~~~~~~
  #   # slow but works (~10 seconds for 5k records)
  #   # *******need to change to sapply***********
  #   for (m in 1:nrow(fun.data.import.mod)) {
  # #     print(m)
  # #     utils::flush.console()
  #     fun.data.import.mod[m,myField] <- sd(fun.data.import.mod[
  # ,fun.myField.Data][
  #         fun.data.import.mod[,myName.DateTime]<=fun.data.import.mod[m
  # ,myName.DateTime]
  #         & fun.data.import.mod[,myName.DateTime]>=fun.data.import.mod[m
  # ,myField.T1]
  #         ],na.rm=TRUE)
  #   }
  #   #
  # A.3. Calc, NxSD, SD * n.per
  myCalc.1 <- "SD"
  myCalc.2 <- "SDxN"
  myField.1 <- paste(fun.myField.Data,myCalc.1,sep=".")
  myField.2 <- paste(fun.myField.Data,myCalc.2,sep=".")
  fun.data.import.mod[,myField.2] <- fun.data.import.mod[,myField.1] *
    fun.myThresh.RoC.SD.number
  #
  # A.4. Calc, Diff (1:5) (5 is default but can be more)
  for (i in seq_len(ContData.env$myThresh.Flat.MaxComp)) {##FOR.i.START
    myCalc <- paste("n",i,sep=".")
    myField <- paste(fun.myField.Data,myCalc,sep=".")
    fun.data.import.mod[-(seq_len(i)),myField] <- diff(as.numeric(
      fun.data.import.mod[,fun.myField.Data]),lag=i)
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
  myFields.Match <- match(paste(fun.myField.Data
                                , "n"
                                , seq_len(myThresh)
                                , sep=".")
                          , names(fun.data.import.mod))
  # use rowSums to count the fields
  fun.data.import.mod[,myField] <- rowSums(abs(
    fun.data.import.mod[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
  #
  # A.6. Calc, flat.Lo, count if less than toler
  myCalc <- "flat.Lo"
  myField <- paste(fun.myField.Data,myCalc,sep=".")
  myThresh <- fun.myThresh.Flat.Lo
  # Fields to check
  myFields.Match <- match(paste(fun.myField.Data
                                , "n"
                                , seq_len(myThresh)
                                , sep=".")
                          , names(fun.data.import.mod))
  # use rowSums to count the fields
  fun.data.import.mod[,myField] <- rowSums(abs(
    fun.data.import.mod[,myFields.Match])<=fun.myThresh.Flat.Tolerance)
  #
  ## B. Generate Flags based on Calculation Fields ####
  # B.1. Gross
  myQCTest <- "Gross"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  # Assign Flags
  # default value
  fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
  # data is NA then flag = 9 (missing data)
  fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data]) ==
                                  TRUE] <- ContData.env$myFlagVal.NoData
  # different test for water level, only if negative
  if(fun.myField.Data==ContData.env$myName.SensorDepth) {
    ##IF.Gross.SensorDepth.START
    # data < 0 (i.e., negative) = 4 (fail)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] < 0] <-
      ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import.mod[,myField][fun.data.import.mod[, myField] ==
                                    ContData.env$myFlagVal.NotEval] <-
      ContData.env$myFlagVal.Pass
    # different test for discharge
  } else if(fun.myField.Data==ContData.env$myName.Discharge) {
    # data < 0 (i.e., negative) = 4 (fail)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] < 0] <-
      ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
                                    ContData.env$myFlagVal.NotEval] <-
      ContData.env$myFlagVal.Pass
  } else {
    # data >= Suspect.Hi then flag = 3 (suspect)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] >=
                                    fun.myThresh.Gross.Suspect.Hi] <-
      ContData.env$myFlagVal.Suspect
    # data <= Suspect.Lo then flag = 3 (Suspect)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] <=
                                    fun.myThresh.Gross.Suspect.Lo] <-
      ContData.env$myFlagVal.Suspect
    # data >= Fail.Hi then flag = 4 (fail)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] >=
                                    fun.myThresh.Gross.Fail.Hi] <-
      ContData.env$myFlagVal.Fail
    # data <= Fail.Lo then flag = 4 (fail)
    fun.data.import.mod[,myField][fun.data.import.mod[,fun.myField.Data] <=
                                    fun.myThresh.Gross.Fail.Lo] <-
      ContData.env$myFlagVal.Fail
    # otherwise flag = 1 (pass)
    fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
                                    ContData.env$myFlagVal.NotEval] <-
      ContData.env$myFlagVal.Pass
  }##IF.Gross.SensorDepth.END
  # QC
  #table(fun.data.import.mod[,myField])
  #
  # B.2. Spike
  myQCTest <- "Spike"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
  # Assign Flags
  # default value
  fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
  # diff 1 is NA then flag = 9 (missing data)
  fun.data.import.mod[,myField][is.na(fun.data.import.mod[,myField.Calc.1])==
                                  TRUE] <- ContData.env$myFlagVal.NoData
  # abs(diff 1) >= spike Lo then flag = 3 (suspect)
  fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) >=
                                  fun.myThresh.Spike.Lo] <-
    ContData.env$myFlagVal.Suspect
  # abs(diff 1) >= spike Hi then flag = 4 (fail)
  fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) >=
                                  fun.myThresh.Spike.Hi] <-
    ContData.env$myFlagVal.Fail
  # otherwise flag = 1 (pass)
  fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
                                  ContData.env$myFlagVal.NotEval] <-
    ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import.mod[,myField])
  #
  # B.3. RoC
  myQCTest <- "RoC"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"n",1,sep=".")
  myField.Calc.2 <- paste(fun.myField.Data,"SDxN",sep=".")
  # Assign Flags
  # default value
  fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
  # data is NA then flag = 9 (missing data)
  fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data])==
                                  TRUE] <- ContData.env$myFlagVal.NoData
  # sd is NA then flag = 9 (missing data)
  fun.data.import.mod[,myField][is.na(fun.data.import.mod[,myField.Calc.1])==
                                  TRUE] <- ContData.env$myFlagVal.NoData
  # diff 1 > SD*N then flag = 3 (suspect)
  fun.data.import.mod[,myField][abs(fun.data.import.mod[,myField.Calc.1]) >
                                  fun.data.import.mod[,myField.Calc.2]] <-
    ContData.env$myFlagVal.Suspect
  # otherwise flag = 1 (pass) [no 4/Fail]
  fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
                                  ContData.env$myFlagVal.NotEval] <-
    ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import.mod[,myField])
  #
  # B.4. Flat
  myQCTest <- "Flat"
  myField <- paste("Flag",myQCTest,fun.myField.Data,sep=".")
  myField.Calc.1 <- paste(fun.myField.Data,"flat.Hi",sep=".")
  myField.Calc.2 <- paste(fun.myField.Data,"flat.Lo",sep=".")
  # default value
  fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
  # Lo >= Thresh.Lo = 3 (suspect)
  fun.data.import.mod[,myField][fun.data.import.mod[,myField.Calc.2] >=
                                  fun.myThresh.Flat.Lo] <-
    ContData.env$myFlagVal.Suspect
  # Hi >= Thresh.Hi = 4 (fail)
  fun.data.import.mod[,myField][fun.data.import.mod[,myField.Calc.1] >=
                                  fun.myThresh.Flat.Hi] <-
    ContData.env$myFlagVal.Fail
  # otherwise flag = 1 (pass)
  fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
                                  ContData.env$myFlagVal.NotEval] <-
    ContData.env$myFlagVal.Pass
  # QC
  #table(fun.data.import.mod[,myField])
  #
  #
  # C. Assign Overall Data Flag ####
  myField <- paste(ContData.env$myName.Flag,fun.myField.Data,sep=".")
  #myNames.QCTests
  # get column numbers (match) for QCTest Flags for this data
  myFields.Match <- match(paste("Flag"
                                ,ContData.env$myNames.QCTests
                                ,fun.myField.Data
                                ,sep=".")
                          , names(fun.data.import.mod))
  # Conditional rowSums for number of flag fields with specified flags
  myFlags.Num.Pass    <- rowSums(fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.Pass)
  myFlags.Num.Suspect <- rowSums(fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.Suspect )
  myFlags.Num.Fail    <- rowSums(fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.Fail)
  myFlags.Num.Missing <- rowSums(fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.NoData)
  myFlags.Num.OK      <- rowSums(fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.Pass |
                                   fun.data.import.mod[,myFields.Match]==
                                   ContData.env$myFlagVal.NoData)
  # Assign
  # default value
  fun.data.import.mod[,myField] <- ContData.env$myFlagVal.NotEval
  # any QC Test flags = 3 then flag = 3 (suspect)
  fun.data.import.mod[,myField][myFlags.Num.Suspect > 0] <-
    ContData.env$myFlagVal.Suspect
  # any QC Test flags = 4 then flag = 4 (fail)
  fun.data.import.mod[,myField][myFlags.Num.Fail > 0] <-
    ContData.env$myFlagVal.Fail
  # all QC Test flags = 1 then flag = 1 (pass)
  fun.data.import.mod[,myField][myFlags.Num.Pass ==
                                  length(ContData.env$myNames.QCTests)] <-
    ContData.env$myFlagVal.Pass
  # all QC Test flags = 1 or 9 then flag = 1 (pass)
  fun.data.import.mod[,myField][myFlags.Num.OK ==
                                  length(ContData.env$myNames.QCTests)] <-
    ContData.env$myFlagVal.Pass
  #fun.data.import.mod[,myField][fun.data.import.mod[,myField]==
  # myFlagVal.NotEval] <- myFlagVal.Pass
  # data is NA then flag = 9 (missing data)
  fun.data.import.mod[,myField][is.na(fun.data.import.mod[,fun.myField.Data])==
                                  TRUE] <- ContData.env$myFlagVal.NoData
  # QC
  #table(fun.data.import.mod[,myField])


  #
  # D. Clean Up ####
  # D.1. Remove QC Calc fields
  # #myNames.QCCalcs <- c("SD.Time","SD","SDxN","n.1","n.2","n.3","n.4","n.5"
  # ,"flat.Lo","flat.Hi")
  # #ContData.env$myNames.QCCalcs <- c("SD.Time","SD","SDxN",paste("n"
  # ,1:ContData.env$myThresh.Flat.MaxComp,sep="."),"flat.Lo","flat.Hi")
  # # get field column numbers
  # myFields.Match <- match(paste(fun.myField.Data,ContData.env$myNames.QCCalcs
  # ,sep="."), names(fun.data.import.mod))
  # # drop fields from data table
  # fun.data.import.mod <- fun.data.import.mod[,-na.omit(myFields.Match)]
  # ~~~~~ Keep new "flag" fields (20170515)
  # Flag Fields (myField is current Flag.Parameter)
  FlagFields.Keep <- c(myField, paste(ContData.env$myName.Flag
                                      ,ContData.env$myNames.QCTests
                                      ,fun.myField.Data
                                      ,sep="."))
  myFields.Drop <- match(paste(fun.myField.Data
                               ,ContData.env$myNames.QCCalcs
                               ,sep=".")
                         , names(fun.data.import.mod))
  fun.data.import.mod <- fun.data.import.mod[, -stats::na.omit(myFields.Drop)]
  #
  # D.2. Offset Timing Fix
  ## Return a merged file if Offset is TRUE
  if(boo.Offset==TRUE) {##IF.boo.Offset.START
    # removed other data fields (and extra times) before above
    # merge back
    # all fields modified = ?????
    #Fld.Mod <- c(ContData.env$myName.DateTime, fun.myField.Data)
    # get fields added (20170512, add in Flag.Param)
    Fld.Flag.Param <- match(myField, names(fun.data.import))
    Fld.New <- names(fun.data.import.mod)[names(fun.data.import.mod) %in%
                                            names(fun.data.import)[
                                              -Fld.Flag.Param]==FALSE]
    # merge on date time
    DF.Return <- merge(fun.data.import[,-Fld.Flag.Param]
                       , fun.data.import.mod[
                         ,c(ContData.env$myName.DateTime, Fld.New)],
                       by=ContData.env$myName.DateTime
                       , all.x=TRUE)
  } else {
    DF.Return <- fun.data.import.mod
  }##IF.boo.Offset.END
  #
  #
  # E. Function output ####
  return(DF.Return)
  #
}##FUN.fun.QC.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fun.DateTime.groupby.first ----
fun.DateTime.GroupBy.First <- function(df){
  #
  check_rows <- nrow(df) == length(unique(df[, ContData.env$myName.DateTime]))
  #
  if(check_rows == FALSE){
    # create first function
    first <- function(x) {
      if (length(x) == 1)
        return(x)
      return(x[1])
    }## FUNCTION ~ first ~ END
    #
    df_mod <- stats::aggregate(df
                              , by=list(df[, ContData.env$myName.DateTime])
                              , FUN=first)
    # drop column 1 (added by aggregate)
    df_mod <- df_mod[, -1]
    return(df_mod)
  } else {
    return(df)
  }## IF ~ check_rows ~ END
  #
}## FUN ~ fun.DateTime.GroupBy.First ~ END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# t-test with extras
# http://www.sthda.com/english/wiki/
#                          t-test-analysis-is-it-always-correct-to-compare-means
# 2021-01-25
#' @title Rquery T-Test
#'
#' @description Performs one or two samples t-test
#'
#' @details
#' 1. shapiro.test is used to check normality
#' 2. F-test is performed to check equality of variances
#'  If the variances are different, then Welch t-test is used
#'
#' @param x a (non-empty) numeric vector of data values.
#' @param y an optional (non-empty) numeric vector of data values
#' @param paired : if TRUE, paired t-test is performed
#' @param graph : if TRUE, the distribution of the data is shown for the
#' inspection of normality
#' @param ... : further arguments to be passed to the built-in t.test()
#' R function
#'
#' @return
#'
#' @export
rquery.t.test<-function(x, y = NULL, paired = FALSE, graph = TRUE, ...)
{
  # I. Preliminary test : normality and variance tests
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  var.equal = FALSE # by default

  # I.1 One sample t test
  if(is.null(y)){
    if(graph) par(mfrow=c(1,2))
    shapiro.px<-normaTest(x, graph,
                          hist.title="X - Histogram",
                          qq.title="X - Normal Q-Q Plot")
    if(shapiro.px < 0.05)
      warning("x is not normally distributed :",
              " Shapiro-Wilk test p-value : ", shapiro.px,
              ".\n Use a non-parametric test like Wilcoxon test.")
  }

  # I.2 Two samples t test
  if(!is.null(y)){

    # I.2.a unpaired t test
    if(!paired){
      if(graph) par(mfrow=c(2,2))
      # normality test
      shapiro.px<-normaTest(x, graph,
                            hist.title="X - Histogram",
                            qq.title="X - Normal Q-Q Plot")
      shapiro.py<-normaTest(y, graph,
                            hist.title="Y - Histogram",
                            qq.title="Y - Normal Q-Q Plot")
      if(shapiro.px < 0.05 | shapiro.py < 0.05){
        warning("x or y is not normally distributed :",
                " Shapiro test p-value : ", shapiro.px,
                " (for x) and ", shapiro.py, " (for y)",
                ".\n Use a non parametric test like Wilcoxon test.")
      }
      # Check for equality of variances
      if(var.test(x,y)$p.value >= 0.05) var.equal=TRUE
    }

    # I.2.b Paired t-test
    else {
      if(graph) par(mfrow=c(1,2))
      d = x-y
      shapiro.pd<-normaTest(d, graph,
                            hist.title="D - Histogram",
                            qq.title="D - Normal Q-Q Plot")
      if(shapiro.pd < 0.05 )
        warning("The difference d ( = x-y) is not normally distributed :",
                " Shapiro-Wilk test p-value : ", shapiro.pd,
                ".\n Use a non-parametric test like Wilcoxon test.")
    }

  }

  # II. Student's t-test
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  res <- t.test(x, y, paired=paired, var.equal=var.equal, ...)
  return(res)
}## FUNCTION ~ rquery.t.test ~ END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# http://www.sthda.com/english/wiki/
#                          t-test-analysis-is-it-always-correct-to-compare-means
#+++++++++++++++++++++++
# Helper function
#+++++++++++++++++++++++
# Performs normality test using Shapiro Wilk's method
# The histogram and Q-Q plot of the data are plotted
# x : a (non-empty) numeric vector of data values.
# graph : possible values are TRUE or FALSE. If TRUE,
# the histogram and the Q-Q plot of the data are displayed
# hist.title : title of the histogram
# qq.title : title of the Q-Q plot
normaTest<-function(x, graph=TRUE,
                    hist.title="Histogram",
                    qq.title="Normal Q-Q Plot",...)
{
  # Significance test
  #++++++++++++++++++++++
  shapiro.p<-signif(shapiro.test(x)$p.value,1)

  if(graph){
    # Plot : Visual inspection
    #++++++++++++++++
    h<-hist(x, col="lightblue", main=hist.title,
            xlab="Data values", ...)
    m<-round(mean(x),1)
    s<-round(sd(x),1)
    mtext(paste0("Mean : ", m, "; SD : ", s),
          side=3, cex=0.8)
    # add normal curve
    xfit<-seq(min(x),max(x),length=40)
    yfit<-dnorm(xfit,mean=mean(x),sd=sd(x))
    yfit <- yfit*diff(h$mids[1:2])*length(x)
    lines(xfit, yfit, col="red", lwd=2)
    # qq plot
    qqnorm(x, pch=19, frame.plot=FALSE,main=qq.title)
    qqline(x)
    mtext(paste0("Shapiro-Wilk, p-val : ", shapiro.p),
          side=3, cex=0.8)
  }
  return(shapiro.p)
}## FUNCTION ~ normaTest ~ END

