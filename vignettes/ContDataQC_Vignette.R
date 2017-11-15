## ---- eval=FALSE---------------------------------------------------------
#  install.packages("devtools")
#  library(devtools)
#  install_github("leppott/ContDataQC")

## ---- eval=FALSE---------------------------------------------------------
#  # install all dependant libraries manually
#  # libraries to be installed
#  data.packages = c(
#                    "dataRetrieval"   # loads USGS data into R
#                    "zoo",
#                    "knitr",
#                    "survival",
#                    "doBy",
#                    "rmarkdown"
#                    )
#  
#  # install packages via a 'for' loop
#  for (i in 1:length(data.packages)) {
#    #install.packages("doBy",dependencies=TRUE)
#    install.packages(data.packages[i])
#  } # end loop
#  
#  print("Task complete.  Check statements above for errors.")
#  

## ---- eval=FALSE---------------------------------------------------------
#  # Install Pandoc (for docx Reports)
#  # (if using recent version of RStudio do not have to install separately)
#  install.packages("installr") # not needed if already have this package.
#  require(installr)
#  install.pandoc()
#  # The above won't work if don't have admin rights on your computer.
#  # Alternative = Download the file below and have your IT dept install for you.
#  # https://github.com/jgm/pandoc/releases/download/1.16.0.2/pandoc-1.16.0.2-windows.msi
#  # For help for installing via command window:
#  # http://www.intowindows.com/how-to-run-msi-file-as-administrator-from-command-prompt-in-windows/

## ---- eval=FALSE---------------------------------------------------------
#  # inter-CRAN release hosted on USGS website
#  install.packages("dataRetrieval",repos="https://owi.usgs.gov/R")
#  # from GitHub
#  # install.packages("devtools")
#  # library(devtools)
#  # install_github("USGS-R/dataRetrieval")

## ---- eval=FALSE---------------------------------------------------------
#  # Parameters
#  Selection.Operation <- c("GetGageData","QCRaw", "Aggregate", "SummaryStats")
#  Selection.Type      <- c("Air","Water","AW","Gage","AWG","AG","WG")
#  Selection.SUB <- c("Data1_RAW","Data2_QC","Data3_Aggregated","Data4_Stats")
#  myDir.BASE <- getwd()
#  
#  # Create data directories
#  myDir.create <- paste0("./",Selection.SUB[1])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[2])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[3])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  myDir.create <- paste0("./",Selection.SUB[4])
#    ifelse(dir.exists(myDir.create)==FALSE,dir.create(myDir.create),"Directory already exists")
#  
#  # Save example data (assumes directory ./Data1_RAW/ exists)
#  myData <- data_raw_test2_AW_20130426_20130725
#    write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20130426_20130725.csv"))
#  myData <- data_raw_test2_AW_20130725_20131015
#    write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20130725_20131015.csv"))
#  myData <- data_raw_test2_AW_20140901_20140930
#    write.csv(myData,paste0("./",Selection.SUB[1],"/test2_AW_20140901_20140930.csv"))
#  myData <- data_raw_test4_AW_20160418_20160726
#    write.csv(myData,paste0("./",Selection.SUB[1],"/test4_AW_20160418_20160726.csv"))
#  myFile <- "config.TZ.Central.R"
#    file.copy(file.path(path.package("ContDataQC"),"extdata",myFile)
#              ,file.path(getwd(),Selection.SUB[1],myFile))

