# Panel, Calc
# main function and instructions


function(){

  tabPanel("Instructions & interface", # Main functions
           # _Instruct, buttons ----
           # Sidebar with inputs for app
           sidebarLayout(
             sidebarPanel(

               #The selected input file
               #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
               tags$div(title="Select one or more csv files to upload here",

                        #Only allows csv files to be imported
                        fileInput("selectedFiles",label="Choose files", multiple = TRUE, accept = ".csv")
               )

               #Operation to be performed on the selected data
               ,selectInput("Operation",
                            label = "Choose operation to perform",
                            choices = c("",
                                        "QC raw data",
                                        "Aggregate QC'ed data",
                                        "Summary statistics")
                            ,selected = "")

               #Only shows the "Run operation" button after data are uploaded
               ,tags$div(title="Click to run selected operation",
                         uiOutput('ui.runProcess')
               )

               ,br()
               ,br()

               #Only shows the "Download" button after the process has run
               ,tags$div(title="Click to download your data",
                         uiOutput('ui.downloadData')
               )
             ),

             mainPanel(

               tabsetPanel(type="tabs",
                           ## _Instruct, text ----
                           tabPanel("Instructions",
                                    h3("Instructions", align = "center"),
                                    br(),
                                    p("Below are abbreviated instructions for the three operations on this tab:
                                                 QCing raw data, aggregating QC'ed data, and summarizing QC'ed data.
                                                 For more complete information on managing continuous data, preparing data for this website,
                                                 understanding outputs, and troubleshooting, please refer to ",
                                      a("this presentation. ", target="_blank", href="Continuous_data_website_slides_2018_04_27.pdf"),
                                      "If you want to try using this website on previously tested files, you can use these ",
                                      a("sample files.", target="_blank", href="Continuous_data_test_files_2017_11_28.zip"),
                                      br(),
                                      br(),
                                      tags$b("QC raw data:"),
                                      p("1. Convert all the spreadsheets you will upload to this website into csvs."),
                                      p("2. Name your input files as follows: SITENAME_DATATYPE_STARTDATE_ENDDATE.csv. The site name
                                                   should match the site name in the input files. Data types are as follows: A (air), W (water), G (flow),
                                                   AW, AG, WG, and AWG. Start and end dates should match the dates in the input files and have the format
                                                   YYYYMMDD (e.g., 20151203). Some example input file names are: 097_A_20150305_20150630.csv,
                                                   GOG12F_AW_20130426_20130725.csv, and BE92_AWG_20150304_20151231.csv."),
                                      p("3. Download the continuous data ",
                                        a("template. ", target = "_blank", href="continuous_data_template_2017_11_15.csv"),
                                        "In order for this website to correctly process your continuous data,
                                                   you need to format your data and column names following this template."),
                                      p("4. Copy the appropriate column headers from the template into the spreadsheet(s) you want
                                                   the website to process. The only required fields to run the QC process are 'Date Time', 'SiteID',
                                                   and at least one measurement column (air, water, sensor depth, or flow). It does not matter what
                                                   order the columns are in within your spreadsheet(s)."),
                                      p("5. Verify that the data in your spreadsheets are in the same formats as the data in
                                                   the template spreadsheet (e.g., that the values in 'Date Time' are formatted the same
                                                   as in the template). The website will not work on your data if the formats are
                                                   incorrect."),
                                      p("6. Delete any extraneous columns from your spreadsheets."),
                                      p("7. Delete any extra header rows besides the ones with the field names. Delete any rows at
                                                   the bottom of the spreadsheets that show termination of the sensor log."),
                                      p("8. Upload your files to the website using the 'Browse' button to the left."),
                                      p("9. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected or if the table is replaced by error messages,
                                                   it means that something is wrong with your input file(s), e.g., a column heading is incorrect."),
                                      p("10. Select 'QC raw data' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                      p("11. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                      p("12. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files (spreadsheets and QC reports).
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                      br(),
                                      tags$b("Aggregate QC'ed data:"),
                                      p("1. Upload your QCed files to the website using the 'Browse' button to the left.
                                                   NOTE: Files must have gone through the QC operation on this website before the 'Aggregate' operation can be used on them."),
                                      p("2. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected, it means that something is wrong with your input file(s), e.g.,
                                                   a column heading is incorrect."),
                                      p("3. Select 'Aggregate QC'ed data' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                      p("4. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                      p("5. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files (spreadsheet and QC report of aggregated data).
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                      br(),
                                      tags$b("Generate summary statistics and plots of QC'ed data:"),
                                      p("NOTE: This operation will not use any records marked as 'Failed'.
                                                   Thus, if you want to include records marked as 'Failed', change their flag to something else."),
                                      p("1. Upload your QC'ed files to the website using the 'Browse' button to the left.
                                                   NOTE: Files must have gone through the QC operation on this website before the 'Summary statistics' operation can be used on them.
                                                   Files do not have to have gone through the 'Aggregate' operation prior to summarization."),
                                      p("2. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected, it means that something is wrong with your input file(s), e.g.,
                                                   a column heading is incorrect."),
                                      p("3. Select 'Summary statistics' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                      p("4. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                      p("5. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files: two csvs and one pdf for each input parameter in each input file.
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                      br(),
                                      br(),
                                      p("For more information on continuous data pre-processing,
                                                   please visit the Regional Monitoring Network Sharepoint or ftp sites."))
                           ),

                           tabPanel("Summary tables",

                                    h3("Summary tables of input files", align = "center"),
                                    br(),

                                    p("After uploading data, confirm that the table below is showing
                                                 the expected values"),

                                    # #FOR TESTING ONLY. Outputs testing text
                                    # textOutput(paste("testText")),

                                    #Shows an empty table until files are input
                                    tableOutput("nullTable1"),
                                    tableOutput("nullTable2"),

                                    #Outputs the table with properties of the input spreadsheets,
                                    #and a testing table of the beginning of the spreadsheets
                                    tableOutput("summaryTable1"),
                                    tableOutput("summaryTable2"),

                                    br(),

                                    #Shows a note if the user uploads non-QCed data and selects
                                    #the Aggregate or Summarize processes
                                    h4(textOutput("aggUnQCedData")),
                                    h4(textOutput("summUnQCedData")),

                                    #Shows a note if spreadsheets with multiple sites are selected
                                    #for the Aggregate process
                                    h4(textOutput("moreThanOneSite"))
                           )
               )
             )
           )
  )

}## FUNCTION ~ END
