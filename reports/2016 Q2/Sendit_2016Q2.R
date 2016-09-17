
#' Sendit_2016Q2.R
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

source(".REDCap_config.R") ## sendit username & password

url <- "https://redcap.gamutqi.org/plugins/sendit_api/sendit.php"
message  <- "The GAMUT database report for Midyear 2016 Q2 is respectfully distributed for your review. This report includes data between July 2015 to June 2016.

Thank you on behalf of the GAMUT database oversight committee."

subject <- "GAMUT 2016 Q2 Summary Report"
org_message <- "
The GAMUT database reports for Midyear 2016 Q2 for your organization are respectfully distributed for your review. This report includes data for each of your programs between July 2015 to June 2016.

We are still working on a new summary report for larger organizations with multiple programs that will show all of your programs on a single report. In the meantime, we are sending these standard individual program reports.

Thank you on behalf of the GAMUT database oversight committee.

"

reports_data_all <- reports_data


# AEL
reports_data_AEL <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("^AEL", program_name))

# AIM
reports_data_AIM <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("^AIM", program_name))

# Mtr
reports_data_MTr <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("^MTr", program_name))

# Everyone else
reports_data_main <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(!grepl("^AIM|^AEL|^Mtr", program_name))


sendit_data <- reports_data_main

sendit_data$file = gsub(" ", "_", sendit_data$program_name)


## individual programs
start_time <- proc.time()
log <- list()
for (row in 1:length(sendit_data$dm_email)) {
    #print(row)

    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2016 Q2 Summary Report - ", sendit_data$program_name[row]),
                        message = message,
                        recipient =  sendit_data$dm_email[row],
                        expireDays = 15,
                        file = paste0("GAMUT_2016Q2_", sendit_data$file[row], ".pdf"),
                        url = url
    )

       log[[row]] <- fromJSON(response)
    cat(paste("Sent", sendit_data$program_name[row], "to", sendit_data$dm_email[row]),
        "at", as.character(Sys.time()),"\n")
    Sys.sleep(10)
}
elapsed <- proc.time() - start_time


## Larger organizations (AEL, AIM, MTr, PHI)
# create a zip file and send just that
#



## log the results
sendit_log_AEL <- as.data.frame(do.call(rbind, log))
sendit_log_AIM <- as.data.frame(do.call(rbind, log))
sendit_log_main <- as.data.frame(do.call(rbind, log))

sendit_log <- rbind(sendit_log_AIM, sendit_log_second)
