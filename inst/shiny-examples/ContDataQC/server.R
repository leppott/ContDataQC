#Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development. dagibbs22@gmail.com
#Written 2017 and 2018

#Source of supporting functions
#source("global.R")

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

  # File Upload ----
  ## File Upload, Main ----
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

  ## File Upload, HOBO ----
  #Creates a reactive object with all the input files
  allFiles_HOBO <- reactive({
    allFiles_HOBO <- input$selectedFiles_HOBO
    if(is.null(allFiles_HOBO)) return(NULL)
    return(allFiles_HOBO)
  }) ## allFiles_HOBO ~ END

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

  ## File Upload, miniDOT_cat ----
  #Creates a reactive object with all the input files
  allFiles_miniDOT_cat <- reactive({
    allFiles_miniDOT_cat <- input$selectedFiles_miniDOT_cat
    if(is.null(allFiles_miniDOT_cat)) return(NULL)
    return(allFiles_miniDOT_cat)
  }) ## allFiles_miniDOT_cat ~ END

  #Creates a reactive object with all the input files' names
  UserFile_Name_miniDOT_cat <- reactive({
    if(is.null(allFiles_miniDOT_cat())) return(NULL)
    return(allFiles_miniDOT_cat()$name)
  })

  #Creates a reactive object with all the input files' directories
  UserFile_Path_miniDOT_cat <- reactive({
    if(is.null(allFiles_miniDOT_cat())) return(NULL)
    return(allFiles_miniDOT_cat()$datapath)
  })

  ## File Upload, miniDOT_reformat ----
  #Creates a reactive object with all the input files
  allFiles_miniDOT_reformat <- reactive({
    allFiles_miniDOT_reformat <- input$selectedFiles_miniDOT_reformat
    if(is.null(allFiles_miniDOT_reformat)) return(NULL)
    return(allFiles_miniDOT_reformat)
  }) ## allFiles_miniDOT_reformat ~ END

  #Creates a reactive object with all the input files' names
  UserFile_Name_miniDOT_reformat <- reactive({
    if(is.null(allFiles_miniDOT_reformat())) return(NULL)
    return(allFiles_miniDOT_reformat()$name)
  })

  #Creates a reactive object with all the input files' directories
  UserFile_Path_miniDOT_reformat <- reactive({
    if(is.null(allFiles_miniDOT_reformat())) return(NULL)
    return(allFiles_miniDOT_reformat()$datapath)
  })

  # Reactive, Main ----
  #Creates a reactive object that stores whether a configuration file has been uploaded
  config <- reactiveValues(
    x="default"
  )

  #Creates the empty table for station properties
  fileAttribsNull <- reactive({

    #Column names for the table
    summColNames <- c("File name"
                      , "Station ID"
                      , "Starting date"
                      , "Ending date"
                      , "Record count"
                      , "Water temperature"
                      , "Air temperature"
                      , "Water pressure"
                      , "Air pressure"
                      , "Sensor depth"
                      , "Discharge"
                      , "Water Level"
                      , "Conductivity"
                      , "DO"
                      , "DO, adj"
                      , "DO, % Saturation"
                      , "pH"
                      , "Turbidity"
                      , "Chlorophyll a")

    #Creates empty table columns
    txt_Waiting <- "Awaiting data"
    fileAttribsNull <- data.frame(filenameNull = txt_Waiting
                                  , stationIDNull = txt_Waiting
                                  , startDateNull = txt_Waiting
                                  , endDateNull = txt_Waiting
                                  , recCountNull = txt_Waiting
                                  , waterTempNull = txt_Waiting
                                  , airTempNull = txt_Waiting
                                  , waterPressureNull = txt_Waiting
                                  , airPressureNull = txt_Waiting
                                  , sensorDepthNull = txt_Waiting
                                  , dischargeNull = txt_Waiting
                                  , waterlevelNull = txt_Waiting
                                  , condNull = txt_Waiting
                                  , doNull = txt_Waiting
                                  , doadjNull = txt_Waiting
                                  , dopctsatNull = txt_Waiting
                                  , pHNull = txt_Waiting
                                  , turbidityNull = txt_Waiting
                                  , chlaNull = txt_Waiting
                                  )

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
    fileAttribsFull <- data.frame(filename = character()
                                  , stationID = character()
                                  , startDate = as.Date(character())
                                  , endDate = as.Date(character())
                                  , recordCount = as.integer()
                                  , waterTempNull = character()
                                  , airTempNull = character()
                                  , waterPressureNull = character()
                                  , airPressureNull = character()
                                  , sensorDepthNull = character()
                                  , dischargeNull = character()
                                  , waterlevelNull = character()
                                  , condNull = character()
                                  , doNull = character()
                                  , doadjNull = character()
                                  , dopctsatNull = character()
                                  , pHNull = character()
                                  , turbidityNull = character()
                                  , chlaNull = character()
                                  )

    #Column names for the table
    summColNames <- c("File name"
                      ,"Station ID"
                      , "Starting date"
                      , "Ending date"
                      , "Record count"
                      , "Water temperature"
                      , "Air temperature"
                      , "Water pressure"
                      , "Air pressure"
                      , "Sensor depth"
                      , "Discharge"
                      , "WaterLevel"
                      , "Conductivity"
                      , "DO"
                      , "DO, adj"
                      , "DO, % Saturation"
                      , "pH"
                      , "Turbidity"
                      , "Chlorophyll a")

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

    col_start <- 6
    col_end <- 12

    #Shows the table headings before files are input
    if (is.null(allFiles())) {

      #Subsets the columns of the pre-upload data for display
      nullTable2 <- fileAttribsNull()[c(1, col_start:col_end)]

      #Sends the empty table to be displayed
      return(nullTable2)
    }

    #Subsets the file attribute table with just
    #file name, water/air temp, water/air pressure, sensor depth,
    #gage height, and flow
    summaryTable2 <- fileAttribsFull()[,c(1, col_start:col_end)]
  colnames(summaryTable2) <- colnames(fileAttribsFull()[c(1,col_start:col_end)])

    return(summaryTable2)
  })

  #Outputs a summary table with file name and whether each data
  #type was found.
  #Each input spreadsheet gets one row.
  output$summaryTable2 <- renderTable({
    table2()
  })

  #Creates a summary data.frame as a reactive object
  #This table includes file name and which data types were found in each file
  table3 <- reactive({

    col_start <- 13
    col_end <- 19 #19

    #Shows the table headings before files are input
    if (is.null(allFiles())) {

      #Subsets the columns of the pre-upload data for display
      nullTable3 <- fileAttribsNull()[c(1, col_start:col_end)]

      #Sends the empty table to be displayed
      return(nullTable3)
    }

    #Subsets the file attribute table with just
    #file name, water/air temp, water/air pressure, sensor depth,
    #gage height, and flow
    summaryTable3 <- fileAttribsFull()[,c(1, col_start:col_end)]
    colnames(summaryTable3) <- colnames(fileAttribsFull()[c(1, col_start:col_end)])

    return(summaryTable3)
  })

  #Outputs a summary table with file name and whether each data
  #type was found.
  #Each input spreadsheet gets one row.
  output$summaryTable3 <- renderTable({
    table3()
  })

  # Run, buttons ----
  ## Run, HOBO, button ----
  output$ui.runProcess_HOBO <- renderUI({
    if (is.null(allFiles_HOBO())) return() # Hidden unless upload files
    #operation <- "formatHOBO"
    actionButton("runProcess_HOBO", "Reformat HOBOware file(s)")
  })

  ## Run, miniDOT_cat, button ----
  output$ui.runProcess_miniDOT_cat <- renderUI({
    if (is.null(allFiles_miniDOT_cat())) return() # Hidden unless upload files
    #operation <- "miniDOT_cat"
    actionButton("runProcess_miniDOT_cat", "Concatenate miniDOT file(s)")
  })

  ## Run, miniDOT_reformat, button ----
  output$ui.runProcess_miniDOT_reformat <- renderUI({
    if (is.null(allFiles_miniDOT_reformat())) return() # Hidden unless upload files
    #operation <- "miniDOT_reformat"
    actionButton("runProcess_miniDOT_reformat", "Reformat miniDOT file(s)")
  })

  ## Run Operation, button ----
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
      return(paste("WARNING: The spreadsheets you have selected for the
                   aggregate process include more than one site.  Please make
                   sure all input spreadsheets are from the same site."))
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
      #Copies the uploaded configuration file from where it was uploaded to
      #                 into the working directory.
      #The config file must be in the working directory for this to work.
      copy.from2 <- file.path(input$configFile$datapath)
      #copy.to2 <- file.path(getwd(), input$configFile$name)
      copy.to2 <- file.path("data", input$configFile$name)
      file.copy(copy.from2, copy.to2)

      #Makes the configuration object refer to the uploaded configuration file
      #config <- file.path(getwd(), input$configFile$name)
      config <- file.path("data", input$configFile$name)

    } else {
    #If no configuration file has been uploaded, the default is used


      #Deletes the uploaded configuration file, if there is one
      #file.remove(file.path(getwd(), input$configFile$name))
      file.remove(file.path("data", input$configFile$name))

      # config <- system.file("extdata", "Config.COLD.R", package="ContDataQC")
      #config <- system.file("extdata", "Config.ORIG.R", package="ContDataQC")
      config <- file.path(".", "www", "Config.R")

    }## IF ~ config_type ~ END

    #Creates a data.frame for the R console output of the ContDataQC() script
    console$disp <- data.frame(consoleOutput = character())

    HOBO_DateFormat_User <- input$HOBO_DateFormat

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
                                 , fun.HoboDateFormat = HOBO_DateFormat_User
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

  # Run, miniDOT_cat, code ----
  observeEvent(input$runProcess_miniDOT_cat, {

    # Remove files in "miniDOT_cat" folder
    message("Remove File, miniDOT_cat")
    file.remove(normalizePath(list.files(file.path("miniDOT_cat"), full.names = TRUE)))

    #Moves the user-selected input files from the default upload folder to Shiny's working directory
    message("Copy")
    copy.from <- file.path(UserFile_Path_miniDOT_cat())
    #copy.to <- file.path(getwd(), UserFile_Name())
    copy.to <- file.path("miniDOT_cat", UserFile_Name_miniDOT_cat())
    file.copy(copy.from, copy.to)

    #Allows users to use their own configuration/threshold files for QC.
    #Copies the status of the config file to this event.
    config_type <- config$x

    #Temporary location for the config file
    config <- file.path(".", "data")

    #If a configuration file has been uploaded, the app uses it
    if (config_type == "uploaded") {
      #Copies the uploaded configuration file from where it was uploaded to
      #                 into the working directory.
      #The config file must be in the working directory for this to work.
      copy.from2 <- file.path(input$configFile$datapath)
      #copy.to2 <- file.path(getwd(), input$configFile$name)
      copy.to2 <- file.path("data", input$configFile$name)
      file.copy(copy.from2, copy.to2)

      #Makes the configuration object refer to the uploaded configuration file
      #config <- file.path(getwd(), input$configFile$name)
      config <- file.path("data", input$configFile$name)

    } else {
      #If no configuration file has been uploaded, the default is used


      #Deletes the uploaded configuration file, if there is one
      #file.remove(file.path(getwd(), input$configFile$name))
      file.remove(file.path("data", input$configFile$name))

      # config <- system.file("extdata", "Config.COLD.R", package="ContDataQC")
      #config <- system.file("extdata", "Config.ORIG.R", package="ContDataQC")
      config <- file.path(".", "www", "Config.R")

    }## IF ~ config_type ~ END

    #Creates a data.frame for the R console output of the ContDataQC() script
    console$disp <- data.frame(consoleOutput = character())

    withProgress(message = paste("Running, runProcess_miniDOT_reformat"), value = 0, {

      #A short pause before the operation begins
      Sys.sleep(2)

      #Creates a vector of filenames
      fileNameVector <-  as.vector(UserFile_Name_miniDOT_cat())
      message("File Name Vector")
      message(paste(fileNameVector, collapse = ", "))

      #Changes the status bar to say that aggregation is occurring
      incProgress(0, detail = paste("miniDOT_cat ", length(fileNameVector), " files"))

      #Saves the R console output of ContDataQC()
      consoleRow <- capture.output(

        message("Run function")
        , message("dir import")
        , message(file.path("miniDOT_cat"))
        # Run function miniDOT_cat
        , ContDataQC::minidot_cat(folderpath = file.path("miniDOT_cat")
                                , savetofolder = file.path("miniDOT_cat")

        ) # miniDOT_cat ~ END
      )## consoleRow ~ END

      #Appends the R console output generated from that input file to the
      #console output data.frame
      consoleRow <- data.frame(consoleRow)
      console$disp <- rbind(console$disp, consoleRow)

      #Fills in the progress bar once the operation is complete
      incProgress(1, detail = paste("Finished miniDOT_cat files"))

      #Pauses the progress bar once it's done
      Sys.sleep(2)

      #Names the single column of the R console output data.frame
      colnames(console$disp) <- c(paste("R console messages for miniDOT_Cat"))

      #unhide download button


    })# with progress ~ END

    # })

  })## observerEvent ~ runProcess_miniDOT_cat ~ END

  # Run, miniDOT_reformat, code ----
  observeEvent(input$runProcess_miniDOT_reformat, {

    # Remove files in "miniDOT_reformat" folder
    message("Remove File, miniDOT_reformat")
    file.remove(normalizePath(list.files(file.path("miniDOT_reformat"), full.names = TRUE)))

    #Moves the user-selected input files from the default upload folder to Shiny's working directory
    message("Copy")
    copy.from <- file.path(UserFile_Path_miniDOT_reformat())
    #copy.to <- file.path(getwd(), UserFile_Name())
    copy.to <- file.path("miniDOT_reformat", UserFile_Name_miniDOT_reformat())
    file.copy(copy.from, copy.to)

    #Allows users to use their own configuration/threshold files for QC.
    #Copies the status of the config file to this event.
    config_type <- config$x

    #Temporary location for the config file
    config <- file.path(".", "data")

    #If a configuration file has been uploaded, the app uses it
    if (config_type == "uploaded") {
      #Copies the uploaded configuration file from where it was uploaded to
      #                 into the working directory.
      #The config file must be in the working directory for this to work.
      copy.from2 <- file.path(input$configFile$datapath)
      #copy.to2 <- file.path(getwd(), input$configFile$name)
      copy.to2 <- file.path("data", input$configFile$name)
      file.copy(copy.from2, copy.to2)

      #Makes the configuration object refer to the uploaded configuration file
      #config <- file.path(getwd(), input$configFile$name)
      config <- file.path("data", input$configFile$name)

    } else {
      #If no configuration file has been uploaded, the default is used


      #Deletes the uploaded configuration file, if there is one
      #file.remove(file.path(getwd(), input$configFile$name))
      file.remove(file.path("data", input$configFile$name))

      # config <- system.file("extdata", "Config.COLD.R", package="ContDataQC")
      #config <- system.file("extdata", "Config.ORIG.R", package="ContDataQC")
      config <- file.path(".", "www", "Config.R")

    }## IF ~ config_type ~ END

    #Creates a data.frame for the R console output of the ContDataQC() script
    console$disp <- data.frame(consoleOutput = character())

    withProgress(message = paste("Running, miniDOT_reformat"), value = 0, {

      #A short pause before the operation begins
      Sys.sleep(2)

      #Creates a vector of filenames
      fileNameVector <-  as.vector(UserFile_Name_miniDOT_reformat())
      message("File Name Vector")
      message(fileNameVector)

      #Changes the status bar to say that aggregation is occurring
      incProgress(0, detail = paste("miniDOT_reformat ", length(fileNameVector), " files"))

      #Saves the R console output of ContDataQC()
      consoleRow <- capture.output(

        message("Run function")
        ,message("dir import")
        ,message(file.path("miniDOT_reformat"))
        # Run function miniDOT_reformat
        ,ContDataQC::format_minidot(fun.myFile = fileNameVector
                                , fun.myDir.import = file.path("miniDOT_reformat")
                                , fun.myDir.export = file.path("miniDOT_reformat")

                                , fun.myConfig = config
        ) # format_minidot ~ END
      )## consoleRow ~ END

      #Appends the R console output generated from that input file to the
      #console output data.frame
      consoleRow <- data.frame(consoleRow)
      console$disp <- rbind(console$disp, consoleRow)

      #Fills in the progress bar once the operation is complete
      incProgress(1, detail = paste("Finished miniDOT_reformat files"))

      #Pauses the progress bar once it's done
      Sys.sleep(2)

      #Names the single column of the R console output data.frame
      colnames(console$disp) <- c(paste("R console messages for format_miniDOT"))

      #unhide download button


    })# with progress ~ END

    # })

  })## observerEvent ~ runProcess_miniDOT_reformat ~ END

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
      #Aggregating files requires having all the file names in a single string
      # input for fun.myFile. Thus, all files selected to be aggregated have
      # their names put into a string.
      if (operation == "Aggregate") {

        #Creates a vector of filenames
        fileNameVector <-  as.vector(UserFile_Name())

        #Changes the status bar to say that aggregation is occurring
        incProgress(0, detail = paste("Aggregating "
                                      , length(fileNameVector)
                                      , " files"))

        #Saves the R console output of ContDataQC()
        consoleRow <- capture.output(
                        #Run aggregation part of ContDataQC() on the input files
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
        colnames(console$disp) <- c(paste("R console messages for "
                                          , input$Operation))

        #Renames the output aggregation files so that the "append_x" is replaced
        #with the ending date
        #aggRenamed <- renameAggOutput(file.path(".", "data")
        #                               , fileAttribsFull())

      }

      # _QCRaw ----
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

  # Download ----
  ## Download, HOBO ----
  output$ui.downloadData_HOBO <- renderUI({
    if (is.null(console$disp)) return()
    downloadButton("downloadData_HOBO", "Download")
  })## ui.downloadData ~ END


  output$downloadData_HOBO <- downloadHandler(
    # _zip-HOBO ----
    #Names the zip file
    filename <- function() {
      paste0("format_HOBO_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip")
    },
    #Zips the output files
    content <- function(fname) {
      #Lists only the csv and html files on the server
      files2zip <- file.path("HOBO"
                             , list.files("HOBO"))
      #Zips the files
      zip(zipfile = fname, files = files2zip)
    }# content ~ END
    ,contentType = "application/zip"
  )

  ## Download, miniDOT_cat ----
  output$ui.downloadData_miniDOT_cat <- renderUI({
    if (is.null(console$disp)) return()
    downloadButton("downloadData_miniDOT_cat", "Download")
  })## ui.downloadData ~ END

  ### _zip-miniDOT_cat ----
  output$downloadData_miniDOT_cat <- downloadHandler(

    #Names the zip file
    filename <- function() {
      paste0("miniDOT_cat_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip")
    },
    #Zips the output files
    content <- function(fname) {
      #Lists only the csv files (input was txt)
      files2zip <- file.path("miniDOT_cat"
                             , list.files("miniDOT_cat", pattern = "csv$"))
      #Zips the files
      zip(zipfile = fname, files = files2zip)
    }# content ~ END
    ,contentType = "application/zip"
  )

  ## Download, miniDOT_reformat ----
  output$ui.downloadData_miniDOT_reformat <- renderUI({
    if (is.null(console$disp)) return()
    downloadButton("downloadData_miniDOT_reformat", "Download")
  })## ui.downloadData ~ END

  ### _zip-miniDOT_reformat ----
  output$downloadData_miniDOT_reformat <- downloadHandler(

    #Names the zip file
    filename <- function() {
      paste0("miniDOT_reformat_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip")
    },
    #Zips the output files
    content <- function(fname) {
      # Saved export file with same name as input file
      files2zip <- file.path("miniDOT_reformat"
                             , list.files("miniDOT_reformat"))
      #Zips the files
      zip(zipfile = fname, files = files2zip)
    }# content ~ END
    ,contentType = "application/zip"
  )

  ## Download, Remove files ----
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

    ### _zip-qc ----
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
          zip.csv  <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = "QC.*csv")
          zip.docx <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = "QC.*docx")
          zip.html <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = "QC.*html")
          files2zip <- file.path("data"
                                 , c(zip.csv, zip.docx, zip.html)
                                 #, full.names = FALSE
                                 )

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
          zip.csv  <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = "DATA.*csv")
          zip.docx <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = ".*docx")
          zip.html <- dir(file.path("data")
                          #, full.names = FALSE
                          , pattern = ".*html")
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
          zip.csv_DV    <- dir(file.path("data")
                               , full.names = FALSE
                               , pattern = "DV.*csv")
          zip.csv_STATS <- dir(file.path("data")
                               , full.names = FALSE
                               , pattern = "STATS.*csv")
          zip.pdf       <- dir(file.path("data")
                               , full.names = FALSE
                               , pattern = ".*pdf")
          files2zip <- file.path("data"
                                 , c(zip.csv_DV, zip.csv_STATS, zip.pdf))

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
    colnames(consoleUSGS$disp) <- "R console messages for all USGS data retrieval:"

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
        zip.csv <- dir(file.path("data")
                       #, full.names = TRUE
                       , pattern = ".*Gage.*csv")
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
    colnames(onServerTableOutput) <- "Files currently on server"
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

  # QC Threshold Edits ####

  # Source the config.R environment
  # source("www/Config.R")

  # Read in dataset
  df_Config <- read.table("www/Config.R", sep = "|", quote = "")

  # df_Config <- read.table("R/Config.R", sep = "|", quote = "")

  # Create custom configuration table for output
  df_Config_Custom <- df_Config
  df_Config_Custom <- data.frame(df_Config_Custom,do.call(rbind,strsplit(df_Config_Custom$V1,"<- ")))

  # rename columns
  names(df_Config_Custom)[names(df_Config_Custom) == "V1"] <- "Orig"
  names(df_Config_Custom)[names(df_Config_Custom) == "X1"] <- "Variable"
  names(df_Config_Custom)[names(df_Config_Custom) == "X2"] <- "Value"

  # change value to numeric
  suppressWarnings(df_Config_Custom$Value <- as.numeric(df_Config_Custom$Value))

  # Update with defaults
  Loc.myDefault.RoC.SD.number<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myDefault.RoC.SD.number"))
  Loc.myDefault.RoC.SD.period<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myDefault.RoC.SD.period"))
  Loc.myDefault.Flat.Hi<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myDefault.Flat.Hi"))
  Loc.myDefault.Flat.Lo<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myDefault.Flat.Lo"))

  # Updated values for all Rate of Change values
  Loc.myThresh.RoC.SD.number<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myThresh.RoC.SD.number"))
  df_Config_Custom[Loc.myThresh.RoC.SD.number,3] <- df_Config_Custom[Loc.myDefault.RoC.SD.number,3]

  Loc.myThresh.RoC.SD.period<- which(startsWith(df_Config_Custom$Variable, "ContData.env$myThresh.RoC.SD.period"))
  df_Config_Custom[Loc.myThresh.RoC.SD.period,3] <- df_Config_Custom[Loc.myDefault.RoC.SD.period,3]

  # Create reactive data frame

  df_Config_react <- reactiveValues(df = df_Config_Custom)

  ## Parameter Units ####
  output$QC_Param_Unit <- renderText({
    if(input$QC_Param_Input == "AirTemp"|input$QC_Param_Input == "WaterTemp"){
      return("Parameter Unit: deg C")
    } else if(input$QC_Param_Input == "AirBP"|input$QC_Param_Input == "WaterP"){
      return("Parameter Unit: psi")
    } else if(input$QC_Param_Input == "SensDepth"){
      return("Parameter Unit: ft")
    } else if(input$QC_Param_Input == "Discharge"){
      return("Parameter Unit: ft3/s")
    } else if(input$QC_Param_Input == "Cond"){
      return("Parameter Unit: uS/cm")
    } else if(input$QC_Param_Input == "DO"|input$QC_Param_Input == "DOadj"){
      return("Parameter Unit: mg/L")
    } else if(input$QC_Param_Input == "DOpctsat"){
      return("Parameter Unit: %")
    } else if(input$QC_Param_Input == "pH"){
      return("Parameter Unit: SU")
    } else if(input$QC_Param_Input == "Turbid"){
      return("Parameter Unit: NTU")
    } else if(input$QC_Param_Input == "Chla"){
      return("Parameter Unit: g/cm3")
    } else if(input$QC_Param_Input == "WtrLvl"){
      return("Parameter Unit: ft")
    } else {
      return("Parameter Unit Missing")
    } # else if ~ END
  }) #renderText

  ## Config.R locations ####

  # Identify locations
  ### AirTemp ####
  Loc.Gross.Fail.Hi.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.AirTemp"))
  Loc.Gross.Fail.Lo.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.AirTemp"))
  Loc.Gross.Suspect.Hi.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.AirTemp"))
  Loc.Gross.Suspect.Lo.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.AirTemp"))
  Loc.Spike.Hi.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.AirTemp"))
  Loc.Spike.Lo.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.AirTemp"))
  Loc.RoC.SD.number.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.AirTemp"))
  Loc.RoC.SD.period.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.AirTemp"))
  Loc.Flat.Hi.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.AirTemp"))
  Loc.Flat.Lo.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.AirTemp"))
  Loc.Flat.Tolerance.AirTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.AirTemp"))
  ### AirBP ####
  Loc.Gross.Fail.Hi.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.AirBP"))
  Loc.Gross.Fail.Lo.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.AirBP"))
  Loc.Gross.Suspect.Hi.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.AirBP"))
  Loc.Gross.Suspect.Lo.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.AirBP"))
  Loc.Spike.Hi.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.AirBP"))
  Loc.Spike.Lo.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.AirBP"))
  Loc.RoC.SD.number.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.AirBP"))
  Loc.RoC.SD.period.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.AirBP"))
  Loc.Flat.Hi.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.AirBP"))
  Loc.Flat.Lo.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.AirBP"))
  Loc.Flat.Tolerance.AirBP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.AirBP"))
  ### Chla ####
  Loc.Gross.Fail.Hi.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.Chlorophylla"))
  Loc.Gross.Fail.Lo.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.Chlorophylla"))
  Loc.Gross.Suspect.Hi.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.Chlorophylla"))
  Loc.Gross.Suspect.Lo.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.Chlorophylla"))
  Loc.Spike.Hi.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.Chlorophylla"))
  Loc.Spike.Lo.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.Chlorophylla"))
  Loc.RoC.SD.number.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.Chlorophylla"))
  Loc.RoC.SD.period.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.Chlorophylla"))
  Loc.Flat.Hi.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.Chlorophylla"))
  Loc.Flat.Lo.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.Chlorophylla"))
  Loc.Flat.Tolerance.Chlorophylla<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.Chlorophylla"))
  ### Cond ####
  Loc.Gross.Fail.Hi.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.Cond"))
  Loc.Gross.Fail.Lo.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.Cond"))
  Loc.Gross.Suspect.Hi.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.Cond"))
  Loc.Gross.Suspect.Lo.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.Cond"))
  Loc.Spike.Hi.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.Cond"))
  Loc.Spike.Lo.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.Cond"))
  Loc.RoC.SD.number.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.Cond"))
  Loc.RoC.SD.period.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.Cond"))
  Loc.Flat.Hi.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.Cond"))
  Loc.Flat.Lo.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.Cond"))
  Loc.Flat.Tolerance.Cond<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.Cond"))
  ### Discharge ####
  Loc.Gross.Fail.Hi.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.Discharge"))
  Loc.Gross.Fail.Lo.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.Discharge"))
  Loc.Gross.Suspect.Hi.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.Discharge"))
  Loc.Gross.Suspect.Lo.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.Discharge"))
  Loc.Spike.Hi.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.Discharge"))
  Loc.Spike.Lo.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.Discharge"))
  Loc.RoC.SD.number.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.Discharge"))
  Loc.RoC.SD.period.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.Discharge"))
  Loc.Flat.Hi.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.Discharge"))
  Loc.Flat.Lo.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.Discharge"))
  Loc.Flat.Tolerance.Discharge<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.Discharge"))
  ### DO ####
  Loc.Gross.Fail.Hi.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.DO           <-"))
  Loc.Gross.Fail.Lo.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.DO           <-"))
  Loc.Gross.Suspect.Hi.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.DO           <-"))
  Loc.Gross.Suspect.Lo.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.DO           <-"))
  Loc.Spike.Hi.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.DO           <-"))
  Loc.Spike.Lo.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.DO           <-"))
  Loc.RoC.SD.number.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.DO           <-"))
  Loc.RoC.SD.period.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.DO           <-"))
  Loc.Flat.Hi.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.DO                  <-"))
  Loc.Flat.Lo.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.DO                  <-"))
  Loc.Flat.Tolerance.DO<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.DO           <-"))
  ### DOadj ####
  Loc.Gross.Fail.Hi.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.DO.adj"))
  Loc.Gross.Fail.Lo.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.DO.adj"))
  Loc.Gross.Suspect.Hi.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.DO.adj"))
  Loc.Gross.Suspect.Lo.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.DO.adj"))
  Loc.Spike.Hi.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.DO.adj"))
  Loc.Spike.Lo.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.DO.adj"))
  Loc.RoC.SD.number.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.DO.adj"))
  Loc.RoC.SD.period.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.DO.adj"))
  Loc.Flat.Hi.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.DO.adj"))
  Loc.Flat.Lo.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.DO.adj"))
  Loc.Flat.Tolerance.DO.adj<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.DO.adj"))
  ### DOpctsat ####
  Loc.Gross.Fail.Hi.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.DO.pctsat"))
  Loc.Gross.Fail.Lo.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.DO.pctsat"))
  Loc.Gross.Suspect.Hi.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.DO.pctsat"))
  Loc.Gross.Suspect.Lo.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.DO.pctsat"))
  Loc.Spike.Hi.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.DO.pctsat"))
  Loc.Spike.Lo.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.DO.pctsat"))
  Loc.RoC.SD.number.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.DO.pctsat"))
  Loc.RoC.SD.period.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.DO.pctsat"))
  Loc.Flat.Hi.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.DO.pctsat"))
  Loc.Flat.Lo.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.DO.pctsat"))
  Loc.Flat.Tolerance.DO.pctsat<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.DO.pctsat"))
  ### pH ####
  Loc.Gross.Fail.Hi.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.pH"))
  Loc.Gross.Fail.Lo.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.pH"))
  Loc.Gross.Suspect.Hi.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.pH"))
  Loc.Gross.Suspect.Lo.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.pH"))
  Loc.Spike.Hi.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.pH"))
  Loc.Spike.Lo.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.pH"))
  Loc.RoC.SD.number.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.pH"))
  Loc.RoC.SD.period.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.pH"))
  Loc.Flat.Hi.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.pH"))
  Loc.Flat.Lo.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.pH"))
  Loc.Flat.Tolerance.pH<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.pH"))
  ### SensDepth ####
  Loc.Gross.Fail.Hi.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.SensorDepth"))
  Loc.Gross.Fail.Lo.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.SensorDepth"))
  Loc.Gross.Suspect.Hi.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth"))
  Loc.Gross.Suspect.Lo.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.SensorDepth"))
  Loc.Spike.Hi.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.SensorDepth"))
  Loc.Spike.Lo.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.SensorDepth"))
  Loc.RoC.SD.number.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.SensorDepth"))
  Loc.RoC.SD.period.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.SensorDepth"))
  Loc.Flat.Hi.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.SensorDepth"))
  Loc.Flat.Lo.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.SensorDepth"))
  Loc.Flat.Tolerance.SensorDepth<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.SensorDepth"))
  ### Turbid ####
  Loc.Gross.Fail.Hi.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.Turbidity"))
  Loc.Gross.Fail.Lo.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.Turbidity"))
  Loc.Gross.Suspect.Hi.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.Turbidity"))
  Loc.Gross.Suspect.Lo.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.Turbidity"))
  Loc.Spike.Hi.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.Turbidity"))
  Loc.Spike.Lo.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.Turbidity"))
  Loc.RoC.SD.number.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.Turbidity"))
  Loc.RoC.SD.period.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.Turbidity"))
  Loc.Flat.Hi.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.Turbidity"))
  Loc.Flat.Lo.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.Turbidity"))
  Loc.Flat.Tolerance.Turbidity<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.Turbidity"))
  ### WtrLvl ####
  Loc.Gross.Fail.Hi.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.WaterLevel"))
  Loc.Gross.Fail.Lo.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.WaterLevel"))
  Loc.Gross.Suspect.Hi.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.WaterLevel"))
  Loc.Gross.Suspect.Lo.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.WaterLevel"))
  Loc.Spike.Hi.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.WaterLevel"))
  Loc.Spike.Lo.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.WaterLevel"))
  Loc.RoC.SD.number.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.WaterLevel"))
  Loc.RoC.SD.period.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.WaterLevel"))
  Loc.Flat.Hi.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.WaterLevel"))
  Loc.Flat.Lo.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.WaterLevel"))
  Loc.Flat.Tolerance.WaterLevel<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.WaterLevel"))
  ### WaterP ####
  Loc.Gross.Fail.Hi.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.WaterP"))
  Loc.Gross.Fail.Lo.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.WaterP"))
  Loc.Gross.Suspect.Hi.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.WaterP"))
  Loc.Gross.Suspect.Lo.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.WaterP"))
  Loc.Spike.Hi.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.WaterP"))
  Loc.Spike.Lo.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.WaterP"))
  Loc.RoC.SD.number.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.WaterP"))
  Loc.RoC.SD.period.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.WaterP"))
  Loc.Flat.Hi.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.WaterP"))
  Loc.Flat.Lo.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.WaterP"))
  Loc.Flat.Tolerance.WaterP<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.WaterP"))
  ### WaterTemp ####
  Loc.Gross.Fail.Hi.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Hi.WaterTemp"))
  Loc.Gross.Fail.Lo.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Fail.Lo.WaterTemp"))
  Loc.Gross.Suspect.Hi.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp"))
  Loc.Gross.Suspect.Lo.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp"))
  Loc.Spike.Hi.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Hi.WaterTemp"))
  Loc.Spike.Lo.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Spike.Lo.WaterTemp"))
  Loc.RoC.SD.number.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.number.WaterTemp"))
  Loc.RoC.SD.period.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.RoC.SD.period.WaterTemp"))
  Loc.Flat.Hi.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Hi.WaterTemp"))
  Loc.Flat.Lo.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Lo.WaterTemp"))
  Loc.Flat.Tolerance.WaterTemp<- which(startsWith(df_Config$V1, "ContData.env$myThresh.Flat.Tolerance.WaterTemp"))

  ## Dynamic inputs ####
  # create dynamic input values based on parameter

  observeEvent(input$QC_Param_Input, {

    ### AirTemp ####
    if(input$QC_Param_Input == "AirTemp"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.AirTemp,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.AirTemp,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.AirTemp,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.AirTemp,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.AirTemp,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.AirTemp,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.AirTemp,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.AirTemp,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.AirTemp,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.AirTemp,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.AirTemp,3])

    ## AirBP ####
    } else if (input$QC_Param_Input == "AirBP"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.AirBP,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.AirBP,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.AirBP,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.AirBP,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.AirBP,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.AirBP,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.AirBP,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.AirBP,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.AirBP,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.AirBP,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.AirBP,3])

      ### Chla ####
    } else if (input$QC_Param_Input == "Chla"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.Chlorophylla,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.Chlorophylla,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.Chlorophylla,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.Chlorophylla,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.Chlorophylla,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.Chlorophylla,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.Chlorophylla,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.Chlorophylla,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.Chlorophylla,3])

      ### Cond ####
    } else if (input$QC_Param_Input == "Cond"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.Cond,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.Cond,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.Cond,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.Cond,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.Cond,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.Cond,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.Cond,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.Cond,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.Cond,3])

      ### Discharge ####
    } else if (input$QC_Param_Input == "Discharge"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.Discharge,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.Discharge,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.Discharge,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.Discharge,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.Discharge,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.Discharge,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.Discharge,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.Discharge,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.Discharge,3])

      ### DO ####
    } else if (input$QC_Param_Input == "DO"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.DO,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.DO,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.DO,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.DO,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.DO,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.DO,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.DO,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.DO,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.DO,3])

      ### DOadj ####
    } else if (input$QC_Param_Input == "DOadj"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.DO.adj,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.DO.adj,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.DO.adj,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.DO.adj,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.DO.adj,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.DO.adj,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.DO.adj,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.DO.adj,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.DO.adj,3])

      ### DOpctsat ####
    } else if (input$QC_Param_Input == "DOpctsat"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.DO.pctsat,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.DO.pctsat,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.DO.pctsat,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.DO.pctsat,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.DO.pctsat,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.DO.pctsat,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.DO.pctsat,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.DO.pctsat,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.DO.pctsat,3])

      ### pH ####
    } else if (input$QC_Param_Input == "pH"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.pH,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.pH,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.pH,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.pH,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.pH,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.pH,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.pH,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.pH,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.pH,3])

      ### SensDepth ####
    } else if (input$QC_Param_Input == "SensDepth"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.SensorDepth,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.SensorDepth,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.SensorDepth,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.SensorDepth,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.SensorDepth,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.SensorDepth,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.SensorDepth,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.SensorDepth,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.SensorDepth,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.SensorDepth,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.SensorDepth,3])

      ### Turbid ####
    } else if (input$QC_Param_Input == "Turbid"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.Turbidity,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.Turbidity,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.Turbidity,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.Turbidity,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.Turbidity,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.Turbidity,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.Turbidity,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.Turbidity,3])
      updateNumericInput(session, "Flat_Fail", value = (df_Config_react$df[Loc.myDefault.Flat.Hi,3])*2)
      updateNumericInput(session, "Flat_Sus", value = (df_Config_react$df[Loc.myDefault.Flat.Lo,3])*2)
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.Turbidity,3])

      ### WtrLvl ####
    } else if (input$QC_Param_Input == "WtrLvl"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.SensorDepth,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.SensorDepth,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.SensorDepth,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.SensorDepth,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.SensorDepth,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.SensorDepth,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.WaterLevel,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.WaterLevel,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.SensorDepth,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.SensorDepth,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.SensorDepth,3])

      ### WaterP ####
    } else if (input$QC_Param_Input == "WaterP"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.WaterP,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.WaterP,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.WaterP,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.WaterP,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.WaterP,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.WaterP,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.WaterP,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.WaterP,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.WaterP,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.WaterP,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.WaterP,3])

      ### WaterTemp ####
    } else if (input$QC_Param_Input == "WaterTemp"){
      updateNumericInput(session, "GR_Fail_Max", value = df_Config_react$df[Loc.Gross.Fail.Hi.WaterTemp,3])
      updateNumericInput(session, "GR_Fail_Min", value = df_Config_react$df[Loc.Gross.Fail.Lo.WaterTemp,3])
      updateNumericInput(session, "GR_Sus_Max", value = df_Config_react$df[Loc.Gross.Suspect.Hi.WaterTemp,3])
      updateNumericInput(session, "GR_Sus_Min", value = df_Config_react$df[Loc.Gross.Suspect.Lo.WaterTemp,3])
      updateNumericInput(session, "Spike_Fail", value = df_Config_react$df[Loc.Spike.Hi.WaterTemp,3])
      updateNumericInput(session, "Spike_Sus", value = df_Config_react$df[Loc.Spike.Lo.WaterTemp,3])
      updateNumericInput(session, "RoC_SDs", value = df_Config_react$df[Loc.RoC.SD.number.WaterTemp,3])
      updateNumericInput(session, "RoC_Hrs", value = df_Config_react$df[Loc.RoC.SD.period.WaterTemp,3])
      updateNumericInput(session, "Flat_Fail", value = df_Config_react$df[Loc.Flat.Hi.WaterTemp,3])
      updateNumericInput(session, "Flat_Sus", value = df_Config_react$df[Loc.Flat.Lo.WaterTemp,3])
      updateNumericInput(session, "Flat_Toler", value = df_Config_react$df[Loc.Flat.Tolerance.WaterTemp,3])
    } else {
      return(NULL)
    } # if else ~ END
  }) # observeEvent

  ## Update Config.R ####
  observeEvent(input$QC_SaveBttn, {
    showNotification(paste0("Threshold changes saved!"),
                     type = "error", duration = 10)

    ### AirTemp ####
    if(input$QC_Param_Input == "AirTemp"){
      df_Config_react$df[Loc.Gross.Fail.Hi.AirTemp, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.AirTemp <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.AirTemp, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.AirTemp <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.AirTemp, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.AirTemp <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.AirTemp, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.AirTemp <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.AirTemp, 1] <- paste0("ContData.env$myThresh.Spike.Hi.AirTemp <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.AirTemp, 1] <- paste0("ContData.env$myThresh.Spike.Lo.AirTemp <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.AirTemp, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.AirTemp <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.AirTemp, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.AirTemp <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.AirTemp, 1] <- paste0("ContData.env$myThresh.Flat.Hi.AirTemp <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.AirTemp, 1] <- paste0("ContData.env$myThresh.Flat.Lo.AirTemp <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.AirTemp, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.AirTemp <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.AirTemp, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.AirTemp, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.AirTemp, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.AirTemp, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.AirTemp, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.AirTemp, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.AirTemp, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.AirTemp, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.AirTemp, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.AirTemp, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.AirTemp, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ## AirBP ####
    } else if(input$QC_Param_Input == "AirBP"){
      df_Config_react$df[Loc.Gross.Fail.Hi.AirBP, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.AirBP <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.AirBP, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.AirBP <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.AirBP, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.AirBP <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.AirBP, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.AirBP <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.AirBP, 1] <- paste0("ContData.env$myThresh.Spike.Hi.AirBP <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.AirBP, 1] <- paste0("ContData.env$myThresh.Spike.Lo.AirBP <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.AirBP, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.AirBP <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.AirBP, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.AirBP <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.AirBP, 1] <- paste0("ContData.env$myThresh.Flat.Hi.AirBP <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.AirBP, 1] <- paste0("ContData.env$myThresh.Flat.Lo.AirBP <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.AirBP, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.AirBP <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.AirBP, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.AirBP, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.AirBP, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.AirBP, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.AirBP, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.AirBP, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.AirBP, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.AirBP, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.AirBP, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.AirBP, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.AirBP, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### Chla ####
    } else if(input$QC_Param_Input == "Chla"){
      df_Config_react$df[Loc.Gross.Fail.Hi.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.Chlorophylla <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.Chlorophylla <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.Chlorophylla <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.Chlorophylla <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Spike.Hi.Chlorophylla <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Spike.Lo.Chlorophylla <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.Chlorophylla, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.Chlorophylla <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.Chlorophylla, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.Chlorophylla <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Flat.Hi.Chlorophylla <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Flat.Lo.Chlorophylla <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.Chlorophylla, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.Chlorophylla <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.Chlorophylla, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.Chlorophylla, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.Chlorophylla, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.Chlorophylla, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.Chlorophylla, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.Chlorophylla, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.Chlorophylla, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.Chlorophylla, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.Chlorophylla, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.Chlorophylla, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.Chlorophylla, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### Cond ####
    } else if(input$QC_Param_Input == "Cond"){
      df_Config_react$df[Loc.Gross.Fail.Hi.Cond, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.Cond <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.Cond, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.Cond <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.Cond, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.Cond <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.Cond, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.Cond <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.Cond, 1] <- paste0("ContData.env$myThresh.Spike.Hi.Cond <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.Cond, 1] <- paste0("ContData.env$myThresh.Spike.Lo.Cond <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.Cond, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.Cond <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.Cond, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.Cond <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.Cond, 1] <- paste0("ContData.env$myThresh.Flat.Hi.Cond <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.Cond, 1] <- paste0("ContData.env$myThresh.Flat.Lo.Cond <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.Cond, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.Cond <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.Cond, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.Cond, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.Cond, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.Cond, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.Cond, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.Cond, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.Cond, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.Cond, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.Cond, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.Cond, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.Cond, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### Discharge ####
    } else if(input$QC_Param_Input == "Discharge"){
      df_Config_react$df[Loc.Gross.Fail.Hi.Discharge, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.Discharge <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.Discharge, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.Discharge <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.Discharge, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.Discharge <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.Discharge, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.Discharge <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.Discharge, 1] <- paste0("ContData.env$myThresh.Spike.Hi.Discharge <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.Discharge, 1] <- paste0("ContData.env$myThresh.Spike.Lo.Discharge <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.Discharge, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.Discharge <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.Discharge, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.Discharge <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.Discharge, 1] <- paste0("ContData.env$myThresh.Flat.Hi.Discharge <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.Discharge, 1] <- paste0("ContData.env$myThresh.Flat.Lo.Discharge <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.Discharge, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.Discharge <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.Discharge, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.Discharge, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.Discharge, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.Discharge, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.Discharge, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.Discharge, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.Discharge, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.Discharge, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.Discharge, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.Discharge, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.Discharge, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### DO ####
    } else if(input$QC_Param_Input == "DO"){
      df_Config_react$df[Loc.Gross.Fail.Hi.DO, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.DO <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.DO, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.DO <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.DO <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.DO <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.DO, 1] <- paste0("ContData.env$myThresh.Spike.Hi.DO <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.DO, 1] <- paste0("ContData.env$myThresh.Spike.Lo.DO <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.DO, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.DO <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.DO, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.DO <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.DO, 1] <- paste0("ContData.env$myThresh.Flat.Hi.DO <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.DO, 1] <- paste0("ContData.env$myThresh.Flat.Lo.DO <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.DO, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.DO <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.DO, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.DO, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.DO, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.DO, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.DO, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.DO, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.DO, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.DO, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.DO, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### DOadj ####
    } else if(input$QC_Param_Input == "DOadj"){
      df_Config_react$df[Loc.Gross.Fail.Hi.DO.adj, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.DO.adj <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.DO.adj, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.DO.adj <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO.adj, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.DO.adj <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO.adj, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.DO.adj <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.DO.adj, 1] <- paste0("ContData.env$myThresh.Spike.Hi.DO.adj <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.DO.adj, 1] <- paste0("ContData.env$myThresh.Spike.Lo.DO.adj <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.DO.adj, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.DO.adj <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.DO.adj, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.DO.adj <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.DO.adj, 1] <- paste0("ContData.env$myThresh.Flat.Hi.DO.adj <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.DO.adj, 1] <- paste0("ContData.env$myThresh.Flat.Lo.DO.adj <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.DO.adj, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.DO.adj <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.DO.adj, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.DO.adj, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO.adj, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO.adj, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.DO.adj, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.DO.adj, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.DO.adj, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.DO.adj, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.DO.adj, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.DO.adj, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.DO.adj, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### DOpctsat ####
    } else if(input$QC_Param_Input == "DOpctsat"){
      df_Config_react$df[Loc.Gross.Fail.Hi.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.DO.pctsat <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.DO.pctsat <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.DO.pctsat <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.DO.pctsat <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Spike.Hi.DO.pctsat <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Spike.Lo.DO.pctsat <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.DO.pctsat, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.DO.pctsat <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.DO.pctsat, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.DO.pctsat <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Flat.Hi.DO.pctsat <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Flat.Lo.DO.pctsat <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.DO.pctsat, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.DO.pctsat <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.DO.pctsat, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.DO.pctsat, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.DO.pctsat, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.DO.pctsat, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.DO.pctsat, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.DO.pctsat, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.DO.pctsat, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.DO.pctsat, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.DO.pctsat, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.DO.pctsat, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.DO.pctsat, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### pH ####
    } else if(input$QC_Param_Input == "pH"){
      df_Config_react$df[Loc.Gross.Fail.Hi.pH, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.pH <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.pH, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.pH <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.pH, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.pH <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.pH, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.pH <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.pH, 1] <- paste0("ContData.env$myThresh.Spike.Hi.pH <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.pH, 1] <- paste0("ContData.env$myThresh.Spike.Lo.pH <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.pH, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.pH <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.pH, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.pH <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.pH, 1] <- paste0("ContData.env$myThresh.Flat.Hi.pH <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.pH, 1] <- paste0("ContData.env$myThresh.Flat.Lo.pH <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.pH, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.pH <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.pH, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.pH, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.pH, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.pH, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.pH, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.pH, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.pH, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.pH, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.pH, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.pH, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.pH, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### SensDepth ####
    } else if(input$QC_Param_Input == "SensDepth"){
      df_Config_react$df[Loc.Gross.Fail.Hi.SensorDepth, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.SensorDepth <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.SensorDepth, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.SensorDepth <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.SensorDepth, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.SensorDepth <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.SensorDepth, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.SensorDepth <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.SensorDepth, 1] <- paste0("ContData.env$myThresh.Spike.Hi.SensorDepth <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.SensorDepth, 1] <- paste0("ContData.env$myThresh.Spike.Lo.SensorDepth <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.SensorDepth, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.SensorDepth <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.SensorDepth, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.SensorDepth <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.SensorDepth, 1] <- paste0("ContData.env$myThresh.Flat.Hi.SensorDepth <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.SensorDepth, 1] <- paste0("ContData.env$myThresh.Flat.Lo.SensorDepth <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.SensorDepth, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.SensorDepth <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.SensorDepth, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.SensorDepth, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.SensorDepth, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.SensorDepth, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.SensorDepth, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.SensorDepth, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.SensorDepth, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.SensorDepth, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.SensorDepth, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.SensorDepth, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.SensorDepth, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### Turbid ####
    } else if(input$QC_Param_Input == "Turbid"){
      df_Config_react$df[Loc.Gross.Fail.Hi.Turbidity, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.Turbidity <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.Turbidity, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.Turbidity <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.Turbidity, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.Turbidity <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.Turbidity, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.Turbidity <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.Turbidity, 1] <- paste0("ContData.env$myThresh.Spike.Hi.Turbidity <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.Turbidity, 1] <- paste0("ContData.env$myThresh.Spike.Lo.Turbidity <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.Turbidity, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.Turbidity <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.Turbidity, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.Turbidity <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.Turbidity, 1] <- paste0("ContData.env$myThresh.Flat.Hi.Turbidity <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.Turbidity, 1] <- paste0("ContData.env$myThresh.Flat.Lo.Turbidity <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.Turbidity, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.Turbidity <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.Turbidity, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.Turbidity, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.Turbidity, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.Turbidity, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.Turbidity, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.Turbidity, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.Turbidity, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.Turbidity, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.Turbidity, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.Turbidity, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.Turbidity, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### WtrLvl ####
    } else if(input$QC_Param_Input == "WtrLvl"){
      df_Config_react$df[Loc.Gross.Fail.Hi.WaterLevel, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.WaterLevel <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterLevel, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.WaterLevel <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterLevel, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.WaterLevel <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterLevel, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.WaterLevel <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.WaterLevel, 1] <- paste0("ContData.env$myThresh.Spike.Hi.WaterLevel <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.WaterLevel, 1] <- paste0("ContData.env$myThresh.Spike.Lo.WaterLevel <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.WaterLevel, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.WaterLevel <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.WaterLevel, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.WaterLevel <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.WaterLevel, 1] <- paste0("ContData.env$myThresh.Flat.Hi.WaterLevel <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.WaterLevel, 1] <- paste0("ContData.env$myThresh.Flat.Lo.WaterLevel <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.WaterLevel, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.WaterLevel <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.WaterLevel, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterLevel, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterLevel, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterLevel, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.WaterLevel, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.WaterLevel, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.WaterLevel, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.WaterLevel, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.WaterLevel, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.WaterLevel, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.WaterLevel, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### WaterP ####
    } else if(input$QC_Param_Input == "WaterP"){
      df_Config_react$df[Loc.Gross.Fail.Hi.WaterP, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.WaterP <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterP, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.WaterP <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterP, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.WaterP <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterP, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.WaterP <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.WaterP, 1] <- paste0("ContData.env$myThresh.Spike.Hi.WaterP <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.WaterP, 1] <- paste0("ContData.env$myThresh.Spike.Lo.WaterP <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.WaterP, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.WaterP <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.WaterP, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.WaterP <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.WaterP, 1] <- paste0("ContData.env$myThresh.Flat.Hi.WaterP <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.WaterP, 1] <- paste0("ContData.env$myThresh.Flat.Lo.WaterP <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.WaterP, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.WaterP <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.WaterP, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterP, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterP, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterP, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.WaterP, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.WaterP, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.WaterP, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.WaterP, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.WaterP, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.WaterP, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.WaterP, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    ### WaterTemp ####
    } else if(input$QC_Param_Input == "WaterTemp"){
      df_Config_react$df[Loc.Gross.Fail.Hi.WaterTemp, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Hi.WaterTemp <- ", input$GR_Fail_Max)
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterTemp, 1] <- paste0("ContData.env$myThresh.Gross.Fail.Lo.WaterTemp <- ", input$GR_Fail_Min)
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterTemp, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Hi.WaterTemp <- ", input$GR_Sus_Max)
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterTemp, 1] <- paste0("ContData.env$myThresh.Gross.Suspect.Lo.WaterTemp <- ", input$GR_Sus_Min)
      df_Config_react$df[Loc.Spike.Hi.WaterTemp, 1] <- paste0("ContData.env$myThresh.Spike.Hi.WaterTemp <- ", input$Spike_Fail)
      df_Config_react$df[Loc.Spike.Lo.WaterTemp, 1] <- paste0("ContData.env$myThresh.Spike.Lo.WaterTemp <- ", input$Spike_Sus)
      df_Config_react$df[Loc.RoC.SD.number.WaterTemp, 1] <- paste0("ContData.env$myThresh.RoC.SD.number.WaterTemp <- ", input$RoC_SDs)
      df_Config_react$df[Loc.RoC.SD.period.WaterTemp, 1] <- paste0("ContData.env$myThresh.RoC.SD.period.WaterTemp <- ", input$RoC_Hrs)
      df_Config_react$df[Loc.Flat.Hi.WaterTemp, 1] <- paste0("ContData.env$myThresh.Flat.Hi.WaterTemp <- ", input$Flat_Fail)
      df_Config_react$df[Loc.Flat.Lo.WaterTemp, 1] <- paste0("ContData.env$myThresh.Flat.Lo.WaterTemp <- ", input$Flat_Sus)
      df_Config_react$df[Loc.Flat.Tolerance.WaterTemp, 1] <- paste0("ContData.env$myThresh.Flat.Tolerance.WaterTemp <- ", input$Flat_Toler)

      df_Config_react$df[Loc.Gross.Fail.Hi.WaterTemp, 3] <- input$GR_Fail_Max
      df_Config_react$df[Loc.Gross.Fail.Lo.WaterTemp, 3] <- input$GR_Fail_Min
      df_Config_react$df[Loc.Gross.Suspect.Hi.WaterTemp, 3] <- input$GR_Sus_Max
      df_Config_react$df[Loc.Gross.Suspect.Lo.WaterTemp, 3] <- input$GR_Sus_Min
      df_Config_react$df[Loc.Spike.Hi.WaterTemp, 3] <- input$Spike_Fail
      df_Config_react$df[Loc.Spike.Lo.WaterTemp, 3] <- input$Spike_Sus
      df_Config_react$df[Loc.RoC.SD.number.WaterTemp, 3] <- input$RoC_SDs
      df_Config_react$df[Loc.RoC.SD.period.WaterTemp, 3] <- input$RoC_Hrs
      df_Config_react$df[Loc.Flat.Hi.WaterTemp, 3] <- input$Flat_Fail
      df_Config_react$df[Loc.Flat.Lo.WaterTemp, 3] <- input$Flat_Sus
      df_Config_react$df[Loc.Flat.Tolerance.WaterTemp, 3] <- input$Flat_Toler

      df_print <- df_Config_react$df[, 1]

      ## Save file ###
      write.table(x = df_print, file = "www/QC_Custom_Config.tsv"
                  , sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

    } else {
      showNotification(paste0("ERROR"),
                       type = "error", duration = 60)
    } # if else ~ END
  }) # observeEvent

  # Download Buttons ----
  #https://stackoverflow.com/questions/33416557/r-shiny-download-existing-file
  #https://stackoverflow.com/questions/25247852/shiny-app-disable-downloadbutton

  # Start with download button disabled
  shinyjs::disable("QC_Thresh_Download")

  # Enable download button once save button is clicked at least once
  observe({
    if(input$QC_SaveBttn > 0){

      Sys.sleep(1)
      # enable the download button
      shinyjs::enable("QC_Thresh_Download")
    } # if ~ END

  }) # observe


  ## Download, Thresh, Custom ----
  output$QC_Thresh_Download <- downloadHandler(
    filename = function() {
      paste0("Custom_QC_Config_", format(Sys.Date(),"%Y%m%d")
             ,"_",format(Sys.time(),"%H%M%S"), ".R")
    },
    content = function(file) {
      file.copy("www/QC_Custom_Config.tsv", file)
    }
  ) # downloadHandler, Thresh, Custom


  ## Download, Thresh Eval Code ----
  output$but_thresh_code <- downloadHandler(
    filename = function() {"Threshold_Eval.zip"}##filename
    , content = function(file) {
      file.copy("www/Threshold_Eval.zip", file)
    }## content
  )## downloadHandler, Thresh Eval Code



})## server
