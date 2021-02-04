# Copy Config file to Shiny
# Run each time update master config file (data\config.R)
#
# Erik.Leppo@tetratech.com
# 2021-01-20
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 0. Prep####
wd <- getwd() # assume is package directory
#library(devtools)

# 1. Copy file with new name
config.from <- file.path(".", "R", "config.R")
config.to  <- file.path(".", "inst", "shiny-examples", "ContDataQC"
                        , "www", "Config.R")
file.copy(config.from, config.to, overwrite = TRUE)

# 2. Copy and save as "TEMPLATE"
config.from <- file.path(".", "R", "config.R")
config.to.template <- file.path(".", "inst", "shiny-examples", "ContDataQC"
                               , "www", "Config_Template.R")
file.copy(config.from, config.to.template, overwrite = TRUE)

# 3. Copy to extdata
config.from <- file.path(".", "R", "config.R")
config.to   <- file.path(".", "inst", "extdata", "Config.ORIG.R")
file.copy(config.from, config.to, overwrite = TRUE)


# 4. Comment out env.new() in TEMPLATE
###### MANUAL *************************************

# 5. Create zip file from TEMPLATE
###### MANUAL *************************************
