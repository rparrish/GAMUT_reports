



dd <- function(data, dag = NA, org = NA) {

    mydata <- data

    program_data <- NULL
    org_data <- NULL

    if (!is.na(org)) {
        program_data <-
            filter(mydata, substr(program_name, 1, 3) == org) %>%
            droplevels()
    }

    if(nrow(program_data)) {
        program_data <-
            program_data %>%
            mutate(org = org) %>%
            select(program_name, redcap_data_access_group, org, everything())

        org_data <-
            program_data %>%
            #summarise_each(funs(sum), num, den) %>%
            summarise_at(vars(num, den), funs(sum)) %>%
            mutate(prop = num/den,
                    org = org,
                    program_name = org,
                    redcap_data_access_group = org
             ) %>%
            select(program_name, redcap_data_access_group, org, everything())
    }


    dag_data <- NULL

    # if (!is.na(dag)) {
    #     program_data <- filter(mydata, redcap_data_access_group == dag)
    #
    #     dag_data <-
    #         program_data %>%
    #         summarise_each(funs(sum), num, den) %>%
    #          mutate(prop = num/den,
    #                 org = dag,
    #                 program_name = dag,
    #                 redcap_data_access_group = dag
    #          ) %>%
    #         select(program_name, redcap_data_access_group, org, everything())
    #
    # }

    gamut_data <-
        mydata %>%
        filter(!program_name %in% program_data$program_name) %>%
        #summarise_each(funs(sum), num, den) %>%
        summarise_at(vars(num, den), funs(sum)) %>%
        mutate(prop = num/den,
                    org = "GAMUT",
                    program_name = "GAMUT",
                    redcap_data_access_group = "GAMUT"
             ) %>%
        select(program_name, redcap_data_access_group, org, everything())


    all_data <-
        bind_rows(program_data, org_data, dag_data, gamut_data) %>%
        arrange(desc(prop)) %>%
        select(group = program_name, everything(), -redcap_data_access_group, -org) %>%
        filter(den >= 5)


    results <- list(
        # mydata = mydata,
        # program_data = program_data,
        # org_data = org_data,
        # dag_data = dag_data,
        # gamut_data = gamut_data,
        all_data = all_data
    )

    return(results)
}
