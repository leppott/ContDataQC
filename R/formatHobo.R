#' @title Format Hoboware output
#'
#' @description  Format HoboWare output for use with `ContDataQC` package.
#' Works on single files.  Imports, modifies, and saves the new file.
#'
#' @param fun.myFile Single file (or vector of files) to perform functions.
#' @param fun.myDir.import Directory for import data.  Default is current working directory.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @param fun.myConfig Configuration file to use for this data analysis.
#' The default is always loaded first so only "new" values need to be included.
#' This is the easiest way to control time zones.
#'
#' @return No data frames are returned.  A CSV file ready for use with the ContDataQC
#' QC function will be generated in the specified output directory.
#'
#' @details Imports a HoboWare output (with minimal tweaks) from a folder
#' , reformats it using defaults from the ContDataQC config file
#' , and exports a CSV to another folder for use with ContDataQC.
#'
#' Below are the default data directories assumed to exist in the working directory.
#' These can be created with code in the example.  Using this function as an example,
#' files will be imported from Data0_Original and exported to Data1_RAW.
#'
#' * ./Data0_Original/ = Unmodified data logger files.
#'
#' * ./Data1_RAW/ = Data logger files modified for use with library.  Modifications for extra rows and file and column names.
#'
#' * ./Data2_QC/ = Repository for library output for QCed files.
#'
#' * ./Data3_Aggregated/ = Repository for library output for aggregated (or split) files.
#'
#' * ./Data4_Stats/ = Repository for library output for statistical summary files.
#'
#' File format should be "SiteID_SensorType_StartDate_EndData.csv".
#'
#'  * SiteID = no spaces or underscores
#'
#'  * SensorType = Air, Water, or AW (Air + Water in the same file)
#'
#'  * Dates = YYYYMMDD (no delimiter)
#'
#'  * Delimiter = underscore (as specified in the config file)
#'
#' @examples
#' \dontrun{
#'
#' # Parameters
#' Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#' Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#' Selection.SUB       <- c("Data0_Original", "Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#' myDir.BASE          <- getwd()
#'
#' # Create data directories
#' myDir.create <- paste0("./",Selection.SUB[1])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[2])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[3])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[4])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#' myDir.create <- paste0("./",Selection.SUB[5])
#'   ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#'
#' # Save example data (assumes directory ./Data0_Original/ exists)
#' fn_1 <- "Charlies_Air_20170726_20170926.csv"
#' fn_2 <- "Charlies_AW_20170726_20170926.csv"
#' fn_3 <- "Charlies_Water_20170726_20170926.csv"
#' lapply(c(fn_1,fn_2,fn_3), function(x)
#'        file.copy(system.file("extdata", x, package="ContDataQC")
#'        , file.path(myDir.BASE, Selection.SUB[1], x)))
#'
#' # Function Inputs
#' myFiles <- c("Charlies_Air_20170726_20170926.csv"
#'              , "Charlies_AW_20170726_20170926.csv"
#'              , "Charlies_Water_20170726_20170926.csv")
#' myDir.import <- file.path(getwd(), "Data0_Original")
#' myDir.export <- file.path(getwd(), "Data1_RAW")
#'
#' # Run Function (with default config)
#' formatHobo(myFiles, myDir.import, myDir.export)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # QC Data
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' myFile <- myFiles
#' myDir.import <- file.path(".","Data1_RAW")
#' myDir.export <- file.path(".","Data2_QC")
#' myReport.format <- "html"
#' ContDataQC(myData.Operation, fun.myDir.import=myDir.import
#'           , fun.myDir.export=myDir.export, fun.myFile=myFile
#'           , fun.myReport.format=myReport.format)
#'
#' }
#
#' @export
formatHobo <- function(fun.myFile=""
                       , fun.myDir.import=getwd()
                       , fun.myDir.export=getwd()
                       , fun.myConfig=""
                       ){##FUNCTION.START
	# 00. QC ####
  ## config file load, 20170517
  if (fun.myConfig!="") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #

  ## dont need check if using "files" version
  if(fun.myFile[1]==""){##IF.fun.myFile.START
    # Error checking.  If any null then kick back
    ## (add later)
    # 20160204, Check for required fields
    #   Add to individual scripts as need to load the file first
    # QC Check - delimiter in site ID
    if(ContData.env$myDelim==".") {##IF.myDelim.START
      # special case for regex check to follow (20170531)
      myDelim2Check <- "\\."
    } else {
      myDelim2Check <- ContData.env$myDelim
    }##IF.myDelim.END
    #
    # QC.SiteID.myDelim <- grepl(myDelim2Check, fun.myData.SiteID) #T/F
    # #
    # if(QC.SiteID.myDelim==TRUE){##IF.QC.SiteID.myDelim.START
    #   #
    #   myMsg <- paste("\n
    #                  SiteID (",fun.myData.SiteID,") contains the same delimiter (",ContData.env$myDelim,") as in your file names.
    #                  \n
    #                  Scripts will not work properly while this is true.
    #                  \n
    #                  Change SiteID names so they do not include the same delimiter.
    #                  \n
    #                  Or change file names and the variable 'myDelim' in the configuration script 'config.R' (or in the file specified by the user).",sep="")
    #   stop(myMsg)
    #   #
    # }##IF.QC.SiteID.myDelim.END
  }##IF.fun.myFile.END

  # 01. Loop Files ####
 # i <- fun.myFile[1]
  for (i in fun.myFile){##FOR.i.START
    #
    # 01.00. Setup ####
    # current file is "i"
    i.num <- match(i, fun.myFile)
    i.len <- length(fun.myFile)
    # User feedback
    cat(paste0("Working on item (", i.num, "/", i.len, "); ", i, "\n"))
    flush.console()

    # 01.01. Import ####
    # import with read.delim (greater control than read.csv)
    df_hobo <- read.delim(file.path(fun.myDir.import, i), skip=1, header=TRUE, sep=","
                          , check.names=FALSE, stringsAsFactors = FALSE)

    # 01.02. Munge ####
    # parse name on "." (for extension) or "_"

    split_fn_hobo   <- unlist(strsplit(i, paste0("[.]|[",ContData.env$myDelim,"]")))
    SiteID          <- split_fn_hobo[1]
    Type            <- split_fn_hobo[2]
    DateRange.Start <- split_fn_hobo[3]
    DateRange.End   <- split_fn_hobo[4]
    FileFormat      <- split_fn_hobo[5]

    # 01.03. Columns ####
    # Check for columns (all lower case)
    find_Date <- "date"
    find_Temp <- "temp"
    find_Pres <- "pres"
    find_Air  <- "air"
    find_Water <- "water"
    find_Depth <- "depth"
    find_Barom <- "barom"
    find_badchar <- "Â"
    find_logger <- "LGR S/N:"

    # Replace bad character
    names(df_hobo) <- gsub(find_badchar, "", names(df_hobo))

    # Columns, Hobo
    ## Date
    col_Date <- names(df_hobo)[grepl(find_Date, tolower(names(df_hobo)))]
    ## Air Temp
    col_AirTemp <- names(df_hobo)[grepl(paste0(find_Air,".*",find_Temp,"|",find_Temp,".*",find_Air)
                                        , tolower(names(df_hobo)))]
    ## Water Temp
    col_WaterTemp <- names(df_hobo)[grepl(paste0(find_Water,".*",find_Temp,"|",find_Temp,".*",find_Water)
                                          , tolower(names(df_hobo)))]
    ## Air Pressure
    col_AirBP <- names(df_hobo)[grepl(paste0(find_Barom,".*",find_Pres,"|",find_Pres,".*",find_Barom)
                                      , tolower(names(df_hobo)))]
    ## Water Pressure
    # find Pres and not Barom
    col_WaterP_find <- grepl(find_Pres, tolower(names(df_hobo))) + !grepl(find_Barom, tolower(names(df_hobo)))
    col_WaterP <- names(df_hobo)[col_WaterP_find==2]
    ## Sensor Depth
    col_SensorDepth <- names(df_hobo)[grepl(find_Depth, tolower(names(df_hobo)))]
    ## Logger (both)
    LogID_str <- "LGR S/N: "
    ## Logger, Water
    ### conditional so is below
    ## Logger, Air
    ### conditional so is below

    # Columns, Output
    ## same values as ContData.env$myName.*
    col_out_SiteID        <- ContData.env$myName.SiteID # "SiteID"
    col_out_DateTime      <- ContData.env$myName.DateTime # "Date.Time"
    col_out_AirTemp       <- ContData.env$myName.AirTemp # "Air.Temp.C"
    col_out_WaterTemp     <- ContData.env$myName.WaterTemp # "Water.Temp.C"
    col_out_AirBP         <- ContData.env$myName.AirBP # "Air.BP.psi"
    col_out_WaterP        <- ContData.env$myName.WaterP # "Water.P.psi"
    col_out_SensorDepth   <- ContData.env$myName.SensorDepth # "Sensor.Depth.ft"
    col_out_WaterLoggerID <- ContData.env$myName.LoggerID.Water # "Water.LoggerID"
    col_out_AirLoggerID   <- ContData.env$myName.LoggerID.Air # "Air.LoggerID"
    col_out_AirRowID      <- ContData.env$myName.RowID.Air
    col_out_WaterRowID    <- ContData.env$myName.RowID.Water

    # 01.04. DF Create ####
    # Create output
    nrow_hobo <- nrow(df_hobo)
    df_out <- data.frame(matrix(, nrow=nrow_hobo, ncol=0)) # missing x on purpose
    # assign SiteID
    df_out[, col_out_SiteID] <- SiteID
    # assign date time
    df_out[, col_out_DateTime] <- df_hobo[,col_Date]

    # all the rest are optional (unknown if included)
    #
    if(length(col_AirTemp)!=0){##IF.col_AirTemp.START
      df_out[, col_out_AirTemp] <- df_hobo[, col_AirTemp]
      # Logger, Air
      LogID_Air_pos <- gregexpr(LogID_str, col_AirTemp)
      LogID_Air_start <- LogID_Air_pos[[1]][1]+nchar(LogID_str)
      LogID_Air_end <- nchar(col_AirTemp)
      LogID_Air <- trimws(gsub(")", "", substr(col_AirTemp, LogID_Air_start, LogID_Air_end)))
      df_out[, col_out_AirLoggerID] <- LogID_Air
      df_out[, col_out_AirRowID] <- row.names(df_hobo)
    }##IF.col_AirTemp.END
    #
    if(length(col_WaterTemp)!=0){##IF.col_WaterTemp.START
      df_out[, col_out_WaterTemp] <- df_hobo[, col_WaterTemp]
      # Logger, Water
      LogID_Water_pos <- gregexpr(LogID_str, col_WaterTemp)
      LogID_Water_start <- LogID_Water_pos[[1]][1]+nchar(LogID_str)
      LogID_Water_end <- nchar(col_WaterTemp)
      LogID_Water <- trimws(gsub(")", "", substr(col_WaterTemp, LogID_Water_start, LogID_Water_end)))
      df_out[, col_out_WaterLoggerID] <- LogID_Water
      df_out[, col_out_WaterRowID] <- row.names(df_hobo)
    }##IF.col_WaterTemp.END
    #
    if(length(col_AirBP)!=0){##IF.col_AirBP.START
      df_out[, col_out_AirBP] <- df_hobo[, col_AirBP]
    }##IF.col_AirBP.END
    #
    if(length(col_WaterP)!=0){##IF.col_WaterP.START
      df_out[, col_out_WaterP] <- df_hobo[, col_WaterP]
    }##IF.col_WaterP.END
    #
    if(length(col_SensorDepth)!=0){##IF.col_SensorDepth.START
      df_out[, col_out_SensorDepth] <- df_hobo[, col_SensorDepth]
    }##IF.col_SensorDepth.END

    # 01.05. DF Save ####
    write.csv(df_out, file.path(fun.myDir.export, i), row.names=FALSE)

    # 01.06. Cleanup
    rm(df_out)
    rm(df_hobo)

  }##FOR.i.END
  #
  cat("Task complete.\n")
  flush.console()
	#
}##FUNCTION.END
