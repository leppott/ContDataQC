# Panel, Data Prep

function() {

  tabPanel("Data Preparation"
           , sidebarPanel(
             h3("Here is a side bar panel - fill info?", align = "Center")


           )## sidebarPanel ~ END
           , mainPanel(
             tabsetPanel(type = "tabs"

                         , tabPanel("Organizing files"
                                    , h4("Organizing files - fill info", align = "Center")
                         )## tabPanel ~ CURRENT ~ END

                         , tabPanel("Naming files"
                                    , h4("Naming files - fill info", align = "Center")
                         )## tabPanel ~ Streams ~ END

                         , tabPanel("Formatting files"
                                    , h4("Formatting files - fill info", align = "Center")
                         )## tabPanel ~ Lakes ~ END


             )## tabsetPanel ~ END

           )## mainPanel ~ END

  ) ## tabPanel ~ Config ~ END

}## FUNCTION ~ END
