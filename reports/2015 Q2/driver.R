
#' driver.R
#'
#' generates a GAMUT report for each data access group
#'
#'
#'
#'

library(knitr)
library(GAMUT)

#' Testing
reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    redcap_data_access_group = c("Flight For Life CO"), # "Cincinnati Childrens"),
    dm_email = c("rparrish@flightweb.com")#, "Hamilton.Schwartz@cchmc.org")
    )

#' send to larger group
reports_data <-
    program_info %>%
    select(redcap_data_access_group, dm_email) %>%
    unique()

## Generate report for each data access group
operator <- ""
for (dag in reports_data$redcap_data_access_group) {
    filename <- gsub(" ", "_", dag)
    print(filename)
    knit2pdf("GAMUT_Summary_2015_Q2.Rnw", output=paste0('GAMUT_2015Q2_', filename, '.tex'))

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
