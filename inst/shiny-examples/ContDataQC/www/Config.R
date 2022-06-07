# User Defined Values
#
# User defined values for variables used across multiple functions in this
# library. The user has the ability to modify the values for names, units, QC
# thresholds, etc.
#
# Saved in a separate environment.
#
# https://www.r-bloggers.com/package-wide-variablescache-in-r-packages/
#
# Continuous data helper script
# Default Values
# Erik.Leppo@tetratech.com (EWL)
# 20150928
# 20170323, add 3 parameters (Cond, DO, pH)
# 20210106, replace gageheight with waterlevel
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User defined variable names for input data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# It is assumed that this R script is stored in a directory with the data files
# as subdirectories. This script is intended to be "source"d from the main
# script.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @keywords continuous data
# @examples
# #Not intended to be accessed indepedant of function ContDataQC().
# #Data values only.  No functions.  Add to environment so only visible inside
# #library.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# USER may make modifications in this section but not mandatory
# this section could be sourced so can use between scripts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#UserDefinedValues <- NA # default value so shows up in help files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Environment Name ####
# Environment for use only by ContDataQC library
ContData.env <- new.env(parent = emptyenv())
# The above line is not used in custom configurations.
# assign variables to new environment requires editing of all lines.
# For example, myDelim <- "_" BECOMES ContData.env$myDelim, "_"
###
# list all elements in environment
# ls(ContData.env)  # all elements in environment
# as.list(ContData.env)  # all elements in environment with assigned values
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Delimiter in File Names (e.g., test2_AW_201301_20131231.csv)
ContData.env$myDelim <- "_"
ContData.env$myDelim_LakeID <- "--"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Acceptable column names for the data ####
## Basic
ContData.env$myName.SiteID        <- "SiteID"
ContData.env$myName.Date          <- "Date"
ContData.env$myName.Time          <- "Time"
ContData.env$myName.DateTime      <- "Date.Time"
#(special characters (e.g., %, space, or /) are converted to "." by R
# , "deg" converted to "A")
### IF CHANGE UNITS WILL NEED TO MODIFY THRESHOLDS ###
ContData.env$myUnits.AirTemp    <- "C" # C or F
ContData.env$myUnits.WaterTemp  <- ContData.env$myUnits.AirTemp
ContData.env$myUnits.AirBP      <- "psi"
ContData.env$myUnits.WaterP     <- ContData.env$myUnits.AirBP
ContData.env$myUnits.SensorDepth <- "ft"
ContData.env$myUnits.Discharge  <- "ft3.s"
ContData.env$myUnits.Cond       <- "uS.cm"
ContData.env$myUnits.DO         <- "mg.L"
ContData.env$myUnits.DO.adj     <- "mg.L"
ContData.env$myUnits.DO.pctsat  <- "percent"
ContData.env$myUnits.pH         <- "SU"
ContData.env$myUnits.Turbidity  <- "NTU"
ContData.env$myUnits.Chlorophylla <- "g.cm3"
ContData.env$myUnits.WaterLevel <- "ft"
ContData.env$myUnits.Salinity   <- "ppt"
## Logger Fields ----
ContData.env$myName.RowID.Water   <- "Water.RowID"
ContData.env$myName.LoggerID.Water<- "Water.LoggerID"
ContData.env$myName.RowID.Air     <- "Air.RowID"
ContData.env$myName.LoggerID.Air  <- "Air.LoggerID"
ContData.env$myName.LoggerDeployment  <- "Logger.Deployment"
ContData.env$myName.LoggerDeployment.start <- "start"
ContData.env$myName.LoggerDeployment.end   <- "end"
## Parameters as appear in logger files
ContData.env$myName.WaterTemp     <- paste0("Water.Temp."
                                            ,ContData.env$myUnits.WaterTemp)
# "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R
ContData.env$myName.AirTemp       <- paste0("Air.Temp."
                                            ,ContData.env$myUnits.AirTemp)
# "deg" from HoboWare files sometimes adds "A " in front.  Replace with "." in R
ContData.env$myName.AirBP         <- paste0("Air.BP."
                                            , ContData.env$myUnits.AirBP)
ContData.env$myName.WaterP        <- paste0("Water.P."
                                            , ContData.env$myUnits.WaterP)
ContData.env$myName.SensorDepth   <- paste0("Sensor.Depth."
                                            , ContData.env$myUnits.SensorDepth)
ContData.env$myName.Discharge     <- paste0("Discharge."
                                            , ContData.env$myUnits.Discharge)
ContData.env$myName.Cond          <- paste0("Conductivity."
                                            , ContData.env$myUnits.Cond)
