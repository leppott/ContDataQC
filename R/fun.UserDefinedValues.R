#' User Defined Values
#' 
#' User defined values for variables used across multiple functions in this library.
#' The user had the ability to modify the values for names, units, QC thresholds, etc.
#
# Continuous data helper script
# Default Values
# Erik.Leppo@tetratech.com (EWL)
# 20150928
##################
# User defined variable names for input data
##################
# It is assumed that this R script is stored in a directory with the data files as subdirectories
# This script is intended to be "source"d from the main script.
#############################
#' @keywords continuous data
#' @examples
#' #Not intended to be accessed indepedant of function ContDataQC().
#' #Data values only.  No functions.
#####################################################################
# USER may make modifications in this section but not mandatory
# this section could be sourced so can use between scripts
#####################################################################
UserDefinedValues <- NA # default value so shows up in help files
#####################################################################
# Delimiter in File Names (e.g., test2_AW_201301_20131231.csv)
myDelim <- "_"
#####################################################################
# Acceptable column names for the data 
#(special characters (e.g., %, space, or /) are converted to "." by R, "deg" converted to "A")
myUnits.AirTemp     <- "C" # C or F
myUnits.WaterTemp   <- myUnits.AirTemp
myUnits.AirBP       <- "psi"
myUnits.WaterP      <- myUnits.AirBP
myUnits.WaterLevel  <- "ft"
myUnits.Discharge   <- "ft3.s"
## Air and Water
myName.SiteID         <- "SiteID"
myName.Date           <- "Date"
myName.Time           <- "Time"
myName.DateTime       <- "Date.Time"
## Water
myName.RowID.Water    <- "Water.RowID"
myName.LoggerID.Water <- "Water.LoggerID"
myName.WaterTemp      <- paste("Water.Temp.",myUnits.WaterTemp,sep="")  # "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R.
## Air
myName.RowID.Air      <- "Air.RowID"
myName.LoggerID.Air   <- "Air.LoggerID"
myName.AirTemp        <- paste("Air.Temp.",myUnits.AirTemp,sep="")   # "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R.
myName.WaterP         <- paste("Water.BP.",myUnits.WaterP,sep="")
myName.AirBP          <- paste("Air.BP.",myUnits.WaterP,sep="")
myName.WaterLevel     <- paste("Water.Level.",myUnits.WaterLevel,sep="")
myName.Discharge      <- paste("Discharge.",myUnits.Discharge,sep="")
## plot labels
myLab.WaterTemp       <- paste("Temperature, Water (deg ",myUnits.WaterTemp,")",sep="")
myLab.AirTemp         <- paste("Temperature, Air (deg ",myUnits.AirTemp,")",sep="")
myLab.Date            <- "Date"
myLab.DateTime        <- "Date"
myLab.WaterP          <- paste("Pressure, Water (",myUnits.AirBP,")",sep="")
myLab.AirBP           <- paste("Barometric Pressure, Air (",myUnits.WaterP,")",sep="")
myLab.WaterLevel      <- paste("Water Level (",myUnits.WaterLevel,")",sep="")
myLab.Temp.BOTH       <- paste("Temperature (deg ",myUnits.WaterTemp,")",sep="")
myLab.Discharge       <- paste("Discharge (ft3/s)")
#####################################################################
# Discrete Measurements
myPrefix.Discrete           <- "Discrete"
myName.Discrete.WaterTemp   <- paste(myPrefix.Discrete,myName.WaterTemp,sep=".")
myName.Discrete.AirTemp     <- paste(myPrefix.Discrete,myName.AirTemp,sep=".")
myName.Discrete.WaterP      <- paste(myPrefix.Discrete,myName.WaterP,sep=".")
myName.Discrete.AirBP       <- paste(myPrefix.Discrete,myName.AirBP,sep=".")
myName.Discrete.WaterLevel  <- paste(myPrefix.Discrete,myName.WaterLevel,sep=".")
myName.Discrete.Discharge   <- paste(myPrefix.Discrete,myName.Discharge,sep=".")
myLab.Discrete.WaterTemp    <- paste(myLab.WaterTemp,"(Discrete)",sep=" ")
myLab.Discrete.AirTemp      <- paste(myLab.AirTemp,"(Discrete)",sep=" ")
myLab.Discrete.WaterP       <- paste(myLab.WaterP,"(Discrete)",sep=" ")
myLab.Discrete.AirBP        <- paste(myLab.AirBP,"(Discrete)",sep=" ")
myLab.Discrete.WaterLevel   <- paste(myLab.WaterLevel,"(Discrete)",sep=" ")
myLab.Discrete.Discharge    <- paste(myLab.Discharge,"(Discrete)",sep=" ")
#####################################################################
# Automated QC stuff
## data type/stages
myDataQuality.Raw         <- "RAW"
myDataQuality.QCauto      <- "QCauto"
myDataQuality.QCmanual    <- "QCmanual"
myDataQuality.Final       <- "Final"
myDataQuality.Aggregated  <- "Aggregated"
#####################################################################
# Directory Names
myName.Dir.1Raw   <- "Data1_Raw"
myName.Dir.2QC    <- "Data2_QC"
myName.Dir.3Agg   <- "Data3_Aggregated"
myName.Dir.4Stats <- "Data4_Stats"
#####################################################################
# Data Fields
myNames.DataFields <- c(myName.WaterTemp,myName.AirTemp,myName.WaterP,myName.AirBP,myName.WaterLevel,myName.Discharge
                        ,myName.Discrete.WaterTemp,myName.Discrete.AirTemp,myName.Discrete.WaterP,myName.Discrete.AirBP,myName.Discrete.WaterLevel,myName.Discrete.Discharge)
