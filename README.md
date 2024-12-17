README-ContDataQC
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

    #> Last Update: 2024-12-16 16:29:26.375795

# ContDataQC

Quality control checks on continuous data. Example data is from a HOBO
data logger with 30 minute intervals.

# R Shiny application (web-version):

<https://shiny.epa.gov/ContDataQC>

# Badges

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/USEPA/ContDataQC/graphs/commit-activity)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)

[![CodeFactor](https://www.codefactor.io/repository/github/leppott/ContDataQC/badge)](https://www.codefactor.io/repository/github/leppott/ContDataQC)
[![codecov](https://codecov.io/gh/USEPA/ContDataQC/branch/master/graph/badge.svg)](https://codecov.io/gh/USEPA/ContDataQC)
[![R-CMD-check](https://github.com/leppott/ContDataQC/workflows/R-CMD-check/badge.svg)](https://github.com/leppott/ContDataQC/actions)

[![GitHub
issues](https://img.shields.io/github/issues/USEPA/ContDataQC.svg)](https://GitHub.com/USEPA/ContDataQC/issues/)

[![GitHub
release](https://img.shields.io/github/release/USEPA/ContDataQC.svg)](https://GitHub.com/USEPA/ContDataQC/releases/)
[![Github all
releases](https://img.shields.io/github/downloads/USEPA/ContDataQC/total.svg)](https://GitHub.com/USEPA/ContDataQC/releases/)

# Installation

To install the current version of the code from GitHub use the example
below.

``` r
if(!require(remotes)){install.packages("remotes")}  #install if needed
remotes::install_github("USEPA/ContDataQC")
```

The vignette (big help file) isn’t created when installing from GitHub
with the above command. If you want the vignette, download the
compressed file from GitHub and install from that file or install with
the command below. The “force = TRUE” command is used to ensure the
package will install over and existing install of the same version
(e.g., the same version without the vignettes).

``` r
if(!require(remotes)){install.packages("remotes")}  #install if needed
remotes::install_github("USEPA/ContDataQC", force = TRUE, build_vignettes = TRUE)
```

If dependent libraries do not install you can install them separately.
This happens occasionally. Without all of the packages the main package
and/or the vignettes will not install properly. Install the separate
packages below and then retry installing ContDataQC.

``` r
# libraries to be installed
pkg <- c("remotes"        # install helper for non CRAN libraries
        , "installr"       # install helper
        , "digest"         # caused error in R v3.2.3 without it
        , "dataRetrieval"  # loads USGS data into R
        , "knitr"          # create documents in other formats (e.g., PDF or Word)
        , "doBy"           # summary stats
        , "zoo"            # z's ordered observations, use for rolling sd calc
        , "htmltools"      # needed for knitr and doesn't always install properly with Pandoc
        , "rmarkdown"      # needed for knitr and doesn't always install properly with Pandoc
        , "htmltools"      # a dependency that is sometimes missed.
        , "evaluate"       # a dependency that is sometimes missed.
        , "highr"          # a dependency that is sometimes missed.
        , "rmarkdown"      # a dependency that is sometimes missed.
        , "ggplot2"        # plots
        , "installr"       # used to install Pandoc
        , "rsconnect"
        , "rLakeAnalyzer"
        , "shiny"          # shiny example
        , "survival"
        , "shinyFiles"     # more Shiny
        , "shinyThemes"    # more Shiny
        , "XLConnect"      # read Excel files
        , "zip"            # read/save zip files
        )
#
lapply(pkg, function(x) install.packages(x))
```

Non-CRAN packages have to be installed separately from GitHub using
remotes.

``` r
if(!require(remotes)){install.packages("remotes")}  #install if needed
# non-CRAN packages
remotes::install_github("jasonelaw/iha", force = TRUE, build_vignettes = TRUE)
remotes::install_github("tsangyp/StreamThermal", force = TRUE, build_vignettes = TRUE)
```

Additionally Pandoc is required for creating the reports and needs to be
installed separately. If you have RStudio installed it comes with Pandoc
and you don’t need to install Pandoc separately.

``` r
## pandoc
if(!require(installr)){install.packages("installr")}  #install if needed
installr::install.pandoc()
```

# Purpose

Built for a project for USEPA for Regional Monitoring Networks (RMN).

Takes as input continuous data from data loggers and QCs it by checking
for gross differences, spikes, rate of change differences, flat line
(consecutive same values), and data gaps. The `ContDataQC` package
provides a organized workflow to QC, aggregate, partition, and generate
summary stats.

The code was presented at the following workshops. And further developed
under contract to USEPA.

- Oct 2015, SWPBA (Region 4 regional biologist meeting, Myrtle Beach,
  SC).

- Mar 2016, AMAAB (Region 3 regional biologist meeting, Cacapon, WV).

- Apr 2016, NWQMC (National Water Monitoring Council Conference, Tampa,
  FL).

Functions were developed to help data generators handle data from
continuous data sensors (e.g., HOBO data loggers).

From a single function, ContDataQC(), can QC, aggregate, or calculate
summary stats on data. `ContDataQC` Uses the USGS `dataRetrieval`
library to get USGS gage data. Reports are generated in Word (through
the use of knitr and Pandoc).

# Usage

Every time R is launched the `ContDataQC` package needs to be loaded.

``` r
# load library and dependant libraries
require("ContDataQC")
```

The default working directory is based on how R was installed but is
typically the user’s ‘MyDocuments’ folder. You can change it through the
menu bar in R (File - Change dir) or RStudio (Session - Set Working
Directory). You can also change it from the command line.

``` r
# if specify directory use "/" not "\" (as used in Windows) and leave off final "/" (example below).
#myDir.BASE  <- "C:/Users/Erik.Leppo/Documents/NCEA_DataInfrastructure/Erik"
myDir.BASE <- getwd()
setwd(myDir.BASE)
```

# Help

Every function has a help file with a working example. There is also a
vignette with descriptions and examples of all functions in the
`ContDataQC` library.

``` r
# To get help on a function
# library(ContDataQC) # the library must be loaded before accessing help
?ContDataQC
```

To see all available functions in the package use the command below.

``` r
# To get index of help on all functions
# library(ContDataQC) # the library must be loaded before accessing help
help(package="ContDataQC")
```

The vignette file is located in the “doc” directory of the library in
the R install folder. Below is the path to the file on my PC. But it is
much easier to use the code below to call the vignette by name. There is
also a link to the vignette at the top of the help index for the
package.

“C:\Programs\R\R-3.4.2\library\ContDataQC\doc\ContDataQC_Vignette.html”

``` r
vignette("ContDataQC_Vignette", package="ContDataQC")
```

If the vignette fails to show on your computer. Run the code below to
reinstall the package and specify the creation of the vignette. As noted
above if dependent packages are not installed the vignette will fail to
build. See above for installing packages.

``` r
library(remotes)
install_github("USEPA/ContDataQC", force=TRUE, build_vignettes=TRUE)
```

If the vignettes still do not show on your computer, there are pre-loaded html copies 
of the vignettes located in the following GitHub folder:

https://github.com/USEPA/ContDataQC/tree/main/inst/_vignettes

Or, in the following general path after downloading the package:

"~ContDataQC\inst\\_vignettes"

## Guide Videos

Guide videos were created for the ContDataQC package and posted on
YouTube.  
The Powerpoint slides (pptx), R code notebooks (html), and videos are
hosted on a companion GitHub site.

<https://github.com/leppott/ContDataQC_Guide>

YouTube video links below.

- Introduction
  - <https://youtu.be/FJAv7g9GPHI>
- Config
  - <https://youtu.be/qbUgPczdfdo>
- Basic Functions
  - <https://youtu.be/zlq1YDPTBsw>
- Gage Data
  - <https://youtu.be/vXyvp9r2tv4>
- Config File Modifications
  - <https://youtu.be/LCHnFs-AdXc>
