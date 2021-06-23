## ----fun_Config.Out, eval=FALSE-----------------------------------------------
#  library(ContDataQC)
#  dn_export <- tempdir()
#  Config.Out(fun.myDir.export = dn_export)

## ----Config, comment="", eval=TRUE, echo=FALSE--------------------------------
fn <- file.path(system.file("extdata", "config.ORIG.R", package="ContDataQC"))
cat(readLines(fn), sep="\n")

