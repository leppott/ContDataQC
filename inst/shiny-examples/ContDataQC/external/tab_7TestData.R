# Panel, Test Data

function() {

  tabPanel("7. Test Data"
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Lakes"
                                    ,includeHTML("App_7TestData.html")
                         )## tabPanel ~ Streams ~ END

                         , tabPanel("Streams"
                         )## tabPanel ~ CURRENT ~ END

             )## tabsetPanel ~ END

           )## mainPanel ~ END

  ) ## tabPanel ~ Config ~ END

}## FUNCTION ~ END