myNames.DataFields.Lab <- c(myLab.WaterTemp,myLab.AirTemp,myLab.WaterP,myLab.AirBP,myLab.WaterLevel,myLab.Discharge
                            ,myLab.Discrete.WaterTemp,myLab.Discrete.AirTemp,myLab.Discrete.WaterP,myLab.Discrete.AirBP,myLab.Discrete.WaterLevel,myLab.Discrete.Discharge)
myNames.DataFields.Col <- c("blue","green","gray","gray","black","brown")
#
## Name Order (change order below to change order in output file)
myNames.Order <- c(myName.SiteID,myName.Date,myName.Time,myName.DateTime,myName.WaterTemp,myName.LoggerID.Air,myName.RowID.Air
                   ,myName.AirTemp,myName.WaterP,myName.AirBP,myName.WaterLevel,myName.LoggerID.Water,myName.RowID.Water,myName.Discharge
                   ,myName.Discrete.WaterTemp,myName.Discrete.AirTemp,myName.Discrete.WaterP,myName.Discrete.AirBP,myName.Discrete.WaterLevel,myName.Discrete.Discharge)
######################################################################
## Data Quality Flag Values
myFlagVal.Pass     <- "P"
myFlagVal.NotEval  <- "NA"
myFlagVal.Suspect  <- "S"
myFlagVal.Fail     <- "F"
myFlagVal.NoData   <- "X"
myFlagVal.Order    <- c(myFlagVal.Pass,myFlagVal.Suspect,myFlagVal.Fail,myFlagVal.NoData)
#####################################################################
# QC Tests and Calculations
#http://stackoverflow.com/questions/16143700/pasting-two-vectors-with-combinations-of-all-vectors-elements
#myNames.QCTests.Calcs.combo <- as.vector(t(outer(myNames.QCTests,myNames.QCTests.Calcs,paste,sep=".")))
# combine so can check for and remove later.
#myNames.DataFields.QCTests.Calcs.combo <- as.vector(t(outer(myNames.DataFields,myNames.QCTests.Calcs.combo,paste,sep=".")))
# Data Quality Flag Thresholds
## Gross Min/Max, Fail (equipment)
myThresh.Gross.Fail.Hi.WaterTemp  <- 30
myThresh.Gross.Fail.Lo.WaterTemp  <- -2
myThresh.Gross.Fail.Hi.AirTemp    <- 35
myThresh.Gross.Fail.Lo.AirTemp    <- -25
myThresh.Gross.Fail.Hi.WaterP    <- 17
myThresh.Gross.Fail.Lo.WaterP    <- 11
myThresh.Gross.Fail.Hi.AirBP      <- 17
myThresh.Gross.Fail.Lo.AirBP      <- 11
myThresh.Gross.Fail.Hi.WaterLevel <- 6    # no longer used (only check for negative values for WaterLevel)
myThresh.Gross.Fail.Lo.WaterLevel <- -1   # no longer used (only check for negative values for WaterLevel)
myThresh.Gross.Fail.Hi.Discharge <-  10^5 #dependant upon stream size (only checkf or negative values)
myThresh.Gross.Fail.Lo.Discharge <-  -1   #dependant upon stream size
## Gross Min/Max, Suspect (extreme)
myThresh.Gross.Suspect.Hi.WaterTemp  <- 25
myThresh.Gross.Suspect.Lo.WaterTemp  <- -1
myThresh.Gross.Suspect.Hi.AirTemp    <- 30
myThresh.Gross.Suspect.Lo.AirTemp    <- -20
myThresh.Gross.Suspect.Hi.WaterP    <- 16
myThresh.Gross.Suspect.Lo.WaterP    <- 12
myThresh.Gross.Suspect.Hi.AirBP      <- 16
myThresh.Gross.Suspect.Lo.AirBP      <- 12
myThresh.Gross.Suspect.Hi.WaterLevel <- 5    # no longer used (only check for negative values for WaterLevel)
myThresh.Gross.Suspect.Lo.WaterLevel <- 0    # no longer used (only check for negative values for WaterLevel)
myThresh.Gross.Suspect.Hi.Discharge <-  10^3 #dependant upon stream size (only checkf or negative values
myThresh.Gross.Suspect.Lo.Discharge <-  -1   #dependant upon stream size
## Spike thresholds (absolute change)
myThresh.Spike.Hi.WaterTemp   <- 10
myThresh.Spike.Lo.WaterTemp   <- 5
myThresh.Spike.Hi.AirTemp     <- 10
myThresh.Spike.Lo.AirTemp     <- 5
myThresh.Spike.Hi.WaterP     <- 5
myThresh.Spike.Lo.WaterP     <- 3
myThresh.Spike.Hi.AirBP       <- 5
myThresh.Spike.Lo.AirBP       <- 3
myThresh.Spike.Hi.WaterLevel  <- 5
myThresh.Spike.Lo.WaterLevel  <- 3
myThresh.Spike.Hi.Discharge   <- 10^4 #dependant upon stream size
myThresh.Spike.Lo.Discharge   <- 10^3 #dependant upon stream size
## Rate of Change (relative change)
myDefault.RoC.SD.number   <- 3
myDefault.RoC.SD.period   <- 25 #hours
myThresh.RoC.SD.number.WaterTemp  <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.WaterTemp  <- myDefault.RoC.SD.period
myThresh.RoC.SD.number.AirTemp    <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.AirTemp    <- myDefault.RoC.SD.period
myThresh.RoC.SD.number.WaterP     <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.WaterP     <- myDefault.RoC.SD.period
myThresh.RoC.SD.number.AirBP      <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.AirBP      <- myDefault.RoC.SD.period
myThresh.RoC.SD.number.WaterLevel <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.WaterLevel <- myDefault.RoC.SD.period
myThresh.RoC.SD.number.Discharge  <- myDefault.RoC.SD.number
myThresh.RoC.SD.period.Discharge  <- myDefault.RoC.SD.period
## No Change (flat-line)
myDefault.Flat.Hi         <- 30  # maximum is myThresh.Flat.MaxComp
myDefault.Flat.Lo         <- 10
myDefault.Flat.Tolerance  <- 0.01 # set to one sigdig less than measurements.  Check with fivenum(x)
myThresh.Flat.Hi.WaterTemp          <- myDefault.Flat.Hi
myThresh.Flat.Lo.WaterTemp          <- myDefault.Flat.Lo
myThresh.Flat.Tolerance.WaterTemp   <- 0.01
myThresh.Flat.Hi.AirTemp            <- myDefault.Flat.Hi
myThresh.Flat.Lo.AirTemp            <- myDefault.Flat.Lo
myThresh.Flat.Tolerance.AirTemp     <- 0.01
myThresh.Flat.Hi.WaterP             <- myDefault.Flat.Hi
myThresh.Flat.Lo.WaterP             <- myDefault.Flat.Lo
myThresh.Flat.Tolerance.WaterP      <- 0.001
myThresh.Flat.Hi.AirBP              <- myDefault.Flat.Hi
myThresh.Flat.Lo.AirBP              <- myDefault.Flat.Lo
myThresh.Flat.Tolerance.AirBP       <- 0.001
myThresh.Flat.Hi.WaterLevel         <- myDefault.Flat.Hi * 2
myThresh.Flat.Lo.WaterLevel         <- myDefault.Flat.Lo * 2
myThresh.Flat.Tolerance.WaterLevel  <- 0.0
myThresh.Flat.Hi.Discharge          <- myDefault.Flat.Hi * 2
myThresh.Flat.Lo.Discharge          <- myDefault.Flat.Lo * 2
myThresh.Flat.Tolerance.Discharge   <- 0.01
myThresh.Flat.MaxComp     <- max(myThresh.Flat.Hi.WaterTemp
                                 ,myThresh.Flat.Hi.AirTemp
                                 ,myThresh.Flat.Hi.WaterP
                                 ,myThresh.Flat.Hi.AirBP
                                 ,myThresh.Flat.Hi.WaterLevel
                                 ,myThresh.Flat.Hi.Discharge)
