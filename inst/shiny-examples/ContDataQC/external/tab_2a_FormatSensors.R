# Data Prep, About/Formatting

function() {

  tabPanel("Format Sensors"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Hobo"
                                    , includeHTML("www/RMD_HTML/App_2a1_HOBO.html")
                         )## tabPanel ~ END

                         , tabPanel("Hobo"
                                    , includeHTML("www/RMD_HTML/App_2a1_HOBO.html")
                         )## tabPanel~ END

                         , tabPanel("miniDOT"
                                    , includeHTML("www/RMD_HTML/App_2a2_miniDOT.html")
                         )## tabPanel ~ END



             )## tabsetPanel ~ END
           )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
