# Panel, Data Prep

function() {

  tabPanel("Data Preparation"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Formatting files"
                                    , includeHTML("www/RMD_HTML/App_2a_FormattingFiles.html")
                         )## tabPanel ~ END

                         , tabPanel("Sensor File Modification"
                            ,tabsetPanel(type = "tabs"
                                         # Hoboware, reformat ----
                                         , tabPanel("HOBOware Reformat"
                                                    ,sidebarLayout(
                                                      sidebarPanel(
                                                        tags$div(title="Select one HOBOware csv files to upload here"
                                                                 , fileInput("selectedFiles_HOBO"
                                                                             ,label="Choose files"
                                                                             , multiple = TRUE
                                                                             , accept = ".csv"
                                                                             , width = "600px") # wider for long file names
                                                        )# tags$div ~ END
                                                        ,selectInput("HOBO_DateFormat"
                                                                     ,label = "Choose date format from the DateTime field in the input file"
                                                                     ,choices = c("MDY"
                                                                                  , "YMD"
                                                                                  , "DMY"
                                                                                  , NULL)
                                                                     ,selected = "MDY")
                                                        #Only shows the "Run operation" button after data are uploaded
                                                        ,tags$div(title="Click to run selected operation (HOBO reformat)"
                                                                  ,uiOutput('ui.runProcess_HOBO')
                                                        )# tags$div ~ END
                                                        , br()
                                                        #Only shows the "Download" button after the process has run
                                                        ,tags$div(title="Click to download your data (HOBO reformat)"
                                                                  ,uiOutput('ui.downloadData_HOBO')
                                                        )# tags$div ~ END
                                                      )# sidebarPanel~ END
                                                      , mainPanel(
                                                        includeHTML("www/RMD_HTML/App_2a1_HOBO.html")
                                                        , img(src = "Fig_HOBOreformat_v1_20210617.png"
                                                              , height = 600, width = 1000)
                                                      ) ## mainPanel ~ END
                                                    )# sidebarLayout~ END
                                         )## tabPanel ~ HOBO ~ END

                                         # miniDOT, cat ----
                                         , tabPanel("miniDOT Concatenate"
                                                    , sidebarLayout(
                                                      sidebarPanel(
                                                        tags$div(title = "Select one or more miniDOT txt files to upload here"
                                                                 , fileInput("selectedFiles_miniDOT_cat"
                                                                             , label = "Choose files"
                                                                             , multiple = TRUE
                                                                             , accept = ".txt"
                                                                             , width = "600px") # same as HOBO
                                                        )##tags$div ~ END
                                                        , br()
                                                        #Only shows the "Run operation" button after data are uploaded
                                                        ,tags$div(title = "Click to run selected operation (miniDOT concatenate)"
                                                                  ,uiOutput('ui.runProcess_miniDOT_cat')
                                                        )# tags$div ~ END
                                                        , br()
                                                        #Only shows the "Download" button after the process has run
                                                        ,tags$div(title = "Click to download your data (miniDOT_cat)"
                                                                  ,uiOutput('ui.downloadData_miniDOT_cat')
                                                        )# tags$div ~ END
                                                      )# sidebarPanel~ END
                                                      , mainPanel(
                                                        includeHTML("www/RMD_HTML/App_2a2_miniDOT1.html")

                                                      ) ## mainPanel ~ END
                                                    )# sidebarLayout~ END
                                         )## tabPanel ~ miniDOT cat ~ END

                                         # miniDOT, reformat ----
                                         , tabPanel("miniDOT Reformat"
                                                    , sidebarLayout(
                                                      sidebarPanel(
                                                        tags$div(title = "Select one miniDOT csv files to upload here"
                                                                 , fileInput("selectedFiles_miniDOT_reformat"
                                                                             , label = "Choose files"
                                                                             , multiple = FALSE
                                                                             , accept = ".csv"
                                                                             , width = "600px") # same as HOBO
                                                        )##tags$div ~ END
                                                        , br()
                                                        #Only shows the "Run operation" button after data are uploaded
                                                        ,tags$div(title = "Click to run selected operation (miniDOT reformat)"
                                                                  ,uiOutput('ui.runProcess_miniDOT_reformat')
                                                        )# tags$div ~ END
                                                        , br()
                                                        #Only shows the "Download" button after the process has run
                                                        , tags$div(title = "Click to download your data (miniDOT_reformat)"
                                                                  ,uiOutput('ui.downloadData_miniDOT_reformat')
                                                        )# tags$div ~ END
                                                      )# sidebarPanel~ END
                                                      , mainPanel(
                                                        includeHTML("www/RMD_HTML/App_2a3_miniDOT2.html")

                                                      ) ## mainPanel ~ END
                                                    )# sidebarLayout~ END
                                         )## tabPanel ~ miniDOT reformat ~ END


                                        )## tabsetPanel
                          )## tabPanel ~ END


                         , tabPanel("Organizing files"
                                    , includeHTML("www/RMD_HTML/App_2b_OrganizingFiles.html")
                         )## tabPanel ~ END

                         , tabPanel("Naming files"
                                    , includeHTML("www/RMD_HTML/App_2c_NamingFiles.html")
                                    # included pic in RMD to HTML
                                    # , img(src = "Fig_NamingFiles_v1_20210617.png"
                                    #       , height = 600, width = 1000)
                         )## tabPanel~ END




             )## tabsetPanel ~ END
           )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
