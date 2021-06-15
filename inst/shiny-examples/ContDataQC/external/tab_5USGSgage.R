# Panel, USGS gage data

function(){

  tabPanel("Download USGS data",
           fluidRow(
             column(5,
                    h3("Instructions", align = "Center"),
                    br(),
                    p("You can download data from USGS gages on this tab."),
                    br(),
                    p("1. Enter as many USGS station IDs as you like separated by
                                 commas and spaces (e.g., 01187300, 01493000, 01639500)."),
                    p("2. Enter a starting and ending date for which data will
                                 be retrieved for each station; the same date range
                                 will be used for every station."),
                    p("3. Click the 'Retrieve USGS data' button.
                                 A progress bar will appear in the bottom-right of the tab.
                                 It will advance as each file is completed.
                                 Thus, if you select three stations, it will wait at 0%,
                                 jump to 33%, jump to 66%, and then jump to 100%."),
                    p("4. After data retrieval completes, a download button
                                 will appear. Click the button to download a zip file of all station records.
                                 Where the files will download on your computer depends on the configuration
                                 of your internet browser.")
             ),

             column(5, offset = 1,
                    h3("Download USGS gage data here")
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
                    ,tags$div(title="Click to download your USGS gage data",
                              uiOutput('ui.downloadUSGSData'))
             )
           )
  )## tabPanel ~ END

}## FUNCTION ~ END
