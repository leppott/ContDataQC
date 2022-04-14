#' CompSiteCDF.updated, compare CDFs of sites
#' this R function is adopted from "CompSiteCDF"
#' from https://github.com/leppott/ContDataQC/blob/main/R/CompSiteCDF.R
#' @keywords internal
#' @examples
#' CompSiteCDF.updated(ParamName.xlab = myXlab, df.input=myDF)
#'
#' @export
CompSiteCDF.updated <- function(file.input = NULL
                        , dir.input = getwd()
                        , dir.output = getwd()
                        , ParamName.xlab = " "
                        , Plot.title = " "
                        , Plot.type = "Density"
                        , Plot.season = "Summer"
                        , hist.columnName = NULL
                        , df.input = NULL){##FUNCTION.CompSiteCDF.START

  # load data (data.frame or from CSV)
  # if no data frame then import file.
  if (!is.null(df.input)) {##IF.START
    data.import <- df.input
  } else {
    data.import <- utils::read.csv(file.path(dir.input, file.input))
  }##IF.END
  #
  # Site Names (Columns) before adding seasonal columns including the "Date" column
  #Col.Sites <- names(data.import)[!(names(data.import) %in% ContData.env$myName.Date)]
  Col.Sites <- names(data.import)


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
      , ContData.env$myName.MoDa])<
      as.numeric(ContData.env$myTimeFrame.Season.Spring.Start)] <- "Winter"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >=
      as.numeric(ContData.env$myTimeFrame.Season.Spring.Start) &
      as.numeric(data.import[,ContData.env$myName.MoDa])<
      as.numeric(ContData.env$myTimeFrame.Season.Summer.Start)] <- "Spring"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >=
      as.numeric(ContData.env$myTimeFrame.Season.Summer.Start) &
      as.numeric(data.import[,ContData.env$myName.MoDa])<
      as.numeric(ContData.env$myTimeFrame.Season.Fall.Start)] <- "Summer"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >=
      as.numeric(ContData.env$myTimeFrame.Season.Fall.Start) &
      as.numeric(data.import[,ContData.env$myName.MoDa])<
      as.numeric(ContData.env$myTimeFrame.Season.Winter.Start)] <- "Fall"
  data.import[,ContData.env$myName.Season][as.numeric(data.import[
    , ContData.env$myName.MoDa]) >=
      as.numeric(ContData.env$myTimeFrame.Season.Winter.Start) &
      as.numeric(data.import[,ContData.env$myName.MoDa])<=
      as.numeric("1231")] <- "Winter"
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

  # Season Names
  SeasonNames <- c("Fall", "Winter", "Spring","Summer")
  if (!is.null(Plot.season)){
    data.import <- data.import[data.import[,ContData.env$myName.Season]==Plot.season,]
  }

  data.plot <- data.import[colnames(data.import) %in% Col.Sites]

  ## revised the plot to a ggplot

  data.plot <- reshape2::melt(data.plot,"Date")
  print(colnames(data.plot))

  if (Plot.type=="Density") {
  my_plot <- ggplot(data=data.plot,aes(x=value,y=stat(density),colour=variable))+
       geom_line(stat="density")+
       geom_histogram(data=data.import[colnames(data.import) %in% hist.columnName],aes(x=!!sym(hist.columnName),y=stat(count)/sum(stat(count))),color="black",fill="white",binwidth=1)+
       #geom_density(data=data.plot,aes(x=value,colour=variable),size=1)+
       labs(x=ParamName.xlab,y="Proportion = value")+
       theme(text=element_text(size=14,face = "bold", color="blue"),
             plot.title = element_text(hjust=0.5),
             legend.position = "right",
             legend.title=element_blank(),
             panel.grid.major.y=element_blank())+
      scale_color_viridis_d(option="D")+
       ggtitle(Plot.title)
  }else if (Plot.type=="CDF") {
  my_plot <- ggplot(data=data.plot,aes(x=value,colour=variable))+
        stat_ecdf(geom="step",alpha=0.6,pad=TRUE)+
        labs(x=ParamName.xlab,y="Proportion <= value")+
        theme(text=element_text(size=14,face = "bold", color="blue"),
              plot.title = element_text(hjust=0.5),
              legend.position = "right",
              legend.title=element_blank(),
              panel.grid.major.y=element_blank())+
    scale_color_viridis_d(option="D")+
    ggtitle(Plot.title)
  }

 return(my_plot);

}
