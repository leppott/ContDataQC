# Helper Functions
##################
# Erik.Leppo@tetratech.com (EWL)
# 20150805
##################


# functions

## for informing user of progress
#' @export
fun.Msg.Status <- function(fun.status, fun.item.num.current, fun.item.num.total, fun.item.name) { ## FUNCTION.START
  print(paste("Processing item ",fun.item.num.current," of ",fun.item.num.total,", ",fun.status,", ",fun.item.name,".",sep=""))
} ## FUNCTION.END 

## write log file
#' @export
fun.write.log <- function(fun.Log,fun.Date,fun.Time) {#FUNCTION.START
  write.table(fun.Log,file=paste("LOG.Items.",fun.Date,".",fun.Time,".tab",sep=""),sep="\t",row.names=FALSE,col.names=TRUE)
}#FUNCTION.END

## QC check for variables in data (20160204)
# referenced in calling script right after data is imported.
# Required fields: myName.SiteID & (myName.DateTime | (myName.Date & myName.Time))
#' @export
fun.QC.ReqFlds <- function(fun.names,fun.File) {##FUNCTION.fun.QC.ReqFlds.START
  #### QC
#   fun.names <- names(data.import)
#   fun.File <- paste(myDir.data.import,strFile,sep="/")
  #####
  # SiteID
  if(myName.SiteID%in%fun.names==FALSE) {##IF.1.START
    myMsg <- paste("\n
      The SiteID column name (",myName.SiteID,") is mispelled or missing from your data file. 
      The scripts will not work properly until you change the SiteID variable 'myName.SiteID' in the script 'UserDefinedValue.R' or modify your file.
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
  if(myName.DateTime%in%fun.names==FALSE & (myName.Date%in%fun.names==FALSE | myName.Time%in%fun.names==FALSE)) {##IF.2.START
    myMsg <- paste("\n
      The DateTime (",myName.DateTime,") and/or Date (",myName.Date,") and/or Time (",myName.Time,") column names are mispelled or missing from your data file.
      Either 'Date.Time' or both of 'Date' and 'Time' are required.
      The scripts will not work properly until you change the variables 'myName.DateTime' and/or 'myName.Date' and/or 'myName.Time' in the script 'UserDefinedValue.R' or modify your file.
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

## QC check of date and time fields (20170115)
# Excel can mess up date formats in CSV files even when don't intentionally change.
# borrow code from fun.QC.R, fun.QC, step 5 ~ line 245
# Access this code after QC for the date and time fields in the Aggregate and Summary Operations
# takes as input a data frame and returns it with changes
###
# QC
#fun.df <- data.import
######
#' @export
fun.QC.datetime <- function(fun.df){##FUNCTION.fun.QC.datetime.START
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
  myField   <- myName.Date
  fun.df[,myField][all(is.na(fun.df[,myField]))] <- fun.df[,myName.DateTime]
  # Time
  myField   <- myName.Time
  fun.df[,myField][all(is.na(fun.df[,myField]))] <- fun.df[,myName.DateTime]
  # DateTime
  #myField   <- myName.DateTime
  # can't fill fill from others without knowing the format
  #
  # get current file date/time records so can set format
  # Function below gets date or time format and returns R format
  # date_time is split and then pasted together.
  # if no AM/PM then 24hr time is assumed
  format.Date     <- fun.DateTimeFormat(fun.df[,myName.Date],"Date")
  format.Time     <- fun.DateTimeFormat(fun.df[,myName.Time],"Time")
  #format.DateTime <- fun.DateTimeFormat(data.import[,myName.DateTime],"DateTime")
  # get error if field is NA, need to fix
  # same for section below
  #
  # 20160322, new section, check for NA and fill if needed
  if (length(na.omit(fun.df[,myName.DateTime]))==0){##IF.DateTime==NA.START
    # move 5.2.1 up here
    myField   <- myName.DateTime
    myFormat  <- myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(data.import[,myName.Date][data.import[,myField]==""]
    #                                                                       ,data.import[,myName.Time][data.import[,myField]==""],sep="")
    #                                                                 ,format=myFormat,usetz=FALSE)
    fun.df[,myField][is.na(fun.df[,myField])] <- strftime(paste(fun.df[,myName.Date][is.na(fun.df[,myField])]
                                                                          ,fun.df[,myName.Time][is.na(fun.df[,myField])]
                                                                          ,sep=" ")
                                                                    ,format=myFormat,usetz=FALSE)
  }##IF.DateTime==NA.START
  format.DateTime <- fun.DateTimeFormat(fun.df[,myName.DateTime],"DateTime")
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
  myField   <- myName.Date
  myFormat.In  <- format.Date #"%Y-%m-%d"
  myFormat.Out <- myFormat.Date #"%Y-%m-%d"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(strptime(fun.df[,myField][!is.na(fun.df[,myField])],format=myFormat.In)
                                                                 ,format=myFormat.Out)
  # 5.1.2. Update Time to "%H:%M:%S" (equivalent to %T) (uses different function)
  myField   <- myName.Time
  myFormat.In  <- format.Time #"%H:%M:%S"
  myFormat.Out <- myFormat.Time #"%H:%M:%S"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(as.POSIXct(fun.df[,myField][!is.na(fun.df[,myField])],format=myFormat.In)
                                                                 ,format=myFormat.Out)
  # 5.1.3. Update DateTime to "%Y-%m-%d %H:%M:%S" (equivalent to %F %T)
  myField   <- myName.DateTime
  myFormat.In  <- format.DateTime #"%Y-%m-%d %H:%M:%S"
  myFormat.Out <- myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
  fun.df[,myField][!is.na(fun.df[,myField])] <- format(strptime(fun.df[,myField][!is.na(fun.df[,myField])],format=myFormat.In)
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
  myField   <- myName.DateTime
  myFormat  <- myFormat.DateTime #"%Y-%m-%d %H:%M:%S"
  #   data.import[,myField][data.import[,myField]==""] <- strftime(paste(data.import[,myName.Date][data.import[,myField]==""]
  #                                                                       ,data.import[,myName.Time][data.import[,myField]==""],sep="")
  #                                                                 ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- strftime(paste(fun.df[,myName.Date][is.na(fun.df[,myField])]
                                                                        ,fun.df[,myName.Time][is.na(fun.df[,myField])]
                                                                        ,sep=" ")
                                                                  ,format=myFormat,usetz=FALSE)
  # 5.2.2. Update Date if NA (use Date_Time)
  myField   <- myName.Date
  myFormat  <- myFormat.Date #"%Y-%m-%d"
  #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Date]==""]
  #                                                               ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- strftime(fun.df[,myName.DateTime][is.na(fun.df[,myField])]
                                                                  ,format=myFormat,usetz=FALSE)
  # 5.2.3. Update Time if NA (use Date_Time)
  myField   <- myName.Time
  myFormat  <- myFormat.Time #"%H:%M:%S"
  #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Time]==""]
  #                                                               ,format=myFormat,usetz=FALSE)
  fun.df[,myField][is.na(fun.df[,myField])] <- as.POSIXct(fun.df[,myName.DateTime][is.na(fun.df[,myField])]
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
  fun.df[,"month"] <- as.POSIXlt(fun.df$Date)$mon+1
  # day
  #     myField   <- "day"
  #     data.import[,myField] <- data.import[,myName.Date]
  #     myFormat.In  <- myFormat.Date #"%Y-%m-%d"
  #     myFormat.Out <- "%d"
  #     data.import[,myField][!is.na(data.import[,myField])] <- format(strptime(data.import[,myField][!is.na(data.import[,myField])],format=myFormat.In)
  #                                                                    ,format=myFormat.Out)
  fun.df[,"day"] <- as.POSIXlt(fun.df$Date)$mday
  #
  #     # example of classes for POSIXlt
  #     Sys.time()
  #     unclass(as.POSIXlt(Sys.time()))
  #     ?DateTimeClasses
  #
  return(fun.df)
  #
}##FUNCTION.fun.QC.datetime.END
