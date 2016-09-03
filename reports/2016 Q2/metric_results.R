
metric_results <- function(measure = "HT-1", show_plotData = FALSE, show_runchart = TRUE, program) {

    metric <- metric_data[metric_data$measure_id == measure,]


    plotData <- pd(dag=program,
                   num=metric$numerator_field,
                   den=metric$denominator_field
    )
    beeswarm_plot(plotData, metric$full_name, program
    )

    # generate kable
    if(show_plotData) {
        show_plotData(measure, program )
    }


    # generate kable
    if(show_runchart) {
        show_runchart(measure, program )
    }


}
