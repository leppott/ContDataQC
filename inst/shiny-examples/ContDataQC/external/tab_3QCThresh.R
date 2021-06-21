# Panel, QC Thresholds

function() {

  tabPanel("3. QC Thresholds"
        , mainPanel(
          tabsetPanel(type = "tabs"
            , tabPanel("Default"
                       , includeHTML("App_3aQCThresh.html")
            )## tabPanel ~ CURRENT ~ END

            , tabPanel("Custom"
                       ,sidebarLayout(
                         sidebarPanel(
                           tags$div(title="Select R configuration file to upload here"
                                      #Only allows R files to be imported
                                      ,fileInput("configFile"
                                                 , label = "Choose configuration file"
                                                 , multiple = FALSE
                                                 , accept = ".R")
                           ) # tag$div ~ END
                           , br()
                           , br()

                           #Only shows the "Default configuration" button after a user-selected file has been used
                           ,tags$div(title = "Click to use default configuration data"
                                     ,uiOutput('ui.defaultConfig'))
                         )# sidebarPanel~ END
                         , mainPanel(
                           includeHTML("App_3bQCThresh.html")
                         ) ## mainPanel ~ END
                       )# sidebarLayout~ END
            )## tabPanel ~ Streams ~ END
          )## tabsetPanel ~ END
        )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
