



measure_summary <- function(measure = "SE-3", program = "Akron Childrens") {

        metric <- metric_data[metric_data$measure_id == measure,]

pretty_rate <- function(data, unit) {
    result <- data
    if(!is.na(data)) {
    #result <- paste0(round(data,3)*100, "%")
    if(unit == "Percent") {
        result <- paste0(round(data,3)*100, "%")
    }
    if(unit == "per 1000") {
        result <- paste0(round(data,3)*1000, " / 1000")
    }
    if(unit == "per 10000") {
        result <- paste0(round(data,4)*10000, " / 10000")
    }
     if(unit == "Avg mins") {
        result <- data
    }
    }
    result
}

                indiv_months <-
                monthly_data %>%
                select_("program_name", metric$numerator_field, metric$denominator_field) %>%
                filter(complete.cases(.)) %>%
                filter(.[2] <= .[3]) %>%
                group_by(program_name) %>%

                summarise_each(funs(sum(., na.rm = TRUE)), 2:3) %>%
                select(program_name, everything()) %>%
                data.frame()

        indiv_months$program_rate <- indiv_months[,2]/indiv_months[, 3]


        ## achievable benchmark of care

        ## if program has data


        program_only <-
                indiv_months %>%
                mutate(measure_id = measure) %>%
                filter(program_name == program) %>%
                droplevels()

        gamut_only <-
            indiv_months %>%
            summarise_each(funs(sum), 2, 3) %>%
            mutate(measure_id = measure,
                   gamut_rate = sum(indiv_months[,2])/sum(indiv_months[, 3])) %>%
            select(measure_id, gamut_rate)




        results <-
            gamut_only %>%
            left_join(program_only, by = "measure_id") %>%
            select(measure_id,  num = 4, den = 5, program_rate, gamut_rate) %>%
            mutate(program_rate = ifelse(den >= 5, program_rate, NA)) %>%
            mutate(oe = round(program_rate/gamut_rate, 1)) %>%
            mutate(#unit = metric$unit,
                   program_rate = pretty_rate(program_rate, metric$unit ),
                   gamut_rate = pretty_rate(gamut_rate, metric$unit))

        return(results)
}
