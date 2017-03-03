#' Date Format (wrapper)
#' 
#' Input a date/time string and output R date/time *format*. The format can then be used to convert to a different format. 
#' Determine Date and Time *format* from input (single record) using Perl regular expresions.
#' Perl Code prepared by Ann Roseberry Lincoln
#' Not all possible formats recognized but the most common are accepted.
#' If AM/PM is left off them assume 24 hr time.
#
# Written August 05, 2015
# perl version 5.16.3
# R version, Erik.Leppo@tetratech.com, 20150806
#
# 20170115, EWL, replace "NA" with NA (can happen with Excel)
#########################################################
#' @param fun.DateTime Date, Time, or DateTime data
#' @param fun.dt.Type type of input; date, time, or date
#' @return Returns a text string representing the date/time format of the input fun.DateTime.  Wrapper function for fun.dt.Type2().
#' @keywords date, time, datetime, format
#' @examples
#' #Not intended to be accessed indepedantly.
#' #format of current date
#' fun.DateTimeFormat(Sys.Date(),"date")
#' fun.DateTimeFormat(Sys.time(),"datetime")
#
# # QC
#  fun.DateTime <- data.import[,myName.Time] 
#  fun.dt.Type <- "time"
#' @export
fun.DateTimeFormat <- function(fun.DateTime,fun.dt.Type) { ##FUN.START
  # convert datetime type to lower case and stop function if not supplied
  fun.dt.Type <- tolower(fun.dt.Type)
  if(fun.dt.Type!="date" & fun.dt.Type!="time" & fun.dt.Type!="datetime") {
    stop("No date or time type supplied (date, time, datetime)")
  }
  #
  # default result value
  #myFormat.Result <- NA
  myResult <- NA
  #
  # Prep Data
  # Remove NA
  dt <- na.omit(fun.DateTime)
  # Remove white space (leading and trailing)
  dt <- trimws(fun.DateTime,"both")
  #
  #
  # check for white space in date time then split into date and time else is date or time
  # runs a subroutine for date or time to get format.
  if(grepl("\\s+",dt[1],perl=TRUE)==TRUE){##IF.grepl.ws.START  
    #
    # delimit date_time into Date and Time based on white space
    ## some internet searches for ideas
    ###  http://stackoverflow.com/questions/19959697/split-string-by-final-space-in-r
    ### http://stackoverflow.com/questions/8299978/splitting-a-string-on-the-first-space
#     #
#     dt.split.datetime <- do.call(rbind,strsplit(dt,pattern.delim.white,perl=TRUE))
#     head(dt.split.datetime)
#     #
#     # http://stackoverflow.com/questions/8299978/splitting-a-string-on-the-first-space
#     pattern.delim.white <- "^(\\.+)\\s?(.*)$"
#     dt.split.date <- as.vector(sub(pattern.delim.white,"\\1",dt,perl=TRUE))
#     dt.split.time <- as.vector(sub(pattern.delim.white,"\\2",dt,perl=TRUE))

#     dt.split <- strsplit(dt,pattern.delim.white,perl=TRUE) 
#     dt.split.date <- unlist(lapply(dt.split, `[[`,1)) #date, all 1st element, and change to vector (unlist)
#     dt.split.time <- unlist(lapply(dt.split, `[[`,2)) #time, all 2nd element, and change to vector (unlist)
#     dt.split.datetime <- cbind(dt.split.date,dt.split.time)
    pattern.delim.white <- "\\s+" #will split out AM/PM if present as catches every white space
    dt.split.datetime <- as.data.frame(do.call(rbind,strsplit(dt,pattern.delim.white,perl=TRUE))) #create data frame from split
    # if AM/PM will have 3 columns so make col names appropriate
    if(ncol(dt.split.datetime)==3) {##IF.ncol.START
      # make new field
      dt.split.datetime[,4] <- paste(dt.split.datetime[,2],dt.split.datetime[,3],sep=" ")
      # rename
      names(dt.split.datetime) <- c("date","time1","time2","time")
    } else {
      names(dt.split.datetime) <- c("date","time")
    }##IF.ncol.END
    #
    # QC
    head(dt.split.datetime)
    #
    # Run date and time separate and combine formats
    myResult.d <- fun.dt.Type2(dt.split.datetime[,"date"],"date")
    myResult.t <- fun.dt.Type2(dt.split.datetime[,"time"],"time")
    myResult <- paste(myResult.d,myResult.t,sep=" ")
    #
  } else {
    myResult <- fun.dt.Type2(dt,fun.dt.Type)
    
  }##IF.grepl.ws.END  
  #
  # return format
  return(myResult)  #NA declared as default value at start
  #
} ##FUN.END

