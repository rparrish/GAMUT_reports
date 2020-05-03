
#' driver_2019Q4.R
#'
#' generates a 2019 Q4 GAMUT report for each data access group
#'
#' Rmarkdown version

library(knitr)
library(GAMUT)
library(REDCapR)
library(zoo)
library(plyr)
library(dplyr)
library(tidyverse)

#' set working directory to source file location
source('GAMUT_render.R')
source('/cloud/project/reports/2019 Q4/.REDCap_config.R')

## set default parameters

start_date <- as.Date("2019-01-01")
end_date <- as.Date("2019-12-01")
month_seq <- data.frame(month = seq(start_date, end_date, by = "month"))

#' Testing
reports_data <- data.frame(
    #redcap_data_access_group = low_volume$redcap_data_access_group,
    program_name = c("AIM Native Air AZ-NM"), #, "Airlift Northwest", "AEL IL", "Flight For Life CO",  "Mercy Life Line"),
    #program_name = c("PHI MD VA Adult Peds", "WVU Medicine Childrens"),
    dm_email = c("rollie.parrish@gmail.com")
    )

## testing

for(i in reports_data$program_name) {
        print(i)
}

# Uncomment next line to get new data from REDCap
#source('/cloud/project/GAMUT_data_cloud.R')
GAMUT_data_cloud(here::here("GAMUT.Rdata"))

load(here::here("GAMUT.Rdata"))

# rename Native Air
monthly_data <- mutate(monthly_data,
                       program_name = ifelse(program_name == "AIM Native Air AZ/NM", "AIM Native Air AZ-NM", as.character(program_name))
                       )
## time data
time_data <-
        monthly_data %>%
        select(program_name, month, total_patients, mean_mobilization, stemi_cases,
               mean_bedside_stemi, mean_scene_stemi) %>%
        filter(month < "2019-07-01")

runchart_data <-
    monthly_data %>%
    filter(month <= end_date)

# Filter past 12 months
monthly_data <- filter(monthly_data,
                       month >= start_date &
                       month <= end_date)

programs_with_data <-
    monthly_data %>%
    select(program_name) %>%
    unique()

#' send to larger group
reports_data <-
    program_info %>%
    select(program_name, dm_email) %>%
    mutate(program_name = as.character(program_name)) %>%
    filter(dm_email != "") %>%
    semi_join(programs_with_data, by = "program_name") %>%
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

    GAMUT_render(format = "pdf_document", program_name = i )
    
    usethis::ui_done("{filename} is done.")
}
elapsed <- proc.time() - start_time
elapsed
}

## Generate single report for organizations

organizations <-
    data.frame(
        org = c("AIM", "PHI"), # AEL and MTr no longer reporting
        #org = c("PHI"),
        org_name = c("Air Methods",  "PHI"),
        #org_name = c("PHI"),
        email = c("awolfe@airmethods.com", 
                  #"noah.banister@air-evac.com",
                  #"kelly.cleary@med-trans.net", 
                  "lmeiner@phihelico.com")
        #email = c("lmeiner@phihelico.com")
    )

# this doesn't work right - need to run knitr manually for each one
for(org in organizations$org) {

    dag <- ""
    filename <- org
    print(filename)

    rmarkdown::render("GAMUT_DAG_template.Rmd",
                      output_format = "pdf_document",
                      #intermediates_dir = "intermediate",
                      clean = TRUE,
                      envir = new.env(),
                      output_file =paste0('GAMUT_2018Q4_', filename, '_Org_Summary.pdf')

    )
    # remove figures
    unlink("figures/*.pdf")#GAMUT_render(format = "pdf_document", program_name = i )

}

### Send Organizational reports via Send-It


## cleanup
#unlink(c("*.toc", "*.out", "*.tex",  "*.gz", "*.aux","*.log"))
unlink("*.pdf")
