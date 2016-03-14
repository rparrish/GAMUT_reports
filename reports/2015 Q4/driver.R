
#' driver.R
#'
#' generates a GAMUT report for each data access group
#'
#' Rmarkdown version

library(knitr)
library(GAMUT)

## set default parameters

start_date <- as.Date("2015-01-01")
end_date <- as.Date("2016-01-01")

#' Testing
reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    program_name = c("Flight For Life CO",  "Cincinnati Childrens"),
    dm_email = c("rparrish@flightweb.com", "rollie.parrish@ampa.org")
    )

#' send to larger group
reports_data <-
    program_info %>%
    select(redcap_data_access_group, dm_email) %>%
    unique()

## testing

 for(i in reports_data$program_name) {
        print(i)
}

# Uncomment next line to get new data from REDCap
#GAMUT_data("GAMUT.Rdata")
load("GAMUT.Rdata")

## time data
time_data <-
        monthly_data %>%
        select(program_name, month, total_patients, mean_mobilization, stemi_cases,
               mean_bedside_stemi, mean_scene_stemi) %>%
        filter(month < "2016-01-01")

# Filter past 12 months
monthly_data <- filter(monthly_data,
                       month >= start_date &
                       month < end_date)

## Generate report for each program
for (program_name in reports_data$program_name) {
        dag <- program_name
    filename <- gsub(" ", "_", program_name)
    print(filename)

    GAMUT_render(program_name)
    print(program_name)
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
