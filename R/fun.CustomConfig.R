#' Custom Configuration
#'
#' Function to load custom configuration of user defined values.
#' Adds to the existing environment.
#' User should load a new configuration prior to master script.
#'
#' Custom config files must **not** include
#' `ContData.env <- new.env(parent = emptyenv())`.
#' This will create a 2nd environment that will not be accessed by the functions
#' in the package.
#'
#' @param myFile Configuration file (including path if not in working directory)
#' @param myExt "R" or "RDS"
#' @return NA, values in file added to environment "ContData.env".
# @example
# # ContData environment (list)
# list(ls(ContData.env))
# # ContData environment (structure)
# ls.str(ContData.env)
# # value that will change
# ContData.env$myDefault.Flat.Hi # 30
# # load configuration from R file
# config.load(file.path(.libPaths()
                 #,"ContDataQC","inst","extdata","config.COOL.R"),myExt="R")
# ContData.env$myDefault.Flat.Hi # 22
# # save configuration as RDS file
# config.export("config.COOL")
# # load configuration from RDS file
# #config.load(file.path(getwd(),"config.COLD.RDS"),myExt="RDS")
#' @export
config.load <- function(myFile, myExt="R"){##FUNCTION.config.load.START
  #
  # 1.0. Rename current "environment" so can get back if needed
  if(exists("ContData.env", mode = "environment") == TRUE){
    # intialize new env
    ContData.env.original <- new.env(parent = emptyenv())
    # copy current env to backup env
    ContData.env.original <- ContData.env
  }## exists ~ END
  #
  # 2.0. Load/Source threshold file
  myEXT <- toupper(myExt)
  if (myEXT=="R"){
    # load R file with source
    #source(file.path(.libPaths(),"ContDataQC","extdata",myFile))
    #source(file.path(path.package("ContDataQC"),"extdata",myFile))
    source(myFile, local=TRUE)
  } else if (myEXT=="RDS") {
    # load RDS
    readRDS(myFile)
  }
  #
}##FUNCTION.thresh.load.END
#
# @param myFile Filename for RDS file to store configuration from ContData.env.
# RDS will be appeneded to the give file name.
# @return NA.  An RDS file is created.
# @example
# # ContData environment (list)
# list(ls(ContData.env))
# # ContData environment (structure)
# ls.str(ContData.env)
# # value that will change
# ContData.env$myDefault.Flat.Hi # 30
# # load configuration from R file
# config.load(file.path(getwd(),"inst","extdata","config.COLD.R"),myExt="R")
# ContData.env$myDefault.Flat.Hi # 22
# # save configuration as RDS file
# config.export("config.COLD")
# # load configuration from RDS file
# config.load(file.path(getwd(),"config.COLD.RDS"),myExt="RDS")
# @export
#config.export <- function(myFile){##FUNCTION.config.export.START
#  # export current env
#  saveRDS(ContData.env,paste0(myFile,".RDS"))
#}##FUNCTION.config.export.END

# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # check if worked
# ContData.env$myName.SiteID        #<- "SiteID"
# ContData.env.original$myName.SiteID
