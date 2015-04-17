
#' Sendit.R
#'
#' distributes individual GAMUT reports to each data manager
#'
#'
#'
#'
source(".REDCap_config.R") ## sendit username & password

url <- "https://ampa.org/redcap/plugins/sendit_api/sendit.php"
message  <- "This is a revision of the GAMUT database report for 2014 with two changes. First, the graph for `waveform capnography among pediatric patients` has been updated with the correct data fields. Second, this version is now correctly filtered to include only 2014 data.

A WebEx conference call to discuss the report will take place on April 20th at 10:30 AM Eastern (7:30 AM Pacific). Connection information will be sent separately.

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
    filter(dm_email != "") %>%
    filter(!grepl("AIM|AEL", redcap_data_access_group))

no_data <-
    reports_data_all %>%
    filter(dm_email == "") %>%
    left_join(record_counts) %>%
    mutate("months submitted" = ifelse(is.na(n), 0, n))


reports_data <- reports_data_second

reports_data$file = gsub(" ", "_", reports_data$redcap_data_access_group)

log <- list()
for (row in 1:length(reports_data$dm_email)) {
    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2014 Summary Report - ", reports_data$redcap_data_access_group[row]),
                        message = message,
                        recipient =  reports_data$dm_email[row],
                        expireDays = 15,
                        file = paste0("GAMUT_2014_", reports_data$file[row], "_v2.pdf"),
                        url = url
    )
    log[[row]] <- fromJSON(response)
    cat(paste("Sent to:", reports_data$dm_email[row]), "\n")
    Sys.sleep(10)

}

sendit_log_AIM <- as.data.frame(do.call(rbind, log))
sendit_log_second <- as.data.frame(do.call(rbind, log))


