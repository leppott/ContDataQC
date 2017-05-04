NEWS-ContDataQC
================

<!-- NEWS.md is generated from NEWS.Rmd. Please edit that file -->
    #> Last Update: 2017-05-04 15:38:14

Version history.

Planned Updates
===============

-   Add 1 *more* parameter (GageHeight). 20170323. On hold.

-   Change WaterLevel to SensorDepth. 20170308/23. On hold

-   Spell out "AW"" and other abbreviations (e.g., AirWater). 20170308. On hold.

-   When Air and Water measurements are at different times the plots aren't working. 20170308.

-   Gaps in data not always evident in the plots. Related to the above. 20170308.

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
