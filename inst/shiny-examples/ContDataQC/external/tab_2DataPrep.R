# Panel, Data Prep

function() {

  tabPanel("2. Data Preparation"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Organizing files"
                                    , includeHTML("App_2aDataPrep.html")
                         )## tabPanel ~ END

                         , tabPanel("Naming files"
                                    , includeHTML("App_2bDataPrep.html")
                                    , img(src = "Fig_NamingFiles_v1_20210617.png"
                                          , height = 600, width = 1000)
                         )## tabPanel~ END

                         , tabPanel("Formatting files"
                                    , includeHTML("App_2cDataPrep.html")
                         )## tabPanel ~ END

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
                                                     ,label = "Choose date format from HOBOware file"
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
                                        ,tags$div(title="Click to download your data"
                                                  ,uiOutput('ui.downloadData_HOBO')
                                        )# tags$div ~ END
                                      )# sidebarPanel~ END
                                      , mainPanel(
                                        includeHTML("App_2dDataPrep.html")
                                        , img(src = "Fig_HOBOreformat_v1_20210617.png"
                                              , height = 600, width = 1000)
                                      ) ## mainPanel ~ END
                                    )# sidebarLayout~ END
                         )## tabPanel  ~ END
             )## tabsetPanel ~ END
           )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
