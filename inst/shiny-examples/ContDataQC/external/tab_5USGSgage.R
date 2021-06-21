# Panel, USGS gage data

function(){

  tabPanel("5. Download USGS data"
           ,fluidRow(
             column(5,
                    includeHTML("App_5USGSgage.html")
             )# column ~ END

             ,column(5, offset = 1
                    ,h3("Download USGS gage data here")
                    ,br()
                    ,textInput("USGSsite"
                               , label = "USGS site ID(s) (separated by commas and spaces)")
                    ,textInput("startDate"
                               , label = "Starting date (YYYY-MM-DD)"
                               , placeholder = "YYYY-MM-DD")
                    ,textInput("endDate"
                               , label = "Ending date (YYYY-MM-DD)"
                               , placeholder = "YYYY-MM-DD")
                    ,br()
                    ,actionButton("getUSGSData", "Retrieve USGS data")
                    ,br()
                    ,br()

                    #Only shows the "Download" button after the process has run
                    ,tags$div(title="Click to download your USGS gage data"
                              ,uiOutput('ui.downloadUSGSData'))
             )# column ~ END
           )# fluidRow ~ END
  )## tabPanel ~ END

}## FUNCTION ~ END
