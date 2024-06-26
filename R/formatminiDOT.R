#' @title Format miniDOT concatenate (cat) output
#'
#' @description  Format miniDOT concatenate (cat) output for use with
#' `ContDataQC` package.   Works on single files.  Imports, modifies, and saves
#' the combined new file.  Data columns with all NA values are removed.
#'
#' @details
#' 1. Imports a miniDOT cat output file from a folder.
#' Can also use ContDataQC::minidot_cat function.
#'
#' 2. Reformat using defaults from the ContDataQC config file.
#'
#' 3. As a QC step, to prevent issues with ContDataQC function, any columns that
#' are all NA will be removed.
#'
#' 4. Exports a CSV to the provided folder for use with ContDataQC.
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
#' # Create Folders
#' myDir.BASE <- tempdir()
#' myDir.create <- file.path(myDir.BASE, "Data0_Original")
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, "Data1_RAW")
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#' myDir.create <- file.path(myDir.BASE, "Data2_QC")
#'   ifelse(dir.exists(myDir.create) == FALSE
#'          , dir.create(myDir.create)
#'          , "Directory already exists")
#'
#' # Data
#' dn_input <- file.path(system.file("extdata", package = "ContDataQC")
#'                       , "minidot")
#' dn_export <- file.path(myDir.BASE, "Data0_Original")
#' filename <- "test_minidot.csv"
#'
#' # Create miniDOT concatenate file
#' minidot_cat(folderpath = dn_input
#'             , savetofolder = dn_export)
#'
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # FORMAT
#' myFiles <- "7392-354869.csv"
#' myDir.BASE <- tempdir()
#' myDir.import <- file.path(myDir.BASE, "Data0_Original")
#' myDir.export <- file.path(myDir.BASE, "Data1_RAW")
#'
#' # Run Function (with default config)
#' format_minidot(myFiles, myDir.import, myDir.export)
#'
#'#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # QC newly created file
#' myData.Operation <- "QCRaw"
#' myFile <- "7392-354869.csv"
#' myDir.BASE <- tempdir()
#' myDir.import <- file.path(myDir.BASE, "Data1_RAW")
#' myDir.export <- file.path(myDir.BASE, "Data2_QC")
#' myReport.format <- "docx"
#' ContDataQC(myData.Operation
#'            , fun.myDir.import = myDir.import
#'            , fun.myDir.export = myDir.export
#'            , fun.myFile = myFile
#'            , fun.myReport.format = myReport.format)
#'
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
format_minidot <- function(fun.myFile = NULL
                           , fun.myDir.import = getwd()
                           , fun.myDir.export = getwd()
                           , fun.myConfig = NULL
                           ) {
  # debug ####
  boo.DEBUG <- FALSE
  if (boo.DEBUG == TRUE) {
    fun.myFile <- "7392-354869.csv"
    fun.myDir.import <- file.path(tempdir(), "Data0_Original")
    fun.myDir.export <- file.path(tempdir(), "Data1_RAW")
    fun.myConfig <- NULL
    # Load environment
    #ContData.env <- new.env(parent = emptyenv()) # in config.R
    dir_dev <- "C:\\Users\\Erik.Leppo\\OneDrive - Tetra Tech, Inc\\MyDocs_OneDrive\\GitHub\\ContDataQC"
    source(file.path(dir_dev, "R", "config.R"), local = TRUE)
  }##IF.boo.DEBUG.END

	# 00. QC ####
  ## config file load, 20170517
  if (!is.null(fun.myConfig)) {
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #

  ## dont need check if using "files" version
  if (is.null(fun.myFile[1])) {
    # Error checking.  If any null then kick back
    ## (add later)
    # 20160204, Check for required fields
    #   Add to individual scripts as need to load the file first
    # QC Check - delimiter in site ID
    if (ContData.env$myDelim == ".") {
      # special case for regex check to follow (20170531)
      myDelim2Check <- "\\."
    } else {
      myDelim2Check <- ContData.env$myDelim
    }##IF.myDelim.END
  }##IF.fun.myFile.END

  # 01. Loop Files ####
  for (i in fun.myFile) {
    #
    if (boo.DEBUG == TRUE) {
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
    df_md <- utils::read.delim(file.path(fun.myDir.import, i)
                               , skip = 0
                               , header = TRUE
                               , sep = ","
                               , check.names = FALSE
                               , stringsAsFactors = FALSE)

    # 01.02. Munge ####
    ## Remove Row 2 (second, none, volt)
    df_md <- df_md[-1, ]
    # Remove Column 1 (UNIX.timestamp)
    df_md <- df_md[, -1]
    # Remove Column 1 (was 2) (UTC_Date_._Time)
    df_md <- df_md[, -1]

    # Rename Columns
    names(df_md)[names(df_md) %in% "Local.Time"] <- ContData.env$myName.DateTime
    names(df_md)[names(df_md) %in% "Temperature"] <- ContData.env$myName.WaterTemp
    names(df_md)[names(df_md) %in% "Dissolved.Oxygen"] <- ContData.env$myName.DO
    names(df_md)[names(df_md) %in% "Dissolved.Oxygen.Saturation"] <- ContData.env$myName.DO.pctsat
    names(df_md)[names(df_md) %in% "serialnum"] <- ContData.env$myName.SiteID
    # Battery
    # Q

    # QC columns to ensure not all NA
    df_md <- df_md[, colSums(is.na(df_md)) < nrow(df_md)]

    #01.03. Reorder Columns----
    df_out <- df_md

    # 01.04. DF Save ####
    utils::write.csv(df_out, file.path(fun.myDir.export, i), row.names = FALSE)

    # 01.05. Cleanup
    rm(df_md)

  }##FOR.i.END
  #
  cat("Task complete.\n")
  utils::flush.console()
	#
}##FUNCTION.END
