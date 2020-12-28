#' Statistical Summary
#'
#' Subfunction for generating statistical summaries.  Needs to be called from ContDataQC().
#' Requires doBy() and survival() [required by doBy]
#' Calculates statistics on input data and saves to a new csv.
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20151120
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 20170116, EWL
# added date & time QC
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Basic Operations:
# load all files in data directory
# perform Stats
# write Stat summary file
#
# library (load any required helper functions)
# library(StreamThermal)
# library(survival) # required for doBy
# library(doBy)
# should have been loaded by master script
#' @param fun.myData.SiteID Station/SiteID.
#' @param fun.myData.Type data type; c("Air","Water","AW","Gage","AWG","AG","WG")
#' @param fun.myData.DateRange.Start Start date for requested data. Format = YYYY-MM-DD.
#' @param fun.myData.DateRange.End End date for requested data. Format = YYYY-MM-DD.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @param fun.myFile.Prefix Valid prefixes are "QC", "DATA", or "STATS".  This determines the RMD to use for the outpu.
#' @param fun.myReport.format Report format (docx or html).  Default is specified in config.R (docx).  Can be customized in config.R; ContData.env$myReport.Format.
#' @param fun.myReport.Dir Report (rmd) template folder.  Default is the package rmd folder.  Can be customized in config.R; ContData.env$myReport.Dir.
#' @return Returns a csv into the specified export directory with additional columns for calculated statistics.
#' @keywords internal continuous data, statistics
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#
#' @export
fun.Stats <- function(fun.myData.SiteID
                     , fun.myData.Type
                     , fun.myData.DateRange.Start
                     , fun.myData.DateRange.End
                     , fun.myDir.import=getwd()
                     , fun.myDir.export=getwd()
                     , fun.myProcedure.Step
                     , fun.myFile.Prefix
                     , fun.myReport.format
                     , fun.myReport.Dir) {##FUN.fun.Stats.START
  #
#   ##
#   # QC (from fun.Master.R)
#   ##
#   if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.3Agg}
#   if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.4Stats}
#   fun.myProcedure.Step <- "STATS"
#   fun.myFile.Prefix <- "DATA"
#   ##
  # 00. Debugging Variables####
  boo.DEBUG <- 0
  if(boo.DEBUG==1) {##IF.boo.DEBUG.START
    #if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.3Agg}
    #if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.4Stats}
    fun.myData.SiteID          <- "test2"
    fun.myData.Type            <- Selection.Type[3] #"AW"
    fun.myData.DateRange.Start <- "2013-01-01"
    fun.myData.DateRange.End   <- "2014-12-31"
    fun.myDir.import           <- file.path(myDir.BASE,Selection.SUB[3]) #"Data3_Aggregated"
    fun.myDir.export           <- myDir.export <- file.path(myDir.BASE,Selection.SUB[4]) #"Data4_Stats"
    fun.myProcedure.Step       <- "STATS"
    fun.myFile.Prefix          <- "DATA"
    fun.myReport.format        <- "docx"
    #fun.myReport.Dir           <- ""
    # Load environment
    #ContData.env <- new.env(parent = emptyenv()) # in config.R
    #source(file.path(getwd(),"R","fun.CustomConfig.R"), local=TRUE)
    source(file.path(getwd(), "R", "config.R"))
    source(file.path(getwd(), "R", "fun.Helper.R"))
    # might have to load manually
  }##IF.boo.DEBUG.END

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
  # myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="","",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  # myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="","",paste("/",fun.myDir.SUB.export,sep="")),sep="")
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
  strFile <- paste(paste(strFile.Prefix,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,sep=ContData.env$myDelim),"csv",sep=".")
  strFile.Base <- substr(strFile,1,nchar(strFile)-nchar(".csv"))
  strFile.parts <- strsplit(strFile.Base, myDelim.strsplit)
  #
  #QC, make sure file exists
  if(strFile %in% list.files(path=myDir.data.import)==FALSE) {##IF.file.START
    #
    print("ERROR; no such file exits.  Cannot generate summary statistics.")
    print(paste("PATH = ",myDir.data.import,sep=""))
    print(paste("FILE = ",strFile,sep=""))
    utils::flush.console()

    # maybe print similar files

    stop("Bad file.")
    #
  }##IF.file.END

  #import the file
  #data.import <- utils::read.csv(paste(myDir.data.import,strFile,sep="/"),as.is=TRUE,na.strings=c("","NA"))
  data.import <- utils::read.csv(file.path(myDir.data.import,strFile),as.is=TRUE,na.strings=c("","NA"))
  #
  # QC required fields: SiteID & (DateTime | (Date & Time))
  #fun.QC.ReqFlds(names(data.import),paste(myDir.data.import,strFile,sep="/"))
  fun.QC.ReqFlds(names(data.import),file.path(myDir.data.import,strFile))
  #

  #
  # QC date and time
  # accessing files with Excel can change formats
  # 20170116, EWL
  data.import <- fun.QC.datetime(data.import)


  # Define time period fields

  myNames.Fields.TimePeriods <- c(ContData.env$myName.Yr, ContData.env$myName.YrMo, ContData.env$myName.MoDa, ContData.env$myName.Mo
                                  , ContData.env$myName.JuDa, ContData.env$myName.Season, ContData.env$myName.YrSeason)
  # add time period fields
  data.import[,ContData.env$myName.Yr]   <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%Y")
  data.import[,ContData.env$myName.Mo]   <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%m")
  data.import[,ContData.env$myName.YrMo] <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%Y%m")
  data.import[,ContData.env$myName.MoDa] <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%m%d")
  data.import[,ContData.env$myName.JuDa] <- as.POSIXlt(data.import[,ContData.env$myName.Date], format=ContData.env$myFormat.Date)$yday +1
  ## add Season fields
#   md <- data.import[,myName.MoDa]
#   data.import[,myName.Season] <- NA
#   data.import[,myName.Season][as.numeric(md)>=as.numeric("0101") & as.numeric(md)<as.numeric(myTimeFrame.Season.Spring.Start)] <- "Winter"
#   data.import[,myName.Season][as.numeric(md)>=as.numeric(myTimeFrame.Season.Spring.Start) & as.numeric(md)<as.numeric(myTimeFrame.Season.Summer.Start)] <- "Spring"
#   data.import[,myName.Season][as.numeric(md)>=as.numeric(myTimeFrame.Season.Summer.Start) & as.numeric(md)<as.numeric(myTimeFrame.Season.Fall.Start)] <- "Summer"
#   data.import[,myName.Season][as.numeric(md)>=as.numeric(myTimeFrame.Season.Fall.Start) & as.numeric(md)<as.numeric(myTimeFrame.Season.Winter.Start)] <- "Fall"
#   data.import[,myName.Season][as.numeric(md)>=as.numeric(myTimeFrame.Season.Winter.Start) & as.numeric(md)<as.numeric("1231")] <- "Winter"
#   data.import[,myName.SeasonYr] <- paste(data.import[,"Season"],data.import[,"Year"],sep="")
  data.import[,ContData.env$myName.Season] <- NA
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric("0101") & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Spring.Start)] <- "Winter"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Spring.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Summer.Start)] <- "Spring"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Summer.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Fall.Start)] <- "Summer"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Fall.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Winter.Start)] <- "Fall"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Winter.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<=as.numeric("1231")] <- "Winter"
  data.import[,ContData.env$myName.YrSeason] <- paste(data.import[,ContData.env$myName.Yr],data.import[,ContData.env$myName.Season],sep="")

  #
  # Loop - Parameter (n=3)
  ## Temperature (Air/Water)
  ## Flow (SensorDepth and Discharge)
  ## Nothing on Pressure (used to calculate SensorDepth)
  # future add pH, Cond, etc from USGS gages
  myFields.Data       <- c(ContData.env$myName.WaterTemp, ContData.env$myName.AirTemp, ContData.env$myName.SensorDepth
                           ,ContData.env$myName.Discharge, ContData.env$myName.Cond, ContData.env$myName.DO, ContData.env$myName.pH
                           ,ContData.env$myName.Turbidity, ContData.env$myName.Chlorophylla, ContData.env$myName.GageHeight)
  myFields.Data.Flags <- paste0(ContData.env$myName.Flag,".",myFields.Data)
  myFields.Type       <- c("Thermal", "Thermal", "Hydrologic"
                           ,"Hydrologic", "WaterChemistry", "WaterChemistry", "WaterChemistry"
                           , "WaterChemistry", "WaterChemistry", "Hydrologic")
  myFields.Keep <- c(ContData.env$myName.SiteID
                     , ContData.env$myName.Date
                     , ContData.env$myName.Time
                     , ContData.env$myName.DateTime
                     , ContData.env$myNames.Fields.TimePeriods
                     , ContData.env$myFields.Data
                     , ContData.env$myFields.Data.Flags
                     )
  # keep only fields needed for stats
 # data.import <- data.import[,myFields.Keep]

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    data2process <- myFields.Data[myFields.Data %in% names(data.import)]
    print(paste("Total items to process = ",length(data2process),":",sep=""))
    print(data2process)
    utils::flush.console()

  ############## QC
  i <- data2process[1] #QC
  # ok to leave in since gets remapped in FOR loop.
  ####################### change from myFields.Data to data2process (need to fix)

  # Loop ####
  for (i in data2process) {##FOR.i.START
    #
    i.num <- match(i,myFields.Data)
    Fields2Drop <- myFields.Data[-i.num]
    data.stats <- data.import[,!(names(data.import) %in% Fields2Drop)]
    # change fails to NA (so can na.rm=T when run stats)
      # flag field
      myFlag <- myFields.Data.Flags[i.num]
    #data.stats.nofail <- data.stats[data.stats[,myFields.Data.Flags[i.num]]!=myFlagVal.Fail,]

    # 20170519, feedback to user
    print(paste0("Processing item ",i.num," of ",length(data2process),"; ",i))
    utils::flush.console()
    #data.stats.nofail <- data.stats
    #data.stats.nofail[data.stats.nofail[,data.stats[,myFields.Data.Flags[i.num]]=myFlagVal.Fail]] <- na

    # change fail to NA for i (only if user define value == FALSE)
    if(ContData.env$myStats.Fails.Exclude==TRUE) {##IF.myStats.Fails.Include.START
      #
      data.stats[,i][data.stats[,myFlag]==ContData.env$myFlagVal.Fail] <- NA
      #
    }##IF.myStats.Fails.Exclude.END

    # #QC test where fails
    # qc.section <- "For.i.A"
    # print(paste0("QC.Section: ",qc.section))
    #   flush.console()

    #
    # summaryBy doesn't work with Group as variable (change value for running here)
    # have to change some back for dv.i when save
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Date] <- "Date"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.YrMo] <- "YearMonth"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.YrSeason] <- "YearSeason"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Yr] <- "Year"

    #QC test where fails
    # qc.section <- "For.i.B.namechanges"
    # print(paste0("QC.Section: ",qc.section))
    # print(dim(data.stats))
    # flush.console()

    # summaryBy not working with "i" as variable.  Have to do an ugly hack to get it working

