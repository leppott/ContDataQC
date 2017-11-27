#' Richards-Baker (Flashiness) Index [RBI] calculator
#'
#' Input is a vector of mean daily flows.  Output is a value that is the RB Flashiness Index
#'
#' The index is valid over the time period of the data.
#' For example, if the vector contains a month's or a year's data the index will represent that time period.
#' The index will be in the same units as the input data.
#' The function assumes all days are represented (insert NA for missing values).
#' Baker, D.B., R.P. Richards, T.T. Loftus, and J.W. Kramer.  2004.  A New Flashiness Index:
#' Characteristics and Applications to Midwestern Rivers and Streams.  April 2004.
#' Journal of the American Water Resources Association (JAWRA).  Pages 503:522.
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20171117
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param Q Vector of mean daily stream flows.
#' @return Returns a value that represents the RBI.
#' @keywords RBI, Richards Baker Flashiness Index
#' @examples
#' # Get Gage Data via the dataRetrieval package from USGS 01187300 2013
#' data.gage <- dataRetrieval::readNWISdv("03238500", "00060", "1974-10-01", "1975-09-30")
#' head(data.gage)
#' # flow data
#' data.Q <- data.gage[,4]
#' # remove zeros
#' data.Q[data.Q==0] <- NA
#' RBIcalc(data.Q)
#'
#' # QC with document Baker et al., 2004
#' # Table 1, Whiteoak Creek near Georgetown, Ohio (03238500)
#' # Figure 8, upward pointing triangle for 1975 water year value close to "1.0".
#' # Using the data downloaded in journal example calculated RBI values in Excel and R match at 0.9833356.
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
RBIcalc <- function(Q){##FUNCTION.RBIcalc.START
  #
  time.start <- proc.time();
  #
  # Size
  myLen <- length(Q)
  # Add previous record in second column
  Qprev <- c(NA,Q[-myLen])
  # Create dataframe.
  myData <- as.data.frame(cbind(Q,Qprev))
  # delta (absolute)
  myData[,"AbsDelta"] <- abs(myData[,"Q"] - myData[,"Qprev"])
  # SumQ
  SumQ <- sum(myData[,"Q"],na.rm=TRUE)
  # Sum Delta
  SumDelta <- sum(myData[,"AbsDelta"], na.rm=TRUE)
  #
  RBIsum <- SumDelta / SumQ
  #
  time.elaps <- proc.time()-time.start
  # cat(c("Rarify of samples complete. \n Number of samples = ",nsamp,"\n"))
  # cat(c(" Execution time (sec) = ", elaps[1]))
  # flush.console()
  #
  # Return RBI value for data submitted.
  return(RBIsum)
  #
} ##FUNCTION.RBIcalc.END
