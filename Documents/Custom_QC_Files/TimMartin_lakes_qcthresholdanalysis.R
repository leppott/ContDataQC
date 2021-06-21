#' Calculate QC Thresholds
#'
#' Runs through continuous logger data and returns a list of data frames containing a variety of statistics which can be used to determine qc thresholds for the ContDataQC package and related Shiny apps.
#' This function will work best if there are multiple years of data collected.
#'   
#' @param loggerdata continuous logger data frame
#' @param datetimefield name of column containing date/time data in the POSIXct format
#' @param depthsfield name of column containing logger depths
#' @param datafield name of column containing the logger data (e.g, Water Temperature, Dissolved Oxygen)
#' @param analysistype does the data frame contains data from a single logger at a single depth or multiple loggers at multiple depths? Valid values are "single" or "multiple." If single, the function will create statistics from the single logger. If multiple, the function will group the loggers into three different clusters based on depth and temperature and develop statistics from each of the clusters. WARNING: the function requires only data from a single logger if "single" is selected and requires data from multiple loggers if "multiple" is selected.
#' @keywords QC threshold ContDataQC
#' @format list
#' @family Pre-QC
#' @examples
#' \dontrun{
#' x = qcthresholdanalysis(
#'     loggerdata = artichoke,
#'     datetimefield = "date_time",
#'     depthsfield = "depths",
#'     datafield = "temp",
#'     analysistype = "single"
#' )
#' }
#'
#' @export


