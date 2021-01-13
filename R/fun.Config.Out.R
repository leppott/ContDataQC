#' Generate Configuration Report
#'
#' Function to output configuration settings to report.
#'
#' @param fun.myConfig Configuration file to use for this data analysis.  The
#' default is always loaded first so only "new" values need to be included.
#' This is the easiest way to control time zones.
#' @param fun.myDir.export Directory for export data.
#' Default is current working directory.
#' @param fun.myReport.format Report format (docx or html).  Default = html.
#' @param fun.myReport.Dir Report (rmd) template folder.  Default is the package
#' rmd folder.  Can be customized in config.R; ContData.env$myReport.Dir.
#'
#' @return Creates a report of the user provided configuration file.
#' A copy of the configuration file is also generated with "Config_Out", date,
#' and time as a prefix to the provided configuration file.
#'
#' @examples
#' # default outputs to temp directory
#' Config.Out(fun.myDir.export = tempdir())
#
#' @export
Config.Out <- function(fun.myConfig = ""
                       , fun.myDir.export = getwd()
                       , fun.myReport.format = "html"
                       , fun.myReport.Dir = ""){##FUNCTION.START
	#
  boo_DEBUG <- FALSE
  if(boo_DEBUG == TRUE){##IF~boo_DEBUG~START
    fun.myConfig        <- ""
    fun.myDir.export    <- getwd()
    fun.myReport.format <- "html"
    fun.myReport.Dir    <- ""
    # Load default config
    myConfig <- file.path(system.file(package="ContDataQC")
                          , "extdata"
                          , "config.ORIG.R")
    #source(myConfig)
  }##IF~boo_DEBUG~START

  # config file load, 20170517
  if (fun.myConfig != "") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #
  # Error Check, Report Directory
  if(fun.myReport.Dir == ""){
    fun.myReport.Dir <- ContData.env$myReport.Dir
  }
  #
  # QC, ensure inputs are in the proper case
  fun.myReport.format <- tolower(fun.myReport.format)

  myDate <- format(Sys.Date(), "%Y%m%d")
  myTime <- format(Sys.time(), "%H%M%S")
  #
	myReport.Name <- "Report_Config"
	#fun.myReport.format <- "html"
	#
  strFile.RMD <- file.path(fun.myReport.Dir, paste0(myReport.Name, ".rmd"))
  strFile.out.ext <- paste0(".", fun.myReport.format) #".docx" # ".html"
  strFile.out <- paste0(paste(myReport.Name
                              , myDate
                              , myTime
                              , sep = ContData.env$myDelim)
                        ,strFile.out.ext)
  strFile.RMD.format <-  paste0(ifelse(fun.myReport.format == "docx"
                                       , "word"
                                       , fun.myReport.format),"_document")
  #paste(paste(strFile.Prefix,strFile.SiteID,fun.myData.Type,,myReport.Name,sep=
  # ContData.env$myDelim),strFile.out.ext,sep="")
  #
  # Test if RMD file exists
  if (file.exists(strFile.RMD)){##IF.file.exists.START
    #suppressWarnings(
    rmarkdown::render(strFile.RMD, output_format=strFile.RMD.format
                      , output_file=strFile.out, output_dir=fun.myDir.export
                      , quiet=TRUE)
    #)
  } else {
    Msg.Line0 <- "\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    Msg.Line1 <- "Provided report template file directory does not include the
    necessary RMD file to generate the report.  So no report will be generated."
    Msg.Line2 <- "The default report directory can be modified in config.R
    (ContData.env$myReport.Dir) and used as input to the function
    (fun.myConfig)."
    Msg.Line3 <- paste0("file = ", paste0(myReport.Name, ".rmd"))
    Msg.Line4 <- paste0("directory = ", fun.myReport.Dir)
    Msg <- paste(Msg.Line0
                 , Msg.Line1
                 , Msg.Line2
                 , Msg.Line3
                 , Msg.Line4
                 , Msg.Line0
                 , sep = "\n\n")
    cat(Msg)
    utils::flush.console()
  }##IF.file.exists.END

  # Config Copy ####

  # Config Name
  if (fun.myConfig != "") {##IF.fun.myConfig.START
    fn_config_in <- fun.myConfig
    fn_config_out <- paste("Config_Out"
                           , myDate
                           , myTime
                           , basename(fn_config_in)
                           , sep = "_")
    file.copy(fn_config_in, file.path(fun.myDir.export, fn_config_out))
  } else {
    #fn_config_in  <- file.path(system.file(package="ContDataQC"), "extdata"
    # , "config.ORIG.R")
    # fn_config_out <- paste("Config_Out"
    #                        , myDate
    #                        , myTime
    #                        , basename(file.path(system.file(package=
    # "ContDataQC"), "extdata", "config.ORIG.R")), sep="_")
    file.copy(file.path(system.file(package="ContDataQC")
                        , "extdata", "config.ORIG.R")
              , file.path(fun.myDir.export
                          , paste("Config_Out"
                                  , myDate
                                  , myTime
                                  , basename(file.path(system.file(package =
                                                                   "ContDataQC")
                                                       , "extdata"
                                                       , "config.ORIG.R"))
                                  , sep = "_")))
  }##IF.fun.myConfig.START

  # fn_config_out <- paste("Config_Out", myDate, myTime, basename(fn_config_in)
  #  , sep="_")
  # file.copy(fn_config_in, file.path(fun.myDir.export, fn_config_out))

  #
	#
}##FUNCTION.END
