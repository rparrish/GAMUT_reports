#' show_plotData.R
#'
#' @return kable (markdown table) of the numerators and denominators for each month
#' @export
#'

show_plotData <- function(measure, program) {

     metric <- metric_data[metric_data$measure_id == measure,]

    indiv_months <-
        monthly_data %>%
        filter(program_name == program) %>%
        right_join(month_seq, by = "month") %>%
        mutate(month = format(month, "%b %Y")) %>%
        select_("month", metric$numerator_field, metric$denominator_field)

    total_months <-
        indiv_months %>%
        filter(complete.cases(.)) %>%
        #summarise_each(funs(sum(., na.rm = TRUE)), 2:3) %>%
        summarise_at(vars(2:3), funs(sum(., na.rm = TRUE))) %>%
        mutate(month = "Total") %>%
        select(month, everything())

    plotData_table <-
       bind_rows(indiv_months, total_months) %>%
        mutate(rate = round(.[[2]]/.[[3]],3)) %>%
        #as_data_frame() %>%
        #kable(caption = paste0(metric$short_name, " monthly data")) %>%
        {.}

    return(plotData_table)
}
