



measure_summary <- function(measure = "HT-1", program) {

        metric <- metric_data[metric_data$measure_id == measure,]

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


        program_only <-
                indiv_months %>%
                filter(program_name == program) %>%
                droplevels()

        program_only$gamut_rate <- sum(indiv_months[,2])/sum(indiv_months[, 3])



        results <-
                program_only %>%
                mutate(measure_id = measure) %>%
                select(measure_id, program_name, num = 2, den = 3, program_rate, gamut_rate)

        return(results)
}
