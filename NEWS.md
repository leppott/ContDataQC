NEWS-ContDataQC
================

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->
    #> Last Update: 2017-05-15 13:52:37

Version history.

Planned Updates
===============

-   Spell out "AW"" and other abbreviations (e.g., AirWater). 20170308. On hold.

-   When Air and Water measurements are at different times the plots and QC aren't working. 20170308.

-   Gaps in data not always evident in the plots. 20170308.

-   Steps/tasks should independant of each other. That is, someone can use just part and not all routines. 20170508.

-   Make knitr silent so don't get code scrolling across screen. 20170512.

-   QC Report, plots are now blank for offset data. 20170515.

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
