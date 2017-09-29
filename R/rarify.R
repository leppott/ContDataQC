#' Rarify (subsample) biological sample to fixed count
#'
#' Takes as an input a 3 column data frame (SampleID, TaxonID, Count) and returns a similar dataframe with revised Counts.
#'
#' The other inputs are subsample size (target number of organisms in each sample) and seed.
#' The seed is given so the results can be reproduced from the same input file.  If no seed is given a random seed is used.
#'
#' rarify function:
#'  R function to rarify (subsample) a macroinvertebrate sample down to a fixed count;
#'  by John Van Sickle, USEPA. email: VanSickle.John@epa.gov    ;
#'  Version 1.0, 06/10/05;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Erik.Leppo@tetratech.com (EWL)
# 20170912
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @param inbug Input data frame.  Needs 3 columns (SampleID, taxonomicID, Count).
#' @param sample.ID Column name in inbug for sample identifier.
#' @param abund Column name in inbug for organism count.
#' @param subsiz Target subsample size for each sample.
#' @param mySeed Seed for random number generator.  If provided the results with the same inbug file will produce the same results.. Defaut = NA (random seed will be used.)
#' @return Returns a data frame with the same three columns but the abund field has been modified so the total count for each sample is no longer above the target (subsiz).
#' @keywords rarify, subsample
#' @examples
#' # load bio data
#' DF.biodata <- data_bio2rarify
#' dim(DF.biodata)
#' View(DF.biodata)
#' # subsample
#' mySize <- 200
#' Seed.MS <- 18171210
#' bugs.mysize <- rarify(inbug=DF.biodata, sample.ID="SampRep"
#'                      ,abund="Count",subsiz=mySize, mySeed=Seed.MS)
#' dim(bugs.mysize)
#' View(bugs.mysize)
#' # save the data
#' write.table(bugs.mysize,paste("bugs",mySize,"txt",sep="."),sep="\t")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @export
rarify<-function(inbug, sample.ID, abund, subsiz, mySeed=NA){##FUNCTION.rarify.START
  start.time=proc.time();
  outbug<-inbug;
  sampid<-unique(inbug[,sample.ID]);
  nsamp<-length(sampid);
  #parameters are set up;
  #zero out all abundances in output data set;
  outbug[,abund]<-0;
  #loop over samples, rarify each one in turn;

  for(i in 1:nsamp) { ;
    #extract current sample;
    isamp<-sampid[i];
    flush.console();
    #print(as.character(isamp));
    onesamp<-inbug[inbug[,sample.ID]==isamp,];
    onesamp<-data.frame(onesamp,row.id=seq(1,dim(onesamp)[[1]])); #add sequence numbers as a new column;
    #expand the sample into a vector of individuals;
    samp.expand<-rep(x=onesamp$row.id,times=onesamp[,abund]);
    nbug<-length(samp.expand); #number of bugs in sample;
    #vector of uniform random numbers;
    if(!is.na(mySeed)) set.seed(mySeed)  #use seed if provided.
    ranvec<-runif(n=nbug);
    #sort the expanded sample randomly;
    samp.ex2<-samp.expand[order(ranvec)];
    #keep only the first piece of ranvec, of the desired fised count size;
    #if there are fewer bugs than the fixed count size, keep them all;
    if(nbug>subsiz){subsamp<-samp.ex2[1:subsiz]} else{subsamp<-samp.ex2};
    #tabulate bugs in subsample;
    subcnt<-table(subsamp);
    #define new subsample frame and fill it with new reduced counts;
    newsamp<-onesamp;
    newsamp[,abund]<-0;
    newsamp[match(newsamp$row.id,names(subcnt),nomatch=0)>0,abund]<-as.vector(subcnt);
    outbug[outbug[,sample.ID]==isamp,abund]<-newsamp[,abund];
  }; #end of sample loop;

  elaps<-proc.time()-start.time;
  cat(c("Rarify of samples complete. \n Number of samples = ",nsamp,"\n"))
  cat(c(" Execution time (sec) = ", elaps[1]))
  flush.console()
  return(outbug) #return subsampled data set as function value;
} #end of function; ##FUNCTION.rarify.END
