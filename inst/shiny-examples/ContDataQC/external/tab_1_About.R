# About

function() {

  tabPanel("About"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Overview"
                                    , p(paste0("Version ", version, "."))
                                    , includeHTML("www/RMD_HTML/App_1a_Overview.html")
                         )## tabPanel ~ END

                         , tabPanel("Test Files"
                                    , includeHTML("www/RMD_HTML/App_1b_TestData.html")
                         )## tabPanel ~ END

                         , tabPanel("Basic Information"
                                    , includeHTML("www/RMD_HTML/App_1c_FAQ.html")
                         )## tabPanel~ END

                         , tabPanel("Tips"
                                    ,includeHTML("www/RMD_HTML/App_1d_Tips.html")
                         )# tabPanel ~ QC Tips ~ END

                         , tabPanel("Advanced"
                                    ,includeHTML("www/RMD_HTML/App_1e_Advanced.html")
                         )# tabPanel ~ Advanced ~ END

                         , tabPanel("Related Apps"
                                    , includeHTML("www/RMD_HTML/App_1f_RelatedApps.html")
                         )## tabPanel ~ END


             )## tabsetPanel ~ END
           )## mainPanel ~ END
  ) ## tabPanel ~ Config ~ END
}## FUNCTION ~ END
