#' @title Format miniDOT concatenate (cat) output
#'
#' @description  Format miniDOT concatenate (cat) output for use with
#' `ContDataQC` package.   Works on single files.  Imports, modifies, and saves
#' the new file.
#'
#' @details
#' 1. Imports a miniDOT cat output from a folder.
#' Can also use ContDataQC::minidot_cat function.
#'
#' 2. Reformats it using defaults from the ContDataQC config file
#'
#' 3. Exports a CSV to the provided folder for use with ContDataQC
#'
#' Below are the default data directories assumed to exist in the working
#' directory.  These can be created with code in the example.  Using this
#' function as an example, files will be imported from Data0_Original and
#' exported to Data1_RAW.
#'
#' * ./Data0_Original/ = Unmodified data logger files.
#'
#' * ./Data1_RAW/ = Data logger files modified for use with library.
#' Modifications for extra rows and file and column names.
#'
#' * ./Data2_QC/ = Repository for library output for QCed files.
#'
#' * ./Data3_Aggregated/ = Repository for library output for aggregated
#' (or split) files.
#'
#' * ./Data4_Stats/ = Repository for library output for statistical
#' summary files.
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
#' Column names are inspected with regular expressions (R not Perl) to find
#' matches before being renamed. If column names do not match the criteria below
#' they will not be formatted properly.
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#' * Date = "date"
#'
#' * Air Temperature = "air.\*temp" or "temp.\*air"
#'
#' * Water Temperature = "water.\*temp" or "temp.\*water"
#'
#' * Air Presssure = "barom.\*pres" or "pres.\*barom"
#'
#' * Water Pressure = "pres" (search for Air Pressure first)
#'
#' * Sensor Depth = "depth"
#'
#' * Water Level = "level"
#'
#' * Dissolved Oxygen (conc) = "do conc"
#'
#' * Dissolved Oxygen (adj conc) = "do" & "adj" (searches for both)
#'
#' * Dissolved Oxygen (% saturation) = "do per"
#'
#' miniDOT files output time in UTC (origin 1970-01-01).
#'
#' @param fun.myFile Single file (or vector of files) to perform functions.
#' @param fun.myDir.import Directory for import data.
#' Default is current working directory.
#' @param fun.myDir.export Directory for export data.
#' Default is current working directory.
#' @param fun.myConfig Configuration file to use for this data analysis.
#' The default is always loaded first so only "new" values need to be included.
#' This is the easiest way to control time zones.
#'
#' @return No data frames are returned.  A CSV file ready for use with the
#' ContDataQC QC function will be generated in the specified output directory.
#'
#' @examples
#' \dontrun{
#'
#' # Parameters
#' Selection.Operation <- c("GetGageData"
#'                          , "QCRaw"
#'                          , "Aggregate"
#'                          , "SummaryStats")
#' Selection.Type      <- c("Air", "Water", "AW", "Gage", "AWG", "AG", "WG")
#' Selection.SUB       <- c("Data0_Original"
#'                          , "Data1_RAW"
#'                          , "Data2_QC"
#'                          , "Data3_Aggregated"
#'                          , "Data4_Stats")
#' myDir.BASE          <- tempdir()
#'
#' # Create data directories
#' myDir.create <- file.path(myDir.BASE, Selection.SUB[1])
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, Selection.SUB[2])
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, Selection.SUB[3])
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, Selection.SUB[4])
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, Selection.SUB[5])
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#'
#' # Save example data (assumes directory ./Data0_Original/ exists)
#' fn_1 <- "Charlies_Air_20170726_20170926.csv"
#' fn_2 <- "Charlies_AW_20170726_20170926.csv"
#' fn_3 <- "Charlies_Water_20170726_20170926.csv"
#' fn_4 <- "ECO66G12_AW_20160128_20160418.csv"
#' fn_5 <- "EXAMPLE_DO_RUSSWOOD--02M_DO_20180918_20190610.csv"
#' lapply(c(fn_1, fn_2, fn_3, fn_4, fn_5), function(x)
#'        file.copy(system.file("extdata", x, package="ContDataQC")
#'        , file.path(myDir.BASE, Selection.SUB[1], x)))
#'
#' # Function Inputs
#' myFiles <- c("Charlies_Air_20170726_20170926.csv"
#'              , "Charlies_AW_20170726_20170926.csv"
#'              , "Charlies_Water_20170726_20170926.csv")
#' myDir.import <- file.path(myDir.BASE, "Data0_Original")
#' myDir.export <- file.path(myDir.BASE, "Data1_RAW")
#'
#' # Run Function (with default config)
#' format_minidot(myFiles, myDir.import, myDir.export)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # QC Data
#' myData.Operation <- "QCRaw" #Selection.Operation[2]
#' myFile <- myFiles
#' myDir.import <- file.path(myDir.BASE, "Data1_RAW")
#' myDir.export <- file.path(myDir.BASE, "Data2_QC")
#' myReport.format <- "html"
#' ContDataQC(myData.Operation
#'           , fun.myDir.import = myDir.import
#'           , fun.myDir.export = myDir.export
#'           , fun.myFile = myFile
#'           , fun.myReport.format = myReport.format)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Example with unmodified dates
#' myFiles <- "ECO66G12_AW_20160128_20160418.csv"
#' myDir.import <- file.path(myDir.BASE, "Data0_Original")
#' myDir.export <- file.path(myDir.BASE, "Data1_RAW")
#' HoboDateFormat <- "MDY"
#'
#' # Run Function (with default config)
#' format_minidot(myFiles, myDir.import, myDir.export, HoboDateFormat)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Example with multiple DO fields
#' myFiles <- "EXAMPLE_DO_RUSSWOOD--02M_DO_20180918_20190610.csv"
#' myDir.import <- file.path(myDir.BASE, "Data0_Original")
#' myDir.export <- file.path(myDir.BASE, "Data1_RAW")
#' HoboDateFormat <- "MDY"
#'
#' # Run Function (with default config)
#' format_minidot(myFiles, myDir.import, myDir.export, HoboDateFormat)
#'
#' }
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
format_minidot <- function(fun.myFile = ""
                       , fun.myDir.import = getwd()
                       , fun.myDir.export = getwd()
                       , fun.myConfig = ""
                       ){##FUNCTION.START
  # debug ####
  boo.DEBUG <- FALSE
  if(boo.DEBUG == TRUE){##IF.boo.DEBUG.START
    setwd(tempdir())
    #fun.myFile <- "Ellis--1.0m_Water_20180524_20180918.csv"
    fun.myFile <- "EXAMPLE_DO_RUSSWOOD--02M_DO_20180918_20190610.csv"
    fun.myDir.import <- file.path(getwd(), "Data0_Original")
    fun.myDir.export <- file.path(getwd(), "Data1_RAW")
    fun.myConfig <- ""
    # Load environment
    #ContData.env <- new.env(parent = emptyenv()) # in config.R
    dir_dev <- "C:\\Users\\Erik.Leppo\\OneDrive - Tetra Tech, Inc\\MyDocs_OneDrive\\GitHub\\ContDataQC"
    source(file.path(dir_dev, "R", "config.R"), local=TRUE)
  }##IF.boo.DEBUG.END

	# 00. QC ####
  ## config file load, 20170517
  if (fun.myConfig != "") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #

  ## dont need check if using "files" version
  if(fun.myFile[1] == ""){##IF.fun.myFile.START
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
    #                  SiteID (",fun.myData.SiteID
    #,") contains the same delimiter (",ContData.env$myDelim,") as in your file
    #names.
    #                  \n
    #                  Scripts will not work properly while this is true.
    #                  \n
    #                  Change SiteID names so they do not include the same
    #delimiter.
    #                  \n
    #                  Or change file names and the variable 'myDelim' in the
    #configuration script 'config.R' (or in the file specified by the user)."
    #,sep="")
    #   stop(myMsg)
    #   #
    # }##IF.QC.SiteID.myDelim.END
  }##IF.fun.myFile.END

  # 01. Loop Files ####
  for (i in fun.myFile){##FOR.i.START
    #
    if (boo.DEBUG == TRUE){##IF.boo.DEBUG.START
      i <- fun.myFile[1]
    }##IF.boo.DEBUG.END

    # 01.00. Setup ####
    # current file is "i"
    i.num <- match(i, fun.myFile)
    i.len <- length(fun.myFile)
    # User feedback
    cat(paste0("Working on item (", i.num, "/", i.len, "); ", i, "\n"))
    utils::flush.console()

    # 01.01. Import ####
    # import with read.delim (greater control than read.csv)
    df_hobo <- utils::read.delim(file.path(fun.myDir.import, i)
                                 , skip=1
                                 , header=TRUE
                                 , sep=","
                                 , check.names=FALSE
                                 , stringsAsFactors = FALSE)

    # 01.02. Munge ####
    # parse name on "." (for extension) or "_"
    # Lake SiteID includes Depth.  Move "." parsing to end.
    split_fn_hobo   <- unlist(strsplit(i, paste0("[",ContData.env$myDelim,"]")))
    SiteID          <- split_fn_hobo[1]
    Type            <- split_fn_hobo[2]
    DateRange.Start <- split_fn_hobo[3]
    split_fn_hobo_4 <- unlist(strsplit(split_fn_hobo[4], "[.]"))
    DateRange.End   <- split_fn_hobo_4[1]
    FileFormat      <- split_fn_hobo_4[2]

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
    find_Level <- "level"
    find_DO        <- "do conc"
    find_DO.adj    <- "adj"
    find_DO.pctsat <- "do per"

    # Replace bad character
    names(df_hobo) <- gsub(find_badchar, "", names(df_hobo))

    # Columns, Hobo
    ## Date
    col_Date <- names(df_hobo)[grepl(find_Date, tolower(names(df_hobo)))]
    ## Air Temp
    col_AirTemp <- names(df_hobo)[grepl(paste0(find_Air,".*",find_Temp
                                               ,"|",find_Temp,".*",find_Air)
                                        , tolower(names(df_hobo)))]
    ## Water Temp
    col_WaterTemp <- names(df_hobo)[grepl(paste0(find_Water,".*",find_Temp
                                                 ,"|",find_Temp,".*",find_Water)
                                          , tolower(names(df_hobo)))]
    ## Air Pressure
    col_AirBP <- names(df_hobo)[grepl(paste0(find_Barom,".*",find_Pres,"|"
                                             ,find_Pres,".*",find_Barom)
                                      , tolower(names(df_hobo)))]
    ## Water Pressure
    # find Pres and not Barom
    col_WaterP_find <- grepl(find_Pres, tolower(names(df_hobo))) +
      !grepl(find_Barom, tolower(names(df_hobo)))
    col_WaterP <- names(df_hobo)[col_WaterP_find == 2]
    ## Sensor Depth
    col_SensorDepth <- names(df_hobo)[grepl(find_Depth
                                            , tolower(names(df_hobo)))]
    ## Logger (both)
    LogID_str <- "LGR S/N: "
    ## Logger, Water
    ### conditional so is below
    ## Logger, Air
    ### conditional so is below

    ## Water Level
    col_WaterLevel <- names(df_hobo)[grepl(find_Level
                                            , tolower(names(df_hobo)))]

    col_DO_ALL <- names(df_hobo)[grepl("do", tolower(names(df_hobo)))]
    col_DO <- names(df_hobo)[grepl(find_DO, tolower(names(df_hobo)))]
    col_DO.adj <- col_DO_ALL[grepl(find_DO.adj, tolower(col_DO_ALL))]
    col_DO.pctsat <- names(df_hobo)[grepl(find_DO.pctsat
                                          , tolower(names(df_hobo)))]


    # Modify Date ----
    # if no format then no transformation

    if(is.null(fun.HoboDateFormat) == TRUE){
      msg <- "No Hoboware date format (MDY, DMY, YMD) specified."
      message(msg)
    } else {

      # new date
      date_new <- df_hobo[, col_Date]

      # Determine delimiter
      if(grepl("-", date_new[1]) == TRUE){
        HW_delim <- "-"
      } else if (grepl("/", date_new[1]) == TRUE){
        HW_delim <- "/"
      } else {
        msg <- "Data format not discernable."
        stop(msg)
      }## grepl("-", date_new[1]) ~ END

      # Determine format, time
      n_colon <- nchar(date_new[1]) - nchar(gsub(":", "", date_new[1]))
      if(n_colon == 2) {
        time_fmt <- " %H:%M:%S"
      } else if(n_colon == 1) {
        time_fmt <- " %H:%M"
      } else {
        time_fmt <- ""
      }## if(n_colon) ~ END

      # Determine format, year
      dateonly <- strsplit(date_new, " ")[[1]][1]
      dateonly_split <- unlist(strsplit(dateonly, HW_delim)[[1]])
      year_fmt <- ifelse(max(nchar(dateonly_split)) == 4
                         , "%Y", "%y")

      # Determine format, date
      if(toupper(fun.HoboDateFormat) == "MDY"){
        HW_format <- paste0("%m", HW_delim, "%d", HW_delim, year_fmt, time_fmt)
      } else if (toupper(fun.HoboDateFormat) == "DMY") {
        HW_format <- paste0("%d", HW_delim, "%m", HW_delim, year_fmt, time_fmt)
      } else if (toupper(fun.HoboDateFormat) == "YMD") {
        HW_format <- paste0(year_fmt, HW_delim, "%m", HW_delim, "%d", time_fmt)
      } else {
      msg <- paste0("Incorrect Hoboware date format (MDY, DMY, YMD) specified, "
                      , fun.HoboDateFormat)
        stop(msg)
      }## if(toupper(fun.HoboDateFormat) ~ END

      # Modify dates
      date_new_mod <- format(strptime(date_new, format = HW_format)
                             , ContData.env$myFormat.DateTime)
      # modify hobo data frame to updated date format
      df_hobo[,col_Date] <- date_new_mod

    }##IF.isnull.hobodate.END




    # Columns, Output
    ## same values as ContData.env$myName.*
    col_out_SiteID        <- ContData.env$myName.SiteID # "SiteID"
    col_out_DateTime      <- ContData.env$myName.DateTime # "Date.Time"
    col_out_AirTemp       <- ContData.env$myName.AirTemp # "Air.Temp.C"
    col_out_WaterTemp     <- ContData.env$myName.WaterTemp # "Water.Temp.C"
    col_out_AirBP         <- ContData.env$myName.AirBP # "Air.BP.psi"
    col_out_WaterP        <- ContData.env$myName.WaterP # "Water.P.psi"
    col_out_SensorDepth   <- ContData.env$myName.SensorDepth # "Sensor.Depth.ft"
    col_out_WaterLevel    <- ContData.env$myName.WaterLevel # "Water.Level.ft"
    col_out_WaterLoggerID <- ContData.env$myName.LoggerID.Water#"Water.LoggerID"
    col_out_AirLoggerID   <- ContData.env$myName.LoggerID.Air # "Air.LoggerID"
    col_out_AirRowID      <- ContData.env$myName.RowID.Air
    col_out_WaterRowID    <- ContData.env$myName.RowID.Water
    col_out_DO            <- ContData.env$myName.DO
    col_out_DO.adj        <- ContData.env$myName.DO.adj
    col_out_DO.pctsat     <- ContData.env$myName.DO.pctsat

    # 01.04. DF Create ####
    # Create output
    nrow_hobo <- nrow(df_hobo)
    #missing x on purpose
    df_out <- data.frame(matrix(, nrow = nrow_hobo, ncol = 0))
    # assign SiteID
    df_out[, col_out_SiteID] <- SiteID
    # assign date time
    df_out[, col_out_DateTime] <- df_hobo[, col_Date]

    # all the rest are optional (unknown if included)
    #
    if(length(col_AirTemp) != 0){##IF.col_AirTemp.START
      df_out[, col_out_AirTemp] <- df_hobo[, col_AirTemp]
      # Logger, Air
      LogID_Air_pos <- gregexpr(LogID_str, col_AirTemp)
      LogID_Air_start <- LogID_Air_pos[[1]][1]+nchar(LogID_str)
      LogID_Air_end <- nchar(col_AirTemp)
      LogID_Air <- trimws(gsub(")", "", substr(col_AirTemp
                                               , LogID_Air_start
                                               , LogID_Air_end)))
      df_out[, col_out_AirLoggerID] <- LogID_Air
      df_out[, col_out_AirRowID] <- row.names(df_hobo)
    }##IF ~ col_AirTemp ~ END
    #
    if(length(col_WaterTemp) != 0){##IF.col_WaterTemp.START
      df_out[, col_out_WaterTemp] <- df_hobo[, col_WaterTemp]
      # Logger, Water
      LogID_Water_pos <- gregexpr(LogID_str, col_WaterTemp)
      LogID_Water_start <- LogID_Water_pos[[1]][1]+nchar(LogID_str)
      LogID_Water_end <- nchar(col_WaterTemp)
      LogID_Water <- trimws(gsub(")", "", substr(col_WaterTemp
                                                 , LogID_Water_start
                                                 , LogID_Water_end)))
      df_out[, col_out_WaterLoggerID] <- LogID_Water
      df_out[, col_out_WaterRowID] <- row.names(df_hobo)
    }##IF ~ col_WaterTemp ~ END
    #
    if(length(col_AirBP) != 0){##IF.col_AirBP.START
      df_out[, col_out_AirBP] <- df_hobo[, col_AirBP]
    }##IF ~ col_AirBP ~ END
    #
    if(length(col_WaterP) != 0){##IF.col_WaterP.START
      df_out[, col_out_WaterP] <- df_hobo[, col_WaterP]
    }##IF ~ col_WaterP ~ END
    #
    if(length(col_SensorDepth) != 0){##IF.col_SensorDepth.START
      df_out[, col_out_SensorDepth] <- df_hobo[, col_SensorDepth]
    }##IF ~ col_SensorDepth ~ END
    #
    if(length(col_WaterLevel) != 0){
      df_out[, col_out_WaterLevel] <- df_hobo[, col_WaterLevel]
    }##IF ~ col_WaterLevel ~ END
    #
    if(length(col_DO) != 0){
      df_out[, col_out_DO] <- df_hobo[, col_DO]
    }##IF ~ col_DO ~ END
    #
    if(length(col_DO.adj) != 0){
      df_out[, col_out_DO.adj] <- df_hobo[, col_DO.adj]
    }##IF ~ col_DO.adj ~ END
    #
    if(length(col_DO.pctsat) != 0){
      df_out[, col_out_DO.pctsat] <- df_hobo[, col_DO.pctsat]
    }##IF ~ col_DO ~ END

    # 01.05. DF Save ####
    utils::write.csv(df_out, file.path(fun.myDir.export, i), row.names=FALSE)

    # 01.06. Cleanup
    rm(df_out)
    rm(df_hobo)

  }##FOR.i.END
  #
  cat("Task complete.\n")
  utils::flush.console()
	#
}##FUNCTION.END