ContData.env$myName.DO            <- paste0("DO.", ContData.env$myUnits.DO)
ContData.env$myName.DO.adj    <- paste0("DO.adj.", ContData.env$myUnits.DO.adj)
ContData.env$myName.DO.pctsat     <- paste0("DO.pctsat.", ContData.env$myUnits.DO.pctsat)
ContData.env$myName.pH            <- paste0("pH."
                                            , ContData.env$myUnits.pH)
ContData.env$myName.Turbidity     <- paste0("Turbidity."
                                            , ContData.env$myUnits.Turbidity)
ContData.env$myName.Chlorophylla   <- paste0("Chlorophylla."
                                            , ContData.env$myUnits.Chlorophylla)
ContData.env$myName.WaterLevel    <- paste0("Water.Level."
                                            , ContData.env$myUnits.WaterLevel)
ContData.env$myName.Salinity      <- paste0("Salinity."
                                            , ContData.env$myUnits.Salinity)
## Plot Labels
ContData.env$myLab.Date           <- "Date"
ContData.env$myLab.DateTime       <- "Date"
ContData.env$myLab.WaterTemp      <- paste0("Temperature, Water (deg "
                                            ,ContData.env$myUnits.WaterTemp
                                            ,")")
ContData.env$myLab.AirTemp        <- paste0("Temperature, Air (deg "
                                            ,ContData.env$myUnits.AirTemp
                                            ,")")
ContData.env$myLab.AirBP          <- paste0("Barometric Pressure, Air ("
                                            ,ContData.env$myUnits.WaterP
                                            ,")")
ContData.env$myLab.WaterP         <- paste0("Pressure, Water ("
                                            ,ContData.env$myUnits.AirBP
                                            ,")")
ContData.env$myLab.SensorDepth    <- paste0("Sensor Depth ("
                                            ,ContData.env$myUnits.SensorDepth
                                            ,")"
                                            ,sep="")
ContData.env$myLab.Temp.BOTH      <- paste0("Temperature (deg "
                                            ,ContData.env$myUnits.WaterTemp
                                            ,")")
ContData.env$myLab.Discharge      <- paste0("Discharge ("
                                            ,sub("\\.","/"
                                                ,ContData.env$myUnits.Discharge)
                                            ,")")  #replace "." with "/"
ContData.env$myLab.Cond           <- paste0("Conductivity ("
                                            ,sub("\\.","/"
                                                 ,ContData.env$myUnits.Cond)
                                            ,")")    #replace "." with "/"
ContData.env$myLab.DO             <- paste0("Dissolved Oxygen ("
                                            ,sub("\\.","/"
                                                 ,ContData.env$myUnits.DO)
                                            ,")")  #replace "." with "/"
ContData.env$myLab.DO.adj         <- paste0("Dissolved Oxygen, adjusted ("
                                            ,sub("\\.","/"
                                                 ,ContData.env$myUnits.DO.adj)
                                            ,")")  #replace "." with "/"
ContData.env$myLab.DO.pctsat <- paste0("Dissolved Oxygen, percent saturation ("
                                            ,sub("\\.","/"
                                            ,ContData.env$myUnits.DO.pctsat)
                                            ,")")  #replace "." with "/"
ContData.env$myLab.pH             <- paste0("pH ("
                                            ,ContData.env$myUnits.pH
                                            ,")")
ContData.env$myLab.Turbidity      <- paste0("Turbidity ("
                                            ,ContData.env$myUnits.Turbidity
                                            ,")")
ContData.env$myLab.Chlorophylla   <- paste0("Chlorophyll a ("
                                            ,sub("\\.","/"
                                             ,ContData.env$myUnits.Chlorophylla)
                                            ,")")    #replace "." with "/"
ContData.env$myLab.WaterLevel     <- paste0("Water Level ("
                                            ,ContData.env$myUnits.WaterLevel
                                            ,")")
ContData.env$myLab.Salinity       <- paste0("Salinity ("
                                            ,ContData.env$myUnits.Salinity
                                            ,")")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Discrete Measurements ####
ContData.env$myPrefix.Discrete          <- "Discrete"
# Discrete, Names
ContData.env$myName.Discrete.WaterTemp  <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.WaterTemp
                                                 ,sep=".")
ContData.env$myName.Discrete.AirTemp    <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.AirTemp
                                                 ,sep=".")
ContData.env$myName.Discrete.AirBP      <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.AirBP
                                                 ,sep=".")
ContData.env$myName.Discrete.WaterP     <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.WaterP
                                                 ,sep=".")
ContData.env$myName.Discrete.SensorDepth <- paste(ContData.env$myPrefix.Discrete
                                                ,ContData.env$myName.SensorDepth
                                                  ,sep=".")
ContData.env$myName.Discrete.Discharge  <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.Discharge
                                                 ,sep=".")
