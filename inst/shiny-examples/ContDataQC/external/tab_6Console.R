# Panel, Console

function() {

  tabPanel("Console",
             ## _Adv Feat, Console ----

               h3("R console output", align = "Center"),
               p("This panel shows messages output by the QC, aggregating, summarizing, and USGS data retrieval processes.
                                 If there are any errors when the tool runs, please copy
                                 the messages and send them and your input files to the contacts listed on the 'Site introduction' tab."),
               tableOutput("logText"),
               tableOutput("logTextUSGS"),
               tags$b(textOutput("logTextMessage"))

               ## For debugging only: lists all files on the server
               # ,br()
               # ,br()
               # ,br()
               # ,br()
               # ,tableOutput("serverTable")




  ) ## tabPanel ~ Adv Feat ~ END

}## FUNCTION ~ END
