# Panel, Calc
# main function and instructions


function(){

  tabPanel("Main Functions"

           , mainPanel(

              tabsetPanel(type = "tabs"

                          , tabPanel("About"
                          , tabsetPanel(type = "tabs"
                                           , tabsetPanel(type="tabs"
                                                        ,tabPanel("Run functions"
                                                                  , includeHTML("www/RMD_HTML/App_3a1_About.html")
                                                                  , img(src = "Fig_Rpackage_v1_20210617.png"
                                                                        , height = 500, width = 800)
                                                        ) # tabPanel ~ Run Functions ~ END
                                                        , tabPanel("QC Reports"
                                                                   , includeHTML("www/RMD_HTML/App_3a2_QCReports.html"))
                                                        , tabPanel("Aggregate"
                                                                   , includeHTML("www/RMD_HTML/App_3a3_Aggregate.html"))
                                                        , tabPanel("Summary Stats"
                                                                   , includeHTML("www/RMD_HTML/App_3a4_SummaryStats.html"))

                                            ) # tabsetPanel ~ END

                                       )## tabsetPanel
                           )##tabPanel ~ About

                          , tabPanel("Import Files"
                                     , sidebarLayout(
                                       sidebarPanel(
                                         #The selected input file
                                         #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
                                         tags$div(title="Select one or more csv files to upload here"

                                                  #Only allows csv files to be imported
                                                  , fileInput("selectedFiles"
                                                              , label = "Choose files"
                                                              , multiple = TRUE
                                                              , accept = ".csv")
                                         )# tags$div ~ END

                                         #Operation to be performed on the selected data
                                         ,selectInput("Operation"
                                                      ,label = "Choose operation to perform"
                                                      ,choices = c("",
                                                                   "QC raw data",
                                                                   "Aggregate QC'ed data",
                                                                   "Summary statistics")
                                                      ,selected = "")

                                         #Only shows the "Run operation" button after data are uploaded
                                         ,tags$div(title="Click to run selected operation"
                                                   ,uiOutput('ui.runProcess')
                                         )# tags$div ~ END
                                         ,br()
                                         ,br()

                                         #Only shows the "Download" button after the process has run
                                         ,tags$div(title="Click to download your data"
                                                   ,uiOutput('ui.downloadData')
                                         )# tags$div ~ END

                                       )# sidebarPanel
                                      , mainPanel(
                                         includeHTML("www/RMD_HTML/App_3b_CheckInput.html")

                                         #Shows an empty table until files are input
                                        ,tableOutput("nullTable1")
                                        ,tableOutput("nullTable2")
                                        ,tableOutput("nullTable3")

                                        #Outputs the table with properties of the input spreadsheets,
                                        #and a testing table of the beginning of the spreadsheets
                                        ,tableOutput("summaryTable1")
                                        ,tableOutput("summaryTable2")
                                        ,tableOutput("summaryTable3")

                                        ,br()

                                        #Shows a note if the user uploads non-QCed data and selects
                                        #the Aggregate or Summarize processes
                                        ,h4(textOutput("aggUnQCedData"))
                                        ,h4(textOutput("summUnQCedData"))

                                        #Shows a note if spreadsheets with multiple sites are selected
                                        #for the Aggregate process
                                        ,h4(textOutput("moreThanOneSite"))

                                      )# main panel


                                     )# sidebarLayout


                                     )##tabPanel ~ Check

                          , tab_3c_QCThresh()

                          # , tabPanel("Advanced?"
                          #            )##tabPanel ~ Adv


              )##tabsetPanel ~ END


           )##mainPanel ~ END
  )#tabPanel ~ END




}## FUNCTION ~ END