ContData.env$myName.Discrete.Cond       <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.Cond
                                                 ,sep=".")
ContData.env$myName.Discrete.DO         <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.DO
                                                 ,sep=".")
ContData.env$myName.Discrete.DO.adj     <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.DO.adj
                                                 ,sep=".")
ContData.env$myName.Discrete.DO.pctsat  <- paste(ContData.env$myPrefix.Discrete
                                                 , ContData.env$myName.DO.pctsat
                                                 , sep=".")
ContData.env$myName.Discrete.pH         <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.pH
                                                 ,sep=".")
ContData.env$myName.Discrete.Turbidity  <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.Turbidity
                                                 ,sep=".")
ContData.env$myName.Discrete.Chlorophylla <-paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.Chlorophylla
                                                 ,sep=".")
ContData.env$myName.Discrete.WaterLevel <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.WaterLevel
                                                 ,sep=".")
ContData.env$myName.Discrete.Salinity <- paste(ContData.env$myPrefix.Discrete
                                                 ,ContData.env$myName.Salinity
                                                 ,sep=".")
# Discrete, Labels
ContData.env$myLab.Discrete.WaterTemp   <- paste(ContData.env$myLab.WaterTemp
                                                 ,"(Discrete)"
												                         ,sep=" ")
ContData.env$myLab.Discrete.AirTemp     <- paste(ContData.env$myLab.AirTemp
                                                 ,"(Discrete)"
												                         ,sep=" ")
ContData.env$myLab.Discrete.AirBP       <- paste(ContData.env$myLab.AirBP
                                                 ,"(Discrete)"
												                         ,sep=" ")
