% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun.QC.File.R
\name{fun.QC.File}
\alias{fun.QC.File}
\title{Quality Control, File}
\usage{
fun.QC.File(
  fun.myFile,
  fun.myDir.import = getwd(),
  fun.myDir.export = getwd(),
  fun.myReport.format,
  fun.myReport.Dir,
  fun.CreateReport = TRUE,
  fun.AddDeployCol = FALSE
)
}
\arguments{
\item{fun.myFile}{Single (or vector of) file name(s).}

\item{fun.myDir.import}{Directory for import data.
Default is current working directory.}

\item{fun.myDir.export}{Directory for export data.
Default is current working directory.}

\item{fun.myReport.format}{Report format (docx or html).
Default is specified in config.R (docx).Can be customized in config.R;
ContData.env$myReport.Format.}

\item{fun.myReport.Dir}{Report (rmd) template folder.
Default is the package rmd folder.  Can be customized in config.R;
ContData.env$myReport.Dir.}

\item{fun.CreateReport}{Boolean parameter to create reports or not.
Default = TRUE.}

\item{fun.AddDeployCol}{Boolean for adding column name.  Default = FALSE.
Can be customized in config.R; ContData.env$myName.LoggerDeployment.}
}
\value{
Returns a csv file to specified directory with QC flags.
}
\description{
Subfunction for performing QC.  Needs to be called from ContDataQC().
Requires zoo().
The 'file' version works on a single (or vector) of files.
}
\examples{
#Not intended to be accessed indepedant of function ContDataQC().
myFile <- "test2_AW_20130426_20130725.csv"
#myFile <- c("test2_AW_20130426_20130725.csv"
#             , "test2_AW_20130725_20131015.csv"
#             , "test2_AW_20140901_20140930.csv")
myDir.import <- file.path(getwd(),"Data1_RAW")
myDir.export <- file.path(getwd(),"Data2_QC")
fun.QC.File(myFile, myDir.import, myDir.export)
}
