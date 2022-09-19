# Panel, Console

function() {

  tabPanel("7. Console"
           ,includeHTML("www/RMD_HTML/App_6Console.html")
           ,tableOutput("logText")
           ,tableOutput("logTextUSGS")
           ,tags$b(textOutput("logTextMessage"))

  ) ## tabPanel ~ Adv Feat ~ END
}## FUNCTION ~ END
