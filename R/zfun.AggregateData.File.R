#' Aggregate Data Files, File
#'
#' Subfunction for aggregating or splitting data files.  Needs to be called from ContDataQC().
#' Combines (appends) all provided filesp.  Saves a new CSV in the export directory.
#' The 'file' version works on a vector of files.
#
# Sourced Routine
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aggregate Data
# combine Single Site and Date Range
# add all data types into columns, merge time stamps
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# make user script smaller and easier to understand
# not a true function, needs defined variables in calling script
# if change variable names in either file have to update the other
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20151021
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 20170116, EWL
# added date & time QC
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# assumes use of CSV.  If using TXT have to modify list.files(pattern), read.csv(), and write.csv()
#
# Basic Operations:
# load all files in data directory
# find ones specified by user
# subset if necessary
# combine
# save
# (repeats much of fun.QCauto)
#' @param fun.myFile Vector of file names.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @return Returns a csv into the specified export directory of each file appended into a single file.
#' @keywords continuous data, aggregate
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#' myFile <- c("QC_test2_AW_20130426_20130725.csv", "QC_test2_AW_20130725_20131015.csv", "QC_test2_AW_20140901_20140930.csv")
#' myDir.import <- file.path(".","Data2_QC")
#' myDir.export <- file.path(".","Data3_Aggregated")
#' fun.AggregateData.File(myFile, myDir.import, myDir.export)
#
#' @export
fun.AggregateData.File <- function(fun.myFile
                                  , fun.myDir.import=getwd()
                                  , fun.myDir.export=getwd()) {##FUN.fun.QCauto.START
  #
  # Error Checking - only 1 SiteID and 1 DataType
  if(length(fun.myFile)==1){
    myMsg <- "Only 1 file selected.  No action performed."
    stop(myMsg)
  }
  # if(length(fun.myData.Type)!=1){
  #   myMsg <- "Function can only handle 1 Data Type."
  #   stop(myMsg)
  # }
  #
  # Convert Data Type to proper case
  # fun.myData.Type <- paste(toupper(substring(fun.myData.Type,1,1)),tolower(substring(fun.myData.Type,2,nchar(fun.myData.Type))),sep="")
  #
  # data directories
  #myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="","",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  #myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="","",paste("/",fun.myDir.SUB.export,sep="")),sep="")
  myDir.data.import <- fun.myDir.import
  myDir.data.export <- fun.myDir.export
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # # Verify input dates, if blank, NA, or null use all data
  # # if DateRange.Start is null or "" then assign it 1900-01-01
  # if (is.na(fun.myData.DateRange.Start)==TRUE||fun.myData.DateRange.Start==""){fun.myData.DateRange.Start<-ContData.env$DateRange.Start.Default}
  # # if DateRange.End is null or "" then assign it today
  # if (is.na(fun.myData.DateRange.End)==TRUE||fun.myData.DateRange.End==""){fun.myData.DateRange.End<-ContData.env$DateRange.End.Default}
  # #
  # Read in list of files to work on, uses all files matching pattern ("\\.csv$")
  # ## if change formats will have to make modifications (pattern, import, export)
  #files2process = list.files(path=myDir.data.import, pattern=" *.csv")
  files2process <- fun.myFile
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
  # myFileTypeNum.Air <- 0
  # myFileTypeNum.Water <- 0
  # myFileTypeNum.AW <- 0
  # myFileTypeNum.Gage <- 0
  #strFile.SiteID.Previous <- ""
  #
  # Create Log file
  ##  List of all items (files)
  myItems.ALL <- as.vector(unique(files2process))
  # create log file for processing results of items
  #myItems.Log <- data.frame(cbind(myItems.ALL,NA),stringsAsFactors=FALSE)
  myItems.Log <- data.frame(ItemID=1:intItems.Total,Status=NA,ItemName=myItems.ALL)
  #


  # Error if no files to process or no files in dir

  # File - file out (name after first file) 20170607
  strFile.Out.Prefix <- "DATA"
  strFile.Out.Base <- substr(fun.myFile[1],1,nchar(fun.myFile[1])-nchar(".csv"))
  strFile.Out <- paste(paste(strFile.Out.Prefix,strFile.Out.Base, "Append",intItems.Total, sep=ContData.env$myDelim),"csv",sep=".")
  strFile.Out.NoPrefix <- paste(paste(strFile.Out.Base, "Append",intItems.Total, sep=ContData.env$myDelim),"csv",sep=".")

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
    strFile <- files2process[intCounter]
    strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))

    #QC, make sure file exists
    if(strFile %in% list.files(path=myDir.data.import)==FALSE) {##IF.file.START
      #
      print("ERROR; no such file exits.  Cannot QC the data.")
      print(paste("PATH = ",myDir.data.import,sep=""))
      print(paste("FILE = ",strFile,sep=""))
      flush.console()
      #
      # maybe print similar files
      #
      stop("Bad file.")
      #
    }##IF.file.END

    # # 1.1. File Name, Parse
    # # QC Check - delimiter for strsplit
    # if(ContData.env$myDelim==".") {##IF.myDelim.START
    #   # special case for regex check to follow (20170531)
    #   myDelim.strsplit <- "\\."
    # } else {
    #   myDelim.strsplit <- ContData.env$myDelim
    # }##IF.myDelim.END
    # strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
    # strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)
    # strFile.SiteID     <- strFile.parts[[1]][2]
    # strFile.DataType   <- strFile.parts[[1]][3]
    # # Convert Data Type to proper case
    # strFile.DataType <- paste(toupper(substring(strFile.DataType,1,1)),tolower(substring(strFile.DataType,2,nchar(strFile.DataType))),sep="")
    # strFile.Date.Start <- as.Date(strFile.parts[[1]][4],"%Y%m%d")
    # strFile.Date.End   <- as.Date(strFile.parts[[1]][5],"%Y%m%d")
    #
    # 2. Check File and skip if doesn't match user defined parameters
    #
    # check vs. previous SiteID
    # if not the same (i.e., False) then reset the FileTypeNum Counters, will create new blank data.append
    # if((strFile.SiteID==strFile.SiteID.Previous)!=TRUE){##IF.SiteID.START
    #   myFileTypeNum.Air <- 0
    #   myFileTypeNum.Water <- 0
    #   myFileTypeNum.AW <- 0
    #   myFileTypeNum.Gage <- 0
    #   myFileTypeNum.AWG <- 0
    #   myFileTypeNum.AG <- 0
    #   myFileTypeNum.WG <- 0
    # }##IF.SiteID.END
    # #str  #code fragment, 20160418
    #
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
    # # 2.2. Check SiteID
    # # if not in provided site list then skip
    # if(strFile.SiteID %in% fun.myData.SiteID == FALSE) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, SiteID)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #   flush.console()
    #   # go to next Item
    #   next
    # }
    # # 2.3. Check DataType
    # # if not equal go to next file (handles both Air and Water)
    # if (strFile.DataType %in% fun.myData.Type == FALSE){
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, DataType)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #   flush.console()
    #   # go to next Item
    #   next
    # }
    # # 2.4. Check Dates
    # # 2.4.2.1. Check File.Date.Start (if file end < my Start then next)
    # if(strFile.Date.End<fun.myData.DateRange.Start) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, Start Date)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #   flush.console()
    #   # go to next Item
    #   next
    # }
    # # 2.4.2.2. Check File.Date.End (if file Start > my End then next)
    # if(strFile.Date.Start>fun.myData.DateRange.End) {
    #   # inform user of progress and update LOG
    #   myMsg <- "SKIPPED (Non-Match, End Date)"
    #   myItems.Skipped <- myItems.Skipped + 1
    #   myItems.Log[intCounter,2] <- myMsg
    #   fun.write.log(myItems.Log,myDate,myTime)
    #   fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    #   flush.console()
    #   # go to next Item
    #   next
    # }
    #
    # 3.0. Import the data
    #data.import=read.table(strFile,header=F,varSep)
    #varSep = "\t" (use read.delim instead of read.table)
    # as.is = T so dates come in as text rather than factor
    #data.import <- read.delim(strFile,as.is=TRUE,na.strings="")
    data.import <- read.csv(file.path(myDir.data.import,strFile),as.is=TRUE,na.strings="")
    #
    # QC required fields: SiteID & (DateTime | (Date & Time))
    fun.QC.ReqFlds(names(data.import),file.path(myDir.data.import,strFile))
    #
    #
    #
    # 4 and 5, skip
    #
    #
    # QC date and time
    # accessing files with Excel can change formats
    # 20170116, EWL
    data.import <- fun.QC.datetime(data.import)



    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # filter data, append (if necessary), then export
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # # 6.0. Filter data based on Date Range
    # ## "subset" can have issues.  "with" doesn't seem work using variables for colnames.
    # data.subset <- data.import[data.import[,ContData.env$myName.Date]>=fun.myData.DateRange.Start
    #                            & data.import[,ContData.env$myName.Date]<=fun.myData.DateRange.End,]
    # #
    # 7.0. Append Data
    # Append different based on the DataType
    # if all Air or all Water "rbind" is fine
    # Define data.append as blank so can always rbind even if the first file
    # but have to switch up if this is the first of either type
    # files alphabetical so will get all Air then all Water files.
    #
    # # 7.1. Record number of Air or Water files have worked on
    # # (set as zero before loop)
    # if(strFile.DataType=="Air"){myFileTypeNum.Air <- myFileTypeNum.Air + 1}
    # if(strFile.DataType=="Water"){myFileTypeNum.Water <- myFileTypeNum.Water + 1}
    # if(strFile.DataType=="Aw"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    # if(strFile.DataType=="Gage"){myFileTypeNum.Gage <- myFileTypeNum.Gage +1}
    # if(strFile.DataType=="AwG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    # if(strFile.DataType=="AG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    # if(strFile.DataType=="WG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    # #
    # # 7.2. If 1st file of either type then create empty data.Append
    # if(strFile.DataType=="Air" & myFileTypeNum.Air==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="Water" & myFileTypeNum.Water==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="Aw" & myFileTypeNum.AW==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="Gage" & myFileTypeNum.Gage==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="AWG" & myFileTypeNum.AWG==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="AG" & myFileTypeNum.AG==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    # if(strFile.DataType=="WG" & myFileTypeNum.WG==1) {
    #   # Create empty data frame for Append file
    #   data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
    #   names(data.append) <- names(data.subset)
    # }
    #
    # File, 20170607
    if(intCounter==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.import)))
      names(data.append) <- names(data.import)
    }
    #
    # 7.3. Append Subset to Append
    #data.append <- rbind(data.append,data.subset)
    # change to merge
    data.append <- merge(data.append,data.import,all=TRUE,sort=FALSE)
    #
    # 8.0. Output file (only works if DataType is Air OR Water not both)
    # 8.1. Set Name
    # File.Date.Start <- format(as.Date(fun.myData.DateRange.Start,ContData.env$myFormat.Date),"%Y%m%d")
    # File.Date.End   <- format(as.Date(fun.myData.DateRange.End,ContData.env$myFormat.Date),"%Y%m%d")
    # strFile.Out.Prefix <- "DATA"
    # strFile.Out <- paste(paste(strFile.Out.Prefix, strFile.Base, "Aggregated", sep=ContData.env$myDelim),"csv",sep=".")
    # 8.2. Save to File the Append data (overwrites any existing file).
    #strFile.Out
    #   varSep <- "\t" #tab-delimited
    #   write.table(data.append,file=strFile.Out,sep=varSep,quote=FALSE,row.names=FALSE,col.names=TRUE)
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #flush.console()
    write.csv(data.append, file=paste(myDir.data.export,"/",strFile.Out,sep=""), quote=FALSE, row.names=FALSE)
    # saves but if gets another one in the time range it will append as append is recycled between loop iterations
    # when gets a new data type it gets a new data.append
    # need trigger for different SiteID (won't combine across sites)



    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # insert QC Report so runs without user intervention

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # run with same import and export directory & on new file
    ###
    # will run repeatedly for each subfile when aggregating

