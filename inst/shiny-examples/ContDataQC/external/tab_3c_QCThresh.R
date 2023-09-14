# Panel, QC Thresholds
# Ben Block, 2021-06-16
# Erik Leppo, 2022-12-19, add Gross boxes
# 2023-09-12, change boxes to width 3 (from 2)
#    and remove sidebar and main panel width specifications
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function() {

  tabPanel("QC Thresholds"
        , mainPanel(
          tabsetPanel(type = "tabs"
            # 3c1. Default----
            , tabPanel("Default"
                       , includeHTML("www/RMD_HTML/App_3c1_QCThresh_Defaults.html")
            )## tabPanel ~ CURRENT ~ END

            # 3c2. Upload Custom ----
            , tabPanel("Upload Custom Thresholds"
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
                           ,tags$div(title = "Click to use default configuration file"
                                     ,uiOutput('ui.defaultConfig'))
                         )# sidebarPanel~ END
                         , mainPanel(
                           includeHTML("www/RMD_HTML/App_3c2_QCThresh_Upload.html")
                         ) ## mainPanel ~ END
                       )# sidebarLayout~ END
            )## tabPanel ~ Custom Thresh ~ END

            # 3c3. Eval----
            , tabPanel("Evaluate Thresholds"
                       , includeHTML("www/RMD_HTML/App_3c3_QCThresh_Eval.html")
                      # , br()
                      # , downloadButton("but_thresh_code")
                       )## tabPanel ~ Eval Thresh

            # 3c4. Edit ----
            , tabPanel("Edit Thresholds"
                       ,shinyjs::useShinyjs()
                       # ,h3("Edit your thresholds here by parameter:")
                       # ,h4("1. Select a parameter for edit using drop-down")
                       # ,h4("2. Edit thresholds using boxes on right")
                       # ,h4("3. Save changes (for each parameter)")
                       # ,h4("4. Download custom thresholds file")
                       ,sidebarLayout(
                         sidebarPanel(#width = 5
                                     # , style = "position:fixed"#;width:22%"
                                      h4("1. Select Parameter")
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
                                     , h4("2. Edit Thresholds")
                                     , p("see boxes to right and down")
                                      ,h4("3. Save your changes")
                                      ,p(paste("Note: Save changes for one parameter at a time"))
                                      ,actionButton(inputId = "QC_SaveBttn"
                                                    , label = "Save changes")
                                      ,h4("4. Download your custom threshold file")
                                      ,p(paste("Note: The downloaded file must be reuploaded"))
                                      ,downloadButton(outputId = "QC_Thresh_Download"
                                                      #, label = "Download custom thresholds file")
                                                      , label = "Download")
                                     , h4("5. Upload custom threshold file")
                                     , p("Go to the 'upload custom thresholds' tab, browse to the custom thresholds file, upload the file and then, under 'Main functions', generate the QC reports. If you skip this step, the default QC thresholds will be used.")

                         ) # sidebarPanel~ END
                         , mainPanel(#width = 12
                                      includeHTML("www/RMD_HTML/App_3c4_QCThresh_Edit.html")
                                     , tags$hr()
                                     , h4("Gross Thresholds")
                                     , p(paste("Test if data point exceeds a user defind"
                                               , "threshold."))
                                     , fluidRow(
                                        column(width = sizeThreshEdit,
                                                numericInput(inputId = "GR_Fail_Max"
                                                             , label = "Fail (Hi)"
                                                             , value = "1"))
                                       ,column(width = sizeThreshEdit,
                                              numericInput(inputId = "GR_Fail_Min"
                                                           , label = "Fail (Lo)"
                                                           , value = "1"))
                                       , column(width = sizeThreshEdit,
                                               numericInput(inputId = "GR_Sus_Max"
                                                            , label = "Suspect (Hi)"
                                                            , value = "1"))
                                       , column(width = sizeThreshEdit,
                                               numericInput(inputId = "GR_Sus_Min"
                                                            , label = "Suspect (Lo)"
                                                            , value = "1"))
                                     ) # fluidRow
                                     , tags$hr()
                                     , h4("Spike Thresholds")
                                     , p(paste("Test if data point exceeds a user defined"
                                               ,"threshold relative to the previous data point."))
                                     , fluidRow(
                                       column(width = sizeThreshEdit,
                                              numericInput(inputId = "Spike_Fail"
                                                           , label = "Fail"
                                                           , value = "1"))
                                       ,column(width = sizeThreshEdit,
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
                                       column(width = sizeThreshEdit,
                                              numericInput(inputId = "RoC_SDs"
                                                           , label = "SDs"
                                                           , value = "1"))
                                       ,column(width = sizeThreshEdit,
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
                                       column(width = sizeThreshEdit,
                                              numericInput(inputId = "Flat_Fail"
                                                           , label = "Fail"
                                                           , value = "1"))
                                       ,column(width = sizeThreshEdit,
                                               numericInput(inputId = "Flat_Sus"
                                                            , label = "Suspect"
                                                            , value = "1"))
                                       ,column(width = sizeThreshEdit,
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
            ) ## tabPanel ~ Edit Thresh


          )## tabsetPanel ~ END
        )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
