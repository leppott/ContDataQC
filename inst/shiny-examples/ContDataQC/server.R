#Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development. dagibbs22@gmail.com
#Written 2017 and 2018

#Source of supporting functions
source("global.R")

shinyServer(function(input, output, session) {

  ###Downloads data template
  #To allow users to download a properly formatted template of the continuous data spreadsheet
  output$downloadTemplate <- downloadHandler(
      filename <- function() {
        paste("continuous_data_template", "csv", sep=".")
      },

      content <- function(file) {
        write.csv(dataTemplate, file)
      }
    )## downloadTemplate ~ END

  # File Upload, Main ----
 ###Defines objects for the whole app
  #Creates a reactive object with all the input files
  allFiles <- reactive({
    allFiles <- input$selectedFiles
    if(is.null(allFiles)) return(NULL)
    return(allFiles)
  }) ## allFiles ~ END

  #Creates a reactive object with all the input files' names
  UserFile_Name <- reactive({
    if(is.null(allFiles())) return(NULL)
    return(allFiles()$name)
  })

  #Creates a reactive object with all the input files' directories
  UserFile_Path <- reactive({
    if(is.null(allFiles())) return(NULL)
    return(allFiles()$datapath)
  })

  # File Upload, HOBO ----
  #Creates a reactive object with all the input files
  allFiles_HOBO <- reactive({
    allFiles_HOBO <- input$selectedFiles_HOBO
    if(is.null(allFiles_HOBO)) return(NULL)
    return(allFiles_HOBO)
  }) ## allFiles ~ END

  #Creates a reactive object with all the input files' names
  UserFile_Name_HOBO <- reactive({
    if(is.null(allFiles_HOBO())) return(NULL)
    return(allFiles_HOBO()$name)
  })

  #Creates a reactive object with all the input files' directories
  UserFile_Path_HOBO <- reactive({
    if(is.null(allFiles_HOBO())) return(NULL)
    return(allFiles_HOBO()$datapath)
  })

  # Reactive, Main ----
  #Creates a reactive object that stores whether a configuration file has been uploaded
  config <- reactiveValues(
    x="default"
  )

  #Creates the empty table for station properties
  fileAttribsNull <- reactive({

    #Column names for the table
    summColNames <- c("File name", "Station ID",
                      "Starting date", "Ending date",
                      "Record count",
                      "Water temperature", "Air temperature",
                      "Water pressure", "Air pressure",
                      "Sensor depth", "Flow")

    #Creates empty table columns
    fileAttribsNull <- data.frame(filenameNull = c("Awaiting data"),
                             stationIDNull = c("Awaiting data"),
                             startDateNull = c("Awaiting data"),
                             endDateNull = c("Awaiting data"),
                             recCountNull = c("Awaiting data"),
                             waterTempNull = c("Awaiting data"),
                             airTempNull = c("Awaiting data"),
                             waterPressureNull = c("Awaiting data"),
                             airPressureNull = c("Awaiting data"),
                             sensorDepthNull = c("Awaiting data"),
                             flow = c("Awaiting data"))

    colnames(fileAttribsNull) <- summColNames

    return(fileAttribsNull)

  })

  # Tables, Import, Attributes ----
  #Creates a table with attributes of input files
  fileAttribsFull <- reactive({

    if(is.null(allFiles())) {
      return(NULL)
    }

    #Initializes the empty columns for the table
    fileAttribsFull <- data.frame(filename = character(),
                      stationID = character(),
                      startDate = as.Date(character()),
                      endDate = as.Date(character()),
                      recordCount = as.integer(),
                      waterTempNull = character(),
                      airTempNull = character(),
                      waterPressureNull = character(),
                      airPressureNull = character(),
                      sensorDepthNull = character(),
                      flow = character())

    #Column names for the table
    summColNames <- c("File name", "Station ID",
                                   "Starting date", "Ending date",
                                   "Record count",
                                   "Water temperature", "Air temperature",
                                   "Water pressure", "Air pressure",
                                   "Sensor depth", "Flow")

    #For each input file, gets the file attributes and adds it to
    #the table
    for (i in seq_len(nrow(allFiles()))) {

      #Calls function that gets file attributes
      actualData <- read.csv(UserFile_Path()[i], header=TRUE)
      fileAttribs <- fileParse(actualData)

      #Adds a column with the filename to the file attributes
      fileAttribs <- cbind(UserFile_Name()[i], fileAttribs)

      #Adds this input file's information to the summary table
      fileAttribsFull <- rbind(fileAttribsFull, fileAttribs)
    }

    #Reformats the date columns to be the right date format
    fileAttribsFull[,3] <- format(fileAttribsFull[,3], "%Y-%m-%d")
    fileAttribsFull[,4] <- format(fileAttribsFull[,4], "%Y-%m-%d")

    #Names the columns
    colnames(fileAttribsFull) <- summColNames

    return(fileAttribsFull)

  })

  # Tables, Import, Summary ----
  ###Creates summary input tables
  #Creates a summary data.frame as a reactive object.
  #This table includes file name, station ID, start date, end date, and record count.
  table1 <- reactive({

    #Shows the table headings before files are input
    if (is.null(allFiles())) {

      #Subsets the columns of the pre-upload data for display
      nullTable1 <- fileAttribsNull()[c(1:5)]

      #Sends the empty table to be displayed
      return(nullTable1)
    }

    #Subsets the file attribute table with just
    #file name, site ID, start date, end date, and number of records
    summaryTable1 <- fileAttribsFull()[, c(1:5)]
    colnames(summaryTable1) <- colnames(fileAttribsFull()[c(1:5)])

    return(summaryTable1)
  })

  #Outputs a summary table with file name, station ID, starting date
  #ending date, and record count
  #Each input spreadsheet gets one row.
  output$summaryTable1 <- renderTable({
    table1()
  })

  #Creates a summary data.frame as a reactive object
  #This table includes file name and which data types were found in each file
  table2 <- reactive({

    #Shows the table headings before files are input
    if (is.null(allFiles())) {

      #Subsets the columns of the pre-upload data for display
      nullTable2 <- fileAttribsNull()[c(1, 6:11)]

      #Sends the empty table to be displayed
      return(nullTable2)
    }

    #Subsets the file attribute table with just
    #file name, water/air temp, water/air pressure, sensor depth,
    #gage height, and flow
    summaryTable2 <- fileAttribsFull()[,c(1, 6:11)]
    colnames(summaryTable2) <- colnames(fileAttribsFull()[c(1, 6:11)])

    return(summaryTable2)
  })

  #Outputs a summary table with file name and whether each data
  #type was found.
  #Each input spreadsheet gets one row.
  output$summaryTable2 <- renderTable({
    table2()
  })

  # Run, HOBO, button ----
  output$ui.runProcess_HOBO <- renderUI({
    if (is.null(allFiles_HOBO())) return() # Hidden unless upload files
    operation <- "formatHOBO"
    actionButton("runProcess_HOBO", "Reformat HOBOware file(s)")
  })

  # Run Operation, button ----
  ###Runs the selected process
  #Shows the "Run operation" button after the data are uploaded
  output$ui.runProcess <- renderUI({

    if (is.null(allFiles())) return()


    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    if (operation == "") return()
    actionButton("runProcess", "Run operation")
  })

  # Warning, noQC, Aggregate ----
  #Shows a warning on the interface if the uploaded sites
  #have not been QCed and Aggregate has been selected
  output$aggUnQCedData <- renderText({

    if (is.null(allFiles())) return()

    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    #Reads in the first uploaded spreadsheet. Only checks the first
    #uploaded spreadsheet's column names on the assumption that if one
    #spreadsheet hasn't been through the QC process, the others haven't
    #as well.
    actualData <- read.csv(UserFile_Path()[1], header=TRUE)

    #The first four characters of each column name, for comparison with the
    #string "Flag", which is produced by the QC process
    fileCols <- substr(colnames(actualData),1,4)

    #Shows the warning if sites haven't been QCed
    if(!("Flag" %in%  fileCols) && operation == "Aggregate"){
      return(paste("WARNING: The spreadsheets you have selected for the aggregate process have
                   not gone through the QC process.
                   Please put these spreadsheets through the QC process first."))
    }
  })

  # Warning, noQC, Summarize ----
  #Shows a warning on the interface if the uploaded sites
  #have not been QCed and Summarize has been selected
  output$summUnQCedData <- renderText({

    if (is.null(allFiles())) return()

    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    #Reads in the first uploaded spreadsheet. Only checks the first
    #uploaded spreadsheet's column names on the assumption that if one
    #spreadsheet hasn't been through the QC process, the others haven't
    #as well.
    actualData <- read.csv(UserFile_Path()[1], header=TRUE)

    #The first four characters of each column name, for comparison with the
    #string "Flag", which is produced by the QC process
    fileCols <- substr(colnames(actualData),1,4)

    #Shows the warning if sites haven't been QCed
    if(!("Flag" %in%  fileCols) && operation == "SummaryStats"){
      return(paste("WARNING: The spreadsheets you have selected for the summarize process have
                   not gone through the QC process.
                   Please put these spreadsheets through the QC process first."))
    }
    })

  # Warning, Agg, multisite ----
  #Shows a warning on the interface if more than one site is
  #included in the spreadsheets for the Aggregate process
  output$moreThanOneSite <- renderText({

    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    #Determines how many sites are included in the Aggregate input files
    siteNum <- length(levels(fileAttribsFull()[,2]))

    #Shows the warning if there is more than one site input to Aggregate
    if(operation == "Aggregate" && siteNum != 1){
      return(paste("WARNING: The spreadsheets you have selected for the aggregate process include more than one site.
                   Please make sure all input spreadsheets are from the same site."))
    }
  })

  # Run, HOBO, code ----
  observeEvent(input$runProcess_HOBO, {

    # Remove files in "HOBO" folder
    message("Remove File")
    file.remove(normalizePath(list.files(file.path("HOBO"), full.names = TRUE)))

    #Moves the user-selected input files from the default upload folder to Shiny's working directory
    message("Copy")
    copy.from <- file.path(UserFile_Path_HOBO())
    #copy.to <- file.path(getwd(), UserFile_Name())
    copy.to <- file.path(".", "HOBO", UserFile_Name_HOBO())
    file.copy(copy.from, copy.to)

    #Allows users to use their own configuration/threshold files for QC.
    #Copies the status of the config file to this event.
    config_type <- config$x

    #Temporary location for the config file
    config <- file.path(".", "data")

    #If a configuration file has been uploaded, the app uses it
    if (config_type == "uploaded") {

      #Copies the uploaded configuration file from where it was uploaded to into the working directory.
      #The config file must be in the working directory for this to work.
      copy.from2 <- file.path(input$configFile$datapath)
      #copy.to2 <- file.path(getwd(), input$configFile$name)
      copy.to2 <- file.path("data", input$configFile$name)
      file.copy(copy.from2, copy.to2)

      #Makes the configuration object refer to the uploaded configuration file
      #config <- file.path(getwd(), input$configFile$name)
      config <- file.path("data", input$configFile$name)

    }
    #If no configuration file has been uploaded, the default is used
    else {

      #Deletes the uploaded configuration file, if there is one
      #file.remove(file.path(getwd(), input$configFile$name))
      file.remove(file.path("data", input$configFile$name))

      # config <- system.file("extdata", "Config.COLD.R", package="ContDataQC")
      config <- system.file("extdata", "Config.ORIG.R", package="ContDataQC")

    }## IF ~ config_type ~ END

    #Creates a data.frame for the R console output of the ContDataQC() script
    console$disp <- data.frame(consoleOutput = character())

    withProgress(message = paste("Running, format Hobo"), value = 0, {

      #A short pause before the operation begins
      Sys.sleep(2)

        #Creates a vector of filenames
        fileNameVector <-  as.vector(UserFile_Name_HOBO())
        message("File Name Vector")
        message(fileNameVector)

        #Changes the status bar to say that aggregation is occurring
        incProgress(0, detail = paste("Format Hobo ", length(fileNameVector), " files"))

        #Saves the R console output of ContDataQC()
        consoleRow <- capture.output(

          message("Run function")
          ,message("dir import")
          ,message(file.path("HOBO"))
          # Run function formatHobo
          ,ContDataQC::formatHobo(fun.myFile = fileNameVector
                                 , fun.myDir.import = file.path("HOBO")
                                 , fun.myDir.export = file.path("HOBO")
                                 , fun.HoboDateFormat = NULL
                                 , fun.myConfig = config
          ) # formatHOBO ~ END
        )## consoleRow ~ END

        #Appends the R console output generated from that input file to the
        #console output data.frame
        consoleRow <- data.frame(consoleRow)
        console$disp <- rbind(console$disp, consoleRow)

        #Fills in the progress bar once the operation is complete
        incProgress(1, detail = paste("Finished formating HOBOware files"))

        #Pauses the progress bar once it's done
        Sys.sleep(2)

        #Names the single column of the R console output data.frame
        colnames(console$disp) <- c(paste("R console messages for format_HOBO"))

        #unhide download button


    })# with progress ~ END

  # })




  })## observerEvent ~ runProcess_HOBO ~ END

  # Run Operation, code ----
  #Runs the selected process by calling on the QC script that Erik Leppo wrote
  observeEvent(input$runProcess, {

    # 2020-12-11
    # Remove files in "data" folder
    file.remove(normalizePath(list.files(file.path(".", "data"), full.names = TRUE)))

    #Deletes the input and output files to keep the server from getting clogged
    deleteFiles(file.path(".", "data"), UserFile_Name())

    #Moves the user-selected input files from the default upload folder to Shiny's working directory
    copy.from <- file.path(UserFile_Path())
    #copy.to <- file.path(getwd(), UserFile_Name())
    copy.to <- file.path(".", "data", UserFile_Name())
    file.copy(copy.from, copy.to)

    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    #Allows users to use their own configuration/threshold files for QC.
    #Copies the status of the config file to this event.
    config_type <- config$x

    #Temporary location for the config file
    config <- file.path(".", "data")

    #If a configuration file has been uploaded, the app uses it
    if (config_type == "uploaded") {

      #Copies the uploaded configuration file from where it was uploaded to into the working directory.
      #The config file must be in the working directory for this to work.
      copy.from2 <- file.path(input$configFile$datapath)
      #copy.to2 <- file.path(getwd(), input$configFile$name)
      copy.to2 <- file.path("data", input$configFile$name)
      file.copy(copy.from2, copy.to2)

      #Makes the configuration object refer to the uploaded configuration file
      #config <- file.path(getwd(), input$configFile$name)
      config <- file.path("data", input$configFile$name)

    }
    #If no configuration file has been uploaded, the default is used
    else {

      #Deletes the uploaded configuration file, if there is one
      #file.remove(file.path(getwd(), input$configFile$name))
      file.remove(file.path("data", input$configFile$name))

     # config <- system.file("extdata", "Config.COLD.R", package="ContDataQC")
      config <- system.file("extdata", "Config.ORIG.R", package="ContDataQC")

    }## IF ~ config_type ~ END

    #Creates a data.frame for the R console output of the ContDataQC() script
    console$disp <- data.frame(consoleOutput = character())

    #Progress bar to tell the user the operation is running
    #Taken from https://shiny.rstudio.com/articles/progress.html
    withProgress(message = paste("Running", operation), value = 0, {

      #A short pause before the operation begins
      Sys.sleep(2)

      ## _appendfiles-agg ----
      #Aggregating files requires having all the file names in a single string input for fun.myFile.
      #Thus, all files selected to be aggregated have their names put into a string.
      if (operation == "Aggregate") {

        #Creates a vector of filenames
        fileNameVector <-  as.vector(UserFile_Name())

        #Changes the status bar to say that aggregation is occurring
        incProgress(0, detail = paste("Aggregating ", length(fileNameVector), " files"))

        #Saves the R console output of ContDataQC()
        consoleRow <- capture.output(

                        #Runs aggregation part of ContDataQC() on the input files
                        ContDataQC(operation,
                        fun.myDir.import = file.path(".", "data"),
                        fun.myDir.export = file.path(".", "data"),
                        fun.myConfig = config,
                        fun.myFile = fileNameVector,
                        fun.myReport.format = "",
                        fun.myReport.Dir = "./rmd"
                        )
        )

        #Appends the R console output generated from that input file to the
        #console output data.frame
        consoleRow <- data.frame(consoleRow)
        console$disp <- rbind(console$disp, consoleRow)

        #Fills in the progress bar once the operation is complete
        incProgress(1, detail = paste("Finished aggregating files"))

        #Pauses the progress bar once it's done
        Sys.sleep(2)

        #Names the single column of the R console output data.frame
        colnames(console$disp) <- c(paste("R console messages for ", input$Operation))

        #Renames the output aggregation files so that the "append_x" is replaced
        #with the ending date
        aggRenamed <- renameAggOutput(file.path(".", "data"), fileAttribsFull())

      }

      #The QCRaw and Summarize functions can be fed individual input files
      #in order to have the progress bar increment after each one is processed
      else {

        #Iterates through all the selected files in the data.frame
        #to perform the QC script on them individually
        for (i in seq_len(nrow(allFiles()))) {

          #Extracts the name of the file from the selected input file
          fileName <- UserFile_Name()[i]

          #Changes the status bar to say that the process is occurring
          incProgress(0, detail = paste("Operating on", fileName))

          #Saves the R console output of ContDataQC()
          consoleRow <- capture.output(

                          #Runs ContDataQC() on an individual file
                          ContDataQC(operation,
                          fun.myDir.import = file.path(".", "data"),
                          fun.myDir.export = file.path(".", "data"),
                          fun.myConfig = config,
                          fun.myFile = fileName,
                          fun.myReport.format = "",
                          fun.myReport.Dir = "./rmd"
                          )
          )

          #Appends the R console output generated from that input file to the
          #console output data.frame
          consoleRow <- data.frame(consoleRow)
          console$disp <- rbind(console$disp, consoleRow)

          # Zip files



          #Fills in the progress bar once the operation is complete
          incProgress(1/nrow(allFiles()), detail = paste("Finished", fileName))

          #Pauses the progress bar once it's done
          Sys.sleep(2)

        }## FOR ~ i ~ END

        #Names the single column of the R console output data.frame
        colnames(console$disp) <- c(paste("R console messages for process '", input$Operation, "'"))

      }## IF ~ operation ~ END

    })## withProgress ~ END

  })## observeEvent ~ input$runProcess ~ END

  # Download, HOBO ----
  output$ui.downloadData_HOBO <- renderUI({
    if (is.null(console$disp)) return()
    downloadButton("downloadData_HOBO", "Download")
  })## ui.downloadData ~ END


  output$downloadData_HOBO <- downloadHandler(
    #Names the zip file
    filename <- function() {
      paste0("formatHOBO_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip")
    },
    #Zips the output files
    content <- function(fname) {
      #Lists only the csv and html files on the server
      files2zip <- file.path("HOBO", list.files("HOBO"))
      #Zips the files
      zip(zipfile = fname, files = files2zip)
    }# content ~ END
    ,contentType = "application/zip"
  )


  # Download, Remove files ----
  ###Downloads the output data and deletes the created files
  #Shows the "Download" button after the selected process is run
  output$ui.downloadData <- renderUI({
    if (is.null(console$disp)) return()
    downloadButton("downloadData", "Download")
  })## ui.downloadData ~ END

  ## Zip ----
  #Zips the output files and makes them accessible for downloading by the user
  observe({

    #Converts the more user-friendly input operation name to the name
    #that ContDataQC() understands
    operation <- renameOperation(input$Operation)

    #Formats the download timestamp for the zip file
    operationTime <- timeFormatter(Sys.time())

    ## _zip-qc ----
    #Zipping procedures for the output of the QC process
    if (operation == "QCRaw"){

      output$downloadData <- downloadHandler(

        #Names the zip file
        filename <- function() {
          paste(operation, operationTime, "zip", sep=".")
        },

        #Zips the output files
        content <- function(fname) {

          #Lists only the csv and html files on the server
          zip.csv  <- dir(file.path("data"), full.names=FALSE, pattern="QC.*csv")
          zip.docx <- dir(file.path("data"), full.names=FALSE, pattern="QC.*docx")
          zip.html <- dir(file.path("data"), full.names=FALSE, pattern="QC.*html")
          files2zip <- file.path("data", c(zip.csv, zip.docx, zip.html))

          #Zips the files
          zip(zipfile = fname, files = files2zip)
        }
        ,contentType = "application/zip"
      )
    }

    ## _zip-agg ----
    #Zipping procedures for the output of the aggregation process
    if (operation == "Aggregate"){

      output$downloadData <- downloadHandler(

        #Names the zip file
        filename <- function() {
          paste(operation, operationTime, "zip", sep=".")
        },

        #Zips the output files
        content <- function(fname) {

          #Lists only the csv and docx files on the server
          zip.csv  <- dir(file.path("data"), full.names=FALSE, pattern="DATA.*csv")
          zip.docx <- dir(file.path("data"), full.names=FALSE, pattern=".*docx")
          zip.html <- dir(file.path("data"), full.names=FALSE, pattern=".*html")
          files2zip <- file.path("data", c(zip.csv, zip.docx, zip.html))

          #Zips the files
          zip(zipfile = fname, files = files2zip)
        }
        ,contentType = "application/zip"
      )
    }

    ## _zip-stats ----
    #Zipping procedures for the output of the SummaryStats process
    if (operation == "SummaryStats"){

      output$downloadData <- downloadHandler(

        #Names the zip file
        filename <- function() {
          paste(operation, operationTime, "zip", sep=".")
        },

        #Zips the output files
        content <- function(fname) {

          #Lists only the csv and docx files on the server
          zip.csv_DV    <- dir(file.path("data"), full.names=FALSE, pattern="DV.*csv")
          zip.csv_STATS <- dir(file.path("data"), full.names=FALSE, pattern="STATS.*csv")
          zip.pdf       <- dir(file.path("data"), full.names=FALSE, pattern=".*pdf")
          files2zip <- file.path("data", c(zip.csv_DV, zip.csv_STATS, zip.pdf))

          #Zips the files
          zip(zipfile = fname, files = files2zip)
        }
        ,contentType = "application/zip"
      )
    }
  })

  # USGS ----
  # _input ----
  ###For getting USGS gage data
  #Runs the gage data extraction process
  observeEvent(input$getUSGSData, {

    #Deletes any files on server before creating new ones to prevent server
    #from getting clogged
    deleteFiles(file.path(".", "data"), UserFile_Name())

    #Converts the string of USGS sites into a vector of USGS sites
    USGSsiteVector <- USGSsiteParser(input$USGSsite)

    #Creates a data.frame for the R console output of the ContDataQC() script
    consoleUSGS$disp <- data.frame(consoleOutputUSGS = character())

    #A short pause before the operation begins
    Sys.sleep(0.5)

    withProgress(message = paste("Getting USGS data"), value = 0, {

      for(i in seq_len(length(USGSsiteVector))) {

        #Changes the status bar to say that aggregation is occurring
        incProgress(0, detail = paste("Retrieving records for site ", USGSsiteVector[i]))

        message("Get gage data, ContDataQC()")

        #Saves the R console output of ContDataQC()
        consoleRowUSGS <- capture.output(

          #Actually gets the gage data from the USGS NWIS system
          ContDataQC(
                  myData.Operation        <- "GetGageData",
                  myData.SiteID           <- USGSsiteVector[i],
                  myData.Type             <- "Gage",
                  myData.DateRange.Start  <- input$startDate,
                  myData.DateRange.End    <- input$endDate,
                  myDir.import            <- "",
                  myDir.export            <- file.path(".", "data"),
                  fun.myReport.Dir        <- ""
          )

        )

        #Appends the R console output generated from that input file to the
        #console output data.frame
        consoleRowUSGS <- data.frame(consoleRowUSGS)
        consoleUSGS$disp <- rbind(consoleUSGS$disp, consoleRowUSGS)

        #Fills in the progress bar once the operation is complete
        incProgress(1/length(USGSsiteVector), detail = paste("Retrieved records for site ", USGSsiteVector[i]))
        Sys.sleep(1)

      }

    })

    #Pauses the progress bar once it's done
    Sys.sleep(1)

    #
    message("data retrieved")

    #Names the single column of the R console output data.frame
    colnames(consoleUSGS$disp) <- c("R console messages for all USGS data retrieval:")

  })

  # _download ----
  #Shows the "Download USGS gage data" button after the selected process is run
  output$ui.downloadUSGSData <- renderUI({
    if (is.null(consoleUSGS$disp)) return()
    downloadButton("downloadUSGSData", "Download USGS gage data")
  })

  #Zips and downloads the USGS gage data
  observe({

    #Formats the download timestamp for the zip file
    operationTime <- timeFormatter(Sys.time())

    #Function for downloading USGS data
    output$downloadUSGSData <- downloadHandler(

      # __zip-usgs ----
      #Names the zip file
      filename <- function() {
        paste("USGSData",input$USGSsite, operationTime, "zip", sep=".")
      },

      #Zips the output files
      content <- function(fname) {

        #Lists only the csv and html files on the server
        zip.csv <- dir(file.path("data"), full.names=FALSE, pattern=".*Gage.*csv")
        files2zip <- file.path("data", c(zip.csv))

        #Zips the files
        zip(zipfile = fname, files = files2zip)
      }
      ,contentType = "application/zip"
    )
  })


  # Console Output ----
  ###Shows the R console output text
  #Creates separate reactive objects for the QC/Agg/Summ and GetGageData processes
  console <- reactiveValues()
  consoleUSGS <- reactiveValues()

  #Before any process is run, shows a message saying that console output will be displayed
  #later (after process is run)
  output$logTextMessage <- renderText({

    if (is.null(console$disp) && is.null(consoleUSGS$disp)){

      beforeRun <- paste("Check here for script messages after running process...")
      return(beforeRun)
    }
  })

  #Shows the output notes that the QC/Agg/Summ processes show in the R console
  output$logText <- renderTable({

    #Won't show console text until after the input files are selected
    #(i.e., after the process is run)
    if (is.null(input$selectedFiles))
      return(NULL)

    return(console$disp)
  })

  #Shows the output notes that the GetGageData process shows in the R console
  output$logTextUSGS <- renderTable({

    #Won't show console text until after the USGS stations are selected
    #(i.e., after the process is run)
    if (is.null(input$USGSsite))
      return(NULL)

    return(consoleUSGS$disp)
  })

  # Config, Default ----
  ###Returns the configuration file to default status
  #Shows the "Default" button after a user-selected config file is uploaded
  output$ui.defaultConfig <- renderUI({
    if (is.null(input$configFile)) return()
    actionButton("defaultConfig", "Return to default configuration file")
  })

  #Changes the config object status to a file being uploaded
  observeEvent(input$configFile, {
    config$x <- "uploaded"
  })

  #Changes the config object status to return to the default config file
  observeEvent(input$defaultConfig, {
    config$x <- "default"
  })

  # Debug, Show all files ----
  ###Shows all files on the server
  #For debugging only: shows the files on the server
  onServerTable <- reactive({
    onServerTableOutput <- as.matrix(list.files(file.path(".", "data"), full.names = FALSE))
    colnames(onServerTableOutput) <- c("Files currently on server")
    return(onServerTableOutput)
  })

  output$serverTable <- renderTable({
    onServerTable()
  })

  # Debug, Test Text ----
  #FOR TESTING.
  output$testText <- renderText({

    inFile <- input$selectedFiles
    if (is.null(inFile))
      return(NULL)

    paste("This is for testing:", file.path(".", "data"))
  })

}
)
