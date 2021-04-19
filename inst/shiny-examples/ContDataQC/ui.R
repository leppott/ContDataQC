# Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development.
# dagibbs22@gmail.com
# Erik.Leppo@tetratech.com
# Written 2017 and 2018 (mostly David)
# Updated 2020 (Erik)
# 2021-04-19, Erik, modular format

# Source ----

tab_Intro    <- source("external/tab_Intro.R", local = TRUE)$value
tab_Calc     <- source("external/tab_Calc.R", local = TRUE)$value
tab_USGSgage <- source("external/tab_USGSgage.R", local = TRUE)$value
tab_FAQ      <- source("external/tab_FAQ.R", local = TRUE)$value
tab_HOBO     <- source("external/tab_HOBO.R", local = TRUE)$value
tab_Config   <- source("external/tab_Config.R", local = TRUE)$value
tab_Console  <- source("external/tab_Console.R", local = TRUE)$value

shinyUI(
  # VERSION ----
  navbarPage("Continuous data QC, summary, and statistics - v2.0.5.9087",
             theme= shinytheme("spacelab"),
             #also liked "cerulean" at https://rstudio.github.io/shinythemes/
             # tabPan, Site Intro ----
             tab_Intro(),
             # tabPan, Calc ----
             tab_Calc(),
             # tabPan, Adv Feat ----
             tab_Console(),
             tab_Config(),
             tab_HOBO(),
             # tabPan, USGS ----
             tab_USGSgage() ,
             # tabPan, FAQ ----
             tab_FAQ()

  )## navbarPage ~ END
)## shinyUI ~ END
