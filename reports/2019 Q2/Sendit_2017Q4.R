
#' Sendit_2017Q4.R
#'
#' distributes individual GAMUT 2016 Q2 reports to each data manager
#'
#'
#'
#'
#'

library(rjson)
library(httr)
library(RCurl)
library(GAMUT)
library(jsonlite)
library(notifier)
library(tidyverse)

source(".REDCap_config.R") ## sendit username & password

url <- "https://redcap.gamutqi.org/plugins/sendit_api/sendit.php"
message  <- "This GAMUT database report is respectfully distributed for your review. This report includes data between Jan 2017 to December 2017.

Thank you on behalf of the GAMUT QI oversight committee."

subject <- "GAMUT 2017 Q4 Summary Report"
org_subject <- "GAMUT 2017 Q4 Organizational Summary Report"
org_message <- "
The GAMUT database reports for your organization are respectfully distributed for your review. This archive includes the individual program reports and an organizational summary that shows the metric performance for each of your organization's program.

Thank you on behalf of the GAMUT QI oversight committee.

"

reports_data_all <- reports_data


# Everyone else
reports_data_main <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(!grepl("^AIM|^AEL|^MTr|^PHI", program_name))
sendit_data <- reports_data_main

# Larger organizations (AEL, AIM, MTr, PHI)
# create a zip file and send just that
#


## individual programs
start_time <- proc.time()
sendit_data$file = gsub(" ", "_", sendit_data$program_name)
log <- list()
for (row in 1:length(sendit_data$dm_email)) {
    #print(row)

    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2017 Q4 Summary Report - ", sendit_data$program_name[row]),
                        message = message,
                        recipients =  as.character(sendit_data$dm_email[row]),
                        expireDays = 15,
                        file = paste0("GAMUT_2017Q4_", sendit_data$file[row], ".pdf"),
                        url = url
    )

       log[[row]] <- fromJSON(response)
    cat(paste("Sent", sendit_data$program_name[row], "to", sendit_data$dm_email[row]),
        "at", as.character(Sys.time()),"\n")
    Sys.sleep(5)
}
elapsed <- proc.time() - start_time
notify(
    title = "Send-it batch complete",
    msg = c("Sent ", length(sendit_data$dm_email), " reports in ", elapsed[1], " minutes.")
)




## log the results
sendit_log <- as.data.frame(do.call(rbind, log))
sendit_log_AIM <- as.data.frame(do.call(rbind, log))
