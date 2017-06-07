NEWS-ContDataQC
================

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->
    #> Last Update: 2017-06-07 11:31:09

Version history.

Planned Updates
===============

-   Spell out "AW"" and other abbreviations (e.g., AirWater). 20170308. On hold.

-   Gaps in data not always evident in the plots. 20170308.

-   Use futile.logger to better log output for user. 20170606.

-   Fix "Aggregate" step to create QC report on large file. 20170607. (v9018)

v2.0.1.9018
===========

2017-06-07

-   Updated main function to allow for a single file or a vector of files. New "file" versions of most scripts. Some updates to the Reports (rmd files).

v2.0.1.9017
===========

2017-06-06

-   Report\_QC.rmd. Correct typo in "Flags" descriptions. Issue \#28. 20170606.

v2.0.1.9016
===========

2017-05-31

-   File delimiter for strsplit(). Also a regex issue with "." (dot). Created special check. 20170531.

v2.0.1.9015
===========

2017-05-31

-   File delimiter. Configuration file allows for user defined values. However, the QC check for StationIDs containing this value uses regular expressions. Added a special condition for the dot, ".", delimiter as regex treats this character as a match for (almost) any character. 20170531.

v2.0.1.9014
===========

2017-05-26

-   Time interval. Fixed calculation of time interval. Certain date time formats would stop processing or be reported as zero. fun.QC.R, Report\_Aggregate.rmd, Report\_QC.rmd, and Report\_Stats.rmd. 20170526.

v2.0..1.9013
============

2017-05-24

-   fun.Stats.R. Had previously commented out stats and plots due to errors. Single typo fixed in year season stats and reworked daily summaryBy stats section. 20170524.

v2.0..1.9012
============

2017-05-24

-   fun.Gage.R. Changed variable "myTZ" to "fun.myTZ" for consistency. 20170524.

v2.0.1.9011
===========

2017-05-23

-   Remove unused arguement "fun.myFile.Prefix" from help file for ContDataQC(). 20170523.

v2.0.1.9010
===========

2017-05-22

-   Modify input and export directories so can be any folder. The default directory is now the working directory. Modified input parameters for ContDataQC() by removing "fun.myDir.BASE". Modified examples and all other necessary scripts.

v2.0.1.9009
===========

2017-05-19

-   Report\_Aggregate.rmd. Fix sampling interval (seconds to minutes,line 23). Left plots as dots instead of lines. 20170519.

-   ContDataQC(). Update examples to with date range. After adding in "test4" the dates don't match for "test2". 20170519.

-   Update "test4" dataset. Change "Water Level ft"" to "Sensor Depth ft". 20170519.

-   Summary Stats quit with error. Fixed in summaryBy statements. 20170519.

v2.0.1.9008
===========

2017-05-18

-   Add example for offset data for QC in main function (ContDataQC()). 20170518.

-   Fix plots (legend) in Report\_QC.R (remove box as it is only partially displaying). 20170518.

-   Config file. Upate Sensor Depth and Water Pressure display names. 20170518.

-   Label code chunks in RMD files. 20170518.

-   Fix plots (blank) in Report\_QC.R for "offset" data. With point type of "line" the NAs in the data caused nothing to be plotted. Fixed with na.omit(as.numeric(x)) when subsetted data for plotting. Then had to fix date range on x-axis. 20170518.

v2.0.1.9007
===========

2017-05-17

-   Add additional config file. Modified config.R to include OlsonNames() in timezone section. Added /extdata/config.TZ.central.R with only time zone change. Modified examples in zfun.ContaDataQC.R to include a USGS gage in the central time zone. Modified ContDataQC() with optional parameter to use helper functions to include different config files. Will only need paramters that are different. User provides path to the new R file for new variables to include in the environment ContData.env.

v2.0.1.9006
===========

2017-05-17

-   zfun.ContDataQC.R. Add in "test4" data (offset times) to examples. 20170515.

-   config.R. Fix typo in ContData.env$myName.GageHeight; missing "." between name and unites. 20170517.

-   fun.QC.R. Line 1034 bad reference for difftime; renamed myTimeDiff.all to myT.diff.all.

-   Comnfirmed that knitr is silent so the user does not get code scrolling across screen. 20170517.

-   Confirmed that steps/tasks in the process are independant of each other. That is, someone can use some or all routines as each is a separate function. 20170517.

v2.0.1.9005
===========

2017-05-15

-   Add data.R to desribe data inlcuded in library. 20170508.

-   fun.QC.R. Fix typo in myT.diff.all operation (line 965). 20170508.

-   Create data process script in "data-raw" for three example "test1" files. 20170509.

-   Revised fun.OffsetCollectionCheck() in fun.Helper.R. Return value is not boolean. 20170509.

-   Revised fun.CalcQCStats() in fun.QC.R. Added ability to handle offset timing for Air/Water data files. 20170509.

-   Fixed typo in finding time interval in markdown files; Report\_Aggregate.RMD, Report\_Stats.RMD, and Report\_QC.RMD. 20170510.

