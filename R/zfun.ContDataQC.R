#' Master Script
#' 
#' Calls other scripts
#' 
# Master Continuous Data Script
# Will prompt user for what to do
# Erik.Leppo@tetratech.com
# 20151118
#################
# Master Functions Script that is invoked from a calling the master script
# The master will have different versions but will all call this one.
#
# Source all helper scripts
# If change location of scripts have to change here.
#myDir.Scripts <- "Scripts"
# as package don't need this section
# myFiles.Source <- paste(myDir.BASE,myDir.Scripts,c("fun.UserDefinedValues.R"
#                                                    ,"fun.DateFormat.R"
#                                                    ,"fun.Helper.R"
#                                                    ,"fun.QC.R"
#                                                    ,"fun.Report.R"
#                                                    ,"fun.AggregateData.R"
#                                                    ,"fun.GageData.R"
#                                                    ,"fun.Stats.R"
#                                                   ),sep="/")
# sapply(myFiles.Source,source,.GlobalEnv)                        
#
# source(paste(myDir.BASE,myDir.Scripts,"fun.UserDefinedValues.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.DateFormat.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.Helper.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.QC.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.QCReport.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.AggregateData.R",sep="/"))
# source(paste(myDir.BASE,myDir.Scripts,"fun.GageData.R",sep="/"))
#source(paste(myDir.BASE,myDir.Scripts,"fun.Stats.R",sep="/"))


#
# Function - Master
# Run different scripts depending upon user input
#' @export
ContDataQC <- function(fun.myData.Operation
                      ,fun.myData.SiteID
                      ,fun.myData.Type
                      ,fun.myData.DateRange.Start
                      ,fun.myData.DateRange.End
                      ,fun.myDir.BASE
                      ,fun.myDir.SUB.import
                      ,fun.myDir.SUB.export) 
  {##FUN.fun.Master.START
  #
  # Error checking.  If any null then kick back
  ## (add later)
  # 20160204, Check for required fields
  #   Add to individual scripts as need to load the file first
  # QC Check - delimiter in site ID
  QC.SiteID.myDelim <- grepl(myDelim,fun.myData.SiteID) #T/F
  if(QC.SiteID.myDelim==TRUE){##IF.QC.SiteID.myDelim.START
    myMsg <- paste("\n
              SiteID (",fun.myData.SiteID,") contains the same delimiter (",myDelim,") as in your file names.  
              \n
              Scripts will not work properly while this is true.
              \n 
              Change SiteID names so they do not include the same delimiter.
              \n
              Or change file names and the variable 'myDelim' in the script 'UserDefinedValue.R'.",sep="")
    stop(myMsg)
    #
  }##IF.QC.SiteID.myDelim.END
  #
  # 20151202, default directories
  #
  # Run different functions based on "fun.myOperation"
  if (fun.myData.Operation=="GetGageData"){##IF.fun.myOperation.START
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.1Raw}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.1Raw}
    fun.myData.Type <- "Gage"
    fun.GageData(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export)
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="QCRaw"){
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.1Raw}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.2QC}
    fun.QC(fun.myData.SiteID
           ,fun.myData.Type
           ,fun.myData.DateRange.Start
           ,fun.myData.DateRange.End
           ,fun.myDir.BASE
           ,fun.myDir.SUB.import
           ,fun.myDir.SUB.export)
    # runs the QC Report as part of sourced function but can run independantly below
  } else if (fun.myData.Operation=="ReportQC") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.2QC}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.2QC}
    myProcedure.Step <- "QC"
    fun.Report(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export
                 ,myProcedure.Step)  
  } else if (fun.myData.Operation=="Aggregate") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.2QC}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.3Agg}
    fun.AggregateData(fun.myData.SiteID
                      ,fun.myData.Type
                      ,fun.myData.DateRange.Start
                      ,fun.myData.DateRange.End
                      ,fun.myDir.BASE
                      ,fun.myDir.SUB.import
                      ,fun.myDir.SUB.export)
  } else if (fun.myData.Operation=="ReportAggregate") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.3Agg}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.3Agg}
    myProcedure.Step <- "DATA"
    fun.Report(fun.myData.SiteID
                 ,fun.myData.Type
                 ,fun.myData.DateRange.Start
                 ,fun.myData.DateRange.End
                 ,fun.myDir.BASE
                 ,fun.myDir.SUB.import
                 ,fun.myDir.SUB.export
                 ,myProcedure.Step)  
  } else if (fun.myData.Operation=="SummaryStats") {
    if (fun.myDir.SUB.import=="") {fun.myDir.SUB.import=myName.Dir.3Agg}
    if (fun.myDir.SUB.export=="") {fun.myDir.SUB.export=myName.Dir.4Stats}
    myProcedure.Step <- "STATS"
    fun.myFile.Prefix <- "DATA"
    fun.Stats(fun.myData.SiteID
              ,fun.myData.Type
              ,fun.myData.DateRange.Start
              ,fun.myData.DateRange.End
              ,fun.myDir.BASE
              ,fun.myDir.SUB.import
              ,fun.myDir.SUB.export
              ,myProcedure.Step
              ,fun.myFile.Prefix) 
  } else {
    myMsg <- "No operation provided."
    stop(myMsg)
  }##IF.fun.myOperation.END
  #
}##FUN.fun.Master.END
####################################################################

########
# QC
########
# fun.myData.SiteID <- myData.SiteID
# fun.myData.Type <- myData.Type
# fun.myData.DateRange.Start <- myData.DateRange.Start
# fun.myData.DateRange.End <- myData.DateRange.End
# fun.myDir.BASE <- myDir.BASE
# fun.myDir.SUB.import <- myDir.SUB.import
# fun.myDir.SUB.export <- myDir.SUB.export
# 
# rm(myData.SiteID)
# rm(myData.Type)
# rm(myData.DateRange.Start)
# rm(myData.DateRange.End)
# rm(myDir.SUB.import)
# rm(myDir.SUB.export)









