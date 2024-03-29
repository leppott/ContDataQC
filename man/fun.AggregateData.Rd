% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zfun.AggregateData.R
\name{fun.AggregateData}
\alias{fun.AggregateData}
\title{Aggregate Data Files}
\usage{
fun.AggregateData(
  fun.myData.SiteID,
  fun.myData.Type,
  fun.myData.DateRange.Start,
  fun.myData.DateRange.End,
  fun.myDir.import = getwd(),
  fun.myDir.export = getwd(),
  fun.myReport.format,
  fun.myReport.Dir,
  fun.CreateReport = TRUE
)
}
\arguments{
\item{fun.myData.SiteID}{Station/SiteID.}

\item{fun.myData.Type}{data type;
c("Air","Water","AW","Gage","AWG","AG","WG")}

\item{fun.myData.DateRange.Start}{Start date for requested data.
Format = YYYY-MM-DD.}

\item{fun.myData.DateRange.End}{End date for requested data.
Format = YYYY-MM-DD.}

\item{fun.myDir.import}{Directory for import data.
Default is current working directory.}

\item{fun.myDir.export}{Directory for export data.
Default is current working directory.}

\item{fun.myReport.format}{Report format (docx or html).
Default is specified in config.R (docx).  Can be customized in config.R;
ContData.env$myReport.Format.}

\item{fun.myReport.Dir}{Report (rmd) template folder.
Default is the package rmd folder.  Can be customized in config.R;
ContData.env$myReport.Dir.}

\item{fun.CreateReport}{Boolean parameter to create reports or not.
Default = TRUE.}
}
\value{
Returns a csv into the specified export directory with additional
columns for calculated statistics.
}
\description{
Subfunction for aggregating or splitting data files.  Needs to be called from
ContDataQC().  Combines or splits files based on given data range.  Saves a
new CSV in the export directory.
}
\examples{
#Not intended to be accessed indepedant of function ContDataQC().
}
