# Panel, QC Thresholds

function() {

  tabPanel("3. QC Thresholds"
        , mainPanel(
          tabsetPanel(type = "tabs"
            , tabPanel("Default"
                       , includeHTML("www/App_3aQCThresh.html")
            )## tabPanel ~ CURRENT ~ END

            , tabPanel("Evaluate Thresholds"
                       , h2("Evaluate Thresholds")
                      , p("If you have one or more years of continuous data for a site, we strongly encourage you to evaluate the performance of the QC test thresholds for each parameter at that site and customize the configuration file if needed.")
                      , p("When doing this, make sure you consider what units you'd like to use. If you are working with lakes and prefer to use meters over feet, click "
                          , a("here", href = "Config_Lakes_Metric.R")
                          , " to download a default configuration file that has been converted to meters.")
                      , p("To aid with documentation of the threshold evaluation process, we provide an Excel worksheet that lists the default thresholds for each parameter and has a column where you can enter the customized values for a given site (as well as rationale for making the changes). Click "
                          , a("here", href="ThresholdsCheckWorksheet_Template_20220117.xlsx")
                          , " to download the threshold evaluation worksheet. ")
                      , p("Currently, our partners are using the following approaches to evaluate thresholds:")
                      , p("* Saving the aggregated QC csv file as an Excel file, then using pivot tables and plots to generate time series plots and column plots to evaluate thresholds for the Unrealistic values ('Gross range') and Spike tests. Click "
                          , a("here", href = "ExcelPivotTablesPlots_GrossSpikeEval_20220117.pdf")
                          , " for instructions.")
                      , p("* Using R code written by Tim Martin (a lake RMN collaborator from Minnesota DNR) to generate statistical outputs that can help inform thresholds for all four QC tests. Click "
                          , a("here", href = "ThresholdsEvaluateFiles.zip")
                          , " to download the R scripts and instructions (requires R software to run).")
                      # , br()
                      # , downloadButton("but_thresh_code")
                       )## tabPanel ~ Eval Thresh

            , tabPanel("Edit Thresholds"
                       ,shinyjs::useShinyjs()
                       # ,h3("Edit your thresholds here by parameter:")
                       # ,h4("1. Select a parameter for edit using drop-down")
                       # ,h4("2. Edit thresholds using boxes on right")
                       # ,h4("3. Save changes (for each parameter)")
                       # ,h4("4. Download custom thresholds file")
                       ,sidebarLayout(
                         sidebarPanel(width = 5
                                     # , style = "position:fixed"#;width:22%"
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
                                     , h4("2. Edit Thresholds")
                                     , p("see boxes to right and down")
                                      ,h4("3. Save your changes")
                                      ,p(paste("Note: Save changes for one parameter at a time"))
                                      ,actionButton(inputId = "QC_SaveBttn"
                                                    , label = "Save changes")
                                      ,h4("4. Download your custom threshold file")
                                      ,p(paste("Note: The downloaded file must be reuploaded"))
                                      ,downloadButton(outputId = "QC_Thresh_Download"
                                                      , label = "Download custom thresholds file")
                                     , h4("5. Upload custom threshold file")
                                     , p("Go to the 'upload custom thresholds' tab, browse to the custom thresholds file, upload the file and then, under 'Main functions', generate the QC reports. If you skip this step, the default QC thresholds will be used.")

                         ) # sidebarPanel~ END
                         , mainPanel(width = 7
                                     , h2("Edit Thresholds")
                                     , p("There are two options for editing thresholds and creating customized configuration files:")
                                     , h3("Option 1, use the interactive functions shown left and below.")
                                     , p("* Select a parameter using the drop-down menu")
                                     , p("* Edit thresholds using boxes below")
                                     , p("* Save changes (for each parameter)")
                                     , p("* Download custom thresholds file")
                                     , h3("Option 2, download the default configuration file, open the file in R or Notepad++, make edits and save.")
                                     , p("Click ", a("here", href = "EditingQCtestThresholds_20220117.pdf") ,"  for instructions. To download the default configuration file, click ", a("here", href = "Config_Default.R") ,".  If you prefer to work in metric units, click ", a("here", href = "Config_Lakes_Metric.R") ," to download an alternate configuration file.")
                                     , br()
                                     , p("For either option, make sure you save the customized configuration file in a folder that is easy to find (see the 'Data Preparation – Organizing Files' tab for suggestions). We also recommend including the SiteID in the file name along with other relevant information. For example, if you customized the file for a particular season (winter vs summer), include the season in the file name; and/or if it is intended to be used for a particular depth or layer in a lake (top, middle or bottom), it is helpful to include that information in the file name as well.")
                                     , p("Acknowledgment: Tim Martin (MN DNR) wrote the R code that we used for the interactive functions below. ")
                                     , hr()
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
            ) ## tabPanel ~ Edit Thresh

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
                           ,tags$div(title = "Click to use default configuration data"
                                     ,uiOutput('ui.defaultConfig'))
                         )# sidebarPanel~ END
                         , mainPanel(
                           #includeHTML("www/App_3bQCThresh.html")
                           h2("Upload Custom Thresholds")
                           , p("Click the 'Browse' button (to the left) and select the desired customized configuration file. The status bar will tell you when the file has been uploaded. A new button will appear that gives you the option of returning to the default configuration file. Do not click this unless you change your mind and no longer want to use the customized file.")
                           , p("Go to the 'Main Functions' tab; select the desired input file(s); run them through the QC function.  Save the output to the desired location. Open the Word or html QC report and scroll to the 'Thresholds, Quick Reference' table (in the middle section of the report). Verify that the correct thresholds were used.")
                           , p("Be aware that each time you close and reopen the Shiny app, it will automatically revert back to the default configuration file. Also – remember the sequencing! If you forget to upload the customized configuration file prior to running the QC function, it will use the default thresholds.")
                           , p("If you have questions and/or need assistance, contact Jen Stamp (", a("Jen.Stamp@tetratech.com", href = "mailto:Jen.Stamp@tetratech.com") , ").")
                         ) ## mainPanel ~ END
                       )# sidebarLayout~ END
            )## tabPanel ~ Custom Thresh ~ END

          )## tabsetPanel ~ END
        )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
