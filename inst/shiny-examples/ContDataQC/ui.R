# Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development.
# dagibbs22@gmail.com
# Erik.Leppo@tetratech.com
# Written 2017 and 2018 (mostly David)
# Updated 2020 (Erik)
# 2021-04-19, Erik, modular format
# 2021-06-15, Ben Block, updated formatting

# Source ----

# tab_Intro    <- source("external/tab_Intro.R", local = TRUE)$value
# tab_Calc     <- source("external/tab_Calc.R", local = TRUE)$value
# tab_Console  <- source("external/tab_Console.R", local = TRUE)$value
# tab_Config   <- source("external/tab_Config.R", local = TRUE)$value
# tab_Reformat <- source("external/tab_Reformat.R", local = TRUE)$value
# tab_USGSgage <- source("external/tab_USGSgage.R", local = TRUE)$value
# tab_FAQ      <- source("external/tab_FAQ.R", local = TRUE)$value

tab_1Overview   <- source("external/tab_1Overview.R", local = TRUE)$value
tab_2DataPrep   <- source("external/tab_2DataPrep.R", local = TRUE)$value
tab_3QCThresh   <- source("external/tab_3QCThresh.R", local = TRUE)$value
tab_4MainFunc   <- source("external/tab_4MainFunc.R", local = TRUE)$value
tab_5USGSgage   <- source("external/tab_5USGSgage.R", local = TRUE)$value
tab_6Console    <- source("external/tab_6Console.R", local = TRUE)$value
tab_7TestData   <- source("external/tab_7TestData.R", local = TRUE)$value
tab_8FAQ        <- source("external/tab_8FAQ.R", local = TRUE)$value
tab_9Status     <- source("external/tab_9Status.R", local = TRUE)$value


shinyUI(
  # VERSION ----
  navbarPage("Continuous data QC, summary, and statistics - v2.0.6.9028",
             theme= shinytheme("spacelab")
             ,tab_1Overview()
             ,tab_2DataPrep()
             ,tab_3QCThresh()
             ,tab_4MainFunc()
             ,tab_5USGSgage()
             ,tab_6Console()
             ,tab_7TestData()
             ,tab_8FAQ()
             ,tab_9Status()
  )## navbarPage ~ END
)## shinyUI ~ END



# shinyUI(
#   # VERSION ----
#   navbarPage("Continuous data QC, summary, and statistics - v2.0.6",
#              theme= shinytheme("spacelab"),
#              #also liked "cerulean" at https://rstudio.github.io/shinythemes/
#              # tabPan, Site Intro ----
#              tab_Intro(),
#              # tabPan, Calc ----
#              tab_Calc(),
#              # tabPan, Adv Feat ----
#              tab_Console(),
#              tab_Config(),
#              tab_Reformat(),
#              # tabPan, USGS ----
#              tab_USGSgage() ,
#              # tabPan, FAQ ----
#              tab_FAQ()
#
#   )## navbarPage ~ END
# )## shinyUI ~ END
