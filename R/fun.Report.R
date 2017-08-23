#' Generate Reports
#'
#' Subfunction for generating Word reports.  Needs to be called from ContDataQC().
#' Requires knitr() and pandoc.
#' Different reports (in Word) are created using the RMD files in this package depending on the input fun.myFile.Prefix.
#' Values are "QC", "DATA", or "STATS".
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20151022
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Basic Operations:
# load all files in data directory
# find ones specified by user
# generate QC data summaries
# output to PDF
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## ideas
# load one file instead of all
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# library (load any required helper functions)
#library(waterData)
#library(knitr)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # 20151221
# # create MD file in myDir.BASE
# # then knit
# # then PANDOC to DOCX
# ##
# # 1. Create MD file
# # 2. Knit MD file
# knit('report_knit_.md')
# # 3. Pandoc, convert MD to DOCX
# pandoc(report.md,-0,"report.docx")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 20150302, Change function to "Report"
# QC / Aggregate
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type; c("Air","Water","AW","Gage","AWG","AG","WG")
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @param fun.myFile.Prefix Valid prefixes are "QC", "DATA", or "STATS".  This determines the RMD to use for the outpu.
#' @return Creates a Word file in the specified directory.
#' @keywords continuous data, report
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#
# FUNCTION
#' @export
fun.Report <- function(fun.myData.SiteID
                         ,fun.myData.Type
                         ,fun.myData.DateRange.Start
                         ,fun.myData.DateRange.End
                         ,fun.myDir.import=getwd()
                         ,fun.myDir.export=getwd()
                         ,fun.myFile.Prefix) {##FUN.fun.Report.START
  #
  # Convert Data Type to proper case
  fun.myData.Type <- paste(toupper(substring(fun.myData.Type,1,1)),tolower(substring(fun.myData.Type,2,nchar(fun.myData.Type))),sep="")
  #
  # data directories
  # myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="","",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  # myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="","",paste("/",fun.myDir.SUB.export,sep="")),sep="")
  myDir.data.import <- fun.myDir.import
  myDir.data.export <- fun.myDir.export
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # Start Time (used to determine run time at end)
  myTime.Start <- Sys.time()
  #
    # 0. Load Single file
    # QC Check - delimiter for strsplit
    if(ContData.env$myDelim==".") {##IF.myDelim.START
      # special case for regex check to follow (20170531)
      myDelim.strsplit <- "\\."
    } else {
      myDelim.strsplit <- ContData.env$myDelim
    }##IF.myDelim.END
    strFile.Prefix     <- toupper(fun.myFile.Prefix)     # DATA = Aggregate, QC = QC
    strFile.SiteID     <- fun.myData.SiteID
    strFile.DataType   <- fun.myData.Type
    strFile.Date.Start <- format(as.Date(fun.myData.DateRange.Start,"%Y-%m-%d"),"%Y%m%d")
    strFile.Date.End   <- format(as.Date(fun.myData.DateRange.End,"%Y-%m-%d"),"%Y%m%d")
    strFile = paste(paste(strFile.Prefix,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
    strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
    strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)

    #QC, make sure file exists
    if(strFile %in% list.files(path=myDir.data.import)==FALSE) {##IF.file.START
      #
      print("ERROR; no such file exits.  Cannot create QC Report.")
      print(paste("PATH = ",myDir.data.import,sep=""))
      print(paste("FILE = ",strFile,sep=""))
      flush.console()
      stop("Bad file.")
      #
    }##IF.file.END

    #import the file
    #data.import <- read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings="")
    data.import <- read.csv(file.path(myDir.data.import,strFile),as.is=TRUE,na.strings="")


    # pick 'report' based on prefix
    myPkg <- "ContDataQC"
    if (strFile.Prefix=="QC") {##IF.strFile.Prefix.START
      myReport.Name <- "Report_QC"
    } else if (strFile.Prefix=="DATA") {
      myReport.Name <- "Report_Aggregate"
    } else if (strFile.Prefix=="STATS") {
      myReport.Name <- "Report_Stats"
    }

    #RStudio help solution
    # use RMD with embedded code
    # much cleaner DOCX than the 2-step process of MD with knit to RMD with pandoc
    #strFile.RMD <- paste(myDir.BASE,"Scripts",paste(myReport.Name,"rmd",sep="."),sep="/") #"QCReport.rmd"
    strFile.RMD <- system.file(paste0("rmd/",myReport.Name,".rmd"),package=myPkg)
    strFile.out.ext <- ".html" # ".docx"
    strFile.out <- paste(paste(strFile.Prefix,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,myReport.Name,sep=ContData.env$myDelim),strFile.out.ext,sep="")
    #suppressWarnings(
      rmarkdown::render(strFile.RMD, output_file=strFile.out, output_dir=fun.myDir.export, quiet=TRUE)
    #)


      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Clean up
    rm(data.import)
    rm(data.plot)
    #


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #print(paste("Processing of ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
 # files2process[intCounter] #use for troubleshooting if get error
  # inform user task complete with status
  myTime.End <- Sys.time()
#   print(paste("Processing of items (n=",intItems.Total,") finished.  Total time = ",format(difftime(myTime.End,myTime.Start)),".",sep=""))
#   print(paste("Items COMPLETE = ",myItems.Complete,".",sep=""))
#   print(paste("Items SKIPPPED = ",myItems.Skipped,".",sep=""))
    print(paste("Task COMPLETE. QC Report.  Total time = ",format(difftime(myTime.End,myTime.Start)),".",sep=""))
  # User defined parameters
  print(paste("User defined parameters: SiteID (",fun.myData.SiteID,"), Data Type (",fun.myData.Type,"), Date Range (",fun.myData.DateRange.Start," to ",fun.myData.DateRange.End,").",sep=""))
  flush.console()
  #
}##FUN.Report.END