#     # QC
#     print("test2")
#     print(i)
#     print("data.stats")
#     print(head(data.stats))
#     flush.console()
#
#
#     data(dietox)
#     dietox12    <- subset(dietox,Time==12)
#     j <- "Weight"
#
#     x<-doBy::summaryBy(as.numeric(Weight)+Feed~Evit+Cu, data=dietox12,
#               FUN=c(mean,var,length))
#
#     print(x)
#     flush.console()
#
#    # myDF <- data.stats
#     #x <- summaryBy(as.numeric(Water.Temp.C)~Date,data=myDF,FUN=c(mean),na.rm=TRUE)
#     #print(dim(x))


    # Create Daily Values (mean) (DV is USGS term so use that)

    # if(i==myFields.Data[1]) {
      # dv.i <- doBy::summaryBy(as.numeric(Water.Temp.C)~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
      #                   , var.names="i",id=c(ContData.env$myName.SiteID, "Year", "YearMonth", ContData.env$myName.Mo, ContData.env$myName.MoDa
      #                                        , ContData.env$myName.JuDa, ContData.env$myName.Season,"YearSeason"))
    # } else if(i==myFields.Data[2]) {
    #   dv.i <- doBy::summaryBy(as.numeric(Air.Temp.C)~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
    #                     , var.names="i",id=c(ContData.env$myName.SiteID, "Year", "YearMonth", ContData.env$myName.Mo, ContData.env$myName.MoDa
    #                                          , ContData.env$myName.JuDa, ContData.env$myName.Season,"YearSeason"))
    # } else if (i==myFields.Data[3]) {
    #   dv.i <- doBy::summaryBy(as.numeric(Water.Level.ft)~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
    #                     , var.names="i",id=c(ContData.env$myName.SiteID, "Year", "YearMonth", ContData.env$myName.Mo, ContData.env$myName.MoDa
    #                                          , ContData.env$myName.JuDa, ContData.env$myName.Season,"YearSeason"))
    # }
    # 20170519, fix hard coded names
    #
    # Convert format
    data.stats[,i] <- as.numeric(data.stats[,i])
    data.stats[,"Date"] <- as.Date(data.stats[,"Date"], format="%Y-%m-%d")
    # name to myVar then name back (summaryBy won't work on i)
    ColNum.i <- match(i,names(data.stats))
    names(data.stats)[ColNum.i] <- "myVar"
    # Summary (could use dplyr but already using doBy package)
    dv.i <- doBy::summaryBy(myVar ~ Date, data=data.stats, FUN=c(mean), na.rm=TRUE
                            , var.names="i"
                            ,id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr
                                  , ContData.env$myName.YrMo, ContData.env$myName.Mo
                                  , ContData.env$myName.MoDa, ContData.env$myName.JuDa
                                  , ContData.env$myName.Season, ContData.env$myName.YrSeason))
    names(data.stats)[ColNum.i] <- i
    #
    #
    #
    #
    # if(i==myFields.Data[1]) {
    #
      # dv.i <- doBy::summaryBy(as.numeric(Water.Temp.C)~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
      #                         , var.names="i",id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr , ContData.env$myName.YrMo, ContData.env$myName.Mo, ContData.env$myName.MoDa
      #                                              , ContData.env$myName.JuDa, ContData.env$myName.Season, ContData.env$myName.YrSeason))
    # } else if(i==myFields.Data[2]) {
    #   dv.i <- doBy::summaryBy(as.numeric(data.stats[,ContData.env$myName.AirTemp])~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
    #                           , var.names="i",id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr , ContData.env$myName.YrMo, ContData.env$myName.Mo, ContData.env$myName.MoDa
    #                                                , ContData.env$myName.JuDa, ContData.env$myName.Season, ContData.env$myName.YrSeason))
    # } else if (i==myFields.Data[3]) {
    #   dv.i <- doBy::summaryBy(as.numeric(data.stats[,ContData.env$myName.SensorDepth])~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
    #                           , var.names="i",id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr , ContData.env$myName.YrMo, ContData.env$myName.Mo, ContData.env$myName.MoDa
    #                                                , ContData.env$myName.JuDa, ContData.env$myName.Season, ContData.env$myName.YrSeason))
    # }
    # 20170519, don't need "if" statement above.
    # dv.i <- doBy::summaryBy(as.numeric(data.stats[,i])~Date, data=data.stats, FUN=c(mean), na.rm=TRUE, var.names="i"
    #                         , id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr , ContData.env$myName.YrMo
    #                               , ContData.env$myName.Mo, ContData.env$myName.MoDa , ContData.env$myName.JuDa
    #                               , ContData.env$myName.Season,ContData.env$myName.YrSeason)
    #                         )
    # dv.i <- doBy::summaryBy(as.numeric(data.stats[,i])~Date, data=data.stats, FUN=c(mean), na.rm=TRUE, var.names="i"
    #                         , id=c(ContData.env$myName.SiteID, ContData.env$myName.Yr, ContData.env$myName.YrMo
    #                                , ContData.env$myName.Mo, ContData.env$myName.MoDa, ContData.env$myName.JuDa
    #                                , ContData.env$myName.Season,ContData.env$myName.YrSeason)
    #                         )
