# User Defined Values
#
# User defined values for variables used across multiple functions in this library.
# The user has the ability to modify the values for names, units, QC thresholds, etc.
#
# Saved in a separate environment.
#
# https://www.r-bloggers.com/package-wide-variablescache-in-r-packages/
#
# Continuous data helper script
# Default Values
# Erik.Leppo@tetratech.com (EWL)
# 20150928
# 20170323, add 3 parameters (Cond, DO, pH)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# User defined variable names for input data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# It is assumed that this R script is stored in a directory with the data files as subdirectories
# This script is intended to be "source"d from the main script.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @keywords continuous data
# @examples
# #Not intended to be accessed indepedant of function ContDataQC().
# #Data values only.  No functions.  Add to environment so only visible inside library.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# USER may make modifications in this section but not mandatory
# this section could be sourced so can use between scripts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#UserDefinedValues <- NA # default value so shows up in help files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Time Zone, used in Gage script in dataRetrieval, OlsonNames()
# ContData.env$myTZ <- Sys.timezone() #"America/New_York" (local time zone)
ContData.env$myTZ <- "America/Chicago" # central time zone
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
















