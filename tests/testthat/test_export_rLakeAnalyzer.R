# Export.rLakeAnalyzer ####
test_that("Export.rLakeAnalyzer", {
  #
  # Convert Data for use with rLakeAnalyzer

  # Data
  fn_CDQC <- "TestLake_Water_20180702_20181012.csv"
  df_CDQC <- read.csv(file.path(system.file(package = "ContDataQC"), "extdata", fn_CDQC))

  # Convert Date.Time from factor to POSIXct (make it a date and time field in R)
  df_CDQC[, "Date.Time"] <- as.POSIXct(df_CDQC[, "Date.Time"])

  # Columns, date listed first
  col_depth <- "Depth"
  col_CDQC <- c("Date.Time", "temp_F", "DO_conc")
  col_rLA  <- c("datetime", "wtr", "doobs")

  # Output Options
  dir_export <- getwd()
  fn_export <- paste0("rLA_", fn_CDQC)

  # Run function
  df_rLA <- Export.rLakeAnalyzer(df_CDQC, col_depth, col_CDQC, col_rLA
                                 , dir_export, fn_export)

  df_calc <- df_rLA

  sum_calc <- sum(df_rLA[, 2:7], na.rm = TRUE)

  sum_qc <- 488353.7

  # test
  testthat::expect_equal(sum_calc, sum_qc, tolerance = 0.01)

})## Test ~ Export.rLakeAnalyzer ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