#
#         fun.Report.File(strFile
#                         , fun.myDir.export
#                         , fun.myDir.export
#                         , strFile.Out.Prefix)
#                 ##
#                 # QC
#                 ##
#                 fun.myData.SiteID           <- strFile.SiteID
#                 fun.myData.Type             <- strFile.DataType
#                 fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
#                 fun.myData.DateRange.End    <- fun.myData.DateRange.End
#                 fun.myDir.BASE              <- fun.myDir.BASE
#                 fun.myDir.SUB.import        <- fun.myDir.SUB.export
#                 fun.myDir.SUB.export        <- fun.myDir.SUB.export
#                 fun.myFile.Prefix           <- strFile.Out.Prefix
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





    # 9. Clean up
    # set previous SiteID for QC check near top
    #strFile.SiteID.Previous <- strFile.SiteID
    # 9.1. Inform user of progress and update LOG
    myMsg <- "COMPLETE"
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.write.log(myItems.Log,myDate,myTime)
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
      flush.console()
    # 9.2. Remove data (import and subset)
    rm(data.import)
    #
  }##while.END
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  rm(data.append)

  # 20170607, move outside of loop (and remove prefix for fun.Report.File)
  fun.Report.File(strFile.Out.NoPrefix
                  , fun.myDir.export
                  , fun.myDir.export
                  , strFile.Out.Prefix)

  #
  print(paste("Processing of ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
  files2process[intCounter] #use for troubleshooting if get error
  # inform user task complete with status
  myTime.End <- Sys.time()
  print(paste("Processing of items (n=",intItems.Total,") finished.  Total time = ",format(difftime(myTime.End,myTime.Start)),".",sep=""))
  print(paste("Items COMPLETE = ",myItems.Complete,".",sep=""))
  print(paste("Items SKIPPPED = ",myItems.Skipped,".",sep=""))
  # User defined parameters
  print(paste("User defined parameters: File Output(",strFile.Out,").",sep=""))
    flush.console()


  #
}##FUN.Aggregate.END



