# ContDataQC
Quality control checks on continuous data.  Example data is from a HOBO data logger with 30 minute intervals.


Installation
-----------------
library(devtools) 
install.git_hub("leppott/ContDataQC")

Purpose
--------------
Functions developed to help data generators handle data from continuous data sensors (e.g., HOBO data loggers).

From a single function, ContDataQC(), can QC, aggregate, or calculate summary stats on data.  Uses the USGS dataRetrieval library to get USGS gage data.  Reports are generated in Word (through the use of knitr and Pandoc).