#####################################################################
# Data Fields with Flags
myName.Flag <- "Flag" # flag prefix
myNames.Cols4Flags <- c(myName.DateTime,myNames.DataFields)
myNames.Flags <- paste(myName.Flag,myNames.Cols4Flags,sep=".")  # define ones using in the calling script
## flag labels
myName.Flag.DateTime    <- paste(myName.Flag,myName.DateTime,sep=".")
myName.Flag.WaterTemp   <- paste(myName.Flag,myName.WaterTemp,sep=".")
myName.Flag.AirTemp     <- paste(myName.Flag,myName.AirTemp,sep=".")
myName.Flag.WaterP      <- paste(myName.Flag,myName.WaterP,sep=".")
myName.Flag.AirBP       <- paste(myName.Flag,myName.AirBP,sep=".")
myName.Flag.WaterLevel  <- paste(myName.Flag,myName.WaterLevel,sep=".")
myName.Flag.Discharge   <- paste(myName.Flag,myName.Discharge,sep=".")
# Data Quality Test Names
myNames.QCTests <- c("Gross","Spike","RoC","Flat")
myNames.QCCalcs <- c("SD.Time","SD","SDxN",paste("n",1:myThresh.Flat.MaxComp,sep="."),"flat.Lo","flat.Hi")
#####################################################################
# Exceedance values for stats (default to Gross-Suspect-Hi value)
myExceed.WaterTemp  <- myThresh.Gross.Suspect.Hi.WaterTemp
myExceed.AirTemp    <- myThresh.Gross.Suspect.Hi.AirTemp
myExceed.WaterLevel <- myThresh.Gross.Suspect.Hi.WaterLevel
#####################################################################
# Date and Time Formats
myFormat.Date           <- "%Y-%m-%d"
myFormat.Time           <- "%H:%M:%S"
myFormat.DateTime       <- "%Y-%m-%d %H:%M:%S"
DateRange.Start.Default <- "1900-01-01" #YYYY-MM-DD
DateRange.End.Default   <- format(Sys.Date(),"%Y-%m-%d")
# Time Zone, used in Gage script in dataRetrieval
myTZ <- "America/New_York"
######################################################################
# Time Frames (MM-DD)
myTimeFrame.Annual.Start        <- "0101"
myTimeFrame.Annual.End          <- "1231"
myTimeFrame.WaterYear.Start     <- "1001"
#myTimeFrame.WaterYear.End      <- "0930"
myTimeFrame.Season.Spring.Start <- "0301"
#myTimeFrame.Season.Spring.End  <- "0531"
myTimeFrame.Season.Summer.Start <- "0601"
#myTimeFrame.Season.Summer.End  <- "0831"
myTimeFrame.Season.Fall.Start   <- "0901"
#myTimeFrame.Season.Fall.End    <- "1130"
myTimeFrame.Season.Winter.Start <- "1201"
#myTimeFrame.Season.Winter.End  <- "0228" #but 0229 in leap year, use start dates only
# Time Frame Names
myName.Yr       <- "Year"
myName.YrMo     <- "YearMonth"
myName.Mo       <- "Month"
myName.MoDa     <- "MonthDay"
myName.JuDa     <- "JulianDay"
myName.Season   <- "Season"
myName.YrSeason <- "YearSeason"
######################################################################
# Trigger for Stats to exclude (TRUE) or include (FALSE) where flag = "fail"
myStats.Fails.Exclude <- TRUE  #FALSE #TRUE
######################################################################














