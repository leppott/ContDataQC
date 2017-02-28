# Sourced Routine
##################
# Download USGS Gage Data
##################
# Erik.Leppo@tetratech.com (EWL)
# 20151130
##################
#
# Basic Operations:
# download from USGS based on user selection
# daily means


# library (load any required helper functions)
#library(dataRetrieval)
#' @export
fun.GageData <- function(fun.myData.SiteID
                     ,fun.myData.Type
                     ,fun.myData.DateRange.Start
                     ,fun.myData.DateRange.End
                     ,fun.myDir.BASE
                     ,fun.myDir.SUB.import
                     ,fun.myDir.SUB.export) {##FUN.fun.GageData.START
  #
  # data directories
  myDir.data.import <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.import=="","",paste("/",fun.myDir.SUB.import,sep="")),sep="")
  myDir.data.export <- paste(fun.myDir.BASE,ifelse(fun.myDir.SUB.export=="","",paste("/",fun.myDir.SUB.export,sep="")),sep="")
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
  # Verify input dates, if blank, NA, or null use all data
  # if DateRange.Start is null or "" then assign it 1900-01-01
  if (is.na(fun.myData.DateRange.Start)==TRUE||fun.myData.DateRange.Start==""){fun.myData.DateRange.Start<-DateRange.Start.Default}
  # if DateRange.End is null or "" then assign it today
  if (is.na(fun.myData.DateRange.End)==TRUE||fun.myData.DateRange.End==""){fun.myData.DateRange.End<-DateRange.End.Default}
  #
  # Start Time (used to determine run time at end)
  myTime.Start <- Sys.time()
  #
  ##################################
  #    DD parameter   Description ("parameter_nm" from whatNWISdata)
  #    01   00060     Discharge, cubic feet per second
  #    02   00065     Gage height, feet
  #    05   00010     Temperature, water, degrees Celsius
  #    06   00020     Temperature, air, degrees Celsius
  #         00095     Conductivity
  #         00040     pH
  #         00300     DO
  #         63680     turbidity
  #         00045     precip
  #         62611     GWL
  #         72019     WLBLS
  #         00045     Precipitation, total, inches
  #