ContData.env$myLab.Discrete.WaterP      <- paste(ContData.env$myLab.WaterP
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.SensorDepth <- paste(ContData.env$myLab.SensorDepth
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.Discharge   <- paste(ContData.env$myLab.Discharge
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.Cond        <- paste(ContData.env$myLab.Cond
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.DO          <- paste(ContData.env$myLab.DO
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.DO.adj      <- paste(ContData.env$myLab.DO.adj
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.DO.pctsat   <- paste(ContData.env$myLab.DO.pctsat
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.pH          <- paste(ContData.env$myLab.pH
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.Turbidity   <- paste(ContData.env$myLab.Turbidity
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.Chlorophylla<- paste(ContData.env$myLab.Chlorophylla
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.WaterLevel  <- paste(ContData.env$myLab.WaterLevel
                                                 ,"(Discrete)"
                                                 ,sep=" ")
ContData.env$myLab.Discrete.Salinity  <- paste(ContData.env$myLab.Salinity
                                                 ,"(Discrete)"
                                                 ,sep=" ")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Automated QC stuff ####
## data type/stages
ContData.env$myDataQuality.Raw        <- "RAW"
ContData.env$myDataQuality.QCauto     <- "QCauto"
ContData.env$myDataQuality.QCmanual   <- "QCmanual"
ContData.env$myDataQuality.Final      <- "Final"
ContData.env$myDataQuality.Aggregated <- "Aggregated"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Directory Names ####
ContData.env$myName.Dir.0Original  <- "Data0_Original"
ContData.env$myName.Dir.1Raw       <- "Data1_Raw"
ContData.env$myName.Dir.2QC        <- "Data2_QC"
ContData.env$myName.Dir.3Agg       <- "Data3_Aggregated"
ContData.env$myName.Dir.4Stats     <- "Data4_Stats"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data Fields ####
ContData.env$myNames.DataFields <- c(ContData.env$myName.WaterTemp
                                     , ContData.env$myName.AirTemp
									                   , ContData.env$myName.AirBP
                                     , ContData.env$myName.WaterP
                                     , ContData.env$myName.SensorDepth
                                     , ContData.env$myName.Discharge
                                     , ContData.env$myName.Cond
                                     , ContData.env$myName.DO
									                   , ContData.env$myName.DO.adj
									                   , ContData.env$myName.DO.pctsat
                                     , ContData.env$myName.pH
                                     , ContData.env$myName.Turbidity
                                     , ContData.env$myName.Chlorophylla
                                     , ContData.env$myName.WaterLevel
									                   , ContData.env$myName.Salinity
                                     , ContData.env$myName.Discrete.WaterTemp
                                     , ContData.env$myName.Discrete.AirTemp
                                     , ContData.env$myName.Discrete.WaterP
                                     , ContData.env$myName.Discrete.AirBP
                                     , ContData.env$myName.Discrete.SensorDepth
                                     , ContData.env$myName.Discrete.Discharge
                                     , ContData.env$myName.Discrete.Cond
                                     , ContData.env$myName.Discrete.DO
									                   , ContData.env$myName.Discrete.DO.adj
									                   , ContData.env$myName.Discrete.DO.pctsat
                                     , ContData.env$myName.Discrete.pH
                                     , ContData.env$myName.Discrete.Turbidity
                                     , ContData.env$myName.Discrete.Chlorophylla
                                     , ContData.env$myName.Discrete.WaterLevel
									                   , ContData.env$myName.Discrete.Salinity
                                     )
ContData.env$myNames.DataFields.Lab <- c(ContData.env$myLab.WaterTemp
                                         , ContData.env$myLab.AirTemp
                                         , ContData.env$myLab.AirBP
                                         , ContData.env$myLab.WaterP
                                         , ContData.env$myLab.SensorDepth
                                         , ContData.env$myLab.Discharge
                                         , ContData.env$myLab.Cond
                                         , ContData.env$myLab.DO
                                         , ContData.env$myLab.DO.adj
                                         , ContData.env$myLab.DO.pctsat
                                         , ContData.env$myLab.pH
                                         , ContData.env$myLab.Turbidity
                                         , ContData.env$myLab.Chlorophylla
                                         , ContData.env$myLab.WaterLevel
                                         , ContData.env$myLab.Salinity
                                         , ContData.env$myLab.Discrete.WaterTemp
                                         , ContData.env$myLab.Discrete.AirTemp
                                         , ContData.env$myLab.Discrete.WaterP
                                         , ContData.env$myLab.Discrete.AirBP
                                      , ContData.env$myLab.Discrete.SensorDepth
                                         , ContData.env$myLab.Discrete.Discharge
                                         , ContData.env$myLab.Discrete.Cond
                                         , ContData.env$myLab.Discrete.DO
                                      , ContData.env$myLab.Discrete.DO.adj
                                      , ContData.env$myLab.Discrete.DO.pctsat
                                         , ContData.env$myLab.Discrete.pH
                                         , ContData.env$myLab.Discrete.Turbidity
                                      , ContData.env$myLab.Discrete.Chlorophylla
                                        , ContData.env$myLab.Discrete.WaterLevel
                                      , ContData.env$myLab.Discrete.Salinity
                                         )
ContData.env$myNames.DataFields.Col <- c("blue","green","gray","gray","black"
                                         ,"brown","purple","orange","salmon"
                                         ,"rosybrown","aquamarine1")
#
## Name Order (change order below to change order in output file)
ContData.env$myNames.Order <- c(ContData.env$myName.SiteID
                                , ContData.env$myName.Date
                                , ContData.env$myName.Time
                                , ContData.env$myName.DateTime
                                , ContData.env$myName.LoggerDeployment
                                , ContData.env$myName.WaterTemp
                                , ContData.env$myName.LoggerID.Air
                                , ContData.env$myName.RowID.Air
                                , ContData.env$myName.AirTemp
                                , ContData.env$myName.WaterP
                                , ContData.env$myName.AirBP
                                , ContData.env$myName.SensorDepth
                                , ContData.env$myName.Discharge
                                , ContData.env$myName.Cond
                                , ContData.env$myName.DO
                                , ContData.env$myName.DO.adj
                                , ContData.env$myName.DO.pctsat
                                , ContData.env$myName.pH
                                , ContData.env$myName.Turbidity
                                , ContData.env$myName.Chlorophylla
                                , ContData.env$myName.WaterLevel
                                , ContData.env$myName.Salinity
                                , ContData.env$myName.LoggerID.Water
                                , ContData.env$myName.RowID.Water
                                , ContData.env$myName.Discrete.WaterTemp
                                , ContData.env$myName.Discrete.AirTemp
                                , ContData.env$myName.Discrete.WaterP
                                , ContData.env$myName.Discrete.AirBP
                                , ContData.env$myName.Discrete.SensorDepth
                                , ContData.env$myName.Discrete.Discharge
                                , ContData.env$myName.Discrete.Cond
                                , ContData.env$myName.Discrete.DO
                                , ContData.env$myName.Discrete.DO.adj
                                , ContData.env$myName.Discrete.DO.pctsat
                                , ContData.env$myName.Discrete.pH
                                , ContData.env$myName.Discrete.Turbidity
                                , ContData.env$myName.Discrete.Chlorophylla
                                , ContData.env$myName.Discrete.WaterLevel
                                , ContData.env$myName.Discrete.Salinity
                                )
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Data Quality Flag Values ####
ContData.env$myFlagVal.Pass    <- "P"
ContData.env$myFlagVal.NotEval <- "NA"
ContData.env$myFlagVal.Suspect <- "S"
ContData.env$myFlagVal.Fail    <- "F"
ContData.env$myFlagVal.NoData  <- "X"
ContData.env$myFlagVal.Order   <- c(ContData.env$myFlagVal.Pass
                                    , ContData.env$myFlagVal.Suspect
                                    , ContData.env$myFlagVal.Fail
                                    , ContData.env$myFlagVal.NoData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC Tests and Calculations ####
#http://stackoverflow.com/questions/16143700/pasting-two-vectors-with-combinations-of-all-vectors-elements
#myNames.QCTests.Calcs.combo <- as.vector(t(outer(myNames.QCTests,myNames.QCTests.Calcs,paste,sep=".")))
# combine so can check for and remove later.
#myNames.DataFields.QCTests.Calcs.combo <- as.vector(t(outer(myNames.DataFields,myNames.QCTests.Calcs.combo,paste,sep=".")))
# Data Quality Flag Thresholds
# _QC, Gross----
## Gross Min/Max, Fail (equipment)
### Examines values as outliers versus threholds
### if value >= Hi or <= Lo then flagged as "Fail"
ContData.env$myThresh.Gross.Fail.Hi.WaterTemp    <- 30
ContData.env$myThresh.Gross.Fail.Lo.WaterTemp    <- -2
ContData.env$myThresh.Gross.Fail.Hi.AirTemp      <- 38
ContData.env$myThresh.Gross.Fail.Lo.AirTemp      <- -25
ContData.env$myThresh.Gross.Fail.Hi.AirBP        <- 15
ContData.env$myThresh.Gross.Fail.Lo.AirBP        <- 13
ContData.env$myThresh.Gross.Fail.Hi.WaterP       <- 17
ContData.env$myThresh.Gross.Fail.Lo.WaterP       <- 13
ContData.env$myThresh.Gross.Fail.Hi.SensorDepth  <- 10^5 # dependent upon stream size
ContData.env$myThresh.Gross.Fail.Lo.SensorDepth  <- -1   # dependent upon stream size
ContData.env$myThresh.Gross.Fail.Hi.Discharge    <- 10^5 # dependent upon stream size
ContData.env$myThresh.Gross.Fail.Lo.Discharge    <- -1   # dependent upon stream size
ContData.env$myThresh.Gross.Fail.Hi.Cond         <- 1500 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.Cond         <- 10   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.DO           <- 20   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.DO           <- 1    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.DO.adj       <- 20   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.DO.adj       <- 1    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.DO.pctsat    <- 120   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.DO.pctsat    <- -1    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.pH           <- 12   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.pH           <- 3    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.Turbidity    <- 10^5 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.Turbidity    <- -1   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.Chlorophylla <- 10^5 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Lo.Chlorophylla <- -1   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Fail.Hi.WaterLevel   <- ContData.env$myThresh.Gross.Fail.Hi.SensorDepth
ContData.env$myThresh.Gross.Fail.Lo.WaterLevel   <- ContData.env$myThresh.Gross.Fail.Lo.SensorDepth
ContData.env$myThresh.Gross.Fail.Hi.Salinity      <- 41
ContData.env$myThresh.Gross.Fail.Lo.Salinity     <- 2
## Gross Min/Max, Suspect (extreme)
### Examines values as outliers versus threholds
### if value >= Hi or <= Lo then flagged as "Suspect"
ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp    <- 25
ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp    <- -0.1
ContData.env$myThresh.Gross.Suspect.Hi.AirTemp      <- 35
ContData.env$myThresh.Gross.Suspect.Lo.AirTemp      <- -23
ContData.env$myThresh.Gross.Suspect.Hi.AirBP        <- 14.8
ContData.env$myThresh.Gross.Suspect.Lo.AirBP        <- 13.0
ContData.env$myThresh.Gross.Suspect.Hi.WaterP       <- 16.8
ContData.env$myThresh.Gross.Suspect.Lo.WaterP       <- 13.5
ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth  <- 10^3 # dependent upon stream size
ContData.env$myThresh.Gross.Suspect.Lo.SensorDepth  <- 0    # dependent upon stream size
ContData.env$myThresh.Gross.Suspect.Hi.Discharge    <- 10^3 # dependent upon stream size
ContData.env$myThresh.Gross.Suspect.Lo.Discharge    <- -1   # dependent upon stream size
ContData.env$myThresh.Gross.Suspect.Hi.Cond         <- 1200 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.Cond         <- 20   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.DO           <- 18   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.DO           <- 2    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.DO.adj       <- 18   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.DO.adj       <- 2    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.DO.pctsat    <- 100   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.DO.pctsat    <- 0    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.pH           <- 11   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.pH           <- 4    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.Turbidity    <- 10^3 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.Turbidity    <- -1   # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.Chlorophylla <- 10^3 # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Lo.Chlorophylla <- 1    # this threshold has not been closely evaluated
ContData.env$myThresh.Gross.Suspect.Hi.WaterLevel   <- ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth
ContData.env$myThresh.Gross.Suspect.Lo.WaterLevel   <- ContData.env$myThresh.Gross.Suspect.Lo.SensorDept
ContData.env$myThresh.Gross.Suspect.Hi.Salinity    <- 37
ContData.env$myThresh.Gross.Suspect.Lo.Salinity    <- 3
# _QC, Spike ----
## Spike thresholds (absolute change)
### Examines difference between consecutive measurements
### if delta >= Hi then flagged as "Fail"
### if delta >= Lo then flagged as "Suspect"
ContData.env$myThresh.Spike.Hi.WaterTemp    <- 1.5
ContData.env$myThresh.Spike.Lo.WaterTemp    <- 1
ContData.env$myThresh.Spike.Hi.AirTemp      <- 10
ContData.env$myThresh.Spike.Lo.AirTemp      <- 8
ContData.env$myThresh.Spike.Hi.AirBP        <- 0.25
ContData.env$myThresh.Spike.Lo.AirBP        <- 0.15
ContData.env$myThresh.Spike.Hi.WaterP       <- 0.7
ContData.env$myThresh.Spike.Lo.WaterP       <- 0.5
ContData.env$myThresh.Spike.Hi.SensorDepth  <- 10^4 # dependent upon stream size
ContData.env$myThresh.Spike.Lo.SensorDepth  <- 10^3 # dependent upon stream size
ContData.env$myThresh.Spike.Hi.Discharge    <- 10^4 # dependent upon stream size
ContData.env$myThresh.Spike.Lo.Discharge    <- 10^3 # dependent upon stream size
ContData.env$myThresh.Spike.Hi.Cond         <- 10   # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.Cond         <- 5    # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.DO           <- 10   # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.DO           <- 5    # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.DO.adj       <- 10   # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.DO.adj       <- 5    # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.DO.pctsat    <- 25   # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.DO.pctsat    <- 10    # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.pH           <- 10   # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.pH           <- 5    # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.Turbidity    <- 10^4 # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.Turbidity    <- 10^3 # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.Chlorophylla <- 10^4 # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Lo.Chlorophylla <- 10^3 # this threshold has not been closely evaluated
ContData.env$myThresh.Spike.Hi.WaterLevel  <- ContData.env$myThresh.Spike.Hi.SensorDepth
ContData.env$myThresh.Spike.Lo.WaterLevel  <- ContData.env$myThresh.Spike.Lo.SensorDepth
ContData.env$myThresh.Spike.Hi.Salinity    <- 5
ContData.env$myThresh.Spike.Lo.Salinity    <- 3
# _QC, ROC----
## Rate of Change (relative change)
### Examines SD over "period" and difference in consecutive values
### If delta >= SD.number * SD then flagged as "Suspect"
ContData.env$myDefault.RoC.SD.number  <- 3
ContData.env$myDefault.RoC.SD.period  <- 25 #hours
ContData.env$myThresh.RoC.SD.number.WaterTemp    <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.WaterTemp    <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.AirTemp      <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.AirTemp      <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.AirBP        <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.AirBP        <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.WaterP       <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.WaterP       <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.SensorDepth  <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.SensorDepth  <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.Discharge    <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.Discharge    <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.Cond         <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.Cond         <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.DO           <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.DO           <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.DO.adj       <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.DO.adj       <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.DO.pctsat    <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.DO.pctsat    <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.pH           <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.pH           <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.Turbidity    <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.Turbidity    <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.Chlorophylla <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.Chlorophylla <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.WaterLevel   <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.WaterLevel   <- ContData.env$myDefault.RoC.SD.period
ContData.env$myThresh.RoC.SD.number.Salinity     <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.Salinity     <- ContData.env$myDefault.RoC.SD.period
# QC, Flat Line----
## No Change (flat-line)
### Examines consecutive values within "Tolerance" of each other
### If number of consecutive values >= Hi then flagged as "Fail"
### If number of consecutive values >= Lo (and < Hi) then flagged as "Suspect"
ContData.env$myDefault.Flat.Hi        <- 30  # maximum is myThresh.Flat.MaxComp
ContData.env$myDefault.Flat.Lo        <- 15
ContData.env$myDefault.Flat.Tolerance <- 0.01 # set to one sigdig less than measurements.  Check with fivenum(x)
ContData.env$myThresh.Flat.Hi.WaterTemp           <- 30
ContData.env$myThresh.Flat.Lo.WaterTemp           <- 20
ContData.env$myThresh.Flat.Tolerance.WaterTemp    <- 0.01
ContData.env$myThresh.Flat.Hi.AirTemp             <- 20
ContData.env$myThresh.Flat.Lo.AirTemp             <- 15
ContData.env$myThresh.Flat.Tolerance.AirTemp      <- 0.01
ContData.env$myThresh.Flat.Hi.AirBP               <- 15
ContData.env$myThresh.Flat.Lo.AirBP               <- 10
ContData.env$myThresh.Flat.Tolerance.AirBP        <- 0.001
ContData.env$myThresh.Flat.Hi.WaterP              <- 15
ContData.env$myThresh.Flat.Lo.WaterP              <- 10
ContData.env$myThresh.Flat.Tolerance.WaterP       <- 0.001
ContData.env$myThresh.Flat.Hi.SensorDepth         <- 60
ContData.env$myThresh.Flat.Lo.SensorDepth         <- 20
ContData.env$myThresh.Flat.Tolerance.SensorDepth  <- 0.0
ContData.env$myThresh.Flat.Hi.Discharge           <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Discharge           <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Discharge    <- 0.01
ContData.env$myThresh.Flat.Hi.Cond                <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Cond                <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Cond         <- 0.01
ContData.env$myThresh.Flat.Hi.DO                  <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.DO                  <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.DO           <- 0.01
ContData.env$myThresh.Flat.Hi.DO.adj              <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.DO.adj              <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.DO.adj       <- 0.01
ContData.env$myThresh.Flat.Hi.DO.pctsat           <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.DO.pctsat           <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.DO.pctsat    <- 0.01
ContData.env$myThresh.Flat.Hi.pH                  <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.pH                  <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.pH           <- 0.01
ContData.env$myThresh.Flat.Hi.Turbidity           <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Turbidity           <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Turbidity    <- 0.01
ContData.env$myThresh.Flat.Hi.Chlorophylla        <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Chlorophylla        <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Chlorophylla <- 0.01
ContData.env$myThresh.Flat.Hi.WaterLevel          <- ContData.env$myThresh.Flat.Hi.SensorDepth
ContData.env$myThresh.Flat.Lo.WaterLevel          <- ContData.env$myThresh.Flat.Lo.SensorDepth
ContData.env$myThresh.Flat.Tolerance.WaterLevel   <- ContData.env$myThresh.Flat.Tolerance.SensorDepth
ContData.env$myThresh.Flat.Hi.Salinity            <- ContData.env$myThresh.Flat.Hi.SensorDepth * 2
ContData.env$myThresh.Flat.Lo.Salinity            <- ContData.env$myThresh.Flat.Lo.SensorDepth * 2
ContData.env$myThresh.Flat.Tolerance.Salinity     <- 0.01
#
ContData.env$myThresh.Flat.MaxComp    <- max(ContData.env$myThresh.Flat.Hi.WaterTemp
                                             , ContData.env$myThresh.Flat.Hi.AirTemp
                                             , ContData.env$myThresh.Flat.Hi.AirBP
                                             , ContData.env$myThresh.Flat.Hi.WaterP
                                             , ContData.env$myThresh.Flat.Hi.SensorDepth
                                             , ContData.env$myThresh.Flat.Hi.Discharge
                                             , ContData.env$myThresh.Flat.Hi.Cond
                                             , ContData.env$myThresh.Flat.Hi.DO
                                             , ContData.env$myThresh.Flat.Hi.DO.adj
                                             , ContData.env$myThresh.Flat.Hi.DO.pctsat
                                             , ContData.env$myThresh.Flat.Hi.pH
                                             , ContData.env$myThresh.Flat.Hi.Turbidity
                                             , ContData.env$myThresh.Flat.Hi.Chlorophylla
                                             , ContData.env$myThresh.Flat.Hi.WaterLevel
                                             , ContData.env$myThresh.Flat.Hi.Salinity
                                             )
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data Fields with Flags ####
ContData.env$myName.Flag        <- "Flag" # flag prefix
ContData.env$myNames.Cols4Flags <- c(ContData.env$myName.DateTime
                                     , ContData.env$myNames.DataFields)
ContData.env$myNames.Flags      <- paste(ContData.env$myName.Flag
                                         , ContData.env$myNames.Cols4Flags
                                         , sep=".")
# define ones using in the calling script

## flag labels
ContData.env$myName.Flag.DateTime     <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.DateTime
                                               , sep=".")
ContData.env$myName.Flag.WaterTemp    <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.WaterTemp
                                               , sep=".")
ContData.env$myName.Flag.AirTemp      <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.AirTemp
                                               , sep=".")
ContData.env$myName.Flag.AirBP        <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.AirBP
                                               , sep=".")
ContData.env$myName.Flag.WaterP       <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.WaterP
                                               , sep=".")
ContData.env$myName.Flag.SensorDepth  <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.SensorDepth
                                               , sep=".")
ContData.env$myName.Flag.Discharge    <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.Discharge
                                               , sep=".")
ContData.env$myName.Flag.Cond         <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.Cond
                                               , sep=".")
ContData.env$myName.Flag.DO           <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.DO
                                               , sep=".")
ContData.env$myName.Flag.DO.adj       <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.DO.adj
                                               , sep=".")
ContData.env$myName.Flag.DO.pctsat    <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.DO.pctsat
                                               , sep=".")
