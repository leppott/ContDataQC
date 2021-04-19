# Panel, Config

function() {

  tabPanel("QC Thresholds"
           , sidebarPanel(
             h3("QC thresholds", align = "Center")
             , p("You can upload custom QC thresholds here.
                                 Please use",
                 a("this ", target="_blank", href="Config_Template.zip"),
                 "configuration document as a template.")
             , p("Once you have made your changes to the configuration file, upload them below.
                                 You will have the option to return to the default configuration after you upload your custom file.
                                 Note that if the newenv() line (33) does not stay commented out it will not work.")
             , br()
             #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
             , tags$div(title="Select R configuration file to upload here",

                        #Only allows R files to be imported
                        fileInput("configFile"
                                  , label = "Choose configuration file"
                                  , multiple = FALSE
                                  , accept = ".R")
             )

             , br()
             , br()

             #Only shows the "Default configuration" button after a user-selected file has been used
             ,tags$div(title = "Click to use default configuration data",
                       uiOutput('ui.defaultConfig'))


           )## sidebarPanel ~ END
        , mainPanel(
          tabsetPanel(type = "tabs"

            , tabPanel("Current"
              , h4("QC Thresholds, CURRENT", align = "Center")
            )## tabPanel ~ CURRENT ~ END

            , tabPanel("Default, Streams"
                       , h4("QC Thresholds, DEFAULT, STREAMS", align = "Center")
            )## tabPanel ~ Streams ~ END

            , tabPanel("Default, Lakes"
                       , h4("QC Thresholds, DEFAULT, LAKES", align = "Center")
            )## tabPanel ~ Lakes ~ END


          )## tabsetPanel ~ END

        )## mainPanel ~ END

  ) ## tabPanel ~ Config ~ END

}## FUNCTION ~ END
