
#' Sendit.R
#'
#' distributes individual GAMUT reports to each data manager
#'
#'
#'
#'
#'

library(rjson)
library(httr)
library(RCurl)

source(".REDCap_config.R") ## sendit username & password

url <- "https://ampa.org/redcap/plugins/sendit_api/sendit.php"
message  <- "The GAMUT database report for 2015 is respectfully distributed for your review. This report includes data between January to December 2015.

Thank you on behalf of the GAMUT database oversight committee."

reports_data_all <- reports_data

# AIM
reports_data_AIM <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("AIM", program_name))

# AEL
reports_data_AEL <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("AEL", program_name))

reports_data_second <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(!grepl("AIM|AEL", program_name))


sendit_data <- reports_data_second

sendit_data$file = gsub(" ", "_", sendit_data$program_name)


start_time <- proc.time()
log <- list()
for (row in 1:length(sendit_data$dm_email)) {
    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2015 Summary Report - ", sendit_data$program_name[row]),
                        message = message,
                        recipient =  sendit_data$dm_email[row],
                        expireDays = 15,
                        file = paste0("GAMUT_2015Q4_", sendit_data$file[row], ".pdf"),
                        url = url
    )
    log[[row]] <- fromJSON(response)
    cat(paste("Sent", sendit_data$program_name[row], "to", sendit_data$dm_email[row]),
        "at", as.character(Sys.time()),"\n")
    Sys.sleep(10)
}
elapsed <- proc.time() - start_time

sendit_log_AIM <- as.data.frame(do.call(rbind, log))
sendit_log_AEL <- as.data.frame(do.call(rbind, log))
sendit_log_second <- as.data.frame(do.call(rbind, log))

sendit_log <- rbind(sendit_log_AIM, sendit_log_second)
