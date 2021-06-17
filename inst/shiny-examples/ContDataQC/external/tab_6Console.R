# Panel, Console

function() {

  tabPanel("6. Console"
           ,includeHTML("App_6Console.html")
           ,tableOutput("logText")
           ,tableOutput("logTextUSGS")
           ,tags$b(textOutput("logTextMessage"))

  ) ## tabPanel ~ Adv Feat ~ END

}## FUNCTION ~ END
