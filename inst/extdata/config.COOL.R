# User Defined Values
#
# User defined values for variables used across multiple functions in this library.
# The user had the ability to modify the values for names, units, QC thresholds, etc.
#
# Saved in a separate environment.
#
# https://www.r-bloggers.com/package-wide-variablescache-in-r-packages/
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
# @keywords continuous data
# @examples
# #Not intended to be accessed indepedant of function ContDataQC().
# #Data values only.  No functions.  Add to environment so only visible inside library.
#####################################################################
# USER may make modifications in this section but not mandatory
# this section could be sourced so can use between scripts
#####################################################################
#UserDefinedValues <- NA # default value so shows up in help files
#####################################################################
# Environment for use only by ContDataQC library
#ContData.env <- new.env(parent = emptyenv())
# assign variables to new environment requires editing of all lines.
# For example, myDelim <- "_" BECOMES ContData.env$myDelim, "_"
###
# list all elements in environment
# ls(ContData.env)  # all elements in environment
# as.list(ContData.env)  # all elements in environment with assigned values
# #####################################################################
# # Delimiter in File Names (e.g., test2_AW_201301_20131231.csv)
# ContData.env$myDelim <- "_"
# ContData.env$myDelim_LakeID <- "~"
# #####################################################################
# # Acceptable column names for the data
# #(special characters (e.g., %, space, or /) are converted to "." by R, "deg" converted to "A")
# ContData.env$myUnits.AirTemp    <- "C" # C or F
# ContData.env$myUnits.WaterTemp  <- ContData.env$myUnits.AirTemp
# ContData.env$myUnits.AirBP      <- "psi"
# ContData.env$myUnits.WaterP     <- ContData.env$myUnits.AirBP
# ContData.env$myUnits.SensorDepth <- "ft"
# ContData.env$myUnits.Discharge  <- "ft3.s"
# ## Air and Water
# ContData.env$myName.SiteID        <- "SiteID"
# ContData.env$myName.Date          <- "Date"
# ContData.env$myName.Time          <- "Time"
# ContData.env$myName.DateTime      <- "Date.Time"
# ## Water
# ContData.env$myName.RowID.Water   <- "Water.RowID"
# ContData.env$myName.LoggerID.Water<- "Water.LoggerID"
# ContData.env$myName.WaterTemp     <- paste("Water.Temp.",ContData.env$myUnits.WaterTemp,sep="")  # "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R.
# ## Air
# ContData.env$myName.RowID.Air     <- "Air.RowID"
# ContData.env$myName.LoggerID.Air  <- "Air.LoggerID"
# ContData.env$myName.AirTemp       <- paste("Air.Temp.",ContData.env$myUnits.AirTemp,sep="")   # "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R.
# ContData.env$myName.WaterP        <- paste("Water.BP.",ContData.env$myUnits.WaterP,sep="")
# ContData.env$myName.AirBP         <- paste("Air.BP.",ContData.env$myUnits.WaterP,sep="")
# ContData.env$myName.SensorDepth    <- paste("Water.Level.",ContData.env$myUnits.SensorDepth,sep="")
# ContData.env$myName.Discharge     <- paste("Discharge.",ContData.env$myUnits.Discharge,sep="")
# ## plot labels
# ContData.env$myLab.WaterTemp      <- paste("Temperature, Water (deg ",ContData.env$myUnits.WaterTemp,")",sep="")
# ContData.env$myLab.AirTemp        <- paste("Temperature, Air (deg ",ContData.env$myUnits.AirTemp,")",sep="")
# ContData.env$myLab.Date           <- "Date"
# ContData.env$myLab.DateTime       <- "Date"
# ContData.env$myLab.WaterP         <- paste("Pressure<- Water (",ContData.env$myUnits.AirBP,")",sep="")
# ContData.env$myLab.AirBP          <- paste("Barometric Pressure, Air (",ContData.env$myUnits.WaterP,")",sep="")
# ContData.env$myLab.SensorDepth     <- paste("Water Level (",ContData.env$myUnits.SensorDepth,")",sep="")
# ContData.env$myLab.Temp.BOTH      <- paste("Temperature (deg ",ContData.env$myUnits.WaterTemp,")",sep="")
# ContData.env$myLab.Discharge      <- paste("Discharge (ft3/s)")
# #####################################################################
# # Discrete Measurements
# ContData.env$myPrefix.Discrete          <- "Discrete"
# # Discrete, Names
# ContData.env$myName.Discrete.WaterTemp  <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.WaterTemp,sep=".")
# ContData.env$myName.Discrete.AirTemp    <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.AirTemp,sep=".")
# ContData.env$myName.Discrete.WaterP     <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.WaterP,sep=".")
# ContData.env$myName.Discrete.AirBP      <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.AirBP,sep=".")
# ContData.env$myName.Discrete.SensorDepth <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.SensorDepth,sep=".")
# ContData.env$myName.Discrete.Discharge  <- paste(ContData.env$myPrefix.Discrete,ContData.env$myName.Discharge,sep=".")
# # Discrete, Labels
# ContData.env$myLab.Discrete.WaterTemp   <- paste(ContData.env$myLab.WaterTemp,"(Discrete)",sep=" ")
# ContData.env$myLab.Discrete.AirTemp     <- paste(ContData.env$myLab.AirTemp,"(Discrete)",sep=" ")
# ContData.env$myLab.Discrete.WaterP      <- paste(ContData.env$myLab.WaterP,"(Discrete)",sep=" ")
# ContData.env$myLab.Discrete.AirBP       <- paste(ContData.env$myLab.AirBP,"(Discrete)",sep=" ")
# ContData.env$myLab.Discrete.SensorDepth  <- paste(ContData.env$myLab.SensorDepth,"(Discrete)",sep=" ")
# ContData.env$myLab.Discrete.Discharge   <- paste(ContData.env$myLab.Discharge,"(Discrete)",sep=" ")
# #####################################################################
# # Automated QC stuff
# ## data type/stages
# ContData.env$myDataQuality.Raw        <- "RAW"
# ContData.env$myDataQuality.QCauto     <- "QCauto"
# ContData.env$myDataQuality.QCmanual   <- "QCmanual"
# ContData.env$myDataQuality.Final      <- "Final"
# ContData.env$myDataQuality.Aggregated <- "Aggregated"
# #####################################################################
# # Directory Names
# ContData.env$myName.Dir.0Original  <- "Data0_Original"
# ContData.env$myName.Dir.1Raw  <- "Data1_Raw"
# ContData.env$myName.Dir.2QC   <- "Data2_QC"
# ContData.env$myName.Dir.3Agg  <- "Data3_Aggregated"
# ContData.env$myName.Dir.4Stats<- "Data4_Stats"
# #####################################################################
# # Data Fields
# ContData.env$myNames.DataFields <- c(ContData.env$myName.WaterTemp
#                                      , ContData.env$myName.AirTemp
#                                      , ContData.env$myName.WaterP
#                                      , ContData.env$myName.AirBP
#                                      , ContData.env$myName.SensorDepth
#                                      , ContData.env$myName.Discharge
#                                      , ContData.env$myName.Discrete.WaterTemp
#                                      , ContData.env$myName.Discrete.AirTemp
#                                      , ContData.env$myName.Discrete.WaterP
#                                      , ContData.env$myName.Discrete.AirBP
#                                      , ContData.env$myName.Discrete.SensorDepth
#                                      , ContData.env$myName.Discrete.Discharge)
#
# ContData.env$myNames.DataFields.Lab <- c(ContData.env$myLab.WaterTemp
#                                          , ContData.env$myLab.AirTemp
#                                          , ContData.env$myLab.WaterP
#                                          , ContData.env$myLab.AirBP
#                                          , ContData.env$myLab.SensorDepth
#                                          , ContData.env$myLab.Discharge
#                                          , ContData.env$myLab.Discrete.WaterTemp
#                                          , ContData.env$myLab.Discrete.AirTemp
#                                          , ContData.env$myLab.Discrete.WaterP
#                                          , ContData.env$myLab.Discrete.AirBP
#                                          , ContData.env$myLab.Discrete.SensorDepth
#                                          , ContData.env$myLab.Discrete.Discharge)
#
# ContData.env$myNames.DataFields.Col <- c("blue","green","gray","gray","black","brown")
# #
# ## Name Order (change order below to change order in output file)
# ContData.env$myNames.Order <- c(ContData.env$myName.SiteID
#                                 , ContData.env$myName.Date
#                                 , ContData.env$myName.Time
#                                 , ContData.env$myName.DateTime
#                                 , ContData.env$myName.WaterTemp
#                                 , ContData.env$myName.LoggerID.Air
#                                 , ContData.env$myName.RowID.Air
#                                 , ContData.env$myName.AirTemp
#                                 , ContData.env$myName.WaterP
#                                 , ContData.env$myName.AirBP
#                                 , ContData.env$myName.SensorDepth
#                                 , ContData.env$myName.LoggerID.Water
#                                 , ContData.env$myName.RowID.Water
#                                 , ContData.env$myName.Discharge
#                                 , ContData.env$myName.Discrete.WaterTemp
#                                 , ContData.env$myName.Discrete.AirTemp
#                                 , ContData.env$myName.Discrete.WaterP
#                                 , ContData.env$myName.Discrete.AirBP
#                                 , ContData.env$myName.Discrete.SensorDepth
#                                 , ContData.env$myName.Discrete.Discharge)
#
# ######################################################################
# ## Data Quality Flag Values
# ContData.env$myFlagVal.Pass    <- "P"
# ContData.env$myFlagVal.NotEval <- "NA"
# ContData.env$myFlagVal.Suspect <- "S"
# ContData.env$myFlagVal.Fail    <- "F"
# ContData.env$myFlagVal.NoData  <- "X"
# ContData.env$myFlagVal.Order   <- c(ContData.env$myFlagVal.Pass
#                                     , ContData.env$myFlagVal.Suspect
#                                     , ContData.env$myFlagVal.Fail
#                                     , ContData.env$myFlagVal.NoData)
# #####################################################################
# QC Tests and Calculations
#http://stackoverflow.com/questions/16143700/pasting-two-vectors-with-combinations-of-all-vectors-elements
#myNames.QCTests.Calcs.combo <- as.vector(t(outer(myNames.QCTests,myNames.QCTests.Calcs,paste,sep=".")))
# combine so can check for and remove later.
#myNames.DataFields.QCTests.Calcs.combo <- as.vector(t(outer(myNames.DataFields,myNames.QCTests.Calcs.combo,paste,sep=".")))
# Data Quality Flag Thresholds
## Gross Min/Max, Fail (equipment)
ContData.env$myThresh.Gross.Fail.Hi.WaterTemp  <- 30
ContData.env$myThresh.Gross.Fail.Lo.WaterTemp  <- -2
# ContData.env$myThresh.Gross.Fail.Hi.AirTemp    <- 35
# ContData.env$myThresh.Gross.Fail.Lo.AirTemp    <- -25
# ContData.env$myThresh.Gross.Fail.Hi.WaterP     <- 17
# ContData.env$myThresh.Gross.Fail.Lo.WaterP     <- 11
# ContData.env$myThresh.Gross.Fail.Hi.AirBP      <- 17
# ContData.env$myThresh.Gross.Fail.Lo.AirBP      <- 11
# ContData.env$myThresh.Gross.Fail.Hi.SensorDepth <- 6   # no longer used (only check for negative values for SensorDepth)
# ContData.env$myThresh.Gross.Fail.Lo.SensorDepth <- -1  # no longer used (only check for negative values for SensorDepth)
# ContData.env$myThresh.Gross.Fail.Hi.Discharge  <-  10^5 #dependant upon stream size (only checkf or negative values)
# ContData.env$myThresh.Gross.Fail.Lo.Discharge  <-  -1  #dependant upon stream size
## Gross Min/Max, Suspect (extreme)
ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp  <- 25
ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp  <- -1
# ContData.env$myThresh.Gross.Suspect.Hi.AirTemp    <- 30
# ContData.env$myThresh.Gross.Suspect.Lo.AirTemp    <- -20
# ContData.env$myThresh.Gross.Suspect.Hi.WaterP     <- 16
# ContData.env$myThresh.Gross.Suspect.Lo.WaterP     <- 12
# ContData.env$myThresh.Gross.Suspect.Hi.AirBP      <- 16
# ContData.env$myThresh.Gross.Suspect.Lo.AirBP      <- 12
# ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth <- 5    # no longer used (only check for negative values for SensorDepth)
# ContData.env$myThresh.Gross.Suspect.Lo.SensorDepth <- 0    # no longer used (only check for negative values for SensorDepth)
# ContData.env$myThresh.Gross.Suspect.Hi.Discharge  <-  10^3 #dependant upon stream size (only checkf or negative values
# ContData.env$myThresh.Gross.Suspect.Lo.Discharge  <-  -1   #dependant upon stream size
## Spike thresholds (absolute change)
ContData.env$myThresh.Spike.Hi.WaterTemp  <- 10
ContData.env$myThresh.Spike.Lo.WaterTemp  <- 5
# ContData.env$myThresh.Spike.Hi.AirTemp    <- 10
# ContData.env$myThresh.Spike.Lo.AirTemp    <- 5
# ContData.env$myThresh.Spike.Hi.WaterP     <- 5
# ContData.env$myThresh.Spike.Lo.WaterP     <- 3
# ContData.env$myThresh.Spike.Hi.AirBP      <- 5
# ContData.env$myThresh.Spike.Lo.AirBP      <- 3
# ContData.env$myThresh.Spike.Hi.SensorDepth <- 5
# ContData.env$myThresh.Spike.Lo.SensorDepth <- 3
# ContData.env$myThresh.Spike.Hi.Discharge  <- 10^4 #dependant upon stream size
# ContData.env$myThresh.Spike.Lo.Discharge  <- 10^3 #dependant upon stream size
## Rate of Change (relative change)
# ContData.env$myDefault.RoC.SD.number  <- 3
# ContData.env$myDefault.RoC.SD.period  <- 25 #hours
ContData.env$myThresh.RoC.SD.number.WaterTemp  <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.WaterTemp  <- ContData.env$myDefault.RoC.SD.period
# ContData.env$myThresh.RoC.SD.number.AirTemp    <- ContData.env$myDefault.RoC.SD.number
# ContData.env$myThresh.RoC.SD.period.AirTemp    <- ContData.env$myDefault.RoC.SD.period
# ContData.env$myThresh.RoC.SD.number.WaterP     <- ContData.env$myDefault.RoC.SD.number
# ContData.env$myThresh.RoC.SD.period.WaterP     <- ContData.env$myDefault.RoC.SD.period
# ContData.env$myThresh.RoC.SD.number.AirBP      <- ContData.env$myDefault.RoC.SD.number
# ContData.env$myThresh.RoC.SD.period.AirBP      <- ContData.env$myDefault.RoC.SD.period
# ContData.env$myThresh.RoC.SD.number.SensorDepth <- ContData.env$myDefault.RoC.SD.number
# ContData.env$myThresh.RoC.SD.period.SensorDepth <- ContData.env$myDefault.RoC.SD.period
# ContData.env$myThresh.RoC.SD.number.Discharge  <- ContData.env$myDefault.RoC.SD.number
# ContData.env$myThresh.RoC.SD.period.Discharge  <- ContData.env$myDefault.RoC.SD.period
## No Change (flat-line)
ContData.env$myDefault.Flat.Hi        <- 22 # maximum is myThresh.Flat.MaxComp
ContData.env$myDefault.Flat.Lo        <- 2
ContData.env$myDefault.Flat.Tolerance <- 0.01 # set to one sigdig less than measurements.  Check with fivenum(x)
ContData.env$myThresh.Flat.Hi.WaterTemp         <- ContData.env$myDefault.Flat.Hi
ContData.env$myThresh.Flat.Lo.WaterTemp         <- ContData.env$myDefault.Flat.Lo
ContData.env$myThresh.Flat.Tolerance.WaterTemp  <- 0.01
ContData.env$myThresh.Flat.Hi.AirTemp           <- ContData.env$myDefault.Flat.Hi
ContData.env$myThresh.Flat.Lo.AirTemp           <- ContData.env$myDefault.Flat.Lo
ContData.env$myThresh.Flat.Tolerance.AirTemp    <- 0.01
ContData.env$myThresh.Flat.Hi.WaterP            <- ContData.env$myDefault.Flat.Hi
ContData.env$myThresh.Flat.Lo.WaterP            <- ContData.env$myDefault.Flat.Lo
ContData.env$myThresh.Flat.Tolerance.WaterP     <- 0.001
ContData.env$myThresh.Flat.Hi.AirBP             <- ContData.env$myDefault.Flat.Hi
ContData.env$myThresh.Flat.Lo.AirBP             <- ContData.env$myDefault.Flat.Lo
ContData.env$myThresh.Flat.Tolerance.AirBP      <- 0.001
ContData.env$myThresh.Flat.Hi.SensorDepth        <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.SensorDepth        <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.SensorDepth <- 0.0
ContData.env$myThresh.Flat.Hi.Discharge         <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Discharge         <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Discharge  <- 0.01
ContData.env$myThresh.Flat.MaxComp    <- max(ContData.env$myThresh.Flat.Hi.WaterTemp
                                             , ContData.env$myThresh.Flat.Hi.AirTemp
                                             , ContData.env$myThresh.Flat.Hi.WaterP
                                             , ContData.env$myThresh.Flat.Hi.AirBP
                                             , ContData.env$myThresh.Flat.Hi.Discharge)

