
#' Sendit.R
#'
#' distributes individual GAMUT reports to each data manager
#'
#'
#'
#'
source("../.REDCap_config.R") ## sendit username & password

url <- "https://ampa.org/redcap/plugins/sendit_api/sendit.php"
message  <- ""

reports_data <- data.frame(
    redcap_data_access_group = c("Akron Childrens", "AEL"),
    dm_email = c("mbigham@chmca.org", "mbigham@chmca.org")
    )

reports_data$file = gsub(" ", "_", reports_data$redcap_data_access_group)

log <- list()
for (row in 1:length(reports_data$dm_email)) {
    response <-  sendit(username=username, password=password,
                        subject=paste("GAMUT 2014 Q4 Report - ", reports_data$redcap_data_access_group[row]),
                        message = message,
                        recipient =  reports_data$dm_email[row],
                        expireDays = 1,
                        file = paste0("GAMUT_2014_", reports_data$file[row], ".pdf"),
                        url = url
    )
    log[[row]] <- fromJSON(response)
    cat(paste("Sent to:", reports_data$dm_email[row]), "\n")
    Sys.sleep(10)

}

sendit_log <- as.data.frame(do.call(rbind, log))
sendit_log
