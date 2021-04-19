# Panel, HOBO reformat

function() {

  tabPanel("Reformat Input",
           h3("HOBOware reformat", align = "Center")
           , tags$b("Description")
           , p("Format HoboWare output for use with 'ContDataQC' package. Works on individual csv files. Imports, modifies, and saves with the same filename for download.")
           , p("One file or multiple files can be uploaded for processing.")
           , tags$b("Details")
           , p("Imports a HoboWare output (with minimal tweaks), reformats it using defaults from the ContDataQC config file , and exports a CSV to another folder for use with ContDataQC.")
           , p("Older versions of HOBOware  only output ambiguous dates with 2 digits.
                                              Newer versions use 4 digits.  There are two delimiters (/ and -) and three formats (MDY, DMY, and YMD) resulting in six possible formats.")
           , p("The user can specify the date format below.  'DMY' is the default as this is what most people use and is the default on Windows computers.  NULL will not modify the input dates.")
           , p("It is assumed the user has a single Date Time field rather than two fields (Date and Time).")
           , p("A zip file with all CSV files ready for use with the ContDataQC QC function will be generated and can be downloaded.")
           , p("'Run' and 'Download' buttons do not appear until the previous step is complete ('Upload' and 'Run', respectively).")
           , hr()
           , tags$div(title="Select one HOBOware csv files to upload here"
                      , fileInput("selectedFiles_HOBO"
                                  ,label="Choose files"
                                  , multiple = TRUE
                                  , accept = ".csv"
                                  , width = "600px") # wider for long file names
           )
           ,selectInput("HOBO_DateFormat",
                        label = "Choose date format from HOBOware file",
                        choices = c("MDY"
                                    , "YMD"
                                    , "DMY"
                                    , NULL)
                        ,selected = "MDY")
           #Only shows the "Run operation" button after data are uploaded
           ,tags$div(title="Click to run selected operation (HOBO reformat)",
                     uiOutput('ui.runProcess_HOBO')
           )
           , br()
           #Only shows the "Download" button after the process has run
           ,tags$div(title="Click to download your data",
                     uiOutput('ui.downloadData_HOBO')
           )
  )## tabPanel ~ HOBO ~ END

}## FUNCTION ~ END
