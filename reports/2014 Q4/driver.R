
#' driver.R
#'
#' generates a GAMUT report for each data access group
#'
#'
#'
#'

# Tue Apr 14 17:59:21 2015 ------------------------------

reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    redcap_data_access_group = c("AIM Region 8"),
    dm_email = c("rollie.parrish@ampa.org")
    )

programs_with_total_patients <-
    monthly_data %>%
    group_by(redcap_data_access_group, program_name, ID) %>%
    summarize(total_patients = sum(total_patients)) %>%
    ungroup() %>%
    arrange(total_patients)


reports_data <-
    program_info %>%
    select(redcap_data_access_group, dm_email) %>%
    unique() %>%
    semi_join(programs_with_total_patients)



## Generate report for each data access group
operator <- ""
AIM_reports_data <- filter(reports_data, substr(redcap_data_access_group, 1, 3) == "AIM")

for (dag in reports_data$redcap_data_access_group) {
    filename <- gsub(" ", "_", dag)
    print(filename)
    knit2pdf("GAMUT_Summary_2015_Q2.Rnw", output=paste0('GAMUT_2015Q2_', filename, '.tex'))
    ## cleanup
    unlink(c("*.toc", "*.out", "*.tex",  "*.gz", "*.aux","*.log"))

}


## Generate single report for Air Methods (operator = "AIM")
    dag = ""
    operator = "AIM"
    filename <- gsub(" ", "_", "Air_Methods")
    print(filename)
    knit2pdf("GAMUT_Summary_2015_Q2.Rnw", output=paste0('GAMUT_2015Q2_', filename, '.tex'))


### Send reports via Send-It


## cleanup
unlink(c("*.toc", "*.out", "*.tex",  "*.gz", "*.aux","*.log"))
unlink("*.pdf")
