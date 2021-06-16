# Panel, Test Data

function() {

  tabPanel("7. Test Data"
           , sidebarPanel(
             h3("Here is a side bar panel - fill info?", align = "Center")


           )## sidebarPanel ~ END
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Streams"
                                    , h4("Streams - fill info", align = "Center")
                         )## tabPanel ~ CURRENT ~ END

                         , tabPanel("Lakes"
                                    , h4("Lakes - fill info", align = "Center")
                         )## tabPanel ~ Streams ~ END

             )## tabsetPanel ~ END

           )## mainPanel ~ END

  ) ## tabPanel ~ Config ~ END

}## FUNCTION ~ END
