# ContDataQC
Quality control checks on continuous data.  Example data is from a HOBO data logger with 30 minute intervals.

Installation
-----------------
library(devtools) 
install.git_hub("leppott/ContDataQC")

Purpose
--------------
Built for a project for USEPA for Regional Monitoring Networks (RMN).

Takes continuous data from data loggers and QCs it by checking for gross differences, spikes, rate of change differences, flat line (consecutive same values), and data gaps.

Scripts provide a organized workflow to QC, aggregate, partition, and generate summary stats.

This gitrepository is a work in progress and should be considered draft.

The code was presented at the following workshops. Oct 2015, SWPBPA (Region 4 regional biologist meeting, Myrtle Beach, SC) Mar 2016, AMAAB (Region 3 regional biologist meeting, Cacapon, WV) Apr 2016, NWQMC (National Water Monitoring Council Conference, Tampa, FL).

Functions developed to help data generators handle data from continuous data sensors (e.g., HOBO data loggers).

From a single function, ContDataQC(), can QC, aggregate, or calculate summary stats on data.  Uses the USGS dataRetrieval library to get USGS gage data.  Reports are generated in Word (through the use of knitr and Pandoc).