ContData.env$myName.Flag.pH           <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.pH
                                               , sep=".")
ContData.env$myName.Flag.Turbidity    <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.Turbidity
                                               , sep=".")
ContData.env$myName.Flag.Chlorophylla <- paste(ContData.env$myName.Flag
                                             , ContData.env$myName.Chlorophylla
                                               , sep=".")
ContData.env$myName.Flag.WaterLevel   <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.WaterLevel
                                               , sep=".")
ContData.env$myName.Flag.Salinity     <- paste(ContData.env$myName.Flag
                                               , ContData.env$myName.Salinity
                                               , sep=".")
# Data Quality Test Names
ContData.env$myNames.QCTests <- c("Gross","Spike","RoC","Flat")
ContData.env$myNames.QCCalcs <- c("SD.Time"
                                  , "SD"
                                  , "SDxN"
                                  , paste("n"
                                          , seq_len(
                                            ContData.env$myThresh.Flat.MaxComp)
                                          , sep=".")
                                  , "flat.Lo"
                                  , "flat.Hi")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Exceedance values for stats (default to Gross-Suspect-Hi value) ####
ContData.env$myExceed.WaterTemp   <-
  ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp
ContData.env$myExceed.AirTemp     <-
  ContData.env$myThresh.Gross.Suspect.Hi.AirTemp
