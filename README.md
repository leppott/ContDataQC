README-ContDataQC
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
    #> Last Update: 2017-03-08 08:33:56

ContDataQC
==========

Quality control checks on continuous data. Example data is from a HOBO data logger with 30 minute intervals.

Installation
------------

'\# Installing just this library (should get all dependancies) library(devtools) install.git\_hub("leppott/ContDataQC")

'\# Installing dependancies separately '\# set CRAN mirror '\#(loads gui in R; in R-Studio select \#\# of mirror in Console pane) '\# If know mirror can use "ind=" in 2nd statement and comment out (prefix line with \#) the first. chooseCRANmirror() '\#chooseCRANmirror(ind=21) '\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\# '\# must run "chooseCRANmirror()" by itself before running the rest of the script

'\# libraries to be installed data.packages = c(
"devtools" \# install helper for non CRAN libraries ,"installr" \# install helper ,"digest" \# caused error in R v3.2.3 without it ,"dataRetrieval" \# loads USGS data into R ,"knitr" \# create documents in other formats (e.g., PDF or Word) ,"doBy" \# summary stats ,"zoo" \# z's ordered observations, use for rolling sd calc ,"htmltools" \# needed for knitr and doesn't always install properly with Pandoc ,"rmarkdown" \# needed for knitr and doesn't always install properly with Pandoc ,"htmltools" \# a dependency that is sometimes missed. ,"evaluate" \# a dependency that is sometimes missed. ,"highr" \# a dependency that is sometimes missed. ,"rmarkdown" \# a dependency that is sometimes missed. '\# ,"reshape" \# list to matrix '\# ,"lattice" \# plotting '\# ,"waterData" \# QC of hydro time series data '\# ,"summaryBy" \# used in summary stats )

lapply(data.packages,function(x) install.packages(x))

'\#\# pandoc require(installr) install.pandoc()

Purpose
-------

Built for a project for USEPA for Regional Monitoring Networks (RMN).

Takes continuous data from data loggers and QCs it by checking for gross differences, spikes, rate of change differences, flat line (consecutive same values), and data gaps.

Scripts provide a organized workflow to QC, aggregate, partition, and generate summary stats.

This gitrepository is a work in progress and should be considered draft.

The code was presented at the following workshops. Oct 2015, SWPBPA (Region 4 regional biologist meeting, Myrtle Beach, SC) Mar 2016, AMAAB (Region 3 regional biologist meeting, Cacapon, WV) Apr 2016, NWQMC (National Water Monitoring Council Conference, Tampa, FL).

Functions developed to help data generators handle data from continuous data sensors (e.g., HOBO data loggers).

From a single function, ContDataQC(), can QC, aggregate, or calculate summary stats on data. Uses the USGS dataRetrieval library to get USGS gage data. Reports are generated in Word (through the use of knitr and Pandoc).

Usage
-----

'\# load library and dependant libraries require("ContDataQC")

Define working Directory '\# if specify directory use "/" not "" (as used in Windows) and leave off final "/" (example below). '\#myDir.BASE &lt;- "C:/Users/Erik.Leppo/Documents/NCEA\_DataInfrastructure/Erik" myDir.BASE &lt;- getwd() setwd(myDir.BASE) '\# library (load any required helper functions) '\#source(paste(myDir.BASE,"Scripts","fun.Master.R",sep="/")) '\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\# '\# USER input in this section (see end of script for explanations) '\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\# '\# '\# PROMPT; Operation Selection.Operation &lt;- c("GetGageData","QCRaw", "Aggregate", "SummaryStats") myData.Operation &lt;- Selection.Operation\[3\] \#number corresponds to intended operation in the line above '\# '\# PROMPT; Site ID '\# single site; "ECO66G12" '\# group of sites; c("test2", "HRCC", "PBCC", "ECO66G12", "ECO66G20", "ECO68C20", "01187300") myData.SiteID &lt;- "ECO71F19" '\# '\# PROMPT; Data Type '\# Type of data file Selection.Type &lt;- c("Air","Water","AW","Gage","AWG","AG","WG") \# only one at a time myData.Type &lt;- Selection.Type\[3\] \#number corresponds to intended operation in the line above '\# '\# PROMPT; Start Date '\# YYYY-MM-DD ("-" delimiter), leave blank for all data ("1900-01-01") myData.DateRange.Start &lt;- "2013-01-01" '\# '\# PROMPT; End Date '\# YYYY-MM-DD ("-" delimiter), leave blank for all data (today) myData.DateRange.End &lt;- "2014-12-31" '\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\# '\# PROMPT; SubDirectory, input file location. Leave blank for defaults Selection.SUB &lt;- c("Data1\_RAW","Data2\_QC","Data3\_Aggregated","Data4\_Stats") myDir.SUB.import &lt;- "" \#Selection.SUB\[2\] '\# '\# PROMPT; SubDirectory, output file location. Leave blank for default. myDir.SUB.export &lt;- "" \#Selection.SUB\[3\] '\# '\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\# '\# Run the script with the above user defined values ContDataQC(myData.Operation ,myData.SiteID ,myData.Type ,myData.DateRange.Start ,myData.DateRange.End ,myDir.BASE ,myDir.SUB.import ,myDir.SUB.export)
