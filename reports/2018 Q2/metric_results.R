
metric_results <- function(measure = "AA-1b", show_plotData = TRUE, show_runchart = TRUE, program) {

    metric <- metric_data[metric_data$measure_id == measure,]


    plotData <- pd(dag=program,
                   num=metric$numerator_field,
                   den=metric$denominator_field
    )
    opar <- par()
    beeswarm_plot(plotData, metric$full_name, program, metric$unit)
    par <- opar


    # generate kable
    if(show_runchart) {
        show_runchart(measure, program )
    }

    # generate kable
    if(show_plotData) {
        plot_table <- show_plotData(measure, program )
        print(plotData)

    }



}
