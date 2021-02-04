#' @title Daily stats for a given time period
#'
#' @description Generates daily stats (N, mean, min, max, range, std deviation)
#' for the specified time period before a given date. Output is a multiple
#' column CSV (Date and Parameter Name by statistic) and a report (HTML or DOCX)
#' with plots. Input is the ouput file of the QC operation of ContDataQC().
#'
#' @details The input is output file of the QC operation in ContDataQC().  That
#' is, a file with Date.Time, and parameters (matching formats in config.R).
#'
#' To get different periods (30, 60, or 90 days) change function input
#' "fun.myPeriod.N".
#' It is possible to provide a vector for Period.N and Period.Units.
#' If the date range is longer than that in the data provided the stats will not
#' calculate properly.
#'
#' The dates must be in the standard format (Y-m-d) or the function may not work
#' as intended.  For example, the date is used in the file name and dates with
#' "/" will result in an invalid file name.
#'
#' One or two parameters can be analyzed at a time.
#' If provide 2 parameters both will produce period statistic summaries.
#' And the plots will have both parameters.  The 2nd parameter will be on the
#' 2nd (right) y-axis.
#'
#' Requires doBy library for the period statistics summary and rmarkdown for the
#' report.
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170905
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.myDate Benchmark date.
#' @param fun.myDate.Format Format of benchmark date.  This should be the same
#' format of the date in the data file.
#' Default is \%Y-\%m-\%d (e.g., 2017-12-31).
#' @param fun.myPeriod.N Period length.  Default = 30.
#' @param fun.myPeriod.Units Period units (days or years written as d or y).
#' Default is d.
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
#' @param fun.myReport.format Report format (docx or html).
#' Default is specified in config.R (docx).Can be customized in config.R;
#' ContData.env$myReport.Format.
#' @param fun.myReport.Dir Report (rmd) template folder.
#' Default is the package rmd folder.  Can be customized in config.R;
#' ContData.env$myReport.Dir.
#' @return Returns a csv with daily means and a PDF summary with plots into the
#' specified export directory for the specified time period before the given
#' date.
#'
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
#' myDate <- "2013-09-30"
#' myDate.Format <- "%Y-%m-%d"
#' myPeriod.N <- c(30, 60, 90, 120, 1)
#' myPeriod.Units <- c("d", "d", "d", "d", "y")
#' myFile <- "DATA_period_test2_Aw_20130101_20141231.csv"
#' myDir.import <- tempdir()
#' myDir.export <- tempdir()
#' myParam.Name <- "Water.Temp.C"
#' myDateTime.Name <- "Date.Time"
#' myDateTime.Format <- "%Y-%m-%d %H:%M:%S"
#' myThreshold <- 20
#' myConfig <- ""
#' myReport.format <- "docx"
#' # Custom Config
#' myConfig.Fail.Include  <- "config.ExcludeFailsFalse.R"
#'
#' # Run Function
#' ## Example 1. default report format (html)
#' PeriodStats(myDate
#'           , myDate.Format
#'           , myPeriod.N
#'           , myPeriod.Units
#'           , myFile
#'           , myDir.import
#'           , myDir.export
#'           , myParam.Name
#'           , myDateTime.Name
#'           , myDateTime.Format
#'           , myThreshold
#'           , myConfig)
#'
#' ## Example 2. DOCX report format
#' PeriodStats(myDate
#'           , myDate.Format
#'           , myPeriod.N
#'           , myPeriod.Units
#'           , myFile
#'           , myDir.import
#'           , myDir.export
#'           , myParam.Name
#'           , myDateTime.Name
#'           , myDateTime.Format
#'           , myThreshold
#'           , myConfig
#'           , myReport.format)
#'
#' ## Example 3. DOCX report format and Include Flag Failures
#' PeriodStats(myDate
#'           , myDate.Format
#'           , myPeriod.N
#'           , myPeriod.Units
#'           , myFile
#'           , myDir.import
#'           , myDir.export
#'           , myParam.Name
#'           , myDateTime.Name
#'           , myDateTime.Format
#'           , myThreshold
#'           , myConfig.Fail.Include
#'           , myReport.format)
#'
#' ## Example 4. DOCX report format with two parameters
#' myParam.Name <- c("Water.Temp.C", "Sensor.Depth.ft")
#' PeriodStats(myDate
#'           , myDate.Format
#'           , myPeriod.N
#'           , myPeriod.Units
#'           , myFile
#'           , myDir.import
#'           , myDir.export
#'           , myParam.Name
#'           , myDateTime.Name
#'           , myDateTime.Format
#'           , myThreshold
#'           , myConfig
#'           , myReport.format)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
PeriodStats <- function(fun.myDate
                       , fun.myDate.Format = NA
                       , fun.myPeriod.N = 30
                       , fun.myPeriod.Units = "d"
                       , fun.myFile
                       , fun.myDir.import = getwd()
                       , fun.myDir.export = getwd()
                       , fun.myParam.Name
                       , fun.myDateTime.Name = "Date.Time"
                       , fun.myDateTime.Format = NA
                       , fun.myThreshold = NA
                       , fun.myConfig = ""
                       , fun.myReport.format = ""
                       , fun.myReport.Dir = ""
                       )
{##FUN.fun.Stats.START
  # 00. Debugging Variables####
  boo_DEBUG <- FALSE
  if(boo_DEBUG==TRUE) {##IF.boo_DEBUG.START
    fun.myDate <- "2013-09-30"
    fun.myDate.Format <- "%Y-%m-%d"
    fun.myPeriod.N <- c(30, 60, 90, 120, 1)
    fun.myPeriod.Units <- c("d", "d", "d", "d", "y")
    fun.myFile <- "DATA_test2_Aw_20130101_20141231.csv"
    fun.myDir.import <- file.path(".","data-raw")
    fun.myDir.export <- getwd()
    fun.myParam.Name <- c("Water.Temp.C", "Sensor.Depth.ft")
    #fun.myParam.Name <- "Water.Temp.C"
    fun.myDateTime.Name <- "Date.Time"
    fun.myDateTime.Format <- NA
    fun.myThreshold <- 20
    fun.myConfig <- ""
    fun.myReport.format <- ""
    fun.myReport.Dir <- ""
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

  # 0b.0. Load defaults from environment
  # 0b.1. Format, Date
  if (is.na(fun.myDate.Format)) {
    fun.myDate.Format <- ContData.env$myFormat.Date
  }
  # 0b.2. Format, DateTime
  if (is.na(fun.myDateTime.Format)) {##IF.fun.myConfig.START
    fun.myDateTime.Format <- ContData.env$myFormat.DateTime
  }##IF.fun.myConfig.START

  # 0c.0. Error Checking, Period (N vs. Units)
  len.N <- length(fun.myPeriod.N)
  len.Units <- length(fun.myPeriod.Units)
  if(len.N != len.Units) {##IF.length.START
    myMsg <- paste0("Length of period N (",len.N,") and Units (",len.Units,") does not match.")
    stop(myMsg)
  }##IF.length.END

  # 1.0 Convert date format to YYYY-MM-DD####
  fd01 <- "%Y-%m-%d" #ContData.env$myFormat.Date
  myDate.End <- as.POSIXlt(format(as.Date(fun.myDate, fun.myDate.Format), fd01))
  # use POSIX so can access parts
  # 1.1. Error Checking, Date Conversion
  if(is.na(myDate.End)) {
    myMsg <- paste0("Provided date (",fun.myDate,") and date format ("
                    ,fun.myDate.Format,") do not match.")
    stop(myMsg)
  }

  # 2.0. Load Data####
  # 2.1. Error Checking, make sure file exists
  if(fun.myFile %in% list.files(path=fun.myDir.import)==FALSE) {##IF.file.START
    #
    myMsg <- paste0("Provided file (",fun.myFile,") does not exist in the provided import directory (",fun.myDir.import,").")
    stop(myMsg)
    #
  }##IF.file.END
  # 2.2. Load File
  df.load <- utils::read.csv(file.path(fun.myDir.import, fun.myFile),as.is=TRUE,na.strings=c("","NA"))
  # 2.3. Error Checking, data field names
  param.len <- length(fun.myParam.Name)
  myNames2Match <- c(fun.myParam.Name, fun.myDateTime.Name)
  #myNames2Match %in% names(df.load)
  if(sum(myNames2Match %in% names(df.load))!= (param.len + 1)){##IF.match.START
    # find non match
    Names.NonMatch <- myNames2Match[is.na(match(myNames2Match, names(df.load)))]
    myMsg <- paste0("Provided data file (",fun.myFile,") does not contain the column name ("
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
    # ContData.env$myName.Flag.WaterTemp  <- paste(ContData.env$myName.Flag,ContData.env$myName.WaterTemp,sep=".")
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
        myMsg <- paste0("QC Flag field was found and ", myFails.Num, " fails were excluded based on user's config file.")
      } else {
        # Message to User
        myMsg <- "QC Flag field was found and fails were all included based on user's config file."
      }##IF.Fails.END
      #
    } else {
      # QC.2.2. No Flag column
      myCol <- c(fun.myDateTime.Name, i)
      myMsg <- "No QC Flag field was found so all data points were used in calculations."
    }##IF.flagINnames.END
    cat(paste0(myMsg, "\n"))


    # 3. Munge Data####
    # 3.1. Subset Fields
    df.param <- df.load[,myCol]
    # 3.2. Add "Date" field
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
    myFUN.Names <- c("mean","median","min","max","range","sd","var","cv","n",paste("q",formatC(100*myQ,width=2,flag="0"),sep=""))
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
    df.summary <- doBy::summaryBy(x ~ Date, data=df.param, FUN=myFUN.sumBy, na.rm=TRUE
                                  , var.names=i)

    # 20181115, Save df.summary for report
    if(i.num==1){##FOR.i.num.START
      df.summary.plot.1 <- df.summary
    } else if (i.num==2){
      df.summary.plot.2 <- df.summary
    }
    #~~~~~~~~~~~~~~~~~~~~~~~~~
    # # 4. Daily stats
    # # dplyr summary (not working with variable name)
    # x <- quo(fun.myParam.Name)
    # df.summary <- df.param %>%
    #                 dplyr::group_by(Date) %>%
    #                   dplyr::summarise(n=n()
    #                                    #,min=min(fun.myParam.Name,na.rm=TRUE)
    #                                     ,mean=mean(!!x,na.rm=TRUE)
    #                                    # ,max=mean(fun.myParam.Name,na.rm=TRUE)
    #                                    # ,sd=stats::sd(fun.myParam.Name,na.rm=TRUE)
    #                                    )

    # 5. Determine period start date####
    # Loop through each Period (N and Units)
    numPeriods <- length(fun.myPeriod.N)
    myDate.Start <- rep(myDate.End, numPeriods)
    for (k in seq_len(numPeriods)) {##FOR.k.START
      if(tolower(fun.myPeriod.Units[k])=="d" ) {##IF.format.START
        # day, $mday
        myDate.Start[k]$mday <- myDate.End$mday - (fun.myPeriod.N[k] - 1)
      } else if(tolower(fun.myPeriod.Units[k])=="y") {
        # year, $year
        myDate.Start[k]$year <- myDate.End$year - fun.myPeriod.N[k]
        myDate.Start[k]$mday <- myDate.End$mday + 1
      } else {
        myMsg <- paste0("Provided period units (",fun.myPeriod.Units
                        ,") unrecognized.  Accepted values are 'd', 'm', or 'y').")
        stop(myMsg)
      }##IF.format.END
    }##FOR.k.END
    # 20181114, change from i to k
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # # single period
    # myDate.Start <- myDate.End
    # if(tolower(fun.myPeriod.Units)=="d" ) {##IF.format.START
    #   # day, $mday
    #   myDate.Start$mday <- myDate.End$mday - (fun.myPeriod.N - 1)
    # } else if(tolower(fun.myPeriod.Units)=="y") {
    #   # year, $year
    #   myDate.Start$year <- myDate.End$year - fun.myPeriod.N
    #   myDate.Start$mday <- myDate.End$mday + 1
    # } else {
    #   myMsg <- paste0("Provided period units (",fun.myPeriod.Units
    #                   ,") unrecognized.  Accepted values are 'd', 'm', or 'y').")
    #   stop(myMsg)
    # }##IF.format.END
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # # 6.0. Subset Date Range
    # df.subset <- df.subset[df.subset[,myDate.Name]>=myDate.Start & df.subset[,myDate.Name]<=myDate.End,]
    # # df.period <- df.summary %>%
    # #               dplyr::filter(myDate.Name>=myDate.Start, myDate.Name<=myDate.End)
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 6. Subset and Save summary file ####
    myDate <- format(Sys.Date(),"%Y%m%d")
    myTime <- format(Sys.time(),"%H%M%S")
    myFile.Export.ext <- ".csv"
    myFile.Export.base <- substr(fun.myFile,1,nchar(fun.myFile)-4)
    # Loop through sets
    # numPeriods defined above
    for (j in seq_len(numPeriods)){##FOR.j.START
      # subset
      df.summary.subset <- df.summary[df.summary[,myDate.Name]>=as.Date(myDate.Start[j]) & df.summary[,myDate.Name]<=as.Date(myDate.End),]
      # create file name
      myFile.Export.full <- paste0(paste(myFile.Export.base
                                         ,"PeriodStats"
                                         ,fun.myDate
                                         ,i
                                         ,paste0(fun.myPeriod.N[j],fun.myPeriod.Units[j])
                                         ,myDate
                                         ,myTime
                                         ,sep="_")
                                   ,myFile.Export.ext)
      # save
      utils::write.csv(df.summary.subset, file.path(fun.myDir.export, myFile.Export.full),quote=FALSE,row.names=FALSE)
    }##FOR.j.END
    #
  }##FOR.i.END




  # 7. Generate markdown summary file with plots ####
  # extra info for report (20180118)
  myDate.File.Min <- min(df.load$Date)
  myDate.Diff.FileMin.Benchmark <- as.Date(fun.myDate) - as.Date(myDate.File.Min)

  # Error Check, Report Format
  if(fun.myReport.format==""){
    fun.myReport.format <- ContData.env$myReport.Format
  }
  fun.myReport.format <- tolower(fun.myReport.format)

  # 20180212
  # Error Check, Report Directory
  if(fun.myReport.Dir==""){
    fun.myReport.Dir <- ContData.env$myReport.Dir
  }

  #myReport.Name <- paste0("Report_PeriodStats","_",fun.myReport.format)
  myReport.Name <- "Report_PeriodStats"
  myPkg <- "ContDataQC"
  if(boo_DEBUG==TRUE){
    strFile.RMD <- file.path(getwd(),"inst","rmd",paste0(myReport.Name,".rmd")) # for testing
  } else {
    #strFile.RMD <- system.file(paste0("rmd/",myReport.Name,".rmd"),package=myPkg)
    # use provided dir for template
    strFile.RMD <- file.path(fun.myReport.Dir, paste0(myReport.Name, ".rmd"))
  }
  #
  #
  strFile.out.ext <- paste0(".",fun.myReport.format) #".docx" # ".html"
  strFile.out <- paste0(paste(myFile.Export.base,"PeriodStats",fun.myDate,paste(fun.myParam.Name,collapse="_"),myDate,myTime,sep="_"), strFile.out.ext)
  strFile.RMD.format <- paste0(ifelse(fun.myReport.format=="docx","word",fun.myReport.format),"_document")
  #
  # 20180212
  # Test if RMD file exists
  if (file.exists(strFile.RMD)){##IF.file.exists.START
    #suppressWarnings(
    rmarkdown::render(strFile.RMD, output_format=strFile.RMD.format
                      ,output_file=strFile.out, output_dir=fun.myDir.export
                      , quiet=TRUE)
    #)
  } else {
    Msg.Line0 <- "\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    Msg.Line1 <- "Provided report template file directory does not include the necessary RMD file to generate the report.  So no report will be generated."
    Msg.Line2 <- "The default report directory can be modified in config.R (ContData.env$myReport.Dir) and used as input to the function (fun.myConfig)."
    Msg.Line3 <- paste0("report file = ", paste0(myReport.Name, ".rmd"))
    Msg.Line4 <- paste0("directory = ", fun.myReport.Dir)
    Msg <- paste(Msg.Line0, Msg.Line1, Msg.Line2, Msg.Line3, Msg.Line4, Msg.Line0, sep="\n\n")
    cat(Msg)
    utils::flush.console()
  }##IF.file.exists.END
  #

  # 8. Inform user task is complete.####
  cat("Task complete.  Data (CSV) and report (",toupper(fun.myReport.format),") files saved to directory:\n")
  cat(fun.myDir.export)
  utils::flush.console()

}##FUNCTION.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
