#' show_plotData.R
#'
#' @return runchart (qichart) the spedificed measure
#' @export
#'

show_runchart <- function(measure, program_name) {

     metric <- metric_data[metric_data$measure_id == measure,]
     direction <- ifelse(metric$direction_higher == "Higher", 1, 0)

     program <- program_name
     num=metric$numerator_field
     den=metric$denominator_field

    qd <-
        runchart_data %>%
        filter(program_name == program) %>%
        select_("program_name", "month", y = num, n = den) %>%
        filter(.[, 3]/.[, 4] <= 1) %>%
        group_by(program_name, month) %>%
        summarise_each(funs(sum(., na.rm = TRUE))) %>%
        ungroup() %>%
        mutate(month = as.Date(month)) %>%
        data.frame()


    qd$metric = round(qd[, 3]/qd[, 4],2)

    par(mar = c(5.1,4,2.5,3.1))
    par(oma = c(0,0,0,0))

    if(nrow(qd) >= 6) {
        plot_result <-
            qic(
                y = y, #unintended_hypothermia,
                n = n,
                x = month,
                x.format = "%b %Y",
                main = paste(program_name, ": ", metric$short_name),
                direction = direction,
                data = qd,
                chart = "run",
                multiply = 100,
                #target = target,
                llabs = c("LCL", "CL", "UCL", "Bench"),
                xlab = "",
                ylab = "Percent",
                #ylab = paste(total_count()$metric_ylab),
                #ylim = c(0,100),
                cex = 1.0,
                las = 2,
                #nint = 3,
                #freeze = 12,
                print.out = TRUE,
                plot.chart = TRUE
                #runvals = TRUE
                #sub = "subtitle"

            ) } else {
                #  http://stackoverflow.com/questions/19918985/r-plot-only-text
                plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')
                text(x = 0.5, y = 0.5, paste("Insufficient data for runchart"),
                     cex = 1.6, col = "black")
            }
}

