#' CompSiteCDF, compare CDFs of sites
#'
#' Takes as an input a data frame with date and up to 5 columns of parameter data.
#' Column names are SiteIDs and values are daily means for some measurement.
#'
#' CDFs are generate for year, season, and year/season and saved to a PDF
#'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170921
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param df.input Input data as CSV.  Needs 6 columns (SampleID and up to 5 SiteIDs).
#' @param dir.input Directory where data file is located.
#' @param dir.output Directory where PDF file is to be saved.
#' @param ParamName.xlab Parameter name for x-axis on plots
#' @return Returns a PDF of CDFs.
#' @keywords continuous data, CDF, site comparison
#' @examples
#' # load bio data
#' df.data <- data_CompSiteCDF
#' dim(df.data)
#' View(df.data)
#'
#' # subsample
#' mySize <- 200
#' Seed.MS <- 18171210
#' bugs.mysize <- rarify(inbug=DF.biodata, sample.ID="SampRep",abund="Count",subsiz=mySize, mySeed=Seed.MS)
#' dim(bugs.mysize)
#' View(bugs.mysize)
#' # save the data
#' write.table(bugs.mysize,paste("bugs",mySize,"txt",sep="."),sep="\t")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
CompSiteCDF <- function(df.input, dir.input, dir.output, ParamName.xlab){##FUNCTION.rarify.START

  # add year, month, season
  # assume Date is POSIXct



  #for testing load ContData.env
  source(file.path(getwd(),"R","config.R"))

  ParamName.xlab <- ContData.env$myLab.WaterTemp


  #df.data <- data_CompSiteCDF
  wd <- getwd()
  myFile <- "CDF_WaterTemp_2014_MA.csv"
  data.import <- read.csv(file.path(wd,"data-raw",myFile))


  # Site Names (Columns)
  Col.Sites <- names(data.import)[!(names(data.import) %in% ContData.env$myName.Date)]


  # # Add columns
  # myName.Yr       <- "Year"
  # myName.Mo       <- "Month"
  # myName.Season   <- "Season"
  # myName.YrSeason <- "YearSeason"



  # add time period fields
  data.import[,ContData.env$myName.Yr]   <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%Y")
  data.import[,ContData.env$myName.Mo]   <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%m")
  data.import[,ContData.env$myName.YrMo] <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%Y%m")
  data.import[,ContData.env$myName.MoDa] <- format(as.Date(data.import[,ContData.env$myName.Date]),format="%m%d")
  # data.import[,ContData.env$myName.JuDa] <- as.POSIXlt(data.import[,ContData.env$myName.Date], format=ContData.env$myFormat.Date)$yday +1
  # ## add Season fields
  data.import[,ContData.env$myName.Season] <- NA
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric("0101") & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Spring.Start)] <- "Winter"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Spring.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Summer.Start)] <- "Spring"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Summer.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Fall.Start)] <- "Summer"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Fall.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<as.numeric(ContData.env$myTimeFrame.Season.Winter.Start)] <- "Fall"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[,ContData.env$myName.MoDa])>=as.numeric(ContData.env$myTimeFrame.Season.Winter.Start) & as.numeric(data.import[,ContData.env$myName.MoDa])<=as.numeric("1231")] <- "Winter"
  data.import[,ContData.env$myName.YrSeason] <- paste(data.import[,ContData.env$myName.Yr],data.import[,ContData.env$myName.Season],sep="")
  #
  View(data.import)


  # calc CDF
  x <- ecdf(data.import[,Col.Sites[1]])
  plot(x, col="blue")

  # plot
  i=1

  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  strFile <- "CompSiteCDF_"
  strFile.Out <- paste(paste("CompSiteCDF",myDate,myTime,sep=ContData.env$myDelim),"pdf",sep=".")

  # Color Blind Palatte
 # http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/
  # The palette with grey:
  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

  # The palette with black:
  cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


  #~~~~~~~~~~~~~~~~~~~
  {
  myDate <- format(Sys.Date(),"%Y%m%d")
  myTime <- format(Sys.time(),"%H%M%S")
  strFile <- "CompSiteCDF_"
  strFile.Out <- paste(paste("CompSiteCDF",myDate,myTime,sep=ContData.env$myDelim),"pdf",sep=".")
  #
  pdf(file=strFile.Out, width=7, height=10)##PDF.START
    par(mfrow=c(2,1))

    myColors <- cbPalette #rainbow(length(Col.Sites))

    # PLOT 1
    for (j in 1:length(Col.Sites)){##FOR.j.START
      # subset out NA
      data.j <- data.import[,Col.Sites[j]]
      # different first iteration
      if (j==1) {##IF.j==1,START
        hist(data.import[,Col.Sites[j]], prob=TRUE, border="white"
             ,main="All Data", xlab=ParamName.xlab, ylab="Proportion = value")
        box()
      }##IF.j==1.END
      # plot lines
      lines(density(data.j, na.rm=TRUE), col=myColors[j], lwd=2)
    }##FOR.j.END
    legend("topright",Col.Sites,fill=myColors)


    # Plot 2
    myLWD <- 1.5
    for (i in 1:length(Col.Sites)){##FOR.i.START
      #myColors <- cbPalette #rainbow(length(Col.Sites))
      if(i==1){##IF.i==1.START
        plot(ecdf(data.import[,Col.Sites[i]]), col=myColors[i], verticals=TRUE, lwd=myLWD, do.p=FALSE #pch=19, cex=.75 #do.p=FALSE
             #, col.01line="white"
             , main="All Data", xlab=ParamName.xlab, ylab="Proportion <= value" )
      } else {
        plot(ecdf(data.import[,Col.Sites[i]]), col=myColors[i], verticals=TRUE, lwd=myLWD, do.p=FALSE, add=T)
      }##IF.i==1.END
    }##FOR.i.END
    legend("bottomright",Col.Sites,fill=myColors)


  dev.off() ##PDF.END
  }
  #~~~~~~~~~~~~~~~~~~~


  #Plot Proportion equal to each value.
  # Round to single digit first
  x <- round(data.import$Browns,1)
  y <- as.data.frame(table(x))

  z <- sum(y$Freq)
  y$Freq <- y$Freq/z
  y$x <- as.numeric(y$x)  # works for plot but converts to rowID


  plot(y, type="l")


  AA <- data.import$Browns[!is.na(data.import$Browns)]

  hist(AA, prob=TRUE)
  lines(density(AA), col="blue", lwd=2)
  box()


  cat(paste0("PDF created; ",strFile.Out))
  flush.console()


} #end of function; ##FUNCTION.rarify.END
