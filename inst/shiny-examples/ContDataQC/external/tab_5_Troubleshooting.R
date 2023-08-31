# Panel, Console

function() {
  tabPanel("Troubleshooting"
           , mainPanel(
               tabsetPanel(type = "tabs"
                         , tabPanel("Troubleshooting"
                                  ,includeHTML("www/RMD_HTML/App_5a_Troubleshooting.html")
                                  # ,tableOutput("logText")
                                  # ,tableOutput("logTextUSGS")
                                  # ,tags$b(textOutput("logTextMessage")
                                  )

                        , tabPanel("Console"
                                             ,includeHTML("www/RMD_HTML/App_5b_Console.html")
                                             ,tableOutput("logText")
                                             ,tableOutput("logTextUSGS")
                                             ,tags$b(textOutput("logTextMessage"))
                         )##tabPanel
                        , tabPanel("Contact Info"
                                   ,includeHTML("www/RMD_HTML/App_5c_Contact.html")
                        )##tabPanel
               )##tabsetPanel
          )##mainPanel
       )##tabPanel
}## FUNCTION ~ END
