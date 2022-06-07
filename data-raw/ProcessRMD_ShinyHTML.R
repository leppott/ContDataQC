# Create HTML files for use with Shiny app
# Erik.Leppo@tetratech.com
# 2022-06-01
#~~~~~~~~~~~~~~


# Packages
# libary(rmarkdown)

# # Files
# path_rmd <- "data-raw/rmd"
# myFiles <- list.files(path = path_rmd
#                       , pattern = "^App_.+\\.Rmd$"
#                       , full.names = TRUE)
# #myFiles <- myFiles[!myFiles %in% "data-raw/RMD/ShinyHTML_About.Rmd"]
#
# # Loop over files
#
#
# # Render as HTML
# path_shiny_www <- file.path("inst", "shiny-examples", "ContDataQC", "www")
#
#
# for(i in myFiles) {
#   # file name w/o extension
#   #i_fn <- tools::file_path_sans_ext(basename(i))
#   # save to HTML
#   rmarkdown::render(input = i
#                     , output_dir = path_shiny_www
#                 #, output_format = rmarkdown::html_fragment(df_print = "kable")
#                 )
# }## FOR ~ i
#
# shell.exec(normalizePath(path_shiny_www))

#______________________________
# Knit to HTML manually

path_rmd <- "data-raw/rmd"
path_shiny_www <- file.path("inst", "shiny-examples", "ContDataQC", "www")

# open folder
shell.exec(normalizePath(path_rmd))

# Copy
myFile <- list.files(path = path_rmd
                     , pattern = "^App_.+\\.html$"
                     , full.names = TRUE)
file.copy(myFile
          , file.path(path_shiny_www, basename(myFile))
          , overwrite = TRUE)
# Delete
unlink(myFile)
