# Panel, FAQ

function() {

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
  ) #tabPanel ~ END

}## FUNCTION ~ END
