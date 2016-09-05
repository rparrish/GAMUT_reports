
#' driver_2016Q2.R
#'
#' generates a 2016 Q2 GAMUT report for each data access group
#'
#' Rmarkdown version

library(knitr)
library(GAMUT)
library(REDCapR)
library(zoo)
library(plyr)
library(dplyr)

source('GAMUT_render.R')
source('.REDCap_config.R')

## set default parameters

start_date <- as.Date("2015-07-01")
end_date <- as.Date("2016-06-01")
month_seq <- data.frame(month = seq(start_date, end_date, by = "month"))

#' Testing
reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    program_name = c( "Akron Childrens","Airlift Northwest", "AEL IL", "Flight For Life CO", "Boston MedFlight", "Mercy Life Line"),
    dm_email = c("none@nospam.com")
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
        filter(month < "2016-07-01")

runchart_data <-
    monthly_data

# Filter past 12 months
monthly_data <- filter(monthly_data,
                       month >= start_date &
                       month <= end_date)

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

overview$none <-
    overview$enrolled - overview$partial - overview$full

overview$total_contacts <-
    monthly_data %>%
    with(., sum(total_patients))

overview$countries <- 6

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


g <- function() {
start_time <- proc.time()
## Generate report for each program

for (i in reports_data$program_name) {
        dag <- i
        program <- i
        program_name <- i

    filename <- gsub(" ", "_", i)
    print(filename)

    GAMUT_render(format = "pdf_document", program_name = i )
}
elapsed <- proc.time() - start_time
elapsed
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
