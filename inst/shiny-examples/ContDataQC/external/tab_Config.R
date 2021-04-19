# Panel, Config

function() {

  tabPanel("Custom QC thresholds"
           , h3("Custom QC thresholds", align = "Center")
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
                     uiOutput('ui.defaultConfig')
           )
  ) ## tabPanel ~ Config ~ END

}## FUNCTION ~ END
