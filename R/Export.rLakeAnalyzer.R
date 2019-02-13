#' @title Export data for rLakeAnalyzer package
#'
#' @description Creates a date frame (and file export) from Continuous Data in
#' the format used by the rLakeAnalyzer package.
#'
#' @details The rLakeAnalyzer package is not included in the ContDataQC package.  But an example is provided.
#'
#' To run the example rLakeAnalyzer calculations you will need the rLakeAnalyzer package (from CRAN).
#'
#' Install commands in the example.
#'
#' The rLakeAnalyzer format is "datetime" in the format of "yyyy-mm-dd HH:MM:SS" followed by columns of data.
#' The header of these data columns is "Param_Depth"; e.g., wtr_0.5 is water temperature (deg C) at 0.5 meters.
#'
#' * doobs = Dissolved Oxygen Concentration (mg/L)
#'
#' * wtr = Water Temperature (degrees C)
#'
#' * wnd = Wind Speed (m/s)
#'
#' * airT = Air Temperature (degrees C)
#'
#' * rh = Relative Humidity (%)
#'
#' Files will be saved, if desired, as csv.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20180212
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param df_CDQC Data frame to be converted for use with rLakeAnalyzer.
#' @param col_depth Column name for "depth" in df_CDQC.  Default = "Depth"
#' @param col_CDQC Column names in df_CDQC to transform for use with rLakeAnalyzer.  Date time must be the first entry.
#' @param col_rLA Column names to use with rLakeAnalyzer.  See details for accepted entries.  datetime must be the first entry.
#' @param dir_export Directory for export data.  Default = current working directory.
#' @param fn_export File name of result to be exported.  If no name provided the data frame will not be exported.  Default = NULL.
#'
#' @return Returns a data frame with daily mean values by date (in the specified range).  Also, a csv file is saved to the specified directory with the prefix "IHA" and the date range before the file extension.
#'
#' @examples
#' # Convert Data for use with rLakeAnalyzer
#'
#' # Data
#' fn_CDQC <- "TestLake_Water_20180702_20181012.csv"
#' df_CDQC <- read.csv(file.path(system.file(package = "ContDataQC"), "extdata", fn_CDQC))
#'
#'# Convert Date.Time from factor to POSIXct (make it a date and time field in R)
#' df_CDQC[, "Date.Time"] <- as.POSIXct(df_CDQC[, "Date.Time"])
#'
#' # Columns, date listed first
#' col_depth <- "Depth"
#' col_CDQC <- c("Date.Time", "temp_F", "DO_conc")
#' col_rLA  <- c("datetime", "wtr", "doobs")
#'
#' # Output Options
#' dir_export <- getwd()
#' fn_export <- paste0("rLA_", fn_CDQC)
#'
#' # Run function
#' df_rLA <- Export.rLakeAnalyzer(df_CDQC, col_depth, col_CDQC, col_rLA
#'                                , dir_export, fn_export)
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # use rLakeAnalyzer
#' library(rLakeAnalyzer)
#'
#' # Filter Data for only temperature
#' col_wtr <- colnames(df_rLA)[grepl("wtr_", colnames(df_rLA))]
#' df_rLA_wtr <- df_rLA[, c("datetime", col_wtr)]
#'
#' # Generate Heat Map
#' wtr.heat.map(df_rLA_wtr)
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Plot original data in ggplot
#' library(ggplot2)
#'
#' # Plot, Create
#' p <- ggplot(df_CDQC, aes(x=Date.Time, y=temp_F)) +
#'        geom_point(aes(color=Depth)) +
#'        scale_color_continuous(trans="reverse") +
#'        scale_x_datetime(date_labels = "%Y-%m")
#'
#' # Plot, Show
#' p
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
Export.rLakeAnalyzer <- function(df_CDQC
                                 , col_depth="Depth"
                                 , col_CDQC
                                 , col_rLA
                                 , dir_export=getwd()
                                 , fn_export=NULL
                      ) {##FUNCTION~Export.rLakeAnalyzer~START
  #
  boo_DEBUG <- FALSE
  # QC
  ## QC, equal columns
  if(length(col_CDQC)!=length(col_rLA)){
    msg <- "Number of columns not equal."
    stop(msg)
  }
  ## QC, cols_CDQC
  if(sum(col_CDQC %in% colnames(df_CDQC))!=length(col_CDQC)){
    msg <- "The data frame (df_CDQC) does not contain all specified columns (col_CDQC)."
    stop(msg)
  }

  #
  myParams <- col_CDQC[-1]

  #
  if(boo_DEBUG==TRUE){
    i <- myParams[1]
    #fn_export <- NULL
  }

  #
  for (i in myParams){
    #
    i_num <- match(i, myParams)

    # long to wide for parameter i
    #df_i <- dcast(df_CDQC, col_CDQC[1] ~ col_depth, value.var=i, fun=mean)
    df_i <- reshape2::dcast(df_CDQC, df_CDQC[, col_CDQC[1]] ~ df_CDQC[, col_depth], value.var=i, fun=mean)
    names(df_i)[1] <- c("datetime")
    names(df_i)[-1] <- paste(col_rLA[i_num+1], names(df_i)[-1], sep="_")

    if(i_num==1){
      df_rLA <- df_i
    } else {
      df_rLA <- merge(df_rLA, df_i)
    }
  }

  # write
  if(!is.null(fn_export)==TRUE){
    write.csv(df_rLA, file.path(dir_export, fn_export), row.names=FALSE)
  }


  # Return
  return(df_rLA)


}##FUNCTION~Export.rLakeAnalyzer~END
