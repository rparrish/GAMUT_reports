##
## get GAMUT data and transform to metricData

require(lattice)
require(xtable)
require(plyr)
require(REDCapR)

source("../reports/original_gamut/functions/dotplot.errors.R")
source("../reports/original_gamut/functions/dotplot.No_errors.R")

source("../reports/original_gamut/functions/get.CI.R")
source("../reports/original_gamut/functions/rc_export.R")
source("../reports/original_gamut/functions/plot.metrics.R")
source("../reports/original_gamut/functions/plot.metrics.wm.R")
source("../reports/original_gamut/functions/anonymize.R")

use.ID <- TRUE

## load data
uri <- "https://ampa.org/redcap/api/"
#token <- "1549742112EEBB389E4C17527EF39BA8"
token <- "C212EB36C4A8347D35690465E350E6C3"



redcap_data <- redcap_read(redcap_uri=uri, token=token,
                           export_data_access_groups=TRUE,
                           raw_or_label = "label")$data

redcap_data$program_name <- as.factor(redcap_data$program_name)
redcap_data$redcap_event_name <- as.factor(redcap_data$redcap_event_name)
redcap_data$redcap_data_access_group <- as.factor(redcap_data$redcap_data_access_group)

mydata <- redcap_data

#mydata <- read.csv("../Data/SOTMPediatricQuality_raw.csv")
# remove demographics rows
participants <- mydata[mydata$redcap_event_name == "Annual",1:13]

mydata <- mydata[mydata$redcap_event_name != "Demographics",]
mydata <- mydata[mydata$redcap_event_name != "Annual",]

## complete data only
mydata <- mydata[mydata$monthly_data_complete == "Complete", ]


#mydata$total_patients <- mydata$total_neo_patients + mydata$total_peds_patients + mydata$total_adult_patients

#mydata$total_runs <- mydata$total_neo_runs + mydata$total_peds_runs

ID.lookup <- data.frame(
    program_name = levels(mydata$program_name)
    , ID = anonymize(as.factor(mydata$program_name))
)

mydata <- merge(mydata, ID.lookup, by="program_name")

mydata <- mydata[,c(1,74,14:72)]

#mydata <- working[,c(1,74,14:37)]

#metricData <- aggregate( . ~ redcap_data_access_group + ID  , FUN=sum, data=mydata[c(1,3:23,48,49,50)])
metricData <- aggregate( . ~ program_name + ID,
                        FUN=sum,
                        na.rm=TRUE, na.action=NULL,
                        data=mydata
)

ID.lookup <- merge(ID.lookup, metricData[2:3], by="ID", all.x=TRUE)

#timeData <- ddply(mydata[, c(1, 3,20,49,50)], .(redcap_data_access_group, ID),
mobilization <- ddply(mydata[mydata$mean_mobilization > 0, c(1,2,3,39,40,41)], .(program_name, ID),
                      function(x) data.frame(
                          mobilization.wavg=weighted.mean(x$mean_mobilization, x$total_patients, na.rm=TRUE)
                      )
)

bedside_stemi <- ddply(mydata[mydata$stemi_cases > 0, c(1,2,39,40,41,42)], .(program_name, ID),
                       function(x) data.frame(
                           bedside_stemi.wavg=weighted.mean(x$mean_bedside_stemi, x$stemi_cases, na.rm=TRUE)
                       )
)

scene_stemi <- ddply(mydata[mydata$stemi_cases > 0, c(1,2,39,40,41,42)], .(program_name, ID),
                     function(x) data.frame(
                         scene_stemi.wavg=weighted.mean(x$mean_scene_stemi, x$stemi_case, na.rm=TRUE)
                     )
)






if (use.ID == TRUE) {
    metricData$group <- metricData$ID
    mobilization$group <- mobilization$ID
    bedside_stemi$group <- bedside_stemi$ID
    scene_stemi$group <- scene_stemi$ID
} else {
    metricData$group <- metricData$program_name
    mobilization$group <- mobilization$program_name
    bedside_stemi$group <- bedside_stemi$program_name
    scene_stemi$group <- scene_stemi$program_name
}

GAMUT_date_loaded <- date()


save(mydata, metricData, ID.lookup, GAMUT_date_loaded,
     mobilization, scene_stemi, bedside_stemi,
     file="../data/GAMUT.Rdata")
