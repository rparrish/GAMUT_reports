
#' driver.R
#'
#' generates a GAMUT report for each data access group
#'
#' Rmarkdown version

library(knitr)
library(GAMUT)
library(REDCapR)
library(zoo)
library(dplyr)

## set default parameters

start_date <- as.Date("2015-01-01")
end_date <- as.Date("2016-01-01")

#' Testing
reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    program_name = c("Cleveland Clinic Adult"),
    dm_email = c("browna23@ccf.org")
    )

## testing

 for(i in reports_data$program_name) {
        print(i)
}

# Uncomment next line to get new data from REDCap
GAMUT_data("GAMUT.Rdata")
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

overview <- list()

overview$enrolled <-
    redcap_data %>%
    with(., levels(as.factor(program_name))) %>%
    length()

overview$partial <-
    monthly_data %>%
    group_by(program_name, month) %>%
    group_by(program_name) %>%
    dplyr::summarise(n = n()) %>%
    filter(n < 12) %>%
    nrow()

overview$full <-
    monthly_data %>%
    group_by(program_name, month) %>%
    group_by(program_name) %>%
    dplyr::summarise(n = n()) %>%
    filter(n == 12) %>%
    nrow()

overview$total_contacts <-
    monthly_data %>%
    with(., sum(total_patients))

programs_with_data <-
    monthly_data %>%
    select(program_name) %>%
    unique()

#' send to larger group
reports_data <-
    program_info %>%
    select(program_name, dm_email) %>%
    filter(dm_email != "") %>%
    semi_join(programs_with_data) %>%
    mutate(program_name = gsub("\\/", " ", program_name)) %>%
    unique()


start_time <- proc.time()
## Generate report for each program
for (program_name in reports_data$program_name) {
        dag <- program_name
    filename <- gsub(" ", "_", program_name)
    print(filename)

    GAMUT_render(format = "pdf_document")
}
elapsed <- proc.time() - start_time

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