-   Offset time collections (e.g., Air and Water data in same file but not starting at the same time). Fixed fun.QC.R(fun.QC() and fun.CalcQCStats()) to account for this disparity. Previous iteration flagged every other row. Rows without data are no longer flagged (unless the data at the regular time interval was missing). 20170512.

-   Applied fix from fun.QC.R for difftime to report markdown files; Report\_Aggregate.RMD, Report\_Stats.RMD, and Report\_QC.RMD.. 20170512.

-   Modified example files in /data-raw/ to use "Sensor Depth" instead of "Water Level". Reran ProcessData scripts to recreate data files. 20170512.

-   fun.QC(); moved "Working" message inside of IF statement to only reports to user if that data type is present in the data. Avoids printing to the console all 11 parameters being checked. 20170512.

-   config.R; ContData.env*m**y**N**a**m**e*.*T**u**r**b**i**d**i**t**y**m**o**d**i**f**i**e**d**v**a**l**u**e*, *C**o**n**t**D**a**t**a*.*e**n**v*myName.Chlorophylla modified typo in name (and changed value), ContData.env*m**y**L**a**b*.*C**h**l**o**r**o**p**h**y**l**l**a**m**o**d**i**f**i**e**d**v**a**l**u**e**t**y**p**o*, *C**o**n**t**D**a**t**a*.*e**n**v*myThresh.RoC.SD.number.Chlorophylla name fix, ContData.env*m**y**N**a**m**e*.*F**l**a**g*.*C**h**l**o**r**o**p**h**y**l**l**a**n**a**m**e**f**i**x*, *C**o**n**t**D**a**t**a*.*e**n**v*myUnits.Chlorophylla name fix. 20170512.

-   Offset data files. Fix overall data flags for each parameters. Currently giving "NA" if any "NA". And have "NA" due to offset data. fun.QC.R. 20170512.

v2.0.1.9004
===========

2017-05-05

-   Reformat file comments for proper outlining in RStudio. 20170505.

-   Fix development version from 2.0.1.0004 to 2.0.1.9004. 20170505.

-   Update Description with version number (last edit was 2.0.1.0000). 20170505.

v2.0.1.0003
===========

2017-05-05

-   Change WaterLevel to SensorDepth; config.R, config\_COLD.R, Report\_Aggregate.RMD, Report\_QC.RMD, fun.QC.R, fun.Stats.R, zfunAggregateData.R. 20170505.

-   Changed WaterLevel to GageHeight in fun.GageData.R and added new parameter to config.R. Added to config.R with thresholds. 20170505.

-   Corrected flag names for Turbidity and Chlorophyll a; config.R. 20170505.

v2.0.1.0002
===========

2017-05-04

-   Corrected error in Julian Day (0:364 instead of 1:365). Fixed in fun.Stats.R (line 131) by adding "+1". 20170320.

-   Added 5 parameters (Conductivity, Dissolved Oxygen, pH, Turbidity, and Chrlorphyl a) to those that can be evaluated. Changes made to env.UserDefinedValues.R and fun.QC.R. 20170323.

-   Renamed env.UserDefinedValues.R to config.R. 20170421.

-   Added "config" functions to load user configuration (e.g., thresholds specific to coldwater streams) \[fun.CustomConfig.R\] 20170421.

-   Tweak Reports (Report\_Aggregate.RMD, Report\_QC.RMD, and Report\_Stats.RMD) and fun.QC.R for determining time frequency for sampling. Was using interval for 10th and 11th samples (or 4th and 5th in fun.QC.R). Now using median of all time differences. Will always work as long as have at least 1 sample. Previously could fail with less than 5 samples (or 11).

v2.0.1.0001
===========

2017-03-08

-   Bug fix for missed references to new environment for variables introduced in v2.0.1. Multiple files affected. Gage data, QC, and Aggregate working but not Stats. One table in the QC and Aggregate reports has been commented out. (To be fixed later).

v2.0.1
======

2017-03-06

-   Bug fix for variable names not showing up.

-   Created environment ContData.env and assigned all variables in fun.UserDefinedValues.R file to it.

-   Renamed fun.UserDefinedValues.R to env.UserDefinedValues.R.

-   Converted all RMD and R files in package to use ContData.env$.

-   Added NEWS.md

-   Edited earlier fix to fun.QC.R for adding day, month, year to data. Did not use variable names in previous edit.

-   Create RMD files for ReadMe and NEWS. Added RMD to ignore list.

v2.0.0
======

2017-02-28

-   Released on GitHub as a fully documented package.

-   Update for TN, Modified QC report (RMD) to summarize number of samples differently.

-   Included tables in Aggregate report (RMD).

-   Reworked scripts to be run as a library.

-   Uploaded to GitHub.

v1.2.1
======

2017-01-16

-   Update for NJ, fixed date/time issue when resaving files in Excel.

-   Added date/time QC process to be run again at the aggregate step.

v1.2.0
======

2016-05-04

-   NWQMC 2016, Tampa, FL

v1.1.0
======

2016-03-31

-   AMAAB 2016, Cacapon, WV

-   Minor

v1.0.0
======

2015-10-26

-   SWPBA 2015, Myrtle Beach, SC

-   Initial public release.
