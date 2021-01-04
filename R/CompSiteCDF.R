#' CompSiteCDF, compare CDFs of sites
#'
#' Takes as an input a data frame with date and up to 8 columns of parameter
#' data.  Column names are Date and SiteIDs and values are daily means for some
#' measurement.
#'
#' More than 8 columns can be used but colors are recycled after 8 and the plot
#' lines will be difficult to distinguish.
#'
#' CDFs are generate for all data, year, season, and year/season and saved to a
#' PDF.  Winter + Year is such that December is included with the following year
#' (e.g., Dec 2013, Jan 2014, Feb 2014 are 2014Winter).
#'
#' Two plots per page are generated.  The first plot is the proportion of values
#' at a certain value.  This plot is similar to a histogram.  The second plot is
#' a CDF of values.  The line represents the proportion of values less than or
#' equal to parameter values on the x-axis.
#'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170921
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param file.input Input data as CSV.  Needs Date column and it will handle up
#' to 5 SiteIDs (with data under each SiteID).
#' @param dir.input Directory where data file is located.
#' Default is the working directory; getwd().
#' @param dir.output Directory where PDF file is to be saved.
#' Default is the working directory; getwd().
#' @param ParamName.xlab Parameter name for x-axis on plots
#' @param df.input Optionally use existing data frame over importing file.input.
#' Default = NULL (import file.input).
#'
#' @return Returns a PDF of CDFs.
#'
# @keywords continuous data, CDF, site comparison
#'
#' @examples
#' # Variant 1 (with File)
#' # Load Data
#' myFile <- "CDF_WaterTemp_2014_MA.csv"
#' # example file from ContDataQC library files
#' myDir.input <- file.path(path.package("ContDataQC"),"extdata")
#' myDir.output <- getwd()
#' # X Label
#' myXlab <- "Temperature, Water (deg C)"
#' # Run the Function
#' CompSiteCDF(file.input=myFile, dir.input=myDir.input
#'            , dir.output=myDir.output, ParamName.xlab=myXlab)
#'
#' # Variant 2 (with Data Frame)
#' # Load Data
#' myDF <- data_CompSiteCDF
#' # X Label
#' myXlab <- "Temperature, Water (deg C)"
#' # Run the Function (output will default to working directory)
#' CompSiteCDF(ParamName.xlab=myXlab, df.input=myDF )
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # QC
# myDF <- data_CompSiteCDF
# myXlab <- "Temperature, Water (deg C)"
# # file.input <- myFile
# # dir.input <- myDir.input
# # dir.output <- myDir.output
# ParamName.xlab <- myXlab
# df.input <- myDF
# source(file.path(getwd(),"R","config.R"))
#
# CompSiteCDF(ParamName.xlab = myXlab, df.input=myDF)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
CompSiteCDF <- function(file.input=NULL
                        , dir.input=getwd()
                        , dir.output=getwd()
                        , ParamName.xlab
                        , df.input = NULL){##FUNCTION.CompSiteCDF.START
  #
  # load data (data.frame or from CSV)
  # if no data frame then import file.
  if (!is.null(df.input)) {##IF.START
    data.import <- df.input
  } else {
    data.import <- utils::read.csv(file.path(dir.input, file.input))
  }##IF.END
  #
  # Site Names (Columns)
  Col.Sites <- names(data.import)[!(names(data.import) %in%
                                      ContData.env$myName.Date)]
  #
  # Add columns for time periods
  # add Year, Month, Season, YearSeason (names are in config.R)
  # assume Date is POSIXct
  #
  # add time period fields
  data.import[,ContData.env$myName.Yr]   <- format(as.Date(data.import[
    , ContData.env$myName.Date]),format="%Y")
  data.import[,ContData.env$myName.Mo]   <- format(as.Date(data.import[
    , ContData.env$myName.Date]),format="%m")
  data.import[,ContData.env$myName.YrMo] <- format(as.Date(data.import[
    , ContData.env$myName.Date]),format="%Y%m")
  data.import[,ContData.env$myName.MoDa] <- format(as.Date(data.import[
    , ContData.env$myName.Date]),format="%m%d")
  # data.import[,ContData.env$myName.JuDa] <- as.POSIXlt(data.import[
  #,ContData.env$myName.Date], format=ContData.env$myFormat.Date)$yday +1
  # ## add Season fields
  data.import[,ContData.env$myName.Season] <- NA
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >= as.numeric("0101") & as.numeric(data.import[
      , ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Spring.Start)] <- "Winter"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >= as.numeric(ContData.env$myTimeFrame.Season.Spring.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Summer.Start)] <- "Spring"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >= as.numeric(ContData.env$myTimeFrame.Season.Summer.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Fall.Start)] <- "Summer"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >= as.numeric(ContData.env$myTimeFrame.Season.Fall.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Winter.Start)] <- "Fall"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >= as.numeric(ContData.env$myTimeFrame.Season.Winter.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<=as.numeric("1231")] <- "Winter"
  data.import[,ContData.env$myName.YrSeason] <- paste(data.import[
    , ContData.env$myName.Yr],data.import[,ContData.env$myName.Season], sep="")
  # Remove bad date records
  data.import <- data.import[!is.na(data.import[,ContData.env$myName.Yr]),]
  # rectify December as part of winter of year + 1
  mySelection <- data.import[,ContData.env$myName.Mo]=="12"
  if(sum(mySelection) != 0){##IF.sum.START
    data.import[, ContData.env$myName.YrSeason][mySelection] <- paste(
      as.numeric(data.import[, ContData.env$myName.Yr]) + 1
      , data.import[, ContData.env$myName.Season],sep="")
  }##IF.sum.END
  #
  #View(data.import)
  #
  # Color Blind Palatte
  # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
  # The palette with grey:
  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  # The palette with black:
  #cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  #
  myColors <- cbPalette #rainbow(length(Col.Sites))
  #
  # Season Names
  SeasonNames <- c("Fall", "Winter", "Spring","Summer")
  #
  #~~~~~~~~PLOT CODE~~~~~~~~~~~
  CreatePlots <- function(...) {##FUNCTION.CreatePlots.START
    # PLOT 1
    for (i in seq_len(length(Col.Sites))){##FOR.j.START
      # subset out NA
      data.i <- data.plot[,Col.Sites[i]]
      # different first iteration
      if (i==1) {##IF.j==1,START
        # need ylim
        myYlim.max <- 0
        for (ii in seq_len(length(Col.Sites))) {
          myYlim.max <- max(graphics::hist(data.plot[,Col.Sites[ii]],plot=FALSE)$density, myYlim.max)
        }
        myYlim <- c(0,myYlim.max)
        #
        graphics::hist(data.plot[,Col.Sites[i]], prob=TRUE, border="white"
             ,main=myMain, xlab=ParamName.xlab, ylab="Proportion = value"
             ,ylim=myYlim)
        graphics::box()
      }##IF.j==1.END
      # plot lines
      graphics::lines(stats::density(data.i, na.rm=TRUE), col=myColors[i], lwd=2)
    }##FOR.j.END
    graphics::legend("topright",Col.Sites,fill=myColors)
    #
    # Plot 2
    myLWD <- 1.5
    for (j in seq_len(length(Col.Sites))){##FOR.i.START
      if(j==1){##IF.i==1.START
        plot(stats::ecdf(data.plot[,Col.Sites[j]]), col=myColors[j], verticals=TRUE, lwd=myLWD, do.p=FALSE #pch=19, cex=.75 #do.p=FALSE
             #, col.01line="white"
             , main=myMain, xlab=ParamName.xlab, ylab="Proportion <= value" )
      } else {
        plot(stats::ecdf(data.plot[,Col.Sites[j]]), col=myColors[j], verticals=TRUE, lwd=myLWD, do.p=FALSE, add=T)
      }##IF.i==1.END
    }##FOR.i.END
    graphics::legend("bottomright",Col.Sites,fill=myColors)
  }##FUNCTION.CreatePlots.END
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  {
  # File.Out
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  strFile <- "CompSiteCDF_"
  strFile.Out <- paste(paste("CompSiteCDF",myDate,myTime,sep=ContData.env$myDelim),"pdf",sep=".")
  #
  # Plot and Save to PDF
  grDevices::pdf(file=strFile.Out, width=7, height=10)##PDF.START
    # 2 plots per page
    graphics::par(mfrow=c(2,1))
    #
    # ALL
    myMain <- "All Data"
    data.plot <- data.import
    CreatePlots()
    #
    # Subset by Year
    myYears <- sort(unique(data.import[,ContData.env$myName.Yr]))
    for (a in myYears){##FOR.a.START}
      myMain <- paste0("Year, ",a)
      data.plot <- data.import[data.import[,ContData.env$myName.Yr]==a,]
      CreatePlots()
    }##FOR.a.END
    #
    # Subset by Season
    mySeasons <- SeasonNames[SeasonNames %in% unique(data.import[,ContData.env$myName.Season])]
    for (b in mySeasons){##FOR.a.START}
      myMain <- paste0("Season, ",b)
      data.plot <- data.import[data.import[,ContData.env$myName.Season]==b,]
      CreatePlots()
    }##FOR.a.END
    #
    # Subset by SeasonYear
    YearSeasonsAll <- paste0(myYears, mySeasons)
    myYearSeasons <- YearSeasonsAll[YearSeasonsAll %in% unique(data.import[,ContData.env$myName.YrSeason])]
    for (c in myYearSeasons){##FOR.a.START}
      myMain <- paste0("Year Season, ",c)
      data.plot <- data.import[data.import[,ContData.env$myName.YrSeason]==c,]
      CreatePlots()
    }##FOR.a.END
    #
  grDevices::dev.off() ##PDF.END
  }
  #~~~~~~~~~~~~~~~~
  # Junk Code
  # #Plot Proportion equal to each value.
  # # Round to single digit first
  # x <- round(data.import$Browns,1)
  # y <- as.data.frame(table(x))
  #
  # z <- sum(y$Freq)
  # y$Freq <- y$Freq/z
  # y$x <- as.numeric(y$x)  # works for plot but converts to rowID
  #
  #
  # plot(y, type="l")
  #
  #
  # AA <- data.import$Browns[!is.na(data.import$Browns)]
  #
  # hist(AA, prob=TRUE)
  # lines(stats::density(AA), col="blue", lwd=2)
  # box()
  #~~~~~~~~~~~~~~~~
  #
  # Inform user that task is done
  cat(paste0("PDF created; ",strFile.Out))
  utils::flush.console()
  #
} #end of function; ##FUNCTION.CompSiteCDF.END
