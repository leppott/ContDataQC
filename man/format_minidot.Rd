% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formatminiDOT.R
\name{format_minidot}
\alias{format_minidot}
\title{Format miniDOT concatenate (cat) output}
\usage{
format_minidot(
  fun.myFile = NULL,
  fun.myDir.import = getwd(),
  fun.myDir.export = getwd(),
  fun.myConfig = NULL
)
}
\arguments{
\item{fun.myFile}{Single file (or vector of files) to perform functions.}

\item{fun.myDir.import}{Directory for import data.
Default is current working directory.}

\item{fun.myDir.export}{Directory for export data.
Default is current working directory.}

\item{fun.myConfig}{Configuration file to use for this data analysis.
The default is always loaded first so only "new" values need to be included.
This is the easiest way to control time zones.}
}
\value{
No data frames are returned.  A CSV file ready for use with the
ContDataQC QC function will be generated in the specified output directory.
}
\description{
Format miniDOT concatenate (cat) output for use with
`ContDataQC` package.   Works on single files.  Imports, modifies, and saves
the new file.  Data columns with all NA values are removed.
}
\details{
1. Imports a miniDOT cat output file from a folder.
Can also use ContDataQC::minidot_cat function.

2. Reformats it using defaults from the ContDataQC config file.

3. As a QC step to prevent issues with ContDataQC function any columns that
are all NA will be removed.

4. Exports a CSV to the provided folder for use with ContDataQC.

Below are the default data directories assumed to exist in the working
directory.  These can be created with code in the example.  Using this
function as an example, files will be imported from Data0_Original and
exported to Data1_RAW.

* ./Data0_Original/ = Unmodified data logger files.

* ./Data1_RAW/ = Data logger files modified for use with library.
Modifications for extra rows and file and column names.
}
\examples{
# Create Folders
myDir.BASE <- tempdir()
myDir.create <- file.path(myDir.BASE, "Data0_Original")
  ifelse(dir.exists(myDir.create) == FALSE
         , dir.create(myDir.create)
         , "Directory already exists")
myDir.create <- file.path(myDir.BASE, "Data1_RAW")
  ifelse(dir.exists(myDir.create) == FALSE
         , dir.create(myDir.create)
         , "Directory already exists")
myDir.create <- file.path(myDir.BASE, "Data2_QC")
  ifelse(dir.exists(myDir.create) == FALSE
         , dir.create(myDir.create)
         , "Directory already exists")

# Data
dn_input <- file.path(system.file("extdata", package = "ContDataQC")
                      , "minidot")
dn_export <- file.path(myDir.BASE, "Data0_Original")
filename <- "test_minidot.csv"

# Create miniDOT concatenate file
minidot_cat(folderpath = dn_input
            , savetofolder = dn_export)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# FORMAT
myFiles <- "7392-354869.csv"
myDir.BASE <- tempdir()
myDir.import <- file.path(myDir.BASE, "Data0_Original")
myDir.export <- file.path(myDir.BASE, "Data1_RAW")

# Run Function (with default config)
format_minidot(myFiles, myDir.import, myDir.export)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# QC newly created file
myData.Operation <- "QCRaw"
myFile <- "7392-354869.csv"
myDir.BASE <- tempdir()
myDir.import <- file.path(myDir.BASE, "Data1_RAW")
myDir.export <- file.path(myDir.BASE, "Data2_QC")
myReport.format <- "docx"
ContDataQC(myData.Operation
           , fun.myDir.import = myDir.import
           , fun.myDir.export = myDir.export
           , fun.myFile = myFile
           , fun.myReport.format = myReport.format)

}
