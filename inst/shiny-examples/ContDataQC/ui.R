# Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development.
# dagibbs22@gmail.com
# Erik.Leppo@tetratech.com
# Written 2017 and 2018 (mostly David)
# Updated 2020 (Erik)

shinyUI(
  # VERSION ----
  navbarPage("Continuous data QC, summary, and statistics - v2.0.5.9040",
             theme= shinytheme("spacelab"), #also liked "cerulean" at https://rstudio.github.io/shinythemes/
            # tabPan, Site Intro ----
             tabPanel("Site introduction",
                      h3("Background and features", align = "center"),
                      br(),
                      h4("Purpose of this site"),
                      p("One challenge of using continuous water monitoring devices is managing the tremendous amount of data they generate.
                        One sensor recording one parameter every 30 minutes will produce over 17,000 records in one year.
                        All of those records must be checked for errors before they can be used for further analyses.
                        Following completion of quality control checks, creating summaries of the very detailed continuous
                        records is important for conveying its key features.
                        Unfortunately, the sheer number of records can make manual performance of QC and data summarization time-consuming
                        and error-ridden and lead to backlogs in the analysis of valuable data."),
                      br(),
                      p("This website helps expedite continuous data processing by performing several operations on such data.
                        They allow users of continuous monitoring data to QC, combine, and summarize their
                        continuous data files in a standardized way without having to download any programs to their computer.
                        This website also allows users to download U.S. Geological Survey gage data at sites and over periods of their choosing.
                        Collectively, these should reduce errors due to and time needed for manual processing of continuous data."),
                      br(),
                      p("NOTE: This website is under development. New versions will be released periodically.
                        E-mail the contacts at the bottom of this page for project updates.
                        This website was last updated on 4/27/18."),
                      br(),
                      h4("Features of this website"),
                      p("Each feature below is described in more detail in the presentation found on the 'Instructions & interface' tab."),
                      tags$b("1. QC raw data:"),
                      p("Using this website, you can perform quality control checks on continuous stream data
                        in a standardized way without having to download any programs to your computer.
                        This website was developed for air and water temperature and pressure, sensor depth, and stream flow measurements.
                        It has not been tested for other water parameters, such as conductivity, dissolved oxygen, or nutrients.
                        You can process files from multiple sites at the same time but the more records you submit, the longer
                        it will take for the website to process them."),
                      p("This website performs four QC checks on each input parameter: unrealistic high/low values, spikes, fast rates of change,
                        and values staying constant (not changing).
                        Each value can pass (P), be flagged as suspect (S), or be flagged as failing (F).
                        Whether each value is marked as P, S, or F (or X if the test is not applicable to that record) depends on
                        the input threshold values for the QC tests.
                        A file with default threshold values can be found in the 'Advanced features' tab.
                        You can also upload your own custom threshold spreadsheet on that tab.
                        Although this website performs QC checks on the data you input,
                        it is up to you to decide how to respond to any erroneous or suspect values.
                        The website does not change your values for you.
                        For each input file, you receive two output files: a spreadsheet with QC flags for each record,
                        and a summary report (html document)."),
                      tags$b("2. Aggregate QC'ed data:"),
                      p("This website can combine spreadsheets that have been through the QC process in two different ways:
                        by date or by data type.
                        By date: This website can combine multiple QCed spreadsheets from the same site with the same
                        parameters covering different time periods (e.g., combine 2/8/14-4/15/14 and 4/16/14-7/17/14 into a single
                        spreadsheet covering 2/8/14-7/17/14).
                        In this case, the files being aggregated should not have overlapping records (i.e. the later input should start after
                        the end of the first input file).
                        By parameter: This website can combine multiple QCed spreadsheets with different parameters from the same time period at the same site
                        into a multi-parameter spreadsheet (e.g., separate air and water temperature spreadsheets from 7/1/15 to 9/30/15
                        into an air-water temperature spreadsheet over that same time period)."),
                      tags$b("3. Produce summary statistics and plots of QCed data:"),
                      p("Each parameter input to this operation produces three summary output files.
                        1. A spreadsheet with daily average values.
                        2. A spreadsheet with annual, seasonal, monthly, and daily averages, medians, minima, maxima, ranges, standard
                        deviations, and more.
                        3. A pdf with graphs of summart statistics by day, month, season, and year."),
                      tags$b("4. Download USGS gage data:"),
                      p("You can input USGS gage IDs and a date range and the website will
                        download a separate csv for each gage over that time period.
                        See the 'Download USGS gage data' tab for more information."),
                      br(),
                      h4("Further information"),
                      p("This website and the underlying data processing scripts were originally created for the Regional Monitoring Networks (RMNs).
                        The RMNs are groups of long-term stream monitoring sites designed
                        to detect changes in stream health over large areas and long time periods.
                        Their goal is to establish a baseline for stream temperature, hydrology, and macroinvertebrate communities
                        in streams across the US and characterize natural variation and long-term trends.
                        They are a partnership between the U.S. EPA, other federal agencies, states, tribes,
                        and local organizations.
                        Although the types of sites included in the RMNs vary throughout the U.S., many of the sites are
                        high-quality, high-gradient reference sites. For more information on the RMNs, please refer to the ",
                        tags$a(href="https://cfpub.epa.gov/ncea/global/recordisplay.cfm?deid=307973", "RMN report.", target="_blank")),
                      br(),
                      p("One component of the RMN program is the use of standardized monitoring methods across sites to
                        improve characterization of baseline conditions and the statistical power to detect
                        regional, long-term changes in streams.
                        To this end, the same protocols are being used across RMN sites to collect automated
                        water temperature measurements at 15 or 30 minute intervals (continuous data).
                        Some sites also collect water level or flow measurements at the same intervals.
                        One aspect of using standardized protocols is using the same QC checks on data collected
                        at all sites.
                        Although this website was originally developed for the RMNs, it is open to all users of continuous water monitoring data."),
                      br(),
                      p("If you have questions about this website or the RMNs, please contact Britta Bierwagen (bierwagen.britta@epa.gov),
                        David Gibbs (dagibbs22@gmail.com), Jen Stamp (jen.stamp@tetratech.com), and Erik Leppo (erik.leppo@tetratech.com).
                        You may also submit a bug/enhancement notice at this project's",
                        tags$a(href="https://github.com/dagibbs22/RShiny_RMN_QC_scripts/issues", "GitHub page.", target="_blank"),
                        "The R code underlying the data processing (package ContDataQC) was written by Erik Leppo at Tetra Tech, Inc.
                        The package is available for download from GitHub for running on your computer within R from ",
                        tags$a(href="https://github.com/leppott/ContDataQC", "this GitHub page.", target="_blank"),
                        "David Gibbs (ORISE fellow at the U.S. EPA) developed this website."),
                      br()


                      ),
              # tabPan, Instruct ----
             tabPanel("Instructions & interface",
                      # _Instruct, buttons ----
                      # Sidebar with inputs for app
                      sidebarLayout(
                        sidebarPanel(

                          #The selected input file
                          #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
                          tags$div(title="Select one or more csv files to upload here",

                                   #Only allows csv files to be imported
                                   fileInput("selectedFiles",label="Choose files", multiple = TRUE, accept = ".csv")
                          )

                          #Operation to be performed on the selected data
                          ,selectInput("Operation",
                                       label = "Choose operation to perform",
                                       choices = c("",
                                                   "QC raw data",
                                                   "Aggregate QC'ed data",
                                                   "Summary statistics")
                                       ,selected = "")

                          #Only shows the "Run operation" button after data are uploaded
                          ,tags$div(title="Click to run selected operation",
                                    uiOutput('ui.runProcess')
                          )

                          ,br()
                          ,br()

                          #Only shows the "Download" button after the process has run
                          ,tags$div(title="Click to download your data",
                                    uiOutput('ui.downloadData')
                          )
                        ),

                        mainPanel(

                          tabsetPanel(type="tabs",
                                      ## _Instruct, text ----
                                      tabPanel("Instructions",
                                               h3("Instructions", align = "center"),
                                               br(),
                                               p("Below are abbreviated instructions for the three operations on this tab:
                                                 QCing raw data, aggregating QC'ed data, and summarizing QC'ed data.
                                                 For more complete information on managing continuous data, preparing data for this website,
                                                 understanding outputs, and troubleshooting, please refer to ",
                                                 a("this presentation. ", target="_blank", href="Continuous_data_website_slides_2018_04_27.pdf"),
                                                 "If you want to try using this website on previously tested files, you can use these ",
                                                 a("sample files.", target="_blank", href="Continuous_data_test_files_2017_11_28.zip"),
                                                 br(),
                                                 br(),
                                                 tags$b("QC raw data:"),
                                                 p("1. Convert all the spreadsheets you will upload to this website into csvs."),
                                                 p("2. Name your input files as follows: SITENAME_DATATYPE_STARTDATE_ENDDATE.csv. The site name
                                                   should match the site name in the input files. Data types are as follows: A (air), W (water), G (flow),
                                                   AW, AG, WG, and AWG. Start and end dates should match the dates in the input files and have the format
                                                   YYYYMMDD (e.g., 20151203). Some example input file names are: 097_A_20150305_20150630.csv,
                                                   GOG12F_AW_20130426_20130725.csv, and BE92_AWG_20150304_20151231.csv."),
                                                 p("3. Download the continuous data ",
                                                   a("template. ", target = "_blank", href="continuous_data_template_2017_11_15.csv"),
                                                   "In order for this website to correctly process your continuous data,
                                                   you need to format your data and column names following this template."),
                                                 p("4. Copy the appropriate column headers from the template into the spreadsheet(s) you want
                                                   the website to process. The only required fields to run the QC process are 'Date Time', 'SiteID',
                                                   and at least one measurement column (air, water, sensor depth, or flow). It does not matter what
                                                   order the columns are in within your spreadsheet(s)."),
                                                 p("5. Verify that the data in your spreadsheets are in the same formats as the data in
                                                   the template spreadsheet (e.g., that the values in 'Date Time' are formatted the same
                                                   as in the template). The website will not work on your data if the formats are
                                                   incorrect."),
                                                 p("6. Delete any extraneous columns from your spreadsheets."),
                                                 p("7. Delete any extra header rows besides the ones with the field names. Delete any rows at
                                                   the bottom of the spreadsheets that show termination of the sensor log."),
                                                 p("8. Upload your files to the website using the 'Browse' button to the left."),
                                                 p("9. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected or if the table is replaced by error messages,
                                                   it means that something is wrong with your input file(s), e.g., a column heading is incorrect."),
                                                 p("10. Select 'QC raw data' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                                 p("11. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                                 p("12. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files (spreadsheets and QC reports).
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                                 br(),
                                                 tags$b("Aggregate QC'ed data:"),
                                                 p("1. Upload your QCed files to the website using the 'Browse' button to the left.
                                                   NOTE: Files must have gone through the QC operation on this website before the 'Aggregate' operation can be used on them."),
                                                 p("2. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected, it means that something is wrong with your input file(s), e.g.,
                                                   a column heading is incorrect."),
                                                 p("3. Select 'Aggregate QC'ed data' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                                 p("4. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                                 p("5. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files (spreadsheet and QC report of aggregated data).
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                                 br(),
                                                 tags$b("Generate summary statistics and plots of QC'ed data:"),
                                                 p("NOTE: This operation will not use any records marked as 'Failed'.
                                                   Thus, if you want to include records marked as 'Failed', change their flag to something else."),
                                                 p("1. Upload your QC'ed files to the website using the 'Browse' button to the left.
                                                   NOTE: Files must have gone through the QC operation on this website before the 'Summary statistics' operation can be used on them.
                                                   Files do not have to have gone through the 'Aggregate' operation prior to summarization."),
                                                 p("2. Verify that the files are being interpreted correctly in the tables in the 'Summary tables' tab.
                                                   If they are not showing as expected, it means that something is wrong with your input file(s), e.g.,
                                                   a column heading is incorrect."),
                                                 p("3. Select 'Summary statistics' using the drop-down menu to the left.
                                                   A 'Run operation' button should appear below the operation selection drop-down menu."),
                                                 p("4. Click the 'Run operation' button.
                                                   A progress bar will appear in the bottom-right of the browser tab.
                                                   It will advance after each file is processed.
                                                   Thus, if you upload three files, it will wait at 0%, jump to 33%, jump to 66%, and then jump to 100%.
                                                   It will not advance while each file is being processed."),
                                                 p("5. Once the process is completed, a 'Download' button will appear below the 'Run operation'
                                                   button.
                                                   Click the button to download a zip file of all output files: two csvs and one pdf for each input parameter in each input file.
                                                   Where the files will download on your computer depends on the configuration of your internet browser."),
                                                 br(),
                                                 br(),
                                                 p("For more information on continuous data pre-processing,
                                                   please visit the Regional Monitoring Network Sharepoint or ftp sites."))
                                                 ),

                                      tabPanel("Summary tables",

                                               h3("Summary tables of input files", align = "center"),
                                               br(),

                                               p("After uploading data, confirm that the table below is showing
                                                 the expected values"),

                                               # #FOR TESTING ONLY. Outputs testing text
                                               # textOutput(paste("testText")),

                                               #Shows an empty table until files are input
                                               tableOutput("nullTable1"),
                                               tableOutput("nullTable2"),

                                               #Outputs the table with properties of the input spreadsheets,
                                               #and a testing table of the beginning of the spreadsheets
                                               tableOutput("summaryTable1"),
                                               tableOutput("summaryTable2"),

                                               br(),

                                               #Shows a note if the user uploads non-QCed data and selects
                                               #the Aggregate or Summarize processes
                                               h4(textOutput("aggUnQCedData")),
                                               h4(textOutput("summUnQCedData")),

                                               #Shows a note if spreadsheets with multiple sites are selected
                                               #for the Aggregate process
                                               h4(textOutput("moreThanOneSite"))
                                               )
                                                 )
                                                 )
                                                 )
                                               ),
              # tabPan, USGS ----
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
                               ,textInput("USGSsite", "USGS site ID(s) (separated by commas and spaces)")
                               ,textInput("startDate", "Starting date (YYYY-MM-DD)")
                               ,textInput("endDate", "Ending date (YYYY-MM-DD)")
                               ,br()
                               ,actionButton("getUSGSData", "Retrieve USGS data")
                               ,br()
                               ,br()

                               #Only shows the "Download" button after the process has run
                               ,tags$div(title="Click to download your USGS gage data",
                                         uiOutput('ui.downloadUSGSData'))
                        )
                               )
                               ),
              # tabPan, Adv Feat ----
             tabPanel("Advanced features",
                     sidebarLayout(
                       ## _Adv Feat, Console ----
                        sidebarPanel(
                               h3("R console output", align = "Center"),
                               p("This panel shows messages output by the QC, aggregating, summarizing, and USGS data retrieval processes.
                                 If there are any errors when the tool runs, please copy
                                 the messages and send them and your input files to the contacts listed on the 'Site introduction' tab."),
                               tableOutput("logText"),
                               tableOutput("logTextUSGS"),
                               tags$b(textOutput("logTextMessage"))

                               ## For debugging only: lists all files on the server
                               # ,br()
                               # ,br()
                               # ,br()
                               # ,br()
                               # ,tableOutput("serverTable")
                               ), ## sidebarPanel ~ END

                        mainPanel(
                          tabsetPanel(type="tabs",
                                ## _Adv Feat, Config ----
                               tabPanel("Custom QC thresholds",
                               h3("Custom QC thresholds", align = "Center"),
                               p("You can upload custom QC thresholds here.
                                 Please use",
                                 a("this ", target="_blank", href="Config_R.zip"),
                                 "configuration document as a template."),
                               p("Once you have made your changes to the configuration file, upload them below.
                                 You will have the option to return to the default configuration after you upload your custom file."),
                               br(),
                               #Tool tip code from https://stackoverflow.com/questions/16449252/tooltip-on-shiny-r
                               tags$div(title="Select R configuration file to upload here",

                                        #Only allows R files to be imported
                                        fileInput("configFile",label="Choose configuration file", multiple = FALSE, accept = ".R")
                               )

                               ,br()
                               ,br()

                               #Only shows the "Default configuration" button after a user-selected file has been used
                               ,tags$div(title="Click to use default configuration data",
                                         uiOutput('ui.defaultConfig')
                               )
                               ) ## tabPanel ~ QC ~ END
                               ## _Adv Feat, HOBO ----
                               , tabPanel("HOBOware reformat",
                                          h3("HOBOware reformat", align = "Center")
                                          , tags$b("Description")
                                          , p("Format HoboWare output for use with 'ContDataQC' package. Works on individual csv files. Imports, modifies, and saves with the same filename for download.")
                                          , p("One file or multiple files can be uploaded for processing.")
                                          , tags$b("Details")
                                          , p("Imports a HoboWare output (with minimal tweaks), reformats it using defaults from the ContDataQC config file , and exports a CSV to another folder for use with ContDataQC.")
                                          , p("HOBOware will only output ambiguous dates with 2 digits. There are two delimiters (/ and -) and three formats (MDY, DMY, and YMD) resulting in six possible formats. The default is set to NULL and will not modify the date format.")
                                          , p("It is assumed the user has a single Date Time field rather than two fields (Date and Time).")
                                          , p("A zip file with all CSV files ready for use with the ContDataQC QC function will be generated and can be downloaded.")
                                          , p("'Run' and 'Download' buttons do not appear until the previous step is complete ('Upload' and 'Run', respectively).")
                                          , hr()
                                          , tags$div(title="Select one HOBOware csv files to upload here"
                                                     , fileInput("selectedFiles_HOBO"
                                                                 ,label="Choose files"
                                                                 , multiple = TRUE
                                                                 , accept = ".csv"
                                                                 , width = "600px") # wider for long file names
                                          )

                                          # ,selectInput("HOBO_DateFormat",
                                          #              label = "Choose date format from HOBOware file",
                                          #              choices = c(NULL
                                          #                          , "DMY"
                                          #                          )
                                          #              ,selected = NULL)
                                          #Only shows the "Run operation" button after data are uploaded
                                          ,tags$div(title="Click to run selected operation (HOBO reformat)",
                                                    uiOutput('ui.runProcess_HOBO')
                                          )
                                          , br()
                                          #Only shows the "Download" button after the process has run
                                          ,tags$div(title="Click to download your data",
                                                    uiOutput('ui.downloadData_HOBO')
                                          )
                                 )## tabPanel ~ HOBO ~ END
                          )##tabsetPanel ~ END
                               )## mainPanel ~ END
                        )## sidebarLayout ~ END
             ), ## tabPanel ~ Adv Feat ~ END
            # tabPan, FAQ ----
             tabPanel("FAQ",
                      h3("A growing list of potentially frequently asked questions")
                      ,br()
                      ,p("Question: Why does the website header say 'preliminary'?")
                      ,p("Answer: This website is still under development. Features are being added to it.
                         Moreover, it has not been approved for public release and is not hosted on
                         an official EPA server.")
                      ,br()
                      ,p("Q: What internet browsers is this website compatible with?")
                      ,p("A: It has been tested with Internet Explorer and Google Chrome.
                         It may be compatible with other browsers but they have not been tested.")
                      ,br()
                      ,p("Q: What will happen if the site IDs in the input file names don't match the site IDs in the
                         input files?")
                      ,p("A: The tool will still work. The output file names will use the site IDs in the input
                         file names.
                         The output spreadsheets themselves will use the site IDs used in the input spreadsheets.
                         Nevertheless, it is good practice to have the site IDs in the file names and inside
                         the files match.")
                      ,br()
                      ,p("Q: What will happen if the date ranges in the input file names don't match the date ranges
                         in the files?")
                      ,p("A: The tool will still process the inputs over the date ranges used inside the
                         files (i.e. the dates of the first and last rows of each input file).
                         The output file names will use the date ranges of the input file names.
                         It is good practice to have the date ranges in the file names and inside the files match.")
                      ,br()
                      ,p("Q: What will happen if I try to aggregate files with overlapping dates?")
                      ,p("A: This may cause errors in the output spreadsheet.
                         We recommend that the files input to the aggregate process do not have overlapping dates.
                         It is fine if the input files are non-consecutive (i.e. skip dates).")
                      ,br()
                      ,p("Q: What's the largest spreadsheet size I can upload?")
                      ,p("A: The total size of uploaded spreadsheets should not be larger than 70 MB.
                         Note that it would take the website quite a while to process such a large input
                         and the progress bar would show no progress until processing is complete.")
                      ,br()
                      ,p("Q: What's the limit on the number of spreadsheets I can upload?")
                      ,p("A: No limit is known at this point. We have tested the website with seven spreadsheets.
                         If you encounter a limit, please let us know.")
                      ,br()
                      ,p("Q: What will happen if I accidentally run the wrong process on my input files?")
                      ,p("A: Either the tool won't run at all or it'll produce output files with weird names
                         (e.g., if you run the QC operation on files you've already run through the QC operation,
                         you'll get output files that start with the name 'QC_QC_').")
                      ,br()
                      ,p("Q: How long does it take for the website to process uploaded files?")
                      ,p("A: Of the QC, aggregate, and summarize processes, QCing takes the longest and it should
                         not take more than a minute or two per 5000 records being processed.
                         Retrieving USGS gage data should only take a few minutes per site for a year's worth
                         of records.")
                      ,br()
                      ,p("Q: I ran one of the website's processes and then left my computer for 10 minutes.
                         When I returned the website was grayed out. What happened?")
                      ,p("A: The website times out after a few minutes of not being used.
                         You will need to upload your files and start the process again in order to get files that you can download.")
                      ,br()
                      ,p("Q: Why does the progress bar stay still for awhile then jump ahead to completion?")
                      ,p("A: It's a result of how the website processes uploaded files.
                         The progress bar does not move until after each file is completed.
                         Thus, if only one file is uploaded, the progress bar goes from 0% to 100% in one jump.
                         If three files are uploaded, the bar jumps from 0% to 33% to 66% to 100% as each file
                         is completed.
                         Think of the progress bar as showing which file the website is currently processing, not
                         as the actual progress towards processing each file.")
                      ,br()
                      ,p("Q: Why isn't my spreadsheet processing? The website just shuts down.")
                      ,p("A: One common reason the site won't process input spreadsheets is because they are
                         formatted incorrectly.
                         Make sure the formatting of your input spreadsheets is correct by checking it against
                         the template",
                         a("here.", target = "_blank", href="continuous_data_template_2017_11_15.csv"),
                         "If that does not fix the problem, contact the e-mail addresses listed on the 'Site introduction' tab.")
                      ,br()
                      ,p("Q: Can other people download my files from the website?")
                      ,p("A: They should not be able to.
                         As soon as you upload a new set of data or close the tab in which you are viewing
                         the website, all of your files (inputs, outputs, USGS data) should be deleted.
                         If you do somehow get someone else's data (instead of or in addition to your own),
                         please contact us.")
                      ,br()
                      ,p("Q: Can multiple people use this website simultaneously?")
                      ,p("A: We think that although multiple people can view the website at a time, only one person can run an operation at a time.
                         It appears that if someone else tries to run an operation while you have an operation running, your operation will terminate.
                         Although we hope that this site is widely used and in constant demand, it is not terribly
                         likely that multiple people will be on it at the same time.
                         However, if the website ever does somehow suggest that multiple people are on it at once, please let us know.")
                      ,br()
                      ,p("Q: Can I change the QC thresholds that the QC process uses?")
                      ,p("A: Yes, you can.
                         Do so under the 'Advanced features' tab.
                         The website will not record which thresholds you used for each output, so make sure you
                         record that information somewhere.")
                      ,br()
                      ,p("Q: What is the 'Advanced features' tab for?")
                      ,p("A: All four processes on this website produce status updates.
                         After the process has completed, these messages are displayed on this tab.
                         You don't need to refer to them unless there's an error, in which case you should send
                         the console output to the contacts listed on this website.
                         You can also upload your own QC threshold spreadsheet on this tab.")
                      ,br()
                      ,p("Q: Can I download data from different USGS gages at different time periods?")
                      ,p("A: Not at this time. Currently, all USGS gages you enter will have data downloaded
                         over the same time period.")
                      ,br()
                      ,p("Q: I've gotta QC my data on the go. Can I use this site on my phone?")
                      ,p("A: Mobile use of this app is untested.
                         Please let us know how it goes.
                         Just remember that internet access is required.")
                      ,br()
                      )

                      )
                      )
