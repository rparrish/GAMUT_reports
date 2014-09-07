##
## REDCap-Tableau.R
## 
## Export REDCap data to .csv for Tableau Public
##
## Rollie Parrish
## 2/18/2014


require(lattice)
require(xtable)
require(plyr)
require(REDCapR)

source("anonymize.R")

use.ID <- TRUE

## load data
uri <- "https://ampa.org/redcap/api/"
token <- "1549742112EEBB389E4C17527EF39BA8"

redcap_data <- redcap_read(redcap_uri=uri, token=token, 
                           export_data_access_groups=TRUE,
                           raw_or_label = "label")$data

redcap_data$program_name <- as.factor(redcap_data$program_name)
redcap_data$redcap_event_name <- as.factor(redcap_data$redcap_event_name)
redcap_data$redcap_data_access_group <- as.factor(redcap_data$redcap_data_access_group)

mydata <- redcap_data

#mydata <- read.csv("../Data/SOTMPediatricQuality_raw.csv")
# remove demographics rows
mydata <- mydata[mydata$redcap_event_name != "Demographics",]

mydata$total_patients <- mydata$total_neo_patients + mydata$total_peds_patients
mydata$total_runs <- mydata$total_neo_runs + mydata$total_peds_runs

ID.lookup <- data.frame(
  program_name = levels(mydata$program_name)
  , ID = anonymize(as.factor(mydata$program_name))
)

mydata <- merge(mydata, ID.lookup, by="program_name")

#head(mydata)

write.csv(mydata, file="../SOTMPQM_Demo/Data/Tableau_data.csv", row.names=FALSE)
