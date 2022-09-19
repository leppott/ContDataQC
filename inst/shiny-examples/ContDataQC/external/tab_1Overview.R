# Panel, Overview

function(){

  tabPanel("1. About ContDataQC"
           , mainPanel(
             includeHTML("www/RMD_HTML/App_1Overview.html")
             , tags$head(includeHTML(("google-analytics.html")))
           )## mainPanel ~ END
  ) #tabPanel ~END
}##FUNCTION ~ END
