
gamut_trend_plot <- function(measure = "AA-1a", freeze = 12) {

    metric <- metric_data[metric_data$measure_id == measure,]

    num=metric$numerator_field
    den=metric$denominator_field

    get_legacy_data <- function(...) {

        mydata <-
            runchart_data %>%
            select_("program_name",  "month", ...) %>%
            filter(complete.cases(.))
            #filter(#!is.na(num),
                   #!is.na(den),
                   #den >= 0,
        names(mydata) <- c("program_name", "month", "num", "den")
        mydata <- filter(mydata, num <= den)

        legacy_programs <-
            mydata %>%
            group_by(program_name) %>%
            tally(sort = TRUE) %>%
            filter(n == 36)

        mydata <-
            mydata %>%
            semi_join(legacy_programs)
        return(mydata)
    }

    legacy_data <- get_legacy_data(num, den)

    legacy_trend <-
        legacy_data %>%
        group_by(month) %>%
        summarise_if(is.numeric, sum, na.rm = TRUE)


    myplot <-
        qic(y = num, n = den, x = month,
            data = legacy_trend,
            chart = "p",
            main = metric$short_name,
            ylab = "percent",
            xlab = "",
            freeze = freeze,
            multiply = 100,
            #breaks = c(12),
            x.format = "%b %Y",
            pre.text = "Baseline: 2014",
            post.text = "2015 forward",
            plot.chart = FALSE)

    return(myplot)
}
