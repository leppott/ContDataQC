# User Defined Values

# QC Tests and Calculations
#http://stackoverflow.com/questions/16143700/pasting-two-vectors-with-combinations-of-all-vectors-elements
#myNames.QCTests.Calcs.combo <- as.vector(t(outer(myNames.QCTests,myNames.QCTests.Calcs,paste,sep=".")))
# combine so can check for and remove later.
#myNames.DataFields.QCTests.Calcs.combo <- as.vector(t(outer(myNames.DataFields,myNames.QCTests.Calcs.combo,paste,sep=".")))
# Data Quality Flag Thresholds
## Gross Min/Max, Fail (equipment)
ContData.env$myThresh.Gross.Fail.Hi.WaterTemp  <- 30
ContData.env$myThresh.Gross.Fail.Lo.WaterTemp  <- -2

## Gross Min/Max, Suspect (extreme)
ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp  <- 25
ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp  <- -1

## Spike thresholds (absolute change)
ContData.env$myThresh.Spike.Hi.WaterTemp  <- 10
ContData.env$myThresh.Spike.Lo.WaterTemp  <- 5

## Rate of Change (relative change)
# ContData.env$myDefault.RoC.SD.number  <- 3
# ContData.env$myDefault.RoC.SD.period  <- 25 #hours
ContData.env$myThresh.RoC.SD.number.WaterTemp  <- ContData.env$myDefault.RoC.SD.number
ContData.env$myThresh.RoC.SD.period.WaterTemp  <- ContData.env$myDefault.RoC.SD.period

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
ContData.env$myThresh.Flat.Tolerance.SensorDepth <- 0.01
ContData.env$myThresh.Flat.Hi.Discharge         <- ContData.env$myDefault.Flat.Hi * 2
ContData.env$myThresh.Flat.Lo.Discharge         <- ContData.env$myDefault.Flat.Lo * 2
ContData.env$myThresh.Flat.Tolerance.Discharge  <- 0.01
#
ContData.env$myThresh.Flat.MaxComp    <- max(ContData.env$myThresh.Flat.Hi.WaterTemp
                                             , ContData.env$myThresh.Flat.Hi.AirTemp
                                             , ContData.env$myThresh.Flat.Hi.WaterP
                                             , ContData.env$myThresh.Flat.Hi.AirBP
                                             , ContData.env$myThresh.Flat.Hi.Discharge
                                             , ContData.env$myThresh.Flat.Hi.Cond
                                             , ContData.env$myThresh.Flat.Hi.DO
                                             , ContData.env$myThresh.Flat.Hi.pH
                                             , ContData.env$myThresh.Flat.Hi.Turbidity
                                             , ContData.env$myThresh.Flat.Hi.Chlorophylla
                                             , ContData.env$myThresh.Flat.Hi.WaterLevel
)
