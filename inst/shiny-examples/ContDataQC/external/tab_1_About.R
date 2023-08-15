# About

function() {

  tabPanel("About"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Overview"
                                    , includeHTML("www/RMD_HTML/App_1a_Overview.html")
                         )## tabPanel ~ END

                         , tabPanel("Test Files"
                                    , includeHTML("www/RMD_HTML/App_1b_TestData.html")
                         )## tabPanel ~ END

                         , tabPanel("FAQ"
                                    , includeHTML("www/RMD_HTML/App_1c_FAQ.html")
                         )## tabPanel~ END

                         , tabPanel("Related Apps"
                                    , includeHTML("www/RMD_HTML/App_1d_RelatedApps.html")
                         )## tabPanel ~ END


             )## tabsetPanel ~ END
           )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
