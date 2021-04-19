# Panel, Intro

function(){

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
                        This website was last updated on 2021-01-13."),
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
             tags$a(href="https://leppott.github.io/ContDataQC/", "this GitHub page.", target="_blank"),
             "David Gibbs (ORISE fellow at the U.S. EPA) developed this website."),
           br()


  )

}##FUNCTION ~ END