################################################################
# 2nd function to get the format for date or time (feeds 1st function)
###############################################################
#' Date Format (function)
#' @param fun.dt Date, Time, or DateTime data
#' @param fun.dt2.Type type of input; date, time, or date
#' @return Returns a text string representing the date/time format of the input fun.dt.  Wrapped in function fun.DateTimeFormat().
#' @keywords date, time, datetime, format
#' @examples
#' #Not intended to be accessed indepedant of function "fun.DateTimeFormat()".
#' fun.dt.Type2(Sys.Date(),"date")
#
# # QC
# fun.dt <- dt
# fun2.dt.Type <- fun.dt.Type
#' @export
fun.dt.Type2 <- function(fun.dt, fun2.dt.Type) {##FUN.fun.dt.Type.START
  # get format of date or time, uses a single value
  #
  # 20170115, replace "NA" with NA
  #fun.dt[fun.dt=="NA"] <- NA
  #
  ## grab a single value 
  ## declare possible formats (R) and patterns (Perl regular expressions)
  ## compare input data to each pattern and return R format
  if(fun2.dt.Type=="date") {##IF.fun2.dt.Type.START
    dt2 <- fun.dt[1] # get first value
    # Declare formats and patterns
    #
    fd01 <- "%Y-%m-%d" # YYYY-MM-DD, 2015-08-05
    pd01 <- "^(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)"
    #
    fd02 <- "%Y/%m/%d" # YYYY/MM/DD, 2015/08/05 (2 digit M and D)
    pd02 <- "^(\\d\\d\\d\\d)/(\\d\\d)/(\\d\\d)"
    #
    fd03 <- "%d-%b-%y" # DD-MMM-YY, 05-AUG-15 (upper or lower case) (1 or 2 digit D and 2 digit year)
    pd03 <- "^(\\d{1,2})-(\\w\\w\\w)-(\\d{2,4})"
    #
    fd04 <- "%d-%b-%Y" # DD-MMM-YYYY, 05-AUG-2015 (upper or lower case) (1 or 2 digit D and 4 digit year)
    pd04 <- "^(\\d{1,2})-(\\w\\w\\w)-(\\d\\d\\d\\d)"
    # 
    fd05 <- "%m-%d-%Y" # MM-DD-YYYY, 08-05-2015 (1 or 2 digit M and D)
    pd05 <- "^(\\d{1,2})-(\\d{1,2})-(\\d\\d\\d\\d)"
    #
    fd06 <- "%m/%d/%Y" # MM/DD/YYYY, 08-05-2015 (1 or 2 digit M and D)
    pd06 <- "^(\\d{1,2})/(\\d{1,2})/(\\d\\d\\d\\d)"
    #
    # check each pattern
    myFormats <- c(fd01,fd02,fd03,fd04,fd05,fd06)
    myPatterns <- c(pd01,pd02,pd03,pd04,pd05,pd06)
    # cycle through each pattern
    for (i in 1:length(myFormats)){##FOR.i.Date
      if(grepl(myPatterns[i],dt2,perl=TRUE)==TRUE){
        myFormat.Result <- myFormats[i]
        break #stop after first match
      }  
    }##FOR.i.Date
    #       if(grepl(p01,dt,perl=TRUE)==TRUE){
    #         myFormat <- f01
    #       }else if(grepl(p02,dt,perl=TRUE)==TRUE) {
    #         myFormat <- f02
    #       }else if(grepl(p03,dt,perl=TRUE)==TRUE) {
    #         myFormat <- f03
    #       }else if(grepl(p04,dt,perl=TRUE)==TRUE) {
    #         myFormat <- f04
    #       }else if(grepl(p05,dt,perl=TRUE)==TRUE) {
    #         myFormat <- f05
    #       }else if(grepl(p06,dt,perl=TRUE)==TRUE) {
    #         myFormat <- f06
    #       } else {
    #         myFormat <- "Unknown" #read in calling script
    #       }
    #
  }else if(fun2.dt.Type=="time"){
    #
    # 20170115, replace "NA" with NA
    fun.dt[fun.dt=="NA"] <- NA
    #
    dt2 <- toupper(sort(fun.dt,decreasing=TRUE,na.last=NA))[1]  #get the highest value (so can see if use 24hr time) (make upper case)
    # 20170116, default is to remove NA.  Added step at beginning to replace "NA" with NA
    #
    # Declare formats and patterns
    #
    # check for AM/PM and 13-24 (is no AM/PM then assume is 24hr time)
    # with and without seconds
    #
    # HH:MM:SS AM/PM
    pt01 <- "^(\\d{1,2}):(\\d\\d):(\\d\\d) (AM|PM)"
    ft01 <- "%I:%M:%S %p"   
    # HH:MM AM/PM
    pt02 <- "^(\\d{1,2}):(\\d\\d) (AM|PM)"
    ft02 <- "%I:%M %p"
    # HH:MM:SS (no AM/PM so assume 24hr time)
    pt03 <- "^(\\d{1,2}):(\\d\\d):(\\d\\d)"
    ft03 <- "%H:%M:%S"
    # HH:MM (no AM/PM so assume 24hr time)
    pt04 <- "^(\\d{1,2}):(\\d\\d)"
    ft04 <- "%H:%M"
    #
    # match longer patterns first
    #
    # check each pattern
    myFormats <- c(ft01,ft02,ft03,ft04)
    myPatterns <- c(pt01,pt02,pt03,pt04)
    # cycle through each pattern
    for (i in 1:length(myFormats)){##FOR.i.Date
      if(grepl(myPatterns[i],dt2,perl=TRUE)==TRUE){
        myFormat.Result <- myFormats[i]
        break #stop after first match
      }  
    }##FOR.i.Date
    #
  }##IF.fun2.dt.Type.END
  #
  return(myFormat.Result)
  #
}##FUN.fun.dt.Type.END




