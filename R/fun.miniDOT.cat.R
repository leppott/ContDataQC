#' @title Compile DO data
#'
#' @description This function compiles Dissolved Oxygen data files downloaded
#' from PME miniDot DO loggers. Use if the data where not compiled using the PME
#' java app on the logger.
#'
#' @details
#' Original function (compile_do_folder) written by Tim Martin.
#'
#' https://github.com/mnsentinellakes/mnsentinellakes/blob/master/R/compile_do_folder.R
#'
#' Edits:
#'
#' * Renamed function
#'
#' * Added local_tz as a parameter.
#'
#' * Replaced lubridate::use_tz with as.POSIXct.
#'
#' * Added serial number as column.
#'
#' * Swaped order of operations so fail condition is triggered it happens before
#' any work is done.
#'
#' * Added working example with data.
#'
#' @param folderpath The folder where the individual files are located
#' @param savetofolder The folder where the output csv is to be saved
#' @param local_tz Local time zone used for converting from UTC time zone.
#'
#' Default is Sys.timezone(location = TRUE).
#'
#' @return In ouput folder a CSV file
#'
#' @examples
#' # Data
#' dn_input <- file.path(system.file("extdata", package = "ContDataQC")
#'                       , "minidot")
#' dn_export <- tempdir()
#'
#' # Function
#' minidot_cat(folderpath = dn_input, savetofolder = dn_export)
#'
#' @export
minidot_cat <- function(folderpath
                        , savetofolder
                        , local_tz = Sys.timezone(location = TRUE)
                        ) {

  if (is.null(savetofolder)) {

    warning("Missing saveto")

  } else if(!is.null(savetofolder)) {

    read_do_files=function(filename){
      dofile=utils::read.delim(filename,stringsAsFactors = FALSE)
      dodata=as.data.frame(do.call(rbind,strsplit(dofile[,1],split = ",")))
      names(dodata)=as.character(unlist(dodata[2,]))
      dodata=dodata[-c(1,2),]
      serialnum <- readLines(filename, 1)
      dodata[, "serialnum"] <- serialnum
      return(dodata)
    }

    dofiles=list.files(folderpath,full.names = TRUE,pattern = ".txt")

    docombined=NULL
    for (i in dofiles){
      readdo=read_do_files(i)

      datetime=as.numeric(as.character(readdo$`Time (sec)`))
      datetimeutc=as.POSIXct(datetime,origin = "1970-01-01",tz="UTC")
      batteryformat=as.numeric(as.character(readdo$`  BV (Volts)`))
      tempformat=as.numeric(as.character(readdo$`  T (deg C)`))
      doformat=as.numeric(as.character(readdo$`  DO (mg/l)`))
      qformat=as.numeric(as.character(readdo$`  Q ()`))
      serialnumformat <- as.character(readdo$serialnum)



      doreformat=data.frame("Unix.Timestamp"=as.character(datetime)
                            ,"UTC_Date_._Time"=as.character(datetimeutc)
                            # ,"Central.Standard.Time"=as.character(
                            #      lubridate::with_tz(datetimeutc,'US/Central'))
                            ,"Local.Time" = as.character(as.POSIXct(
                                datetime, origin = "1970-01-01", tz = local_tz))
                            ,"Battery"=as.character(batteryformat)
                            ,"Temperature"=as.character(tempformat)
                            ,"Dissolved.Oxygen"=as.character(doformat)
                            ,"Dissolved.Oxygen.Saturation"=NA
                            ,"Q"=as.character(qformat)
                            , "serialnum" = as.character(serialnumformat)
                            ,stringsAsFactors = FALSE
                            )

      docombined=rbind(docombined,doreformat)
    }

    dorowadd=data.frame("Unix.Timestamp"=as.character("(Second)")
                        ,"UTC_Date_._Time"=as.character("(none)")
                        ,"Local.Time"=as.character("(none)")
                        ,"Battery"=as.character("(Volt)")
                        ,"Temperature"=as.character("(deg C)")
                        ,"Dissolved.Oxygen"=as.character("(mg/l)")
                        ,"Dissolved.Oxygen.Saturation"=as.character("(%)")
                        ,"Q"=as.character("(none)")
                        , "serialnum" = as.character("(none)")
                        ,stringsAsFactors = FALSE)
    dofinal=rbind(dorowadd,docombined)

    folder=unlist(strsplit(folderpath,split = "/"))[
                              length(unlist(strsplit(folderpath,split = "/")))]
    #serialnum=unlist(strsplit(folder,split="-"))[2] # specific to MN
    serialnum <- dofinal[2, "serialnum"]

    if (substr(savetofolder,(nchar(savetofolder)),nchar(savetofolder))!="/") {
      savetofolder=paste0(savetofolder,"/")
    }

    pathout <- file.path(savetofolder, paste0(serialnum, ".csv"))

    utils::write.csv(dofinal,pathout,row.names = FALSE)
  }else{
    warning("ERROR")
  }
}## FUNCTION ~ END