# #####################################################################
# # Data Fields with Flags
# ContData.env$myName.Flag        <- "Flag" # flag prefix
# ContData.env$myNames.Cols4Flags <- c(ContData.env$myName.DateTime,ContData.env$myNames.DataFields)
# ContData.env$myNames.Flags      <- paste(ContData.env$myName.Flag,ContData.env$myNames.Cols4Flags,sep=".")  # define ones using in the calling script
# ## flag labels
# ContData.env$myName.Flag.DateTime   <- paste(ContData.env$myName.Flag,ContData.env$myName.DateTime,sep=".")
# ContData.env$myName.Flag.WaterTemp  <- paste(ContData.env$myName.Flag,ContData.env$myName.WaterTemp,sep=".")
# ContData.env$myName.Flag.AirTemp    <- paste(ContData.env$myName.Flag,ContData.env$myName.AirTemp,sep=".")
# ContData.env$myName.Flag.WaterP     <- paste(ContData.env$myName.Flag,ContData.env$myName.WaterP,sep=".")
# ContData.env$myName.Flag.AirBP      <- paste(ContData.env$myName.Flag,ContData.env$myName.AirBP,sep=".")
# ContData.env$myName.Flag.SensorDepth <- paste(ContData.env$myName.Flag,ContData.env$myName.SensorDepth,sep=".")
# ContData.env$myName.Flag.Discharge  <- paste(ContData.env$myName.Flag,ContData.env$myName.Discharge,sep=".")
# # Data Quality Test Names
# ContData.env$myNames.QCTests <- c("Gross","Spike","RoC","Flat")
# ContData.env$myNames.QCCalcs <- c("SD.Time","SD","SDxN",paste("n",1:ContData.env$myThresh.Flat.MaxComp,sep="."),"flat.Lo","flat.Hi")
# #####################################################################
# # Exceedance values for stats (default to Gross-Suspect-Hi value)
# ContData.env$myExceed.WaterTemp  <- ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp
# ContData.env$myExceed.AirTemp    <- ContData.env$myThresh.Gross.Suspect.Hi.AirTemp
# ContData.env$myExceed.SensorDepth <- ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth
# #####################################################################
# # Date and Time Formats
# ContData.env$myFormat.Date           <- "%Y-%m-%d"
# ContData.env$myFormat.Time           <- "%H:%M:%S"
# ContData.env$myFormat.DateTime       <- "%Y-%m-%d %H:%M:%S"
# ContData.env$DateRange.Start.Default <- format(as.Date("1900-01-01"),ContData.env$myFormat.Date) #YYYY-MM-DD
# ContData.env$DateRange.End.Default   <- format(Sys.Date(),ContData.env$myFormat.Date)
# # Time Zone, used in Gage script in dataRetrieval
# ContData.env$myTZ <- Sys.timezone() #"America/New_York"
# ######################################################################
# # Time Frames (MM-DD)
# ContData.env$myTimeFrame.Annual.Start        <- "0101"
# ContData.env$myTimeFrame.Annual.End          <- "1231"
# ContData.env$myTimeFrame.WaterYear.Start     <- "1001"
# #ContData.env$myTimeFrame.WaterYear.End      <- "0930"
# ContData.env$myTimeFrame.Season.Spring.Start <- "0301"
# #ContData.env$myTimeFrame.Season.Spring.End  <- "0531"
# ContData.env$myTimeFrame.Season.Summer.Start <- "0601"
# #ContData.env$myTimeFrame.Season.Summer.End  <- "0831"
# ContData.env$myTimeFrame.Season.Fall.Start   <- "0901"
# #ContData.env$myTimeFrame.Season.Fall.End    <- "1130"
# ContData.env$myTimeFrame.Season.Winter.Start <- "1201"
# #ContData.env$myTimeFrame.Season.Winter.End  <- "0228" #but 0229 in leap year, use start dates only
# # Time Frame Names
# ContData.env$myName.Yr       <- "Year"
# ContData.env$myName.YrMo     <- "YearMonth"
# ContData.env$myName.Mo       <- "Month"
# ContData.env$myName.MoDa     <- "MonthDay"
# ContData.env$myName.JuDa     <- "JulianDay"
# ContData.env$myName.Day      <- "Day"
# ContData.env$myName.Season   <- "Season"
# ContData.env$myName.YrSeason <- "YearSeason"
# ######################################################################
# # Trigger for Stats to exclude (TRUE) or include (FALSE) where flag = "fail"
# ContData.env$myStats.Fails.Exclude <- TRUE  #FALSE #TRUE
# ######################################################################















