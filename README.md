README-ContDataQC
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

    #> Last Update: 2018-01-17 14:04:06

# ContDataQC

Quality control checks on continuous data. Example data is from a HOBO
data logger with 30 minute intervals.

## Installation

``` r
# Installing just this library (should get all dependancies)
library(devtools) 
install_github("leppott/ContDataQC")
```

If dependant libraries do not load you can install them separately.

``` r
# Choose a CRAN mirror (dowload site) first (can change number)
chooseCRANmirror(ind=21) 
# libraries to be installed
data.packages = c(                  
                  "devtools"        # install helper for non CRAN libraries
                  ,"installr"       # install helper
                  ,"digest"         # caused error in R v3.2.3 without it
                  ,"dataRetrieval"  # loads USGS data into R
                  ,"knitr"          # create documents in other formats (e.g., PDF or Word)
                  ,"doBy"           # summary stats
                  ,"zoo"            # z's ordered observations, use for rolling sd calc
                  ,"htmltools"      # needed for knitr and doesn't always install properly with Pandoc
                  ,"rmarkdown"      # needed for knitr and doesn't always install properly with Pandoc
                  ,"htmltools"      # a dependency that is sometimes missed.
                  ,"evaluate"       # a dependency that is sometimes missed.
                  ,"highr"          # a dependency that is sometimes missed.
                  ,"rmarkdown"      # a dependency that is sometimes missed.
                  )
                  
lapply(data.packages,function(x) install.packages(x))
```

Additionally Pandoc is required for creating the reports and needs to be
installed separately.

``` r
## pandoc
require(installr)
install.pandoc()
```

## Purpose

Built for a project for USEPA for Regional Monitoring Networks (RMN).

Takes as input continuous data from data loggers and QCs it by checking
for gross differences, spikes, rate of change differences, flat line
(consecutive same values), and data gaps. The `ContDataQC` package
provides a organized workflow to QC, aggregate, partition, and generate
summary stats.

The code was presented at the following workshops. And further developed
under contract to USEPA.

  - Oct 2015, SWPBPA (Region 4 regional biologist meeting, Myrtle Beach,
    SC).

  - Mar 2016, AMAAB (Region 3 regional biologist meeting, Cacapon, WV).

  - Apr 2016, NWQMC (National Water Monitoring Council Conference,
    Tampa, FL).

Functions were developed to help data generators handle data from
continuous data sensors (e.g., HOBO data loggers).

From a single function, ContDataQC(), can QC, aggregate, or calculate
summary stats on data. `ContDataQC` Uses the USGS `dataRetrieval`
library to get USGS gage data. Reports are generated in Word (through
the use of knitr and Pandoc).

## Usage

Everytime R is launched the `ContDataQC` package needs to be loaded.

``` r
# load library and dependant libraries
require("ContDataQC")
```

The default working directory is based on how R was installed but is
typically the user’s ‘MyDocuments’ folder. You can change it through the
menu bar in R (File - Change dir) or RStudio (Session - Set Working
Directory). You can also change it from the command
line.

``` r
# if specify directory use "/" not "\" (as used in Windows) and leave off final "/" (example below).
#myDir.BASE  <- "C:/Users/Erik.Leppo/Documents/NCEA_DataInfrastructure/Erik"
myDir.BASE <- getwd()
setwd(myDir.BASE)
```

## Help

Every function has a help file with a working example. There is also a
vignette with descriptions and examples of all functions in the
`ContDataQC` library.

``` r
# To get help on a function
# library(ContDataQC) # the library must be loaded before accessing help
?ContDataQC
```

The vignette file is located in the “doc” directory of the library in
the R install folder. Below is the path to the file on my PC.

“C:-3.4.2\_Vignette.html"

``` r
vignette("ContDataQC_Vignette",package="ContDataQC")
```

If the vignette fails to load. Run the code below.

``` r
library(devtools)
install_github("leppott/ContDataQC", force=TRUE, build_vignettes=TRUE)
```
