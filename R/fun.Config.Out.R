#' Generate Configuration Report
#'
#' Function to output configuration settings to report (HTML).
#'
#' @param fun.myConfig Configuration file to use for this data analysis.  The default is always loaded first so only "new" values need to be included.  This is the easiest way to control time zones.
#' @param fun.myDir.export Directory for export data.  Default is current working directory.
#' @param fun.myReport.Dir Report (rmd) template folder.  Default is the package rmd folder.  Can be customized in config.R; ContData.env$myReport.Dir.
#'
#' @examples
#' # default outputs to working directory
#' Config.Out()
#
#' @export
Config.Out <- function(fun.myConfig="", fun.myDir.export=getwd(), fun.myReport.Dir=""){##FUNCTION.START
	#
  # config file load, 20170517
  if (fun.myConfig!="") {##IF.fun.myConfig.START
    config.load(fun.myConfig)
  }##IF.fun.myConfig.START
  #
  # Error Check, Report Directory
  if(fun.myReport.Dir==""){
    fun.myReport.Dir <- ContData.env$myReport.Dir
  }
  #
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  #
	myReport.Name <- "Report_Config"
	fun.myReport.format <- "html"
	#
  strFile.RMD <- file.path(fun.myReport.Dir, paste0(myReport.Name, ".rmd"))
  strFile.out.ext <- paste0(".",fun.myReport.format) #".docx" # ".html"
  strFile.out <- paste0(paste(myReport.Name,myDate,myTime,sep=ContData.env$myDelim),strFile.out.ext)
  #paste(paste(strFile.Prefix,strFile.SiteID,fun.myData.Type,,myReport.Name,sep=ContData.env$myDelim),strFile.out.ext,sep="")
  #
  # Test if RMD file exists
  if (file.exists(strFile.RMD)){##IF.file.exists.START
    #suppressWarnings(
    rmarkdown::render(strFile.RMD, output_file=strFile.out, output_dir=fun.myDir.export, quiet=TRUE)
    #)
  } else {
    Msg.Line0 <- "\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
    Msg.Line1 <- "Provided report template file directory does not include the necessary RMD file to generate the report.  So no report will be generated."
    Msg.Line2 <- "The default report directory can be modified in config.R (ContData.env$myReport.Dir) and used as input to the function (fun.myConfig)."
    Msg.Line3 <- paste0("file = ", paste0(myReport.Name, ".rmd"))
    Msg.Line4 <- paste0("directory = ", fun.myReport.Dir)
    Msg <- paste(Msg.Line0, Msg.Line1, Msg.Line2, Msg.Line3, Msg.Line4, Msg.Line0, sep="\n\n")
    cat(Msg)
    flush.console()
  }##IF.file.exists.END
	#
}##FUNCTION.END