qcthresholdanalysis = function(loggerdata,datetimefield,depthsfield,datafield,analysistype = c("single"|"multiple")){
  
  #loggerdata must be a data frame
  if (is.data.frame(loggerdata)){
    #Standardize names and clean up data frame
    names(loggerdata)[names(loggerdata) == datetimefield] = "date_time"
    names(loggerdata)[names(loggerdata) == depthsfield] = "depths"
    names(loggerdata)[names(loggerdata) == datafield] = "data"
    #datetimefield must be in POSIXct format
    if (lubridate::is.POSIXct(loggerdata$date_time)){
      loggerdata = data.frame("date_time" = loggerdata$date_time,"depths" = loggerdata$depths,"data" = loggerdata$data)
      #Round datetime to 
      loggerdata$date_time = lubridate::round_date(loggerdata$date_time,unit = "15 minutes")
      loggerdata = loggerdata[order(loggerdata$date_time,loggerdata$depths),]
      
      #Code for RoC analysis
      rollsd = function(loggeryear,testperiod,sdlevel){
        datetimedata = strptime(loggeryear$date_time,format = "%Y-%m-%d %H:%M:%S",tz="UTC")
        timediff = difftime(datetimedata[-1],datetimedata[-length(datetimedata)],units = "mins")
        timediff = stats::median(as.vector(timediff),na.rm = TRUE)
        
        zoodata = zoo::zoo(
          loggeryear$data,
          seq(
            from = 1,
            to = nrow(loggeryear),
            by = 1
          )
        )
        
        rolltime = testperiod/(timediff[[1]]/60)
        
        rollit = zoo::rollapply(
          data = zoodata,
          width = rolltime + 1,
          FUN = sd,
          na.rm = TRUE,
          fill = NA,
          align = "right"
        )
        rollit = rollit * sdlevel
        return(rollit)
      }
      
      #Single Depth Analysis
      if (analysistype == "single"){
        message("Single Logger Analysis")
        loggeryears = unique(lubridate::year(loggerdata$date_time))
        
        grossvalues = NULL
        spikevalues = NULL
        rocvalues = NULL
        flatvalues = NULL
        for (i in loggeryears){
          loggeryear = loggerdata[which(lubridate::year(loggerdata$date_time) == i),]
          loggeryear = loggeryear[!duplicated(loggeryear$date_time),]
          ndates = length(unique(as.Date(loggeryear$date_time)))
          #Gross values
          message("Calculating QC values for ",i,": Gross")
          grossvaluesrow = data.frame(
            "year" = i,
            "max" = max(loggeryear$data,na.rm = TRUE),
            "top1" = quantile(loggeryear$data,probs = 1-1/100,na.rm = TRUE),
            "top5" = quantile(loggeryear$data,probs = 1-5/100,na.rm = TRUE),
            "min" = min(loggeryear$data,na.rm = TRUE),
            "bottom1" = quantile(loggeryear$data,probs = 1/100,na.rm = TRUE),
            "bottom5" = quantile(loggeryear$data,probs = 5/100,na.rm = TRUE),
            "mean" = mean(loggeryear$data,na.rm = TRUE),
            "ndates" = length(unique(as.Date(loggeryear$date_time)))
          )
          row.names(grossvaluesrow) = NULL
          grossvalues = rbind(grossvalues,grossvaluesrow)
          
          #Spike Values
          message("Calculating QC values for ",i,": Spike")
          #Find the difference between successive rows
          loggeryear$diff = c(NA,diff(loggeryear$data))
          
          spikevaluesrow = data.frame(
            "year" = i,
            "max" = max(abs(loggeryear$diff),na.rm = TRUE),
            "top1" = quantile(abs(loggeryear$diff),probs = 1-1/100,na.rm = TRUE),
            "top5" = quantile(abs(loggeryear$diff),probs = 1-5/100,na.rm = TRUE),
            "mean" = mean(abs(loggeryear$diff),na.rm = TRUE),
            "ndates" = ndates
          )
          row.names(spikevaluesrow) = NULL
          spikevalues = rbind(spikevalues,spikevaluesrow)
          
          #RoC Values
          message("Calculating QC values for ",i,": RoC")
          
          loggeryear$sd25_3 = as.numeric(rollsd(loggeryear,25,3))
          loggeryear$sd25_6 = as.numeric(rollsd(loggeryear,25,6))
          loggeryear$sd25_9 = as.numeric(rollsd(loggeryear,25,9))
          
          rocvaluesrow = data.frame(
            "year" = i,
            "sd_3x" = nrow(loggeryear[which(abs(loggeryear$diff) > loggeryear$sd25_3),]),
            "sd_6x" = nrow(loggeryear[which(abs(loggeryear$diff) > loggeryear$sd25_6),]),
            "sd_9x" = nrow(loggeryear[which(abs(loggeryear$diff) > loggeryear$sd25_9),]),
            "ndates" = ndates
          )
          rocvalues = rbind(rocvalues,rocvaluesrow)
          
          #Flat Values
          message("Calculating QC values for ",i,": Flat")
          flatseq = sequence(rle(as.character(loggeryear$diff))$lengths)
          
          loggeryear$flatseq = c(flatseq)
          
          row.names(loggeryear[which(loggeryear$flatseq == max(loggeryear$flatseq)),])
          
          flatvaluesrow = data.frame(
            "year" = i,
            "max" = max(flatseq),
            "top1" = round(quantile(flatseq,probs = 1-1/100),digits = 0),
            # "top1count" = length(flatseq[flatseq == round(quantile(flatseq,probs = 1-1/100),digits = 0)]),
            "top5" = round(quantile(flatseq,probs = 1-5/100),digits = 0),
            # "top5count" = length(flatseq[flatseq == round(quantile(flatseq,probs = 1-5/100),digits = 0)]),
            "ndates" = ndates
          )
          row.names(flatvaluesrow) = NULL
          flatvalues = rbind(flatvalues,flatvaluesrow)
        }
        
        finaloutput = list("analysistype" = "single","levels" = NA,"gross" = grossvalues,
                           "spike" = spikevalues,"roc" = rocvalues,"flat" = flatvalues)
      }else if (analysistype == "multiple"){
        #Function for calculating the mode
        mode <- function(v) {
          uniqv <- unique(v)
          uniqv[which.max(tabulate(match(v, uniqv)))]
        }
        message("Multiple Logger Analysis")
        #Add days of year
        loggerdata$DOY = lubridate::yday(loggerdata$date_time)
        DOYs = sort(unique(loggerdata$DOY))
        message("Calculating Hierarchical Clusters")
        #Calculate hierarchical clusters for each day of the year
        DOY_clusters = lapply(DOYs,function(x){
          doydata = loggerdata[which(loggerdata$DOY == x),]
          doydata = doydata[order(doydata$depths),]
          doydata = doydata[,c(2,3)]
          message("Calculating Hierarchical Clusters: calculating distances (DOY",x,")")
          d = dist(doydata,method = "euclidean")
          message("Calculating Hierarchical Clusters: clustering (DOY",x,")")
          fit = hclust(d,method = "mcquitty")
          rm(d)
          message("Calculating Hierarchical Clusters: cutting tree (DOY",x,")")
          doydata$cluster = as.factor(cutree(fit,k=3))
          rm(fit)
          message("Calculating Hierarchical Clusters: compiling (DOY",x,")")
          DOY_splitrow = data.frame(
            "DOY" = x,
            "c1min" = min(doydata$depths[which(doydata$cluster == 1)]),
            "c1max" = max(doydata$depths[which(doydata$cluster == 1)]),
            "c2min" = min(doydata$depths[which(doydata$cluster == 2)]),
            "c2max" = max(doydata$depths[which(doydata$cluster == 2)]),
            "c3min" = min(doydata$depths[which(doydata$cluster == 3)]),
            "c3max" = max(doydata$depths[which(doydata$cluster == 3)])
          )
          return(DOY_splitrow)
        })
        
        #Convert to data frame
        DOY_splits = plyr::ldply(DOY_clusters,data.frame)
        
        #determine where to separate depths for analysis
        dataclusters = data.frame(
          "l1_top" = min(DOY_splits$c1min),
          "l1_bottom" = mode(DOY_splits$c1max),
          "l2_top" = min(DOY_splits$c2min[which(DOY_splits$c2min > mode(DOY_splits$c1max))]),
          "l2_bottom" = mode(DOY_splits$c2max),
          "l3_top" = min(DOY_splits$c3min[which(DOY_splits$c3min > mode(DOY_splits$c2max))]),
          "l3_bottom" = max(DOY_splits$c3max)
        )
        message("Depths split into three separate levels")
        loggeryears = unique(lubridate::year(loggerdata$date_time))
        
        grossvalues = NULL
        spikevalues = NULL
        rocvalues = NULL
        flatvalues = NULL
        message("Calculating QC values")
        for (i in loggeryears){
          # i = loggeryears[2]
          loggeryear = loggerdata[which(lubridate::year(loggerdata$date_time) == i),]
          ndates = length(unique(as.Date(loggeryear$date_time)))
          
          #Select data by cluster
          loggeryeartop = loggeryear[which(loggeryear$depths >= dataclusters$l1_top & loggeryear$depths <= dataclusters$l1_bottom),]
          loggeryearmiddle = loggeryear[which(loggeryear$depths >= dataclusters$l2_top & loggeryear$depths <= dataclusters$l2_bottom),]
          loggeryearbottom = loggeryear[which(loggeryear$depths >= dataclusters$l3_top & loggeryear$depths <= dataclusters$l3_bottom),]
          
          if (nrow(loggeryeartop) > 0){
            topgrossvalues = data.frame(
              "year" = i,
              "level" = "top",
              "max" = max(loggeryeartop$data,na.rm = TRUE),
              "top1" = quantile(loggeryeartop$data,probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(loggeryeartop$data,probs = 1-5/100,na.rm = TRUE),
              "min" = min(loggeryeartop$data,na.rm = TRUE),
              "bottom1" = quantile(loggeryeartop$data,probs = 1/100,na.rm = TRUE),
              "bottom5" = quantile(loggeryeartop$data,probs = 5/100,na.rm = TRUE),
              "mean" = mean(loggeryeartop$data,na.rm = TRUE),
              "ndates" = length(unique(as.Date(loggeryear$date_time)))
            )
            grossvalues = rbind(grossvalues,topgrossvalues)
          }
          
          if (nrow(loggeryearmiddle) > 0){
            middlegrossvalues = data.frame(
              "year" = i,
              "level" = "middle",
              "max" = max(loggeryearmiddle$data,na.rm = TRUE),
              "top1" = quantile(loggeryearmiddle$data,probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(loggeryearmiddle$data,probs = 1-5/100,na.rm = TRUE),
              "min" = min(loggeryearmiddle$data,na.rm = TRUE),
              "bottom1" = quantile(loggeryearmiddle$data,probs = 1/100,na.rm = TRUE),
              "bottom5" = quantile(loggeryearmiddle$data,probs = 5/100,na.rm = TRUE),
              "mean" = mean(loggeryearmiddle$data,na.rm = TRUE),
              "ndates" = length(unique(as.Date(loggeryear$date_time)))
            )
            grossvalues = rbind(grossvalues,middlegrossvalues)
          }
          
          if (nrow(loggeryearbottom) > 0){
            bottomgrossvalues = data.frame(
              "year" = i,
              "level" = "bottom",
              "max" = max(loggeryearbottom$data,na.rm = TRUE),
              "top1" = quantile(loggeryearbottom$data,probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(loggeryearbottom$data,probs = 1-5/100,na.rm = TRUE),
              "min" = min(loggeryearbottom$data,na.rm = TRUE),
              "bottom1" = quantile(loggeryearbottom$data,probs = 1/100,na.rm = TRUE),
              "bottom5" = quantile(loggeryearbottom$data,probs = 5/100,na.rm = TRUE),
              "mean" = mean(loggeryearbottom$data,na.rm = TRUE),
              "ndates" = length(unique(as.Date(loggeryear$date_time)))
            )
            grossvalues = rbind(grossvalues,bottomgrossvalues)
          }
          
          row.names(grossvalues) = NULL
          
          #Spike, RoC, and Flat Values
          message("Calculating QC values for ",i,": Spike, RoC, and Flat")
          
          #Calculate RoC values for the top level
          if (nrow(loggeryeartop) > 0){
            message("Calculating QC values for ",i,": Spike, RoC, and Flat - top")
            topspike = NULL
            toproc = NULL
            topflat = NULL
            for (j in unique(loggeryeartop$depths)){
              # j = unique(loggeryeartop$depths)[1]
              toplogger = loggeryeartop[which(loggeryeartop$depths == j),]
              toplogger = toplogger[!duplicated(toplogger$date_time),]
              toplogger = toplogger[order(toplogger$date_time),]
              toplogger$diff = c(NA,diff(toplogger$data))
              
              #Spike
              topspike = c(topspike,toplogger$diff)
              
              #RoC
              # #13 hours
              # toplogger$sd13_3 = as.numeric(rollsd(toplogger,25,3))
              # toplogger$sd13_6 = as.numeric(rollsd(toplogger,25,6))
              # toplogger$sd13_9 = as.numeric(rollsd(toplogger,25,9))
              # 
              #25 hours
              toplogger$sd25_3 = as.numeric(rollsd(toplogger,25,3))
              toplogger$sd25_6 = as.numeric(rollsd(toplogger,25,6))
              toplogger$sd25_9 = as.numeric(rollsd(toplogger,25,9))
              # 
              # #50 hours
              # toplogger$sd50_3 = as.numeric(rollsd(toplogger,50,3))
              # toplogger$sd50_6 = as.numeric(rollsd(toplogger,50,6))
              # toplogger$sd50_9 = as.numeric(rollsd(toplogger,50,9))
              
              toprocrow = data.frame(
                "year" = i,
                "level" = "top",
                # "depth" = j,
                # "sd13_3x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd13_3),]),
                # "sd13_6x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd13_6),]),
                # "sd13_9x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd13_9),]),
                "sd_3x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd25_3),]),
                "sd_6x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd25_6),]),
                "sd_9x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd25_9),])
                # "sd50_3x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd50_3),]),
                # "sd50_6x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd50_6),]),
                # "sd50_9x" = nrow(toplogger[which(abs(toplogger$diff) > toplogger$sd50_9),])
              )
              toproc = rbind(toproc,toprocrow)
              
              #Flat
              topflatseq = sequence(rle(as.character(toplogger$diff))$lengths)
              
              topflat = c(topflat,topflatseq)
            }
            
            #Spike Values
            topspikevalues = data.frame(
              "year" = i,
              "level" = "top",
              "max" = max(abs(topspike),na.rm = TRUE),
              "top1" = quantile(abs(topspike),probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(abs(topspike),probs = 1-5/100,na.rm = TRUE),
              "mean" = mean(abs(topspike),na.rm = TRUE),
              "ndate" = ndates
            )
            row.names(topspikevalues) = NULL
            spikevalues = rbind(spikevalues,topspikevalues)
            #RoC Values
            toprocvalues = data.frame(
              "year" = i,
              "level" = "top",
              "max_sd_3x" = max(toproc$sd_3x),
              "top1_sd_3x" = quantile(toprocrow$sd_3x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_3x" = quantile(toprocrow$sd_3x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_3x" = mean(toproc$sd_3x),
              "max_sd_6x" = max(toproc$sd_6x),
              "top1_sd_6x" = quantile(toprocrow$sd_6x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_6x" = quantile(toprocrow$sd_6x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_6x" = mean(toproc$sd_6x),
              "max_sd_9x" = max(toproc$sd_9x),
              "top1_sd_9x" = quantile(toprocrow$sd_9x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_9x" = quantile(toprocrow$sd_9x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_9x" = mean(toproc$sd_9x),
              "ndates" = ndates
            )
            row.names(toprocvalues) = NULL
            rocvalues = rbind(rocvalues,toprocvalues)
            
            #Flat Values
            topflatvalues = data.frame(
              "year" = i,
              "level" = "top",
              "max" = max(topflat),
              "top1" = round(quantile(topflat,probs = 1-1/100),digits = 0),
              # "top1count" = length(topflat[topflat == round(quantile(topflat,probs = 1-1/100),digits = 0)]),
              "top5" = round(quantile(topflat,probs = 1-5/100),digits = 0),
              # "top5count" = length(topflat[topflat == round(quantile(topflat,probs = 1-5/100),digits = 0)]),
              "ndates" = ndates
            )
            row.names(topflatvalues) = NULL
            flatvalues = rbind(flatvalues,topflatvalues)
            
          }
          #Calculate Spike, RoC, and Flat values for the middle level
          if (nrow(loggeryearmiddle) > 0){
            message("Calculating QC values for ",i,": Spike, RoC, and Flat - middle")
            middlespike = NULL
            middleroc = NULL
            middleflat = NULL
            for (j in unique(loggeryearmiddle$depths)){
              middlelogger = loggeryearmiddle[which(loggeryearmiddle$depths == j),]
              middlelogger = middlelogger[!duplicated(middlelogger$date_time),]
              middlelogger = middlelogger[order(middlelogger$date_time),]
              middlelogger$diff = c(NA,diff(middlelogger$data))
              
              #Spike
              middlespike = c(middlespike,middlelogger$diff)
              
              #RoC
              #25 hours
              middlelogger$sd25_3 = as.numeric(rollsd(middlelogger,25,3))
              middlelogger$sd25_6 = as.numeric(rollsd(middlelogger,25,6))
              middlelogger$sd25_9 = as.numeric(rollsd(middlelogger,25,9))
              
              middlerocrow = data.frame(
                "year" = i,
                "level" = "middle",
                "sd_3x" = nrow(middlelogger[which(abs(middlelogger$diff) > middlelogger$sd25_3),]),
                "sd_6x" = nrow(middlelogger[which(abs(middlelogger$diff) > middlelogger$sd25_6),]),
                "sd_9x" = nrow(middlelogger[which(abs(middlelogger$diff) > middlelogger$sd25_9),])
              )
              middleroc = rbind(middleroc,middlerocrow)
              
              #Flat
              middleflatseq = sequence(rle(as.character(middlelogger$diff))$lengths)
              
              middleflat = c(middleflat,middleflatseq)
            }
            
            #Spike Values
            middlespikevalues = data.frame(
              "year" = i,
              "level" = "middle",
              "max" = max(abs(middlespike),na.rm = TRUE),
              "top1" = quantile(abs(middlespike),probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(abs(middlespike),probs = 1-5/100,na.rm = TRUE),
              "mean" = mean(abs(middlespike),na.rm = TRUE),
              "ndate" = ndates
            )
            row.names(middlespikevalues) = NULL
            spikevalues = rbind(spikevalues,middlespikevalues)
            
            #RoC Values
            middlerocvalues = data.frame(
              "year" = i,
              "level" = "middle",
              "max_sd_3x" = max(middleroc$sd_3x),
              "top1_sd_3x" = quantile(middlerocrow$sd_3x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_3x" = quantile(middlerocrow$sd_3x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_3x" = mean(middleroc$sd_3x),
              "max_sd_6x" = max(middleroc$sd_6x),
              "top1_sd_6x" = quantile(middlerocrow$sd_6x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_6x" = quantile(middlerocrow$sd_6x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_6x" = mean(middleroc$sd_6x),
              "max_sd_9x" = max(middleroc$sd_9x),
              "top1_sd_9x" = quantile(middlerocrow$sd_9x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_9x" = quantile(middlerocrow$sd_9x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_9x" = mean(middleroc$sd_9x),
              "ndates" = ndates
            )
            row.names(middlerocvalues) = NULL
            rocvalues = rbind(rocvalues,middlerocvalues)
            
            #Flat Values
            middleflatvalues = data.frame(
              "year" = i,
              "level" = "middle",
              "max" = max(middleflat),
              "top1" = round(quantile(middleflat,probs = 1-1/100),digits = 0),
              # "top1count" = length(middleflat[middleflat == round(quantile(middleflat,probs = 1-1/100),digits = 0)]),
              "top5" = round(quantile(middleflat,probs = 1-5/100),digits = 0),
              # "top5count" = length(middleflat[middleflat == round(quantile(middleflat,probs = 1-5/100),digits = 0)]),
              "ndates" = ndates
            )
            row.names(middleflatvalues) = NULL
            flatvalues = rbind(flatvalues,middleflatvalues)
          }
          #Calculate RoC values for the bottom level
          if (nrow(loggeryearbottom) > 0){
            message("Calculating QC values for ",i,": Spike, RoC, and Flat - bottom")
            bottomspike = NULL
            bottomroc = NULL
            bottomflat = NULL
            for (j in unique(loggeryearbottom$depths)){
              bottomlogger = loggeryearbottom[which(loggeryearbottom$depths == j),]
              bottomlogger = bottomlogger[!duplicated(bottomlogger$date_time),]
              bottomlogger = bottomlogger[order(bottomlogger$date_time),]
              bottomlogger$diff = c(NA,diff(bottomlogger$data))
              
              #Spike
              bottomspike = c(bottomspike,bottomlogger$diff)
              
              #RoC
              #25 hours
              bottomlogger$sd25_3 = as.numeric(rollsd(bottomlogger,25,3))
              bottomlogger$sd25_6 = as.numeric(rollsd(bottomlogger,25,6))
              bottomlogger$sd25_9 = as.numeric(rollsd(bottomlogger,25,9))
              
              bottomrocrow = data.frame(
                "year" = i,
                "level" = "bottom",
                "sd_3x" = nrow(bottomlogger[which(abs(bottomlogger$diff) > bottomlogger$sd25_3),]),
                "sd_6x" = nrow(bottomlogger[which(abs(bottomlogger$diff) > bottomlogger$sd25_6),]),
                "sd_9x" = nrow(bottomlogger[which(abs(bottomlogger$diff) > bottomlogger$sd25_9),])
              )
              bottomroc = rbind(bottomroc,bottomrocrow)
              
              #Flat
              bottomflatseq = sequence(rle(as.character(bottomlogger$diff))$lengths)
              
              bottomflat = c(bottomflat,bottomflatseq)
            }
            
            #Spike Values
            bottomspikevalues = data.frame(
              "year" = i,
              "level" = "bottom",
              "max" = max(abs(bottomspike),na.rm = TRUE),
              "top1" = quantile(abs(bottomspike),probs = 1-1/100,na.rm = TRUE),
              "top5" = quantile(abs(bottomspike),probs = 1-5/100,na.rm = TRUE),
              "mean" = mean(abs(bottomspike),na.rm = TRUE),
              "ndate" = ndates
            )
            row.names(bottomspikevalues) = NULL
            spikevalues = rbind(spikevalues,bottomspikevalues)
            
            #RoC
            bottomrocvalues = data.frame(
              "year" = i,
              "level" = "bottom",
              "max_sd_3x" = max(bottomroc$sd_3x),
              "top1_sd_3x" = quantile(bottomrocrow$sd_3x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_3x" = quantile(bottomrocrow$sd_3x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_3x" = mean(bottomroc$sd_3x),
              "max_sd_6x" = max(bottomroc$sd_6x),
              "top1_sd_6x" = quantile(bottomrocrow$sd_6x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_6x" = quantile(bottomrocrow$sd_6x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_6x" = mean(bottomroc$sd_6x),
              "max_sd_9x" = max(bottomroc$sd_9x),
              "top1_sd_9x" = quantile(bottomrocrow$sd_9x,probs = 1-1/100,na.rm = TRUE),
              "top5_sd_9x" = quantile(bottomrocrow$sd_9x,probs = 1-5/100,na.rm = TRUE),
              "mean_sd_9x" = mean(bottomroc$sd_9x),
              "ndates" = ndates
            )
            row.names(bottomrocvalues) = NULL
            rocvalues = rbind(rocvalues,bottomrocvalues)
            
            #Flat Values
            bottomflatvalues = data.frame(
              "year" = i,
              "level" = "bottom",
              "max" = max(bottomflat),
              "top1" = round(quantile(bottomflat,probs = 1-1/100),digits = 0),
              # "top1count" = length(bottomflat[bottomflat == round(quantile(bottomflat,probs = 1-1/100),digits = 0)]),
              "top5" = round(quantile(bottomflat,probs = 1-5/100),digits = 0),
              # "top5count" = length(bottomflat[bottomflat == round(quantile(bottomflat,probs = 1-5/100),digits = 0)]),
              "ndates" = ndates
            )
            row.names(bottomflatvalues) = NULL
            flatvalues = rbind(flatvalues,bottomflatvalues)
            row.names(spikevalues) = NULL
            row.names(rocvalues) = NULL
            row.names(flatvalues) = NULL
          }
        }
        finaloutput = list("analysistype" = "multiple","levels" = dataclusters,"gross" = grossvalues,
                           "spike" = spikevalues,"roc" = rocvalues,"flat" = flatvalues)
      }
    }else{
      message("datetimefield needs to be in POSIXct format")
    }
  }else{
    message("loggerdata argument requires a data frame")
  }
  return(finaloutput)
}