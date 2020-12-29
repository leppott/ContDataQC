#------------------------------------------------------------------------
#
# This script accesses data using AQUARIUS Time-Series 3.x's Publish API.
#
#
# It depends on the RCurl library; to download and install
# RCurl into your R environment, use this command:
#
#      install.packages('RCurl')
#
#
# Initial command examples were provided by Aquatic Informatics
# technical staff. These examples were then adapted by Mark Hoger at
# Pennsylvania Department of Environmental Protection.
#
# Mark Hoger
# mhoger@pa.gov
#
#------------------------------------------------------------------------

#------------------------------------------------------------------------
#
# Initialize Connection to Database
#
library(RCurl)

co<-c()
# Enter server and AQUARIUS username and password between the ''
server<-''
username<-''
pw<-''
service<-paste('http://', server
               , '/aquarius/Publish/AquariusPublishRestService.svc', sep='')
getauthtoken<-paste(service, '/GetAuthToken?user=', username, '&encPwd='
                    , pw, sep='')
token<-getURL(.opts=co,getauthtoken)
co<-curlOptions(.opts=co,httpheader=c(AQAuthToken=token))
#
# The above commands should result in a token that will be used to access
# data stored in the database.
#
#------------------------------------------------------------------------

#------------------------------------------------------------------------
#
# Data Aquisition
#
# Locations and datasets are selected prior to extracting data. This
# approach reduces the time required to extract data since often only a
# subset of the data is needed.
#
# Steps
# 1. Get a list of locations from database.
# 2. Choose locations.
# 3. Get a list of datasets at the chosen locations.
# 4. Choose datasets (e.g. pH and DO datasets).
# 5. Extract data from datasets chosen. Can limit extraction by date/time
#    during this process.
#
#------------------------------------------------------------------------
# Step 1. Get a list of locations. --------------------------------------
#
getlocations<-paste(service, '/GetLocations',sep='')
locs.all <- read.csv(textConnection(getURL(.opts=co, getlocations)))
#
#------------------------------------------------------------------------
# Step 2. Choose locations. ---------------------------------------------
#
# These steps will depend on the structure of how locations are stored in
# the database you are pulling from. In PADEP's setup, the folders are
# structured by Internal/External data, basin, HUC, then stream name. This
# folder structure is contained in the LOCATIONPATH field and serves as an
# excellent way of grabbing sites from within a watershed.
#
# All subsetting from the original list of locations, locs.all, is stored
# in a dataframe called locs.subset. This dataframe name is used in the
# following steps so it is recommended that you rewrite over, locs. subset
# if multiple steps are done instead of renaming each subset.
#
# Example subsetting of locations. grepl looks for character strings.
#
# To grab all internal data we can use LOCATIONPATH
locs.subset<-locs.all[grepl('Internal Data',locs.all$LOCATIONPATH),]
#
# To search multiple key strings use | as the "or" function:
# 'Swatara|Goose' will return locations with either 'Swatara' or 'Goose'
# in LOCATIONNAME
locs.subset<-locs.subset[grepl('Swatara|Goose',locs.subset$LOCATIONNAME),]
#
#------------------------------------------------------------------------
# Step 3. Get a list of datasets. ---------------------------------------
#
# A loop function is used to pull a list of all datasets at each location
# in locs.subset.
n.sites<-length(locs.subset$IDENTIFIER) # Count locations for the loop
datalist <- list() # Create temporary holder of data
for (i in 1:n.sites){
  getdatasets<-paste(service,'/GetDataSetsList?locId='
                     ,locs.subset$IDENTIFIER[i],sep='')
  datalist[[i]] <- read.csv(textConnection(getURL(.opts=co,getdatasets)))
}
datasets <- do.call(rbind, datalist) # Combine data gathered in loop into
#                                     a dataframe
#
# Make sure no errors were thrown during the loop. If a problem occurred
# it could be with the naming or formatting in AQUARIUS. For example, the
# parameter name (Label field of a dataset in Location Manager) cannot
# include any spaces. Also, time series that have been created but do not
# contain any data will cause problems. A good way to find the issue is
# to see how many elements were created in the loop.
#
#------------------------------------------------------------------------
# Step 4. Choose datasets. ----------------------------------------------
#
# Like with the locations, you now need to select only that datasets you
# want. Again, it is recommended to maintain the dataframe name 'datasets'
# to avoid the need to adjust code in future steps.
#
# To remove Field Visit series from the list of datasets use !grepl to
# select all datasets except those with the given character string.
datasets <- datasets[!grepl("Field Visits", datasets$DataId),]
#
# To select datasets based on parameter type, use parameter identifiers.
# The most common identifiers used by PADEP are below. Parameter
# identifiers can be found in AQUARIUS manager under the parameter tab,
# Parameter ID column.
#       TW = Water temperature
#       SpCond = Specific Conductance
#       PH = pH
#       WO = Dissolved oxygen - concentration
#       WX = Dissolved oxygen - % sat
#       WT = Turbidity
#       HG = Stage
#       QR = Discharge
#       PA = Atmospheric pressure
#       44500 = Calculated-derived series
#
# I typically don't use grepl to subset parameters just in case we ever
# have parameters that contain the same character strings. Instead use
# the following subsetting command.
#
# To grab only water temperature datasets.
datasets <- datasets[datasets$Parameter=='TW',]
# To grab multiple parameter types, use | as the "or" function. For both
# pH and DO concentration datasets:
datasets <- datasets[datasets$Parameter=='PH' | datasets$Parameter=='WO',]
#
#------------------------------------------------------------------------
# Step 5. Extract data. -------------------------------------------------
#
# The datasets dataframe does not contain much location information. To
# better tie location data to the data about to be extracted, I use merge
# to add fields from locs.subset to the datasets dataframe.
datasets<-merge(datasets,locs.subset,all=FALSE,by.x='LocationId'
                ,by.y='IDENTIFIER')
#
# Now we finally grab the actual data from the list of datasets in the
# dataframe 'datasets'. Again, a loop function is used.
n.datasets <- length(datasets$DataId) # Count datasets for the loop
datalist2 <- list() # Create temporary holder of data
for (i in 1:n.datasets){
         # Date range can be selected here. Blank will return all data
         # from the datasets. Format is '2016-10-17T00:00:00.000-05:00'
  start_dt <- ''
  end_dt <- ''
  gettimeseriesdata <- paste(service, '/GetTimeSeriesData', '?dataId='
                             , datasets$DataId[i], '&queryFrom=', start_dt
                             , '&queryTo=', end_dt, sep='')
  datalist2[[i]] <- read.csv(textConnection(getURL(.opts=co, gettimeseriesdata))
                             , skip=4)
  datalist2[[i]]$Time <- strptime(substr(datalist2[[i]]$Time,0,19),"%FT%T")
         # Add some additional identifying columns. Merge with locs.subset
         # must have been done.
  datalist2[[i]]$SiteID<-rep(datasets$LocationId[i],dim(datalist2[[i]])[1])
  datalist2[[i]]$Site<-rep(datasets$LOCATIONNAME[i],dim(datalist2[[i]])[1])
  datalist2[[i]]$Parameter<-rep(datasets$Parameter[i],dim(datalist2[[i]])[1])
  datalist2[[i]]$Units<-rep(datasets$Unit[i],dim(datalist2[[i]])[1])
  datalist2[[i]]$ParameterName<-rep(datasets$DataId[i],dim(datalist2[[i]])[1])
}
dat <- do.call(rbind, datalist2) # Combine data gathered in loop into
#                                 a dataframe
#
# See comments at end of Step 3 if you are getting errors during loop.
#
#------------------------------------------------------------------------
