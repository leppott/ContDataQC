#' Export data for StreamThermal package
#'
#' Creates a date frame (and file export) from Continuous Data in the format used by the StreamThermal package.
#'
#' Required fields are StationID, Date, dailyMax, dailyMin, and dailyMean
#' The fields are named "siteID", "Date", "MaxT", "MinT", and "MeanT".
#'
#' The StreamThermal package is available on GitHub.  It can be installed withe the devtools package:
#'
#' library(devtools)
#'
#' install_github("tsangyp/StreamThermal")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170920
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.myDF User data that has been through the QC process of ContDataQC.  Required fields are SiteID, Date, Water.Temp.C (or as defined in config.R).
#' @param fun.col.SiteID Column name for SiteID.  Default = SiteID (as defined in config.R)
#' @param fun.col.Date Column name for SiteID.  Default = Date (as defined in config.R)
#' @param fun.col.Temp Column name for SiteID.  Default = Water.Temp.C (as defined in config.R)
#' @return Returns a data frame formatted for use with the R library StreamThermal (SiteID, Date, MaxT, MinT, MeanT).  Statistics are calculated in the function.
#' @keywords continuous data, StreamThermal
#' @examples
#' # 1.Define Data
#' #
#' # 1.1. Get USGS data
#' # code from StreamThermal T_frequency example
#' ExUSGSStreamTemp<-readNWISdv("01382310","00010","2011-01-01","2011-12-31"
#'                              ,c("00001","00002","00003"))
#' sitedata<-subset(ExUSGSStreamTemp, select=c("site_no","Date"
#'                  ,"X_00010_00001","X_00010_00002","X_00010_00003"))
#' names(sitedata)<-c("siteID","Date","MaxT","MinT","MeanT")
#' #
#' # 1.2. Use ContDataQC SummaryStats Data
#' myFile <- "STATS_test2_Aw_20130101_20141231_Water.Temp.C.csv"
#' myDir <- "Data4_Stats"
#' myData <- read.csv(file.path(getwd(),myDir,myFile), stringsAsFactors=FALSE)
#' # Subset
#' Col.Keep <- c("SiteID", "TimeValue", "max", "min", "mean")
#' sitedata <- myData[myData[,"TimeFrame"]=="day",Col.Keep]
#' Names.ST <- c("SiteID", "Date", "MaxT", "MinT", "MeanT")
#' names(sitedata) <- Names.ST
#' # Convert date column to date type
#' sitedata[,"Date"] <- as.Date(sitedata[,"Date"])
#' #
#' # 1.3. Use user data that has been QCed
#' myData <- DATA_period_test2_Aw_20130101_20141231
#' sitedata <- Export.StreamThermal(myData)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # 2. Run StreamThermal
#' # Use any of the 'sitedata' dataframes from above
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Library (install if needed)
#' # devtools::install_github("tsangyp/StreamThermal")
#' # Library (load)
#' require(StreamThermal)
#' #~~~~~
#' # StreamThermal
#' (ST.freq <- T_frequency(sitedata))
#' (ST.mag  <- T_magnitude(sitedata))
#' (ST.roc  <- T_rateofchange(sitedata))
#' (ST.tim  <- T_timing(sitedata))
#' (ST.var  <- T_variability(sitedata)) # example in package doesn't work
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # QC Function
# myData         <- DATA_period_test2_Aw_20130101_20141231
# fun.myDF       <- myData
# fun.col.SiteID <- "SiteID"
# fun.col.Date   <- "Date"
# fun.col.Temp   <- "Water.Temp.C"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
Export.StreamThermal <- function(fun.myDF
                                 ,fun.col.SiteID=ContData.env$myName.SiteID
                                 ,fun.col.Date=ContData.env$myName.Date
                                 ,fun.col.Temp=ContData.env$myName.WaterTemp
                                  )
{##FUNCTION.Export.StreamThermal.START
  #
  # Calculate stats (max, min, mean) for SiteID and Date
  agg.stats <- aggregate(fun.myDF[,fun.col.Temp] ~ fun.myDF[,fun.col.SiteID] + fun.myDF[,fun.col.Date]
                         , FUN=function(x) c(MaxT=max(x), MinT=min(x), MeanT=mean(x) ) )
  # Convert to DF
  df.stats <- do.call(data.frame, agg.stats)
  # rename columns
  Names.ST <- c("SiteID", "Date", "MaxT", "MinT", "MeanT")
  names(df.stats) <- Names.ST
  # update column classes
  df.stats[,Names.ST[1]] <- as.character(df.stats[,Names.ST[1]])
  df.stats[,Names.ST[2]] <- as.Date(df.stats[,Names.ST[2]])
  # return DF to user
  return(df.stats)
}##FUNCTION.Export.StreamThermal.END
