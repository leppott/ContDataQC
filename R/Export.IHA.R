#' Export data for IHA package
#'
#' Creates a date frame (and file export) from Continuous Data in the format
#' used by the IHA package.
#'
#' The function assumes the provided data is sampled more often then daily.  The
#' daily means are calculated internally.
#'
#' The IHA package is not included in the ContDataQC package.  But an example
#' is provided.
#'
#' To run the example IHA calculations you will need the IHA package (from
#' GitHub) and for the example export the XLConnect packages.  Install commands
#' are included in the example.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170911
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.myFile Filename (no directory) of data file.  Must be CSV file.
#' Includes Date/Time and Discharge fields.
#' @param fun.myDate.Format Format of benchmark date.  This should be the same
#' format of the date in the data file.
#' Default is \%Y-\%m-\%d (e.g., 2017-12-31).
#' @param fun.myDir.import Directory for import data.
#' Default is current working directory.
#' @param fun.myDir.export Directory for export data.
#' Default is current working directory.
#' @param fun.myDateRange.Start Start date for IHA analysis.  File will be
#' filtered on this date.  Default is NA (no filtering).
#' @param fun.myDateRange.End End date for IHA analysis.  File will be filtered
#' on this date.  Default is NA (no filtering).
#' @param fun.myCol.DateTime Column name in myFile with Date/Time.  Assumes
#' format of \%Y-\%m-\%d \%H:\%M:\%S.  Default = "Date.Time".
#' @param fun.myCol.Parameter Column name in myFile for measurements.
#' Default = "Discharge.ft3.s".
#' @return Returns a data frame with daily mean values by date (in the specified
#' range).  Also, a csv file is saved to the specified directory with the prefix
#' "IHA" and the date range before the file extension.
#'
# @keywords continuous data, daily mean, IHA
#'
#' @examples
#' myDir.BASE <- tempdir()
#'
#' # 1.  Get Gage Data
#' #
#' # 1.A. Use ContDataQC and Save (~1min for download)
#' myData.Operation       <- "GetGageData" #Selection.Operation[1]
#' myData.SiteID          <- "01187300" # Hubbard River near West Hartland, CT
#' myData.Type            <-  "Gage" #Selection.Type[4]
#' myData.DateRange.Start <- "2013-01-01"
#' myData.DateRange.End   <- "2014-12-31"
#' myDir.import           <- ""
#' myDir.export           <- file.path(myDir.BASE, Selection.SUB[2])
#' ContDataQC(myData.Operation
#'            , myData.SiteID
#'            , myData.Type
#'            , myData.DateRange.Start
#'            , myData.DateRange.End
#'            , myDir.import
#'            , myDir.export)
#' #
#' # 1.B. Use saved data
#' myData.SiteID   <- "01187300"
#' myFile          <- "01187300_Gage_20150101_20161231.csv"
#' myCol.DateTime  <- "Date.Time"
#' myCol.Discharge <- "Discharge.ft3.s"
#' #
#' # 2. Prep Data
#' myData.IHA <- Export.IHA(myFile
#'                          , fun.myDir.import = tempdir()
#'                          , fun.myDir.export = tempdir()
#'                          , fun.myCol.DateTime = myCol.DateTime
#'                          , fun.myCol.Parameter = myCol.Discharge
#'                          )
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # 3. Run IHA
#' # Example using returned DF with IHA
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # User info
#' SiteID <- myData.SiteID
#' Notes.User <- Sys.getenv("USERNAME")
#' #~~~~~
#' # Library (install if needed)
#' # devtools::install_github("jasonelaw/IHA")
#' # install.packages("XLConnect")
#' # Library (load)
#' require(IHA)
#' require(XLConnect)
#' #~~~~~
#' # IHA
#' myYr <- "calendar" # "water" or "calendar"
#' # IHA Metrics
#' ## IHA parameters group 1; Magnitude of monthly water conditions
#' Analysis.Group.1 <- group1(myData.IHA, year=myYr)
#' ## IHA parameters group 2: Magnitude of monthly water condition and include
#' # 12 parameters
#' Analysis.Group.2 <- group2(myData.IHA, year=myYr)
## IHA parameters group 3; Timing of annual extreme water conditions
#' Analysis.Group.3 <- group3(myData.IHA, year=myYr)
#' ## IHA parameters group 4; Frequency and duration of high and low pulses
#' # defaults to 25th and 75th percentiles
#' Analysis.Group.4 <- group4(myData.IHA, year=myYr)
#' ## IHA parameters group 5; Rate and frequency of water condition changes
#' Analysis.Group.5 <- group5(myData.IHA, year=myYr)
#' #~~~~~
#' # Save Results to Excel (each group on its own worksheet)
#' Group.Desc <- c("Magnitude of monthly water conditions"
#'            ,"Magnitude of monthly water condition and include 12 parameters"
#'                 ,"Timing of annual extreme water conditions"
#'                 ,"Frequency and duration of high and low pulses"
#'                 ,"Rate and frequency of water condition changes")
#' df.Groups <- as.data.frame(cbind(paste0("Group",1:5),Group.Desc))
#' #
#' myDate <- format(Sys.Date(),"%Y%m%d")
#' myTime <- format(Sys.time(),"%H%M%S")
#' # Notes section (add min/max dates)
#' Notes.Names <- c("Dataset (SiteID)","IHA.Year","Analysis.Date (YYYYMMDD)"
#'                  ,"Analysis.Time (HHMMSS)","Analysis.User")
#' Notes.Data <- c(SiteID, myYr, myDate, myTime, Notes.User)
#' df.Notes <- as.data.frame(cbind(Notes.Names,Notes.Data))
#' Notes.Summary <- summary(myData.IHA)
#' # Open/Create file
#' myFile.XLSX <- paste("IHA", SiteID, myYr, myDate, myTime, "xlsx", sep=".")
#' # load workbook, create if not existing
#' wb <- loadWorkbook(myFile.XLSX, create = TRUE)
#' # create sheets
#' createSheet(wb, name = "NOTES")
#' createSheet(wb, name = "Group1")
#' createSheet(wb, name = "Group2")
#' createSheet(wb, name = "Group3")
#' createSheet(wb, name = "Group4")
#' createSheet(wb, name = "Group5")
#' # write to worksheet
#' writeWorksheet(wb, df.Notes, sheet = "NOTES", startRow=1)
#' writeWorksheet(wb, Notes.Summary, sheet = "NOTES", startRow=10)
#' writeWorksheet(wb, df.Groups, sheet="NOTES", startRow=25)
#' writeWorksheet(wb, Analysis.Group.1, sheet = "Group1")
#' writeWorksheet(wb, Analysis.Group.2, sheet = "Group2")
#' writeWorksheet(wb, Analysis.Group.3, sheet = "Group3")
#' writeWorksheet(wb, Analysis.Group.4, sheet = "Group4")
#' writeWorksheet(wb, Analysis.Group.5, sheet = "Group5")
#' # save workbook
#' saveWorkbook(wb, myFile.XLSX)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # QC Function
# fun.myFile <- myFile
# fun.myDir.import <- tempdir()
# fun.myDir.export <- tempdir()
# fun.myDateRange.Start <- NA
# fun.myDateRange.End <- NA
# fun.myCol.DateTime <- myCol.DateTime
# fun.myCol.Discharge <- myCol.Discharge
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
Export.IHA <- function(fun.myFile
                       , fun.myDate.Format = "%Y-%m-%d"
                       , fun.myDir.import = getwd()
                       , fun.myDir.export = getwd()
                       , fun.myDateRange.Start = NA
                       , fun.myDateRange.End = NA
                       , fun.myCol.DateTime = "Date.Time"
                       , fun.myCol.Parameter = "Discharge.ft3.s"
                       ) {
  # import file
  myDF <- utils::read.csv(fun.myFile, stringsAsFactors = FALSE)
  myCols <- c(fun.myCol.DateTime, fun.myCol.Parameter)
  # add date
  myDF <- myDF[,myCols]
  myDF[,"Date"] <- as.Date(myDF[,fun.myCol.DateTime],format=fun.myDate.Format)
  # filter for date range supplied by user (if NA, default, do nothing)
  if(!is.na(fun.myDateRange.Start)){
    date.start <- as.Date(fun.myDateRange.Start, format=fun.myDate.Format)
    myDF <- myDF[myDF[,"Date"]>=date.start,]
  } else {
    date.start <- "NA"
  }
  if(!is.na(fun.myDateRange.End)){
    date.end <- as.Date(fun.myDateRange.End, format=fun.myDate.Format)
    myDF <- myDF[myDF[,"Date"]<=date.end,]
  } else {
    date.end <- "NA"
  }
  # generate daily values
  data.daily <- stats::aggregate(myDF[,2] ~ myDF[,3], FUN=mean)
  names(data.daily) <- c("Date", fun.myCol.Parameter)
  #head(data.daily)
  # Create zoo object for use with IHA library
  myData <- zoo::zoo(data.daily[,2],order.by=data.daily[,1])
  # Save
  myFile.base <- substr(fun.myFile,1,nchar(fun.myFile)-4)
  myFile.ext <- substr(fun.myFile,nchar(myFile.base)+1,nchar(fun.myFile))
  myFile.dates <- paste0("_",date.start,"_",date.end)
  myFile.IHA <- paste0("IHA_",myFile.base,myFile.dates,myFile.ext)
  utils::write.csv(myData,myFile.IHA)
  # Return DF to user
  return(myData)
}##FUNCTION.Export.IHA.END
