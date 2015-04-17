
#' driver.R
#'
#' generates a GAMUT report for each data access group
#'
#'
#'
#'

reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    redcap_data_access_group = c("Akron Childrens"), # "Cincinnati Childrens"),
    dm_email = c("rparrish@flightweb.com")#, "Hamilton.Schwartz@cchmc.org")
    )

reports_data <-
    program_info %>%
    select(redcap_data_access_group, dm_email) %>%
    unique()
operator <- ""

## Generate report for each data access group
for (dag in reports_data$redcap_data_access_group) {
    filename <- gsub(" ", "_", dag)
    print(filename)
    knit2pdf("GAMUT_Summary_2014_Q1.Rnw", output=paste0('GAMUT_2014_', filename, '_v2.tex'))

}


## Generate single report for Air Methods (operator = "AIM")
    dag = ""
    operator = "AIM"
    filename <- gsub(" ", "_", "Air_Methods")
    print(filename)
    knit2pdf("GAMUT_Summary_2014_Q1.Rnw", output=paste0('GAMUT_2014_', filename, '_v2.tex'))


### Send reports via Send-It


## cleanup
unlink(c("*.toc", "*.out", "*.tex",  "*.gz", "*.aux","*.log"))
unlink("*.pdf")