ContData.env$myExceed.SensorDepth <-
  ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Date and Time Formats ####
ContData.env$myFormat.Date           <- "%Y-%m-%d"
ContData.env$myFormat.Time           <- "%H:%M:%S"
ContData.env$myFormat.DateTime       <- "%Y-%m-%d %H:%M:%S"
ContData.env$DateRange.Start.Default <- format(as.Date("1900-01-01")
                                               , ContData.env$myFormat.Date)
                                               #YYYY-MM-DD
ContData.env$DateRange.End.Default   <- format(Sys.Date()
                                               , ContData.env$myFormat.Date)
# Time Zone, used in Gage script in dataRetrieval, OlsonNames()
ContData.env$myTZ <- Sys.timezone() #"America/New_York" (local time zone)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Time Frames (MM-DD) ####
ContData.env$myTimeFrame.Annual.Start        <- "0101"
ContData.env$myTimeFrame.Annual.End          <- "1231"
ContData.env$myTimeFrame.WaterYear.Start     <- "1001"
#ContData.env$myTimeFrame.WaterYear.End      <- "0930"
ContData.env$myTimeFrame.Season.Spring.Start <- "0301"
#ContData.env$myTimeFrame.Season.Spring.End  <- "0531"
ContData.env$myTimeFrame.Season.Summer.Start <- "0601"
#ContData.env$myTimeFrame.Season.Summer.End  <- "0831"
ContData.env$myTimeFrame.Season.Fall.Start   <- "0901"
#ContData.env$myTimeFrame.Season.Fall.End    <- "1130"
ContData.env$myTimeFrame.Season.Winter.Start <- "1201"
#ContData.env$myTimeFrame.Season.Winter.End  <- "0228" #but 0229 in leap year, use start dates only
# Time Frame Names
ContData.env$myName.Yr       <- "Year"
ContData.env$myName.YrMo     <- "YearMonth"
ContData.env$myName.Mo       <- "Month"
ContData.env$myName.MoDa     <- "MonthDay"
ContData.env$myName.JuDa     <- "JulianDay"
ContData.env$myName.Day      <- "Day"
ContData.env$myName.Season   <- "Season"
ContData.env$myName.YrSeason <- "YearSeason"
# for summary stats
ContData.env$myNames.Fields.TimePeriods <- c(ContData.env$myName.Yr
                      											,ContData.env$myName.YrMo
                      											,ContData.env$myName.Mo
                      											,ContData.env$myName.MoDa
                      											,ContData.env$myName.JuDa
                      											,ContData.env$myName.Season
                      											,ContData.env$myName.YrSeason)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Exclude Trigger ####
# Trigger for Stats to exclude (TRUE) or include (FALSE) where flag = "fail"
ContData.env$myStats.Fails.Exclude <- TRUE  #FALSE #TRUE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Report Format ####
ContData.env$myReport.Format <- "docx" # "html" or "docx"
# DOCX requires Pandoc.
ContData.env$myReport.Dir <- file.path(system.file(package="ContDataQC"), "rmd")
