#' Aggregate Data Files
#'
#' Subfunction for aggregating or splitting data files.  Needs to be called from ContDataQC().
#' Combines or splits files based on given data range.  Saves a new CSV in the export directory.
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
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type; c("Air","Water","AW","Gage","AWG","AG","WG")
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @return Returns a csv into the specified export directory with additional columns for calculated statistics.
#' @keywords continuous data, aggregate
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#
#' @export
fun.AggregateData <- function(fun.myData.SiteID
                             ,fun.myData.Type
                             ,fun.myData.DateRange.Start
                             ,fun.myData.DateRange.End
                             ,fun.myDir.import=getwd()
                             ,fun.myDir.export=getwd()) {##FUN.fun.QCauto.START
  #
  # Error Checking - only 1 SiteID and 1 DataType
  if(length(fun.myData.SiteID)!=1){
    myMsg <- "Function can only handle 1 SiteID."
    stop(myMsg)
  }
  if(length(fun.myData.Type)!=1){
    myMsg <- "Function can only handle 1 Data Type."
    stop(myMsg)
  }
  #
  # Convert Data Type to proper case
  fun.myData.Type <- paste(toupper(substring(fun.myData.Type,1,1)),tolower(substring(fun.myData.Type,2,nchar(fun.myData.Type))),sep="")
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
  myFileTypeNum.AW <- 0
  myFileTypeNum.Gage <- 0
  strFile.SiteID.Previous <- ""
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
    # QC Check - delimiter for strsplit
    if(ContData.env$myDelim==".") {##IF.myDelim.START
      # special case for regex check to follow (20170531)
      myDelim.strsplit <- "\\."
    } else {
      myDelim.strsplit <- ContData.env$myDelim
    }##IF.myDelim.END
    strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
    strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)
    strFile.SiteID     <- strFile.parts[[1]][2]
    strFile.DataType   <- strFile.parts[[1]][3]
    # Convert Data Type to proper case
    strFile.DataType <- paste(toupper(substring(strFile.DataType,1,1)),tolower(substring(strFile.DataType,2,nchar(strFile.DataType))),sep="")
    strFile.Date.Start <- as.Date(strFile.parts[[1]][4],"%Y%m%d")
    strFile.Date.End   <- as.Date(strFile.parts[[1]][5],"%Y%m%d")
    #
    # 2. Check File and skip if doesn't match user defined parameters
    #
    # check vs. previous SiteID
    # if not the same (i.e., False) then reset the FileTypeNum Counters, will create new blank data.append
    if((strFile.SiteID==strFile.SiteID.Previous)!=TRUE){##IF.SiteID.START
      myFileTypeNum.Air <- 0
      myFileTypeNum.Water <- 0
      myFileTypeNum.AW <- 0
      myFileTypeNum.Gage <- 0
      myFileTypeNum.AWG <- 0
      myFileTypeNum.AG <- 0
      myFileTypeNum.WG <- 0
    }##IF.SiteID.END
    #str  #code fragment, 20160418
    #
    # 2.1. Check File Size
    #if(file.info(paste(myDir.data.import,"/",strFile,sep=""))$size==0){
    if(file.info(file.path(myDir.data.import,strFile))$size==0){
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
    #data.import <- read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings="")
    data.import <- read.csv(file.path(myDir.data.import,strFile),as.is=TRUE,na.strings="")
    #
    # QC required fields: SiteID & (DateTime | (Date & Time))
    #fun.QC.ReqFlds(names(data.import),paste(myDir.data.import,strFile,sep="/"))
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

    # 6.0. Filter data based on Date Range
    ## "subset" can have issues.  "with" doesn't seem work using variables for colnames.
    data.subset <- data.import[data.import[,ContData.env$myName.Date]>=fun.myData.DateRange.Start
                               & data.import[,ContData.env$myName.Date]<=fun.myData.DateRange.End,]
    #
    # 7.0. Append Data
    # Append different based on the DataType
    # if all Air or all Water "rbind" is fine
    # Define data.append as blank so can always rbind even if the first file
    # but have to switch up if this is the first of either type
    # files alphabetical so will get all Air then all Water files.
    #
    # 7.1. Record number of Air or Water files have worked on
    # (set as zero before loop)
    if(strFile.DataType=="Air"){myFileTypeNum.Air <- myFileTypeNum.Air + 1}
    if(strFile.DataType=="Water"){myFileTypeNum.Water <- myFileTypeNum.Water + 1}
    if(strFile.DataType=="Aw"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    if(strFile.DataType=="Gage"){myFileTypeNum.Gage <- myFileTypeNum.Gage +1}
    if(strFile.DataType=="AwG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    if(strFile.DataType=="AG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    if(strFile.DataType=="WG"){myFileTypeNum.AW <- myFileTypeNum.AW + 1}
    #
    # 7.2. If 1st file of either type then create empty data.Append
    if(strFile.DataType=="Air" & myFileTypeNum.Air==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="Water" & myFileTypeNum.Water==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="Aw" & myFileTypeNum.AW==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="Gage" & myFileTypeNum.Gage==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="AWG" & myFileTypeNum.AWG==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="AG" & myFileTypeNum.AG==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    if(strFile.DataType=="WG" & myFileTypeNum.WG==1) {
      # Create empty data frame for Append file
      data.append <- data.frame(matrix(nrow=0,ncol=ncol(data.subset)))
      names(data.append) <- names(data.subset)
    }
    #
    # 7.3. Append Subset to Append
    #data.append <- rbind(data.append,data.subset)
    # change to merge
    data.append <- merge(data.append,data.subset,all=TRUE,sort=FALSE)
    #
    # 8.0. Output file (only works if DataType is Air OR Water not both)
    # 8.1. Set Name
    File.Date.Start <- format(as.Date(fun.myData.DateRange.Start,ContData.env$myFormat.Date),"%Y%m%d")
    File.Date.End   <- format(as.Date(fun.myData.DateRange.End,ContData.env$myFormat.Date),"%Y%m%d")
    strFile.Out.Prefix <- "DATA"
    strFile.Out <- paste(paste(strFile.Out.Prefix, strFile.SiteID, strFile.DataType, File.Date.Start, File.Date.End, sep=ContData.env$myDelim),"csv",sep=".")
    # 8.2. Save to File the Append data (overwrites any existing file).
    #strFile.Out
    #   varSep <- "\t" #tab-delimited
    #   write.table(data.append,file=strFile.Out,sep=varSep,quote=FALSE,row.names=FALSE,col.names=TRUE)
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #flush.console()
    #write.csv(data.append, file=paste(myDir.data.export,"/",strFile.Out,sep=""), quote=FALSE, row.names=FALSE)
    write.csv(data.append, file=file.path(myDir.data.export,strFile.Out), quote=FALSE, row.names=FALSE)
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
        fun.Report(strFile.SiteID
                     ,strFile.DataType
                     ,fun.myData.DateRange.Start
                     ,fun.myData.DateRange.End
                     ,fun.myDir.export
                     ,fun.myDir.export
                     ,"DATA")
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
    strFile.SiteID.Previous <- strFile.SiteID
    # 9.1. Inform user of progress and update LOG
    myMsg <- "COMPLETE"
    myItems.Complete <- myItems.Complete + 1
    myItems.Log[intCounter,2] <- myMsg
    fun.write.log(myItems.Log,myDate,myTime)
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strFile)
    flush.console()
    # 9.2. Remove data (import and subset)
    rm(data.import, data.subset)
    #
  }##while.END
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Run report on Aggregated file (20170607)
  strFile.Out.NoPrefix <- substr(strFile.Out,nchar(strFile.Out.Prefix)+2,nchar(strFile.Out))
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
  print(paste("User defined parameters: SiteID (",fun.myData.SiteID,"), Data Type (",fun.myData.Type,"), Date Range (",fun.myData.DateRange.Start," to ",fun.myData.DateRange.End,").",sep=""))
  flush.console()


  ### may have to move to inside of loop (original code for single SiteID)





  # QC
#   fun.myPrefix.merge <- myPrefix.merge
#   fun.Name.myDF.1 <- myDF.Name.1
#   fun.Name.myDF.2 <- myDF.Name.2





  # Need to deal with overlapping data fields (gage and others) (merge only)
  fun.merge <- function(fun.myPrefix.merge, fun.Name.myDF.1, fun.Name.myDF.2){##FUNCTION.fun.merge.START
    #
    #     # QC
    #     fun.myPrefix.merge <- myPrefix.merge
    #     fun.Name.myDF.1    <- myDF.Name.1
    #     fun.Name.myDF.2    <- myDF.Name.2
    #
    # Load Files
    #data.DF.1 <- read.csv(paste(myDir.data.export,fun.Name.myDF.1,sep="/"),as.is=TRUE,na.strings="")
    #data.DF.2 <- read.csv(paste(myDir.data.export,fun.Name.myDF.2,sep="/"),as.is=TRUE,na.strings="")
    data.DF.1 <- read.csv(file.path(myDir.data.export,fun.Name.myDF.1),as.is=TRUE,na.strings="")
    data.DF.2 <- read.csv(file.path(myDir.data.export,fun.Name.myDF.2),as.is=TRUE,na.strings="")
    #
    # strip non file specific columns ????
    # drop overlapping field names in data.DF.2 (typically the gage file) but keep DateTime
    names.match <- names(data.DF.2) %in% names(data.DF.1)
    data.DF.2.mod <- data.DF.2[,c(myName.DateTime,names(data.DF.2)[names.match==FALSE])]
    # merge 1 and 2.mod
    data.merge <- merge(data.DF.1,data.DF.2.mod,by=myName.DateTime,all=TRUE,sort=FALSE,suffixes="")
    #
    # reapply some fields since the merge as some files have differen number of rows and purged duplicate fields
    # Date, Time, month, day (bring from fun.QC.R, change data.import to data.merge)
    # 5.2.2. Update Date if NA (use Date_Time)
    myField   <- ContData.env$myName.Date
    myFormat  <- ContData.env$myFormat.Date #"%Y-%m-%d"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Date]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    data.merge[,myField][is.na(data.merge[,myField])] <- strftime(data.merge[,ContData.env$myName.DateTime][is.na(data.merge[,myField])]
                                                                  ,format=myFormat,usetz=FALSE)
    # 5.2.3. Update Time if NA (use Date_Time)
    myField   <- ContData.env$myName.Time
    myFormat  <- ContData.env$myFormat.Time #"%H:%M:%S"
    #   data.import[,myField][data.import[,myField]==""] <- strftime(data.import[,myName.DateTime][data.import[,myName.Time]==""]
    #                                                               ,format=myFormat,usetz=FALSE)
    #     data.merge[,myField][is.na(data.merge[,myField])] <- as.POSIXct(data.merge[,myName.DateTime][is.na(data.merge[,myField])]
    #                                                                      ,format=myFormat,usetz=FALSE)
    # update all time fields
    data.merge[,myField] <- strftime(as.POSIXct(data.merge[,ContData.env$myName.DateTime],format=ContData.env$myFormat.DateTime,usetz=FALSE)
                                     ,format=myFormat.Time,usetz=FALSE)
    #
    #
    data.merge[,ContData.env$myName.Mo] <- as.POSIXlt(data.merge[,myName.Date])$mon+1
    data.merge[,ContData.env$myName.Day] <- as.POSIXlt(data.merge[,myName.Date])$mday
    # update SiteID
    data.merge[,ContData.env$myName.SiteID][is.na(data.merge[,ContData.env$myName.SiteID])] <- fun.myData.SiteID

    # sort
    # not working in merge command
    data.merge <- data.merge[order(data.merge[,ContData.env$myName.DateTime]),,drop=FALSE]


    # save file
    #File.Date.Start <- format(as.Date(fun.myData.DateRange.Start,myFormat.Date),"%Y%m%d")
    #File.Date.End   <- format(as.Date(fun.myData.DateRange.End,myFormat.Date),"%Y%m%d")
    #strFile.Out <- paste(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,fun.myPrefix.merge,File.Date.Start,File.Date.End,sep=myDelim),"csv",sep="."),sep="/")
    strFile.Out <- file.path(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,fun.myPrefix.merge,File.Date.Start,File.Date.End,sep=myDelim),"csv",sep="."))
    write.csv(data.merge,file=strFile.Out,quote=FALSE,row.names=FALSE)
    # QC report (fails on render - lines 41-83 in rmd)
    #

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # QC
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#           fun.myData.SiteID           <- fun.myData.SiteID
#           fun.myData.Type             <- fun.myPrefix.merge
#           fun.myData.DateRange.Start  <- fun.myData.DateRange.Start #format(as.Date(File.Date.Start,"%Y%m%d"),"%Y-%m-%d")
#           fun.myData.DateRange.End    <- fun.myData.DateRange.End #format(as.Date(File.Date.End,"%Y%m%d"),"%Y-%m-%d")
#           fun.myDir.BASE              <- fun.myDir.BASE
#           fun.myDir.SUB.import        <- fun.myDir.SUB.export
#           fun.myDir.SUB.export        <- fun.myDir.SUB.export
#           fun.myFile.Prefix           <- "DATA"
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    fun.Report(fun.myData.SiteID
                 ,fun.myPrefix.merge
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.export
                 ,fun.myDir.export
                 ,"DATA")
    # inform user
    print(paste("Done merging ",fun.myPrefix.merge," files; ",strFile.Out,sep=""))
    flush.console()
    # remove files
    rm(data.DF.1)
    rm(data.DF.2)
    #rm(data.merge)
    #
    # plot
    data.plot <- data.merge

    # clean up
    rm(data.merge)
    #
    rm(data.plot)

  }##FUNCTION.fun.merge.END
  #








  File.Date.Start <- strftime(as.Date(fun.myData.DateRange.Start,"%Y-%m-%d"),"%Y%m%d")
  File.Date.End   <- strftime(as.Date(fun.myData.DateRange.End,"%Y-%m-%d"),"%Y%m%d")



  # have counters so can keep track of files

  # myData.Type
  # strFile.DataType
  # myFileTypeNum.Air
  # myFileTypeNum.Water
  #
  #
  # DATA_Air_HRCC_20130101_20131231.csv
  # DATA_Water_HRCC_20130101_20131231.csv
  #
  # List both files
  #
  # merge and save as BOTH (AW)
  #
  # paste(paste("DATA",strFile.DataType,myData.SiteID,File.Date.Start,File.Date.End,sep="_"),"csv",sep=".")


  # Check for all Data Type  files (Air, Water, AW, Gage, AWG, AG, WG)
  # had been using "proper" to get "Air" and "Water".  So AWG=Awg, AW=Aw, AG=Ag, and WG=Wg
  # 1
  Name.File.Air <- paste(paste("DATA",fun.myData.SiteID,"Air",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 2
  Name.File.Water <- paste(paste("DATA",fun.myData.SiteID,"Water",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 3
  Name.File.AW <- paste(paste("DATA",fun.myData.SiteID,"Aw",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 4
  Name.File.Gage <- paste(paste("DATA",fun.myData.SiteID,"Gage",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 5
  Name.File.AWG <- paste(paste("DATA",fun.myData.SiteID,"Awg",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 6
  Name.File.AG <- paste(paste("DATA",fun.myData.SiteID,"Ag",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  # 7
  Name.File.WG <- paste(paste("DATA",fun.myData.SiteID,"Wg",File.Date.Start,File.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  #
  #
  files.ALL <- list.files(path=myDir.data.export, pattern=" *.csv")
  files.mine <- c(Name.File.Air,Name.File.Water,Name.File.AW,Name.File.Gage,Name.File.AWG,Name.File.AG,Name.File.WG)
  files.match <- files.mine %in% files.ALL # will be length 7 (length of files.mine)
  files.match.num <- sum(files.match==TRUE)
  #
  # only continue if have more than one.



  ###### 20160418
  # manual combination of A/W/G (auto not working properly depending on sequence)
  #  fun.myData.Type

  if(fun.myData.Type=="Aw"){
    # Files = 1Air & 2Water = 3AW
    if(files.match[1]==TRUE & files.match[2]==TRUE & files.match[3]==FALSE){##IF.files.AW.START
      #
      myPrefix.merge <- "Aw"
      myDF.Name.1 <- Name.File.Air
      myDF.Name.2 <- Name.File.Water
      # run merge function
      fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
      # mark file complete
      myItems.Complete <- myItems.Complete + 1
      #
    }##IF.files.WG.END
  }
  #
  if (fun.myData.Type=="Ag"){
    # Files = 1Air & 4Gage = 6AG
    if(files.match[1]==TRUE & files.match[4]==TRUE & files.match[6]==FALSE){##IF.files.AG.START
      #
      myPrefix.merge <- "Ag"
      myDF.Name.1 <- Name.File.Air
      myDF.Name.2 <- Name.File.Gage
      # run merge function
      fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
      # mark file complete
      myItems.Complete <- myItems.Complete + 1
      #
    }##IF.files.AG.END
  }
  #
  if (fun.myData.Type=="Awg"){
    # Files = 3AW & 4Gage = 5AWG
    if(files.match[3]==TRUE & files.match[4]==TRUE & files.match[5]==FALSE){##IF.files.AWG.START
      # Run Merge Twice (but AW already took care of 1st merge)
      # Merge 2
      myPrefix.merge <- "Awg"
      myDF.Name.1 <- Name.File.AW
      myDF.Name.2 <- Name.File.Gage
      # run merge function
      fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
      # mark file complete
      myItems.Complete <- myItems.Complete + 1
      #
    }##IF.files.AWG.END
  }
  #
  if(fun.myData.Type=="Wg"){
    # Files = 2Water & 4Gage = 7WG
    if(files.match[2]==TRUE & files.match[4]==TRUE & files.match[7]==FALSE){##IF.files.WG.START
      #
      myPrefix.merge <- "Wg"
      myDF.Name.1 <- Name.File.Water
      myDF.Name.2 <- Name.File.Gage
      # run merge function
      fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
      # mark file complete
      myItems.Complete <- myItems.Complete + 1
      #
    }##IF.files.WG.END
  }
  #



  # 20151202
  # Quit if skipped = total
  if(myItems.Complete==0){##IF.items.START
    myMsg <- "No files with the selected attributes available to perform selected procedure.  Check to make sure there are files that match your inputs (SiteID, DataType, and Date Range).  [This is a specific error message not an R error message]."
    stop(myMsg)
  }##IF.items.END


  # trigger above should have caught if zero files and ended there
  if (files.match.num==1){##IF.files.match.num.START
    myMsg <- "No other data type files exist for this SiteID and Date Range.  No combining across data types is possible."
    # may want to continue so don't end
    print(myMsg) #stop(myMsg)
  } else { #should be if >1
    myMsg <- "Files for multiple data types exist for this SiteID and Date Range.  These will be be combined:"
    # list out below
    print(myMsg)
    print(files.mine[files.match==TRUE])
  }
  flush.console()
 #










#
#
#   # Files = 1Air & 4Gage = 6AG
#   if(files.match[1]==TRUE & files.match[4]==TRUE & files.match[6]==FALSE){##IF.files.AG.START
#     #
#     myPrefix.merge <- "Ag"
#     myDF.Name.1 <- Name.File.Air
#     myDF.Name.2 <- Name.File.Gage
#     # run merge function
#     fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
#     #
#   }##IF.files.AG.END
#   #
#   # Files = 2Water & 4Gage = 7WG
#   if(files.match[2]==TRUE & files.match[4]==TRUE & files.match[7]==FALSE){##IF.files.WG.START
#     #
#     myPrefix.merge <- "Wg"
#     myDF.Name.1 <- Name.File.Water
#     myDF.Name.2 <- Name.File.Gage
#     # run merge function
#     fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
#     #
#   }##IF.files.WG.END
#   #
#   # Files = 1Air & 2Water = 3AW
#   if(files.match[1]==TRUE & files.match[2]==TRUE & files.match[3]==FALSE){##IF.files.AW.START
#     #
#     myPrefix.merge <- "Aw"
#     myDF.Name.1 <- Name.File.Air
#     myDF.Name.2 <- Name.File.Water
#     # run merge function
#     fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
#     #
#   }##IF.files.WG.END
#   #
#   # Files = 3AW & 4Gage = 5AWG
#   if(files.match[3]==TRUE & files.match[4]==TRUE & files.match[5]==FALSE){##IF.files.AWG.START
#     # Run Merge Twice (but AW already took care of 1st merge)
#     # Merge 2
#     myPrefix.merge <- "Awg"
#     myDF.Name.1 <- Name.File.AW
#     myDF.Name.2 <- Name.File.Gage
#     # run merge function
#     fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
#     #
#   }##IF.files.AWG.END
#

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # need to write subroutines for merge and plotting
  # AW has all the stuff
  # 20160206, already done (fun.merge)
  # since saving plots in QCReport shouldn't need plots here
# Should be ok to leave in code below for merge&plot when had only Air and Water
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#   #
#   # Files = 1Air & 2Water = 3AW
#   # load files, merge, plot
#   if((files.match[1]==TRUE & files.match[2]==TRUE & files.match[3]==FALSE) | files.match[3]==TRUE){##IF.files.AW.START
#
#     if(files.match[3]==FALSE) {##IF.air/water.START
#       #
# #       myPrefix.merge <- "Aw"
# #       myDF.Name.1 <- Name.File.Air
# #       myDF.Name.2 <- Name.File.Water
# #       # run merge function
# #       fun.merge(myPrefix.merge,myDF.Name.1,myDF.Name.2)
#
#
#
#       # Load Files
#       data.air <- read.csv(paste(myDir.data.export,Name.File.Air,sep="/"),as.is=TRUE,na.strings="")
#       data.water <- read.csv(paste(myDir.data.export,Name.File.Water,sep="/"),as.is=TRUE,na.strings="")
#       # strip non-file specific columns
#       myNames.Order.Air <- c(myName.SiteID,myName.Date,myName.Time,myName.DateTime,myName.AirTemp,myName.LoggerID.Air,myName.RowID.Air)
#       myNames.Order.Water <-c(myName.DateTime,myName.WaterTemp,myName.WaterP,myName.AirBP,myName.SensorDepth,myName.LoggerID.Water,myName.RowID.Water)
#       # data.air <- data.air[,myNames.Order.Air]
#       #  data.water <- data.water[,myNames.Order.Water]
#       # merge
#       data.AW <- merge(data.water,data.air,by=myName.DateTime,all=TRUE,sort=FALSE,suffixes="")
#       #
#
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       # error in date if one file is smaller than the other
#
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       #
#
#       # save file
#       File.Date.Start <- format(as.Date(fun.myData.DateRange.Start,myFormat.Date),"%Y%m%d")
#       File.Date.End   <- format(as.Date(fun.myData.DateRange.End,myFormat.Date),"%Y%m%d")
#       strFile.Out <- paste(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,"Aw",File.Date.Start,File.Date.End,sep=myDelim),"csv",sep="."),sep="/")
#       write.csv(data.AW,file=strFile.Out,quote=FALSE,row.names=FALSE)
#       #
#       #~~~~~~~~~~~~~~~~20160111
#       # insert QC Report so runs without user intervention
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       # run with same import and export directory & on new file
#       ###
#       # will run repeatedly for each subfile when aggregating
#       fun.QCReport(strFile.SiteID
#                    ,"Aw"
#                    ,File.Date.Start
#                    ,File.Date.End
#                    ,fun.myDir.BASE
#                    ,fun.myDir.SUB.export
#                    ,fun.myDir.SUB.export
#                    ,"DATA")
#       #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       #                 # QC
#       #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       #                 fun.myData.SiteID           <- strFile.SiteID
#       #                 fun.myData.Type             <- strFile.DataType
#       #                 fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
#       #                 fun.myData.DateRange.End    <- fun.myData.DateRange.End
#       #                 fun.myDir.BASE              <- fun.myDir.BASE
#       #                 fun.myDir.SUB.import        <- fun.myDir.SUB.export
#       #                 fun.myDir.SUB.export        <- fun.myDir.SUB.export
#       #                 fun.myFile.Prefix           <- strFile.Out.Prefix
#       #
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#
#       #
#       print(paste("Done merging Air and Water files; ",strFile.Out,sep=""))
#       flush.console()
#       #
#       rm(data.air)
#       rm(data.water)
#       #
#     } else if (files.match[3]==TRUE) {
#       #
#       data.AW <- read.csv(paste(myDir.data.export,Name.File.AW,sep="/"),as.is=TRUE,na.strings="")
#       #
#     }##IF.air/water.END
#
#
#     #
#     #
#     data.plot <- data.AW
#     ##
#     # save to PDF
#     ##
#     #
#     # cheat on Date/Time axis
#     n.Total <- length(data.plot[,myName.Date])
#     pct <- c(20,40,60,80,100)*.01
#     myAT <- c(1,round(n.Total * pct,0))
#     myLab <- data.plot[,myName.Date][myAT]
#     #
#     strPDF.out <- paste(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,"Aw",File.Date.Start,File.Date.End,sep=myDelim),"pdf",sep="."),sep="/")
#     pdf(file=strPDF.out)
#       #
#       # 20151120, had to add as.numeric (think b/c of using merge instead of rbind)
#       #
#       # plot (Temp, water & Temp, Air)
#       myPlot.Y <- as.numeric(data.plot[,myName.AirTemp])
#       myPlot.Y2 <- as.numeric(data.plot[,myName.WaterTemp])
#       myPlot.Ylab <- myLab.Temp.BOTH
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="green", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       lines(myPlot.Y2,type="l",col="blue")
#       legend(x="bottomright",lty=1,col=c("green","blue"),legend=c("air","water"))
#       #
#       # plot (Air.Temp)
#       myPlot.Y <- as.numeric(data.plot[,myName.AirTemp])
#       myPlot.Ylab <- myLab.AirTemp
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="green", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#       # plot (Water.Temp)
#       myPlot.Y <- as.numeric(data.plot[,myName.WaterTemp])
#       myPlot.Ylab <- myLab.WaterTemp
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="blue", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#       # plot (Water Temp & Water Level)
#       par.orig <- par(no.readonly=TRUE) # save original par settings
#         par(oma=c(0,0,0,2))
#         myPlot.Y <- as.numeric(data.plot[,myName.WaterTemp])
#         myPlot.Ylab <- myLab.WaterTemp
#         myPlot.Y2 <- as.numeric(data.plot[,myName.SensorDepth])
#         myPlot.Y2lab <- myLab.SensorDepth
#         plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="blue", xaxt="n")
#         axis(1,at=myAT,labels=myLab,tick=TRUE)
#         # Add 2nd y axis (2nd color is black)
#         par(new=TRUE)
#         plot(myPlot.Y2,type="l",col="black",axes=FALSE,ann=FALSE)
#         axis(4)
#         mtext(myPlot.Y2lab,side=4,line=2.5)
#       par(par.orig) # return to original par settings
#       #
#       # plot (Water Level)
#       myPlot.Y <- as.numeric(data.plot[,myName.SensorDepth])
#       myPlot.Ylab <- myLab.SensorDepth
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="black", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#     dev.off()
#     #
#     # lattice
#     #   library(lattice)
#     #   xyplot(y~x|z,df)
#     print(paste("Done creating plot of Air and Water temperature; ",strFile.Out,sep=""))
#     flush.console()
#     #
#
#     rm(data.AW)
#     #
#   }##IF.filesmatch_both.END
#   #
#   # Air
#   if(files.match[1]==TRUE){##IF.filesmatch_air.START
#     #
#     data.air <- read.csv(paste(myDir.data.export,Name.File.Air,sep="/"),as.is=TRUE,na.strings="")
#     data.plot <- data.air
#     # cheat on Date/Time axis
#     n.Total <- length(data.plot[,myName.Date])
#     pct <- c(20,40,60,80,100)*.01
#     myAT <- c(1,round(n.Total * pct,0))
#     myLab <- data.plot[,myName.Date][myAT]
#     #
#     strPDF.out <- paste(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,"Air",File.Date.Start,File.Date.End,sep=myDelim),"pdf",sep="."),sep="/")
#     pdf(file=strPDF.out)
#       # plot
#       myPlot.Y <- as.numeric(data.plot[,myName.AirTemp])
#       myPlot.Ylab <- myLab.AirTemp
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="green", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#     dev.off()
#     #
#   }##IF.filesmatch_air.END
#   #
#   # Water
#   if(files.match[2]==TRUE){##IF.filesmatch_water.START
#     #
#     data.water <- read.csv(paste(myDir.data.export,Name.File.Water,sep="/"),as.is=TRUE,na.strings="")
#     data.plot <- data.water
#     # cheat on Date/Time axis
#     n.Total <- length(data.plot[,myName.Date])
#     pct <- c(20,40,60,80,100)*.01
#     myAT <- c(1,round(n.Total * pct,0))
#     myLab <- data.plot[,myName.Date][myAT]
#     #
#     strPDF.out <- paste(myDir.data.export,paste(paste("DATA",fun.myData.SiteID,"Water",File.Date.Start,File.Date.End,sep=myDelim),"pdf",sep="."),sep="/")
#     pdf(file=strPDF.out)
#       # plot (Temp, Water)
#       myPlot.Y <- as.numeric(data.plot[,myName.WaterTemp])
#       myPlot.Ylab <- myLab.WaterTemp
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="blue", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#       # plot (Water Level)
#       myPlot.Y <- as.numeric(data.plot[,myName.SensorDepth])
#       myPlot.Ylab <- myLab.SensorDepth
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="black", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#       # plot (Water Temp & Water Level)
#       par.orig <- par(no.readonly=TRUE) # save original par settings
#       par(oma=c(0,0,0,2))
#       myPlot.Y <- as.numeric(data.plot[,myName.WaterTemp])
#       myPlot.Ylab <- myLab.WaterTemp
#       myPlot.Y2 <- as.numeric(data.plot[,myName.SensorDepth])
#       myPlot.Y2lab <- myLab.SensorDepth
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="blue", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       # Add 2nd y axis (2nd color is black)
#       par(new=TRUE)
#       plot(myPlot.Y2,type="l",col="black",axes=FALSE,ann=FALSE)
#       axis(4)
#       mtext(myPlot.Y2lab,side=4,line=2.5)
#       par(par.orig) # return to original par settings
#       #
#       # plot (Water Level)
#       myPlot.Y <- as.numeric(data.plot[,myName.SensorDepth])
#       myPlot.Ylab <- myLab.SensorDepth
#       plot(myPlot.Y,type="l",main=fun.myData.SiteID,xlab=myLab.Date,ylab=myPlot.Ylab,col="black", xaxt="n")
#       axis(1,at=myAT,labels=myLab,tick=TRUE)
#       #
#     dev.off()
#     #
#   }##IF.files.AW.END
#   #
#   # inform user task complete
#   myTime.End <- Sys.time()
#   print(paste("Task COMPLETE; ",round(difftime(myTime.End,myTime.Start,units="mins"),2)," min.",sep=""))
#   flush.console()

  #
}##FUN.Aggregate.END



