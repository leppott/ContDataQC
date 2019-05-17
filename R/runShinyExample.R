#' @title run Shiny Example
#'
#' @description Launches Shiny app.
#'
#' @details The Shiny app based on the R package ContDataQC is included in the R package.
#' This function launches that app.
#'
#' The Shiny app is online at:
#' https://davidagibbs.shinyapps.io/rmn_continuous_data_active/
#'
#' @examples
#' \dontrun{
#' # Run Function
#' runShinyExample()
#' }
#
#' @export
runShinyExample <- function(){##FUNCTION.START
  #
  #appDir <- system.file("shiny-examples", "ContDataQC", package = "ContDataQC")
  if (system.file("shiny-examples", "ContDataQC", package = "ContDataQC") == "") {
    stop("Could not find example directory. Try re-installing `ContDataQC`.", call. = FALSE)
  }

  shiny::runApp(system.file("shiny-examples", "ContDataQC", package = "ContDataQC"), display.mode = "normal")
  #
}##FUNCTION.END
