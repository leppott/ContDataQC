# Panel, Calc
# main function and instructions


function(){

  tabPanel("Main functions",
           # _Instruct, buttons ----
           # Sidebar with inputs for app
           sidebarLayout(
             sidebarPanel(

               #The selected input file
               #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
               tags$div(title="Select one or more csv files to upload here",

                        #Only allows csv files to be imported
                        fileInput("selectedFiles",label="Choose files", multiple = TRUE, accept = ".csv")
               )# tags$div ~ END

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
               )# tags$div ~ END

               ,br()
               ,br()

               #Only shows the "Download" button after the process has run
               ,tags$div(title="Click to download your data",
                         uiOutput('ui.downloadData')
               )# tags$div ~ END
             )# sidebarPanel~ END

             ,mainPanel(

               tabsetPanel(type="tabs",
                           ## _Instruct, text ----
                           tabPanel("Run functions",

                           ) # tabPanel ~END

                           , tabPanel("Check input file",

                           ) # tabPanel ~END

                           , tabPanel("Outputs",

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

                           )# tabPanel ~END
               ) # tabsetPanel ~ END
             ) # mainPanel ~ END
           ) # sidebarLayout ~ END
  ) #tabPanel ~ END

}## FUNCTION ~ END