#   param.code <- c("00060"
#                   ,"00065"
#                   ,"00010"
#                   ,"00020"
#                   ,"00040"
#                   ,"00045")
#   param.desc <- c("Discharge, cubic feet per second"
#                   ,"Gage height, feet"
#                   ,"Temperature, water, degrees Celsius"
#                   ,"Temperature, air, degrees Celsius"
#                   ,"pH"
#                   ,"Precipitation, total, inches"
#                   )
#   USGS.Code.Desc <- as.data.frame(cbind(param.code,param.desc))
#   names(USGS.Code.Desc) <- c("Code","Desc")
  #
  ####################
  # USGS Statistic Codes
  # http://help.waterdata.usgs.gov/codes-and-parameters
  # 00011 Instantaneous
  # 00001 Max
  # 00002 Min
  # 00003 Mean (dataRetrieval default)
  # 00006 Sum
  
  # Define Counters for the Loop
  intCounter <- 0
  intCounter.Stop <- length(fun.myData.SiteID)
  intItems.Total <- intCounter.Stop
  print(paste("Total items to process = ",intItems.Total,sep=""))
    flush.console()
  myItems.Complete  <- 0
  #myItems.Skipped   <- 0

  ######################
  # Loop through sites
  ######################
  while (intCounter < intCounter.Stop) {##WHILE.START
    intCounter <- intCounter+1
    strGage <- fun.myData.SiteID[intCounter]
    #
    # Get available data
    data.what.uv <- dataRetrieval::whatNWISdata(strGage,service="uv")
    # future versions to get all available data
    data.what.uv.param <- data.what.uv[,"parameter_nm"]
    #
    #data.what.Codes <- as.vector(USGS.Code.Desc[,"Code"][data.what.uv[,"parameter_nm"]%in%USGS.Code.Desc$Desc])
    data.what.Codes <- data.what.uv[,"parm_cd"]
    
    # inform user
    cat("\n")
    print(paste("Getting available data; ",strGage,".",sep=""))
    cat("\n")
    print(data.what.uv)
    cat("\n")
    flush.console()
    
    myCode <- data.what.Codes #"00060" #c("00060","00065") # can download multiple at one time
    myStat <- "00003"  #data, not daily values
    data.myGage <- dataRetrieval::readNWISuv(strGage, myCode
                              , startDate=fun.myData.DateRange.Start, endDate=fun.myData.DateRange.End, tz=myTZ )
    
    # column headers are "X_myCode_myStat"
    # can put in multipe and it only runs on those present
    data.myGage <- dataRetrieval::renameNWISColumns(data.myGage
                      ,p00060=myName.Discharge
                      ,p00065=myName.WaterLevel
                      ,p00010=myName.WaterTemp
                      ,p00020=myName.AirTemp
                      ,p00040="pH"
                      ,p00045="Precip.Total.in"
                      ,p00011=gsub(".C",".F",myName.WaterTemp)
                      )
    # different data structure for dataRetrieval
    names(data.myGage)
    
    
    # drop columns for Agency Code and TimeZone
    myDrop <- c("agency_cd","tz_cd")
    myKeep <- names(data.myGage)[! names(data.myGage) %in% myDrop]
    data.myGage <- data.myGage[,myKeep]
    # and code column
    #data.myGage <- data.myGage[,-ncol(data.myGage.q)]
    
    ##############
    # hard code only Discharge due to time limits on project
    
  #   NewNames <- c(myName.SiteID,myName.DateTime,myName.Discharge,paste("_cd",myName.Discharge,sep="."))
  #   names(data.myGage) <- NewNames
    
  
    # replace "_Inst" with null and leave "_cd"
    names(data.myGage) <- gsub("_Inst","",names(data.myGage))
    # mod SiteID and DateTIme
    names(data.myGage)[1:2] <- c(myName.SiteID,myName.DateTime)
    
    
    ## Add GageID field so can retain (20160205)
    data.myGage <- cbind(GageID=strGage,data.myGage)
    
    
    
  #   #############################################
  #   # old waterData code, start, unused now
  #   #############################################
  #   data.myGage.q  <- importDVs(fun.myData.SiteID, code="00060", sdate=fun.myData.DateRange.Start, edate=fun.myData.DateRange.End)
  #  # data.myGage.gh <- importDVs(fun.myData.SiteID, code="00065", sdate=fun.myData.DateRange.Start, edate=fun.myData.DateRange.End)
  # #   data.myGage.tw <- importDVs(fun.myData.SiteID, code="00010", sdate=fun.myData.DateRange.Start, edate=fun.myData.DateRange.End)
  # #   data.myGage.ta <- importDVs(fun.myData.SiteID, code="00020", sdate=fun.myData.DateRange.Start, edate=fun.myData.DateRange.End)
  #   
  #   # Column Names - Define
  #   myParam <- myName.Discharge
  #     names.q   <- c(myName.SiteID,myParam,myName.Date,paste("Flag",myParam,sep="."))
  #   myParam <- myName.WaterLevel
  #     names.gh  <- c(myName.SiteID,myParam,myName.Date,paste("Flag",myParam,sep="."))
  # #   myParam <- myName.WaterTemp
  # #     names.tw  <- c(myName.SiteID,myParam,myName.Date,paste("Flag",myParam,sep="."))
  # #   myParam <- myName.AirTemp
  # #     names.ta  <- c(myName.SiteID,myParam,myName.Date,paste("Flag",myParam,sep="."))
  #   # Column Names - Apply
  #   names(data.myGage.q)  <- names.q
  # #  names(data.myGage.gh) <- names.gh
  # #   names(data.myGage.tw) <- names.tw
  # #   names(data.myGage.ta) <- names.ta
  #   
  #   # Merge "q" and "gh"
  #   if(exists("data.myGage.q")==FALSE & exists("data.myGage.gh")==FALSE) {
  #     data.myGage.merge <- merge(data.myGage.q,data.myGage.gh,by=dates,all=TRUE) 
  #   } else if(exists("data.myGage.q")==TRUE & exists("data.myGage.gh")==TRUE) {
  #     stop("No USGS data.")
  #   } else if (exists("data.myGage.q")==TRUE & exists("data.myGage.gh")==FALSE) {
  #     data.myGage.merge <- data.myGage.q
  #   } else if (exists("data.myGage.q")==FALSE & exists("data.myGage.gh")==TRUE) {
  #     data.myGage.merge <- data.myGage.gh
  #   }
  #   #############################################
  #   # old waterData code, end, unused now
  #   #############################################
    
    
    
    
    
    
    # Rework Start and End Dates to match data in file
    strFile.Date.Start  <- format(min(data.myGage[,myName.DateTime]),myFormat.Date)
    strFile.Date.End    <- format(max(data.myGage[,myName.DateTime]),myFormat.Date)
    
    # 10.0. Output file
    # 10.1. Set Name
    File.Date.Start <- format(as.Date(strFile.Date.Start,myFormat.Date),"%Y%m%d")
    File.Date.End   <- format(as.Date(strFile.Date.End,myFormat.Date),"%Y%m%d")
    strFile.Out.Prefix <- "Gage"
    strFile.Out <- paste(paste(strGage,fun.myData.Type,File.Date.Start,File.Date.End,sep=myDelim),"csv",sep=".")
    # 10.2. Save to File the data (overwrites any existing file).
    #print(paste("Saving output of file ",intCounter," of ",intCounter.Stop," files complete.",sep=""))
    #flush.console()
    write.csv(data.myGage,file=paste(myDir.data.export,"/",strFile.Out,sep=""),quote=FALSE,row.names=FALSE)
    #
    # 11. Clean up
    cat("\n")
    # 11.1. Inform user of progress and update LOG
    myMsg <- "COMPLETE"
    myItems.Complete <- myItems.Complete + 1
    #myItems.Log[intCounter,2] <- myMsg
    #fun.write.log(myItems.Log,myDate,myTime)
    fun.Msg.Status(myMsg, intCounter, intItems.Total, strGage)
    cat("\n")
    flush.console()
    # 11.2. Remove data
    rm(data.myGage)
  #  rm(data.myGage.gh)
    

    
  }##WHILE.END
  ######################
  # Loop through sites
  ######################
  
  # inform user task complete with status
  myTime.End <- Sys.time()
  
  myTime.End <- Sys.time()
  print(paste("Task COMPLETE; ",round(difftime(myTime.End,myTime.Start,units="mins"),2)," min.",sep=""))
  flush.console()
  
  # encase in loop so can handle multiple SiteIDs
  
  
  
  #
}##FUN.fun.GageData.END
########################