#     dv.i <- doBy::summaryBy(as.numeric(data.stats[,i])~Date, data=data.stats, FUN=c(mean), na.rm=TRUE
#                       , var.names="i")#,id=c(myName.SiteID,"Year","YearMonth",myName.MoDa,myName.JuDa,myName.Season,"YearSeason"))

    # #QC test where fails
    # qc.section <- "For.i.C.dv.i"
    # print(paste0("QC.Section: ",qc.section))
    # flush.console()


    # rename fields back (use dv.i generated by summaryBy)
    names(dv.i)[2] <- "mean"
    names(dv.i)[names(dv.i) %in% "Date"] <- ContData.env$myName.Date
    names(dv.i)[names(dv.i) %in% "YearMonth"] <- ContData.env$myName.YrMo
    names(dv.i)[names(dv.i) %in% "YearSeason"] <- ContData.env$myName.YrSeason
    names(dv.i)[names(dv.i) %in% "Year"] <- ContData.env$myName.Yr
    # add parameter as column
    dv.i[,"Parameter"] <- i
    # rearrange columns
    dv.i.ColOrder <- c(ContData.env$myName.SiteID, "Parameter", "mean", ContData.env$myName.Date, ContData.env$myNames.Fields.TimePeriods)
    dv.i <- dv.i[,dv.i.ColOrder]

    # For later summaryBy, ensure mean is numeric
    dv.i[,"mean"] <- as.numeric(dv.i[,"mean"])

    # save dv
    strFile.Prefix.Out <- "DV"
    strFile.Out <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,sep=ContData.env$myDelim),"csv",sep=".")
    #write.csv(dv.i,paste(myDir.data.export,strFile.Out,sep="/"),quote=FALSE,row.names=FALSE)
    utils::write.csv(dv.i,file.path(myDir.data.export,strFile.Out),quote=FALSE,row.names=FALSE)

    # #QC test where fails
    # qc.section <- "For.i.D.save.dv"
    # print(paste0("QC.Section: ",qc.section))
    # flush.console()

    # calculate daily mean, max, min, range, sd, n
    # Define FUNCTION for use with summaryBy
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
    #
    #
    # #QC test where fails
    # qc.section <- "For.i.E.calcDaily"
    # print(paste0("QC.Section: ",qc.section))
    # flush.console()
    #
    # summaryBy doesn't work with Group as variable (change value for running here)
    # have to change some back for dv.i.* when save
    #names(data.stats)[names(data.stats) %in% ContData.env$myName.Date] <- "Date"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Date] <- "Date"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.YrMo] <- "YearMonth"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.YrSeason] <- "YearSeason"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Yr] <- "Year"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Mo] <- "Month"
    names(data.stats)[names(data.stats) %in% ContData.env$myName.Season] <- "Season"
    #
    # #QC test where fails
    # qc.section <- "For.i.F.namechanges"
    # print(paste0("QC.Section: ",qc.section))
    # flush.console()
    #
    #
    # Save plots as PDF
    strFile.Prefix.Out <- fun.myProcedure.Step
    strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,sep=ContData.env$myDelim),"pdf",sep=".")
    #pdf(file=paste(myDir.data.export,strFile.plot,sep="/"),width=11,height=8.5)
    grDevices::pdf(file=file.path(myDir.data.export,strFile.plot),width=11,height=8.5)

      ## Daily
        myTimeFrame <- "day"
        myTF.Field <- ContData.env$myName.Date
        myDF <- data.stats
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~Date,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ####### ugly hack
        # if(i==myFields.Data[1]) {
        #   stats.i <- doBy::summaryBy(as.numeric(Water.Temp.C)~Date,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        # } else if(i==myFields.Data[2]) {
        #   stats.i <- doBy::summaryBy(as.numeric(Air.Temp.C)~Date,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        # } else if (i==myFields.Data[3]) {
        #   stats.i <- doBy::summaryBy(as.numeric(Water.Level.ft)~Date,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        # }
        # 20170524, use dv.i (line 270) hack
          ColNum.i <- match(i,names(myDF))
          names(myDF)[ColNum.i] <- "myVar"
          stats.i <- doBy::summaryBy(myVar ~ Date, data=myDF, FUN=myFUN.sumBy, na.rm=TRUE, var.names=myTimeFrame)
          names(myDF)[ColNum.i] <- i
        ##
        # Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.d <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
          plot(stats.i$mean,type=myPlot.Type
               ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
               ,ylim=c(min(stats.i$min),max(stats.i$max)))
          myCol <- "gray"
          graphics::lines(stats.i$max,col=myCol)
          graphics::lines(stats.i$min,col=myCol)
          graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                            , c(stats.i$max, rev(stats.i$min))
                            , col = myCol
                            , border = NA)
          graphics::lines(stats.i$mean)
          # X-Axis
          n.Total <- length(factor(stats.i[,"TimeValue"]))
          pct <- c(20,40,60,80,100)*.01
          myAT <- c(1,round(n.Total * pct,0))
          myLab <- stats.i[,"TimeValue"][myAT]
          graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()

      ## Julian Day
      myTimeFrame <- "JulianDay"
      myTF.Field <- ContData.env$myName.JuDa
      myDF <- dv.i
      #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~YearMonth,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
      ## ugly hack
      stats.i <- doBy::summaryBy(mean ~ JulianDay, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
      ##
      #Range
      #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
      # rename
      names(stats.i) <- c("TimeValue",myFUN.Names)
      stats.i[,"Parameter"] <- i
      stats.i[,"TimeFrame"] <- myTimeFrame
      stats.i.jd <- stats.i
      # plot
      myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
      #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
      #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
      plot(stats.i$mean,type=myPlot.Type
           ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
           ,ylim=c(min(stats.i$min),max(stats.i$max)))
      myCol <- "gray"
      graphics::lines(stats.i$max,col=myCol)
      graphics::lines(stats.i$min,col=myCol)
      graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                        , c(stats.i$max, rev(stats.i$min))
                        , col = myCol
                        , border = NA)
      graphics::lines(stats.i$mean)
      # X-Axis
      n.Total <- length(factor(stats.i[,"TimeValue"]))
      pct <- c(20,40,60,80,100)*.01
      myAT <- c(1,round(n.Total * pct,0))
      myLab <- stats.i[,"TimeValue"][myAT]
      graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
      #dev.off()

      ## Year_Month
        myTimeFrame <- "year_month"
        myTF.Field <- ContData.env$myName.YrMo
        myDF <- dv.i
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~YearMonth,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ## ugly hack
          stats.i <- doBy::summaryBy(mean ~ YearMonth, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
        ##
        #Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.ym <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
        plot(stats.i$mean,type=myPlot.Type
             ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
             ,ylim=c(min(stats.i$min),max(stats.i$max)))
        myCol <- "gray"
        graphics::lines(stats.i$max,col=myCol)
        graphics::lines(stats.i$min,col=myCol)
        graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                          , c(stats.i$max, rev(stats.i$min))
                          , col = myCol
                          , border = NA)
        graphics::lines(stats.i$mean)
        # X-Axis
        n.Total <- length(factor(stats.i[,"TimeValue"]))
        myAT <- seq_len(n.Total)
        myLab <- stats.i[,"TimeValue"][myAT]
        graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()
      #

        ## Month (all years)
        myTimeFrame <- "month"
        myTF.Field <- ContData.env$myName.Mo
        myDF <- dv.i
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~YearMonth,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ## ugly hack
        stats.i <- doBy::summaryBy(mean ~ Month, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
        ##
        #Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.m <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
        plot(stats.i$mean,type=myPlot.Type
             ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
             ,ylim=c(min(stats.i$min),max(stats.i$max)))
        myCol <- "gray"
        graphics::lines(stats.i$max,col=myCol)
        graphics::lines(stats.i$min,col=myCol)
        graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                          , c(stats.i$max, rev(stats.i$min))
                          , col = myCol
                          , border = NA)
        graphics::lines(stats.i$mean)
        # X-Axis
        n.Total <- length(factor(stats.i[,"TimeValue"]))
        myAT <- seq_len(n.Total)
        myLab <- stats.i[,"TimeValue"][myAT]
        graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()
        #
      ## Year_Season
        myTimeFrame <- "year_season"
        myTF.Field <- ContData.env$myName.YrSeason
        myDF <- dv.i
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~SeasonYear,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ## ugly hack
        stats.i <- doBy::summaryBy(mean ~ YearSeason, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
        ###
        # Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.ys <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
        plot(stats.i$mean,type=myPlot.Type
             ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
             ,ylim=c(min(stats.i$min),max(stats.i$max)))
        myCol <- "gray"
        graphics::lines(stats.i$max,col=myCol)
        graphics::lines(stats.i$min,col=myCol)
        graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                          , c(stats.i$max, rev(stats.i$min))
                          , col = myCol
                          , border = NA)
        graphics::lines(stats.i$mean)
        # X-Axis
        n.Total <- length(factor(stats.i[,"TimeValue"]))
        myAT <- seq_len(n.Total)
        myLab <- stats.i[,"TimeValue"][myAT]
        graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()
      #
        #
        ## Season (all years)
        myTimeFrame <- "season"
        myTF.Field <- ContData.env$myName.Season
        myDF <- dv.i
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~SeasonYear,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ## ugly hack
        stats.i <- doBy::summaryBy(mean ~ Season, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
        ##
        # Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.s <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
        plot(stats.i$mean,type=myPlot.Type
             ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
             ,ylim=c(min(stats.i$min),max(stats.i$max)))
        myCol <- "gray"
        graphics::lines(stats.i$max,col=myCol)
        graphics::lines(stats.i$min,col=myCol)
        graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                          , c(stats.i$max, rev(stats.i$min))
                          , col = myCol
                          , border = NA)
        graphics::lines(stats.i$mean)
        # X-Axis
        n.Total <- length(factor(stats.i[,"TimeValue"]))
        myAT <- seq_len(n.Total)
        myLab <- stats.i[,"TimeValue"][myAT]
        graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()
        #
      ## Year
        myTimeFrame <- "year"
        myTF.Field <- ContData.env$myName.Yr
        myDF <- dv.i
        #stats.i <- doBy::summaryBy(as.numeric(myDF[,i])~Year,data=myDF,FUN=myFUN.sumBy,var.names=myTimeFrame)
        ## ugly hack
        stats.i <- doBy::summaryBy(mean ~ Year, data=myDF, FUN=myFUN.sumBy, var.names=myTimeFrame)
        ##
        # Range
        #stats.i[,paste(myTimeFrame,"range",sep=".")] <- stats.i[,paste(myTimeFrame,"max",sep=".")] - stats.i[,paste(myTimeFrame,"min",sep=".")]
        # rename
        names(stats.i) <- c("TimeValue",myFUN.Names)
        stats.i[,"Parameter"] <- i
        stats.i[,"TimeFrame"] <- myTimeFrame
        stats.i.y <- stats.i
        # plot
        myPlot.Type <- ifelse(nrow(stats.i)==1,"p","l")
        #strFile.plot <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,myTimeFrame,sep="_"),"png",sep=".")
        #png(file=paste(myDir.data.export,strFile.plot,sep="/"))
        plot(stats.i$mean,type=myPlot.Type
             ,main=i,ylab="mean",xlab=myTimeFrame,xaxt="n"
             ,ylim=c(min(stats.i$min),max(stats.i$max)))
        myCol <- "gray"
        graphics::lines(stats.i$max,col=myCol)
        graphics::lines(stats.i$min,col=myCol)
        graphics::polygon(c(seq_len(nrow(stats.i)), rev(seq_len(nrow(stats.i))))
                          , c(stats.i$max, rev(stats.i$min))
                          , col = myCol
                          , border = NA)
        graphics::lines(stats.i$mean)
        # X-Axis
        n.Total <- length(factor(stats.i[,"TimeValue"]))
        myAT <- seq_len(n.Total)
        myLab <- stats.i[,"TimeValue"][myAT]
        graphics::axis(1,at=myAT,labels=myLab,tick=TRUE)
        #dev.off()
      #
      #

    grDevices::dev.off()##PDF.END



    # Combine (all the same so just rbind)
    stats.i.ALL <- rbind(stats.i.y, stats.i.s, stats.i.ys, stats.i.m, stats.i.ym, stats.i.jd, stats.i.d)
    stats.i.ALL[,ContData.env$myName.SiteID] <- fun.myData.SiteID

    # rearrange columns (last 2 to first 2)
    myCol.Order <- c(ncol(stats.i.ALL)
                     , (ncol(stats.i.ALL)-2)
                     , (ncol(stats.i.ALL)-1)
                     , seq_len((ncol(stats.i.ALL)-3)))
    #stats.i.ALL <- stats.i.ALL[,c(myName.SiteID,(ncol(stats.i.ALL)-2):(ncol(stats.i.ALL)-1),2:ncol(stats.i.ALL)-3)]
    stats.i.ALL <- stats.i.ALL[,myCol.Order]
    # save stats
    strFile.Prefix.Out <- fun.myProcedure.Step
    strFile.Out <- paste(paste(strFile.Prefix.Out,strFile.SiteID,fun.myData.Type,strFile.Date.Start,strFile.Date.End,i,sep=ContData.env$myDelim),"csv",sep=".")
    #write.csv(stats.i.ALL,paste(myDir.data.export,strFile.Out,sep="/"),quote=FALSE,row.names=FALSE)
    utils::write.csv(stats.i.ALL,file.path(myDir.data.export,strFile.Out),quote=FALSE,row.names=FALSE)
    #

    # need to inform user what part of loop


    #
  }##FOR.i.END
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Run QC Report
#       fun.myData.SiteID           <- strFile.SiteID
#       fun.myData.Type             <- strFile.DataType
#       fun.myData.DateRange.Start  <- fun.myData.DateRange.Start
#       fun.myData.DateRange.End    <- fun.myData.DateRange.End
#       fun.myDir.BASE              <- fun.myDir.BASE
#       fun.myDir.SUB.import        <- fun.myDir.SUB.export
#       fun.myDir.SUB.export        <- fun.myDir.SUB.export
#       fun.myFile.Prefix           <- fun.myProcedure.Step
  # will run repeatedly for each subfile for STATS
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # need to run for each parameter, comment out for now
      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   fun.Report(strFile.SiteID
#                ,strFile.DataType
#                ,fun.myData.DateRange.Start
#                ,fun.myData.DateRange.End
#                ,fun.myDir.BASE
#                ,fun.myDir.SUB.export
#                ,fun.myDir.SUB.export
#                ,fun.myProcedure.Step)  #"STATS"
  #
}##FUN.fun.Stats.END
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#   # Define FUNCTION for use with doBy::summaryBy
#   fun.sumby <- function(x, ...){##FUN.START
#     c(min=min(x,na.rm=TRUE),avg=mean(x,na.rm=TRUE),max=max(x,na.rm=TRUE),var=var(x,na.rm=TRUE),range=max(x,na.rm=TRUE)-min(x,na.rm=TRUE))
#   }##FUN.END
#   #
#
#   myParam <- myName.AirTemp
#
#   # 0.3. avg by month+year (and n) - Temp
#   data.import.avg.monthyear <- doBy::summaryBy(myParam ~ myName.SiteID + month, data=data.import, FUN=mean, na.rm=TRUE)
#   head(data.import.avg.monthyear)
#
#
#   DVmean <- doBy::summaryBy(myParam ~ myName.SiteID, data=data.import, FUN=c(mean))
#
#
#   # Loop - Time Frame (daily, monthly, seasonal, annual) (no water year only calendar year)
#
#
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   # old code - START
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   # force loading of needed libraries
#
#
#
#   # Define FUNCTION for use with summaryBy
#   fun.sumby <- function(x, ...){##FUN.START
#     c(avg=mean(x, ...), n=length(x))
#   }##FUN.END
#   #
#   fun.save <- function(myDF,myOutput) {##FUN.START
#     write.table(myDF,file=myOutput,sep="\t",quote=FALSE,row.names=FALSE,col.names=TRUE)
#   }##FUN.END
#
#   # Define Counters for the LOOP
#   myCounter.Start <- 1
#   myCounter <- myCounter.Start
#   myCounter.Stop = length(items2process)
#   print(paste("Total items to process = ",myCounter.Stop-myCounter.Start+1,sep=""))
#
#   #
#   #
#   #
#   # 1. wrap data manipulation in a loop
#   while (myCounter.Start < myCounter.Stop)
#   { #LOOP.WHILE.START
#     #
#     # 0.1. import the data file
#     myFile <- items2process[myCounter]
#     mySep <- "\t"
#     data.import <- read.table(myFile,header=T,mySep)
#     #
#     # 0.2. Add Field = month from datetime
#     data.import$month <- format.Date(data.import$datetime,"%m")
#     head(data.import)
#     #
#     # Display progress to user (needs flush.console or only writes at end)
#     # put here so some time between crunching the numbers and saving
#     print(paste("Processing item ",myCounter," of ",myCounter.Stop-myCounter.Start+1,"; ",myFile,".",sep=""))
#     flush.console()
#     #
#     # 0.3. avg Q by month+year (and n)
#     data.import.avg.monthyear <- doBy::summaryBy(Q_mean_cfs ~ agency_cd + site_no + year + month, data=data.import, FUN=fun.sumby, na.rm=TRUE)
#     head(data.import.avg.monthyear)
#     # drop months with < 28 measurements
#     data.import.avg.monthyear <- subset(data.import.avg.monthyear, Q_mean_cfs.n>=28)
#     # rename columns
#     colnames(data.import.avg.monthyear) <- c(colnames(data.import.avg.monthyear[,1:4]),"Q_mean_cfs","n")
#     # 0.4. avg Q by year (and n)
#     data.import.avg.year <- doBy::summaryBy(Q_mean_cfs ~ agency_cd + site_no + year, data=data.import.avg.monthyear, FUN=fun.sumby, na.rm=TRUE)
#     head(data.import.avg.year)
#     data.import.avg.year <- subset(data.import.avg.year, Q_mean_cfs.n==12)
#     # rename columns
#     colnames(data.import.avg.year) <- c(colnames(data.import.avg.year[,1:3]),"Q_mean_cfs","n")
#     #
#     # 0.5. avg Q by month (and n)
#     data.import.avg.month <- doBy::summaryBy(Q_mean_cfs ~ agency_cd + site_no + month, data=data.import.avg.monthyear, FUN=fun.sumby, na.rm=TRUE)
#     head(data.import.avg.month)
#     # rename columns
#     colnames(data.import.avg.month) <- c(colnames(data.import.avg.month[,1:3]),"Q_mean_cfs","n")
#
#     # 0.6. Combine results into aggregate file
#     # Exception for 1st iteration - create file
#     if(myCounter==1) {##IF.START
#       # create files on first iteration
#       data.avg.monthyear  <- data.import.avg.monthyear
#       data.avg.year       <- data.import.avg.year
#       data.avg.month      <- data.import.avg.month
#     }##IF.END
#     if(myCounter>1) {##IF.START
#       data.avg.monthyear.rbind  <- rbind(data.avg.monthyear, data.import.avg.monthyear)
#       data.avg.monthyear        <- data.avg.monthyear.rbind
#       data.avg.year.rbind       <- rbind(data.avg.year, data.import.avg.year)
#       data.avg.year             <- data.avg.year.rbind
#       data.avg.month.rbind      <- rbind(data.avg.month, data.import.avg.month)
#       data.avg.month            <- data.avg.month.rbind
#     }##IF.END
#     #
#     #
#     # 0.7. Save the file (to same name as input file, i.e., overwrites orginal)
#     fun.save(data.avg.monthyear ,paste("Gage.Summary.MonthYear.",myDate,".txt",sep=""))
#     fun.save(data.avg.year      ,paste("Gage.Summary.Year.",myDate,".txt",sep=""))
#     fun.save(data.avg.month     ,paste("Gage.Summary.Month.",myDate,".txt",sep=""))
#     # Display progress to user
#     print(paste("Saving output ",myCounter," of ",myCounter.Stop-myCounter.Start+1,"; ",myFile,".",sep=""))
#     flush.console()
#     #
#     # 0.8. Some clean up
#     rm(data.import)
#     # Increase the Counter
#     myCounter <- myCounter+1
#   }##LOOP.WHILE.END
#
#   print(paste("Processing complete; ",myCounter-1," of ",myCounter.Stop," items.",sep=""))
#   print(paste("Last item processed = ",items2process[myCounter-1],".",sep="")) #use for troubleshooting if get error
#   alarm()
#
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     # old code - END
#     #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