################################################################################
# testing stuff
################################################################################ 


# time hh:mm:ss

# time HH:MM am/pm

# time HH:MM:SS am/pm

# # YYYY-MM-DD
# p1 <- "~ /(\\d+)-(\\d+)-(\\d+)"
# p2 <- "^(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)"
# (x <- grepl(p2,"2015-08-05",perl=TRUE))
# 
# 
# d11 <- "2015-08-05"
# d12 <- "8/5/2015"
# d13 <- "8/5/15 10:13:24 PM"
# 
# d1 <- "Wed, Aug 5, 2015"
# d2 <- "8/5/2015"
# d3 <- "2015-8-5"
# d4 <- "5-Aug-2015"
# d5 <- "Aug-5"

# input is single value or vector
# user declares "Date", "Time", or "DateTime"

# #pattern.1 <- "^(((((0[13578])|([13578])|(1[02]))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\-\/\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\-\/\s]?\d{4})(\s(((0[1-9])|([1-9])|(1[0-2]))\:([0-5][0-9])((\s)|(\:([0-5][0-9])\s))([AM|PM|am|pm]{2,2})))?$"
# pattern.1 <- "^(((((0[13578])|([13578])|(1[02]))[\\-\\/\\s]?((0[1-9])|([1-9])|([1-2][0-9])|(3[01])))|((([469])|(11))[\\-\\/\\s]?((0[1-9])|([1-9])|([1-2][0-9])|(30)))|((02|2)[\\-\\/\\s]?((0[1-9])|([1-9])|([1-2][0-9]))))[\\-\\/\\s]?\\d{4})(\\s(((0[1-9])|([1-9])|(1[0-2]))\\:([0-5][0-9])((\\s)|(\\:([0-5][0-9])\\s))([AM|PM|am|pm]{2,2})))?$"
# #http://regexlib.com/DisplayPatterns.aspx?cattabindex=4&categoryId=5
# #
# #pattern.2 <- "/^((0?[13578]|10|12)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[01]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1}))|(0?[2469]|11)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[0]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1})))$/gm"
# pattern.2 <- "/^((0?[13578]|10|12)(-|\\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[01]?))(-|\\/)((19)([2-9])(\\d{1})|(20)([01])(\\d{1})|([8901])(\\d{1}))|(0?[2469]|11)(-|\\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[0]?))(-|\\/)((19)([2-9])(\\d{1})|(20)([01])(\\d{1})|([8901])(\\d{1})))$/gm"
# #http://www.regextester.com/6
# #Match dates (M/D/YY, M/D/YYY, MM/DD/YY, MM/DD/YYYY)
# #
# #http://www.regular-expressions.info/dates.html
# # YYYY-MM-DD
# pattern.3 <- "^(19|20)\\\\d\\\\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$"
# #
# # mm/dd/yyyy
# pattern.4 <- "^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\\d\\d$."
# # have to escape back slashes with a 2nd backslash.
# #
# #
# # Ann
# # This works with comma-using formats (Wed, Aug 5, 2015 or Aug. 5, 2015), with or without a period
# #print "Date is of a format like Day, Month DD, YYYY\n";
# frmt1 <- ""
# pat1 <- "~ /^\\w*\\.?,\\s(\\w*\\.?)\\s(\\d{1,2}),\\s(\\d{2,4})\\s?(\\d{0,2}):?(\\d{0,2}):?(\\d{0,2})\\s?(\\w{0,2})$/"
# # This works for 8/5/2015, 8-5-2015
# #print "Date is of a format like MM/DD/YYYY or MM-DD-YYYY\n";
# frmt2 <- "%m-%d-%Y"
# pat2 <- "~ /^(\\d{1,2})[\\/|-|\\s](\\d{1,2})[\\/|-|\\s](\\d{2,4})\\s?(\\d{0,2}):?(\\d{0,2}):?(\\d{0,2})\\s?(\\w{0,2})/ "
# # This works for 2015-8-5, 2015/08/05 (NO 2-digit years)
# #print "Date is of a format like YYYY/MM/DD or YYYY-MM-DD\n";
# frmt3 <- ""
# pat3 <- "~ /^(\\d{4})[\\/|-](\\d{1,2})[\\/|-](\\d{1,2})\\s?(\\d{0,2}):?(\\d{0,2}):?(\\d{0,2})\\s?(\\w{0,2})/ "
# # This works for 5-Aug-2015 and 05 Aug 2015
# #print "Date is of a format like DD-MMM-YYYY\n";
# frmt4 <- ""
# pat4 <- "~ /^(\\d{1,2})\\s?-?(\\w*)\\s?-?(\\d{2,4})\\s?(\\d{0,2}):?(\\d{0,2}):?(\\d{0,2})\\s?(\\w{0,2})$/"
# # This works for Aug-5
# #print "Date is of a format like Month-DD\n";
# frmt5 <- "%b-%d"
# pat5 <- "~ /^(\\w*)[\\s|-](\\d{1,2})\\s?(\\d{0,2}):?(\\d{0,2}):?(\\d{0,2})\\s?(\\w{0,2})$/"











