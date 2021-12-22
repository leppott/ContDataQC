# Panel, QC Thresholds

function() {

  tabPanel("3. QC Thresholds"
        , mainPanel(
          tabsetPanel(type = "tabs"
            , tabPanel("Default"
                       , includeHTML("www/App_3aQCThresh.html")
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
                           includeHTML("www/App_3bQCThresh.html")
                         ) ## mainPanel ~ END
                       )# sidebarLayout~ END
            )## tabPanel ~ Streams ~ END
            , tabPanel("Edit Thresholds"
                       ,shinyjs::useShinyjs()
                       ,h3("Edit your thresholds here by parameter:")
                       ,h4("1. Select a parameter for edit using drop-down")
                       ,h4("2. Edit thresholds using boxes on right")
                       ,h4("3. Save changes (for each parameter)")
                       ,h4("4. Download custom thresholds file")
                       ,sidebarLayout(
                         sidebarPanel(width = 5
                           ,h4("1. Select Parameter")
                           ,selectInput(inputId = "QC_Param_Input"
                                        , label = NULL
                                        , choices = c("Air Temperature" = "AirTemp"
                                                      ,"Barometric Pressure, air" = "AirBP"
                                                      ,"Chlorophyll a" = "Chla"
                                                      ,"Conductivity" = "Cond"
                                                      ,"Discharge" = "Discharge"
                                                      ,"Dissolved Oxygen" = "DO"
                                                      ,"Dissolved Oxygen, adjusted" = "DOadj"
                                                      ,"Dissolved Oxygen, percent saturation" = "DOpctsat"
                                                      ,"pH" = "pH"
                                                      ,"Sensor Depth" = "SensDepth"
                                                      ,"Turbidity" = "Turbid"
                                                      ,"Water Level" = "WtrLvl"
                                                      ,"Water Pressure" = "WaterP"
                                                      ,"Water Temperature" = "WaterTemp"
                                                      )) # selectInput
                           ,textOutput("QC_Param_Unit")
                           ,h4("3. Save your changes")
                           ,p(paste("Note: Save changes for one parameter at a time"))
                           ,actionButton(inputId = "QC_SaveBttn"
                                         , label = "Save changes")
                           ,h4("4. Download your custom threshold file")
                           ,p(paste("Note: The downloaded file must be reuploaded"))
                           ,downloadButton(outputId = "QC_Thresh_Download"
                                           , label = "Download custom thresholds file")

                         ) # sidebarPanel~ END
                         , mainPanel(width = 7
                           , h3("2. Edit thresholds:")
                           , h4("Gross Range Thresholds")
                           , p("Test if data point exceeds sensor or user defined min/max.")
                           , fluidRow(
                             column(width = 2, offset = 1, "Fail")
                             ,column(width = 2, offset = 3, "Suspect")
                           ) # fluidRow
                           , fluidRow(
                             column(width = 2,
                                    numericInput(inputId = "GR_Fail_Max"
                                                 , label = "Max"
                                                 , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "GR_Fail_Min"
                                                  , label = "Min"
                                                  , value = "1"))
                             ,column(width = 2, offset = 1,
                                     numericInput(inputId = "GR_Sus_Max"
                                                  , label = "Max"
                                                  , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "GR_Sus_Min"
                                                  , label = "Min"
                                                  , value = "1"))
                           ) # fluidRow
                           , tags$hr()
                           , h4("Spike Thresholds")
                           , p(paste("Test if data point exceeds a user defined"
                                     ,"threshold relative to the previous data point."))
                           , fluidRow(
                             column(width = 2,
                                    numericInput(inputId = "Spike_Fail"
                                                 , label = "Fail"
                                                 , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "Spike_Sus"
                                                  , label = "Suspect"
                                                  , value = "1"))
                           ) # fluidRow
                           , tags$hr()
                           , h4("Rate of Change Limits")
                           , p(paste("Test if data point exceeds a number of"
                                      ,"standard deviations from the previous"
                                      ,"data points over a user defined time period."))
                           , fluidRow(
                             column(width = 2,
                                    numericInput(inputId = "RoC_SDs"
                                                 , label = "SDs"
                                                 , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "RoC_Hrs"
                                                  , label = "Hours"
                                                  , value = "1"))
                           ) # fluidRow
                           , tags$hr()
                           , h4("Flat Line Test")
                           , p(paste("Test if data point is within a user defined"
                                     ,"threshold from previous data points over"
                                     ,"a user defined range."))
                           , fluidRow(
                             column(width = 2,
                                    numericInput(inputId = "Flat_Fail"
                                                 , label = "Fail"
                                                 , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "Flat_Sus"
                                                  , label = "Suspect"
                                                  , value = "1"))
                             ,column(width = 2,
                                     numericInput(inputId = "Flat_Toler"
                                                  , label = "Tolerance"
                                                  , value = "1"))
                           ) # fluidRow
                           # , tags$hr()
                           # , h4("3. Save your changes")
                           # , p(paste("Note: Save changes for one parameter at a time"))
                           # , actionButton(inputId = "QC_SaveBttn"
                           #                , label = "Save changes")
                           # , tags$hr()
                           # , h4("4. Download your custom threshold file")
                           # , p(paste("Note: The downloaded file must be reuploaded"))
                           # , downloadButton(outputId = "QC_Thresh_Download"
                           #                  , label = "Download custom thresholds file")
                         )## mainPanel ~ END
                       )# sidebarLayout~ END
            ) ## tabPanel ~ Edit ~ END
          )## tabsetPanel ~ END
        )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
