#' show_plotData.R
#'
#' @return kable (markdown table) of the numerators and denominators for each month
#' @export
#'

show_plotData <- function(measure) {

     metric <- metric_data[metric_data$measure_id == measure,]

    indiv_months <-
        monthly_data %>%
        filter(program_name == dag) %>%
        right_join(month_seq) %>%
        mutate(month = format(month, "%b %Y")) %>%
        select_("month", metric$numerator_field, metric$denominator_field)

    total_months <-
        indiv_months %>%
        filter(complete.cases(.)) %>%

        summarise_each(funs(sum(., na.rm = TRUE)), 2:3) %>%
        mutate(month = "Total") %>%
        select(month, everything())

    kable(bind_rows(indiv_months, total_months))
}
