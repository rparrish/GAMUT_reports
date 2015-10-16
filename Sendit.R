
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
message  <- "The GAMUT database report for Midyear 2015 is respectfully distributed for your review. This report includes data between July 2014 and June 2015.

Thank you on behalf of the GAMUT database oversight committee."

reports_data_all <- reports_data

# AIM
reports_data_AIM <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("AIM", redcap_data_access_group))

# AEL
reports_data_AEL <-
    reports_data_all %>%
    filter(dm_email != "") %>%
    filter(grepl("AEL", redcap_data_access_group))

reports_data_second <-
    reports_data_all %>%
    semi_join(monthly_data, by = "redcap_data_access_group") %>%
    filter(dm_email != "") %>%
    filter(!grepl("AIM|AEL", redcap_data_access_group))

no_data <-
    reports_data_all %>%
    filter(dm_email == "") %>%
    left_join(record_counts) %>%
    mutate("months submitted" = ifelse(is.na(n), 0, n))


sendit_data <- reports_data

sendit_data$file = gsub(" ", "_", sendit_data$redcap_data_access_group)

log <- list()
for (row in 1:length(sendit_data$dm_email)) {
    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2015 Mid-year Summary Report - ", sendit_data$redcap_data_access_group[row]),
                        message = message,
                        recipient =  sendit_data$dm_email[row],
                        expireDays = 15,
                        file = paste0("GAMUT_2015Q2_", sendit_data$file[row], ".pdf"),
                        url = url
    )
    log[[row]] <- fromJSON(response)
    cat(paste("Sent to:", sendit_data$dm_email[row]), "\n")
    Sys.sleep(10)

}

sendit_log_AIM <- as.data.frame(do.call(rbind, log))
sendit_log_AEL <- as.data.frame(do.call(rbind, log))
sendit_log_second <- as.data.frame(do.call(rbind, log))
sendit_log_FFL <- as.data.frame(do.call(rbind, log))

sendit_log <- rbind(sendit_log_AEL, sendit_log_second, sendit_log_FFL)
