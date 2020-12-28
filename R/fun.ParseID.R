#' @title Parse ID string
#'
#' @description This function will parse an ID string into SiteID, ID_Depth, and ID_DepthUnits.
#'
#' @details Designed for use with depth profile data where the depth and, optionally, units are incorporated into the SiteID.
#'
#' Based on the default delimiter specified in the config file (ContData.env$myDelim_LakeID) the given ID is separated into 3 parts.
#' The original SIteID is retained as ID_Full
#'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20190225
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param fun.FileName.In Input file name (with directory).
#' @param fun.FileName.Out Output file name (with directory).
#' @param fun.ColName.ID Column name for SiteID to be parsed.
#' @param fun.Delim ID string delimiter.  Default = "~" (Can be modified in config file; ContData.env$myDelim_LakeID)
#'
#' @return Returns a csv file to specified finelname with the full site ID properly parsed into new columns.
#'
#' @examples
#' \dontrun{
#' # Parse ID string and save
#' dir_files <- file.path("./Data3_Aggregated")
#' setwd(dir_files)
#'
#' fun.myFileName.In <- "DATA_QC_Ellis~1.0m_Water_20180524_20180918_Append_2.csv"
#' fun.myFileName.Out <- "Ellis_FixedID.csv"
#' fun.ColName.ID <- "SiteID"
#' fun.Delim <- "~"
#'
#' fun.ParseID(fun.myFileName.In
#'             , fun.myFileName.Out
#'             , fun.ColName.ID
#'             , fun.Delim)
#' #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' # Example code to Plot data
#' library(ggplot2)
#'
#' # Read file
#' df_Ellis <- read.csv(file.path(system.file("extdata", package="ContDataQC"), "Ellis.csv"))
#' df_Ellis[, "Date.Time"] <- as.POSIXct(df_Ellis[, "Date.Time"])
#'
#' # Plot, Create
#' p <- ggplot(df_Ellis, aes(x=Date.Time, y=Water.Temp.C, group=ID_Depth)) +
#'   geom_point(aes(color=ID_Depth)) +
#'   scale_color_continuous(trans="reverse") +
#'   scale_x_datetime(date_labels = "%Y-%m")
#'
#' # Plot, Show
#' print(p)
#'}
#' @export
fun.ParseID <- function(fun.myFileName.In
                       , fun.myFileName.Out
                       , fun.ColName.ID
                       , fun.Delim=NA) {##FUNCTION~fun.ParseID~START
  # DEBUG
  boo_DEBUG <- FALSE

  # Loop through each file
  for (i in fun.myFileName.In){##IF~i~START
    #
    # DEBUG
    if(boo_DEBUG==TRUE){##IF~boo_DEBUG~START
      i <- fun.myFileName.In[1]
    }##IF~boo_DEBUG~END

    #
    i_num <- match(i, fun.myFileName.In)
    i_len <- length(fun.myFileName.In)

    # QC
    if(file.exists(i)==FALSE){##IF~file.exists~START
      msg <- paste0("Specified file does not exist; ", i)
      stop(msg)
    }##IF~file.exists~END

    # Import
    df_import <- utils::read.csv(i)

    # ID String
    str_ID <- as.character(unique(df_import[, fun.ColName.ID]))

    # Delimiter
    if(is.na(fun.Delim)==TRUE){##IF~is.na~START
      myDelim.strsplit <- ContData.env$myDelim_LakeID
    } else {
      myDelim.strsplit <- fun.Delim
    }##IF~is.na~END

    # Keep original ID String
    df_import[,"ID_Full"] <- df_import[, fun.ColName.ID]

    # Split ID String based on Delimiter into SiteID and NonSiteID
    df_split <- data.frame(do.call("rbind", strsplit(as.character(df_import[, fun.ColName.ID]), myDelim.strsplit, fixed=TRUE)))
    names(df_split) <- c("SiteID", "NonSiteID")

    # Separate Units from NonSiteID
    pat_units <- "[a-z]*$"  # characters, any number, at end of string
    pat_matches <- regexpr(pat_units, df_split[, "NonSiteID"], perl=TRUE, ignore.case = TRUE)
    df_split[, "DepthUnits"]  <- regmatches(df_split[, "NonSiteID"], pat_matches)
    #
    for(i in seq_len(nrow(df_split))){##FOR~i~START
      if(identical(df_split[i, "DepthUnits"], character(0))==TRUE){##IF~identical~START
        df_split[i, "DepthNumber"] <- df_split[i, "NonSiteID"]
        df_split[i, "DepthUnits"]  <- NA
      } else {
        df_split[i, "DepthNumber"] <- sub(df_split[i, "DepthUnits"], "", df_split[i, "NonSiteID"])
        # df_split$Erik <- lapply(df_split[,c("DepthUnits", "NonSiteID")], 2, FUN=sub(x[, 1], "", x[, 2]))
      }##IF~identical~END
    }##FOR~i~END

    # Add columns
    df_import[, "ID_Full"]       <- df_import[, fun.ColName.ID]
    df_import[, "ID_Depth" ]     <- df_split[, "DepthNumber"]
    df_import[, "ID_DepthUnits"] <- df_split[, "DepthUnits"]
    df_import[, fun.ColName.ID]  <- df_split[, "SiteID"]

    # Export the file
    utils::write.csv(df_import, fun.myFileName.Out[i_num])


  }##IF~i~END

  print(paste0("Task COMPLETE; ", i_len, " items."))
  utils::flush.console()

}##FUNCTION~fun.ParseID~END
