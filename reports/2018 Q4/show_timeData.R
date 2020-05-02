#' show_timeData.R
#'
#' @return kable (markdown table) of the average minutes each month
#' @export
#'

show_timeData <- function(measure, program) {

     metric <- metric_data[metric_data$measure_id == measure,]

    indiv_months <-
        monthly_data %>%
        filter(program_name == program) %>%
        right_join(month_seq) %>%
        mutate(month = format(month, "%b %Y")) %>%
        select_("month", metric$numerator_field, metric$denominator_field)


    timeData_table <-
       bind_rows(indiv_months) %>%
        kable(caption = paste0(metric$short_name, " monthly data for 12 months"))

    return(timeData_table)
}
