#' @title Daily stats for a given data file
#'
#' @description Generates daily stats (N, mean, min, max, range, std deviation)
#' for the specified time period before a given date. Output is a multiple
#' column CSV (Date and Parameter Name by statistic) and a report (HTML or DOCX)
#' with plots. Input is the ouput file of the QC operation of ContDataQC().
#'
#' @details The input is output file of the QC operation in ContDataQC().  That
#' is, a file with Date.Time, and parameters (matching formats in config.R).
#' One or two parameters can be analyzed at a time.
#' Requires doBy library for the daily statistics summary
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170905
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.myFile Filename (no directory) of data file.  Must be CSV file.
#' @param fun.myDir.import Directory for import data.
#' Default is current working directory.
#' @param fun.myDir.export Directory for export data.
#' Default is current working directory.
#' @param fun.myParam.Name Column name in myFile to perform summary statistics.
#'  One or two parameters can be specified.
#' @param fun.myDateTime.Name Column name in myFile for date time.
#' Default = "Date.Time".
#' @param fun.myDateTime.Format Format of DateTime field.
#' Default = \%Y-\%m-\%d \%H:\%M:\%S.
#' @param fun.myThreshold Value to draw line on plot.  For example, a regulatory
#'  limit.  Default = NA
#' @param fun.myConfig Configuration file to use for this data analysis.
#' The default is always loaded first so only "new" values need to be included.
#' This is the easiest way to control date and time formats.
#' @return Returns a data frame
#' @examples
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Save example files from Package to use for example
#' ## This step not needed for users working on their own files
#' df.x <- DATA_period_test2_Aw_20130101_20141231
#' write.csv(df.x,"DATA_period_test2_Aw_20130101_20141231.csv")
#' myFile <- "config.ExcludeFailsFalse.R"
#' file.copy(file.path(path.package("ContDataQC"), "extdata", myFile)
#'           , file.path(getwd(), myFile))
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#'
#' # Load File to use for PeriodStats
#' myDir <- tempdir()
#' myFile <- "DATA_period_test2_AW_20130101_20141231.csv"
#' df.x <- read.csv(file.path(myDir, myFile))
#'
#' # function inputs
#' myFile <- "DATA_period_test2_Aw_20130101_20141231.csv"
#' myDir.import <- tempdir()
#' myParam.Name <- "Water.Temp.C"
#' myDateTime.Name <- "Date.Time"
#' myDateTime.Format <- "%Y-%m-%d %H:%M:%S"
#' myThreshold <- 20
#' myConfig <- ""
#' # Custom Config
#' myConfig.Fail.Include  <- "config.ExcludeFailsFalse.R"
#'
#' # Run Function
#' ## Example 1. default report format (html)
#' SumStats.updated(myFile
#'           , myDir.import
#'           , myParam.Name
#'           , myDateTime.Name
#'           , myDateTime.Format
#'           , myThreshold
#'           , myConfig)
#'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
SumStats.updated <- function(fun.myFile
                        , fun.myDir.import = getwd()
                        , fun.myParam.Name
                        , fun.myDateTime.Name = "Date.Time"
                        , fun.myDateTime.Format = NA
                        , fun.myThreshold = NA
                        , fun.myConfig = ""
)
{##FUN.fun.Stats.START
  # 00. Debugging Variables####
  boo_DEBUG <- FALSE
  if(boo_DEBUG==TRUE) {##IF.boo_DEBUG.START
    fun.myFile <- "DATA_test2_Aw_20130101_20141231.csv"
    fun.myDir.import <- file.path(".","data-raw")
    fun.myParam.Name <- c("Water.Temp.C", "Sensor.Depth.ft")
    fun.myDateTime.Name <- "Date.Time"
    fun.myDateTime.Format <- NA
    fun.myThreshold <- 20
    fun.myConfig <- ""
    # Load environment
    #ContData.env <- new.env(parent = emptyenv()) # in config.R
    source(file.path(getwd(),"R","config.R"), local=TRUE)
    # might have to load manually
  }##IF.boo_DEBUG.END
  
  # 0a.0. Load environment
  # config file load, 20170517
  if (fun.myConfig!="") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  
  # change the default settings in Environment if needed
   # ContData.env$myName.Flag        <- "Flag" # flag prefix
   # ContData.env$myStats.Fails.Exclude <- TRUE  #FALSE #TRUE
   # ContData.env$myFlagVal.Fail    <- "F"
  # 0b.2. Format, DateTime
  if (is.na(fun.myDateTime.Format)) {##IF.fun.myConfig.START
    fun.myDateTime.Format <- ContData.env$myFormat.DateTime
  }##IF.fun.myConfig.START
  
  # 2.0. Load Data####
  # 2.1. Error Checking, make sure file exists
  if(fun.myFile %in% list.files(path=fun.myDir.import)==FALSE) {##IF.file.START
    #
    myMsg <- paste0("Provided file ("
                    ,fun.myFile
                    ,") does not exist in the provided import directory ("
                    ,fun.myDir.import
                    ,").")
    stop(myMsg)
    #
  }##IF.file.END
  # 2.2. Load File
  df.load <- utils::read.csv(file.path(fun.myDir.import, fun.myFile)
                             ,as.is=TRUE,na.strings=c("","NA"))
  # 2.3. Error Checking, data field names
  param.len <- length(fun.myParam.Name)
  myNames2Match <- c(fun.myParam.Name, fun.myDateTime.Name)
  #myNames2Match %in% names(df.load)
  if(sum(myNames2Match %in% names(df.load))!= (param.len + 1)){##IF.match.START
    # find non match
    Names.NonMatch <- myNames2Match[is.na(match(myNames2Match, names(df.load)))]
    myMsg <- paste0("Provided data file ("
                    ,fun.myFile
                    ,") does not contain the column name ("
                    ,Names.NonMatch,").")
    stop(myMsg)
  }##IF.match.END
  # 2.4.  Error Checking, DateTime format
  #df.load[,fun.myDateTime.Name] <- as.Date()
  
  # 2.5.  Number of Parameters
  # Check for 1 vs. 2 parameters
  param.len <- length(fun.myParam.Name)
  
  # Loop, Stats ####
  if(boo_DEBUG==TRUE) {##IF.boo_DEBUG.START
    i <- fun.myParam.Name[1]
  }##IF.boo_DEBUG.END
  # 20181114, added for 2nd parameter
  df.list <- list()
  for (i in fun.myParam.Name){##FOR.i.START
    #
    i.num <- match(i, fun.myParam.Name)
    print(paste0("WORKING on parameter (", i.num,"/",param.len,"); ", i))
    utils::flush.console()
    
    # QC.0. FLAGs ####
    # check if flag field is in data
    # Default values from config.R
    # ContData.env$myFlagVal.Fail    <- "F"
    # ContData.env$myName.Flag        <- "Flag" # flag prefix
    # ContData.env$myName.Flag.WaterTemp  <-
    # paste(ContData.env$myName.Flag,ContData.env$myName.WaterTemp,sep=".")
    # #Trigger for Stats to exclude (TRUE) or include (FALSE) where flag = "fail"
    # ContData.env$myStats.Fails.Exclude <- TRUE
    #
    # QC.1. Define parameter flag field
    ## If flag parameter names is different from config then it won't be found
    myParam.Name.Flag <- paste(ContData.env$myName.Flag, i, sep=".")
    # QC.2. Modify columns to keep (see 3.2.) based on presence of "flag" field
    ## give user feedback
    if (myParam.Name.Flag %in% names(df.load)) {##IF.flagINnames.START
      # QC.2.1. Flag field present in data
      myCol <- c(fun.myDateTime.Name, i, myParam.Name.Flag)
      # QC.2.1.1. Convert "Fails" to NA where appropriate
      if (ContData.env$myStats.Fails.Exclude == TRUE) {##IF.Fails.START
        # find Fails
        myFails <- df.load[,myParam.Name.Flag]==ContData.env$myFlagVal.Fail
        myFails.Num <- sum(myFails)
        # convert to NA
        df.load[myFails, i] <- NA
        # Message to User
        myMsg <- paste0("QC Flag field was found and "
                        , myFails.Num
                        , " fails were excluded based on user's config file.")
      } else {
        # Message to User
        myMsg <- "QC Flag field was found and fails were all
included based on user's config file."
      }##IF.Fails.END
      #
    } else {
      # QC.2.2. No Flag column
      myCol <- c(fun.myDateTime.Name, i)
      myMsg <- "No QC Flag field was found so all data points were used in
      calculations."
    }##IF.flagINnames.END
    cat(paste0(myMsg, "\n"))
    
    
    # 3. Munge Data####
    # 3.1. Subset Fields
    df.param <- df.load[,myCol]
    # 3.2. Add "Date" field
    fd01 <- "%Y-%m-%d" #ContData.env$myFormat.Date
    myDate.Name <- "Date"
    df.param[,myDate.Name] <- as.Date(df.param[,fun.myDateTime.Name], fd01)
    # 3.3. Data column to numeric
    # may get "NAs introduced by coercion" so suppress
    df.param[,i] <- suppressWarnings(as.numeric(df.param[,i]))
    #~~~~~~~~~~~~~~~~~~~~~~~~~
    # OLD method using doBy
    # 4. Daily Stats for data####
    # Calculate daily mean, max, min, range, sd, n
    # 4.1. Define FUNCTION for use with summaryBy
    myQ <- c(0.01,0.05,0.10,0.25,0.50,0.75,0.90,0.95,0.99)
    myFUN.Names <- c("mean"
                     ,"median"
                     ,"min"
                     ,"max"
                     ,"range"
                     ,"sd"
                     ,"var"
                     ,"cv"
                     ,"n"
                     ,paste("q",formatC(100*myQ,width=2,flag="0"),sep=""))
    #
    myFUN.sumBy <- function(x, ...){##FUN.myFUN.sumBy.START
      c(mean=mean(x,na.rm=TRUE)
        ,median=stats::median(x,na.rm=TRUE)
        ,min=min(x,na.rm=TRUE)
        ,max=max(x,na.rm=TRUE)
        ,range=max(x,na.rm=TRUE)-min(x,na.rm=TRUE)
        ,sd=stats::sd(x,na.rm=TRUE)
        ,var=stats::var(x,na.rm=TRUE)
        ,cv=stats::sd(x,na.rm=TRUE)/mean(x,na.rm=TRUE)
        ,n=length(x)
        ,q=stats::quantile(x,probs=myQ,na.rm=TRUE)
      )
    }##FUN.myFUN.sumBy.END
    # 4.2.  Rename data column (summaryBy doesn't like variables)
    names(df.param)[match(i,names(df.param))] <- "x"
    # 4.2. Summary
    df.summary <- doBy::summaryBy(x ~ Date
                                  , data=df.param
                                  , FUN=myFUN.sumBy
                                  , na.rm=TRUE
                                  , var.names=i)
    
    new.list <- list(df=df.summary)
    names(new.list) <- i
    df.list <- c(df.list,new.list)
  }##FOR.i.END
  
  return(df.list)
  
}##FUNCTION.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~