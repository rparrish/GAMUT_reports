
metric_results <- function(measure = "HT-1", show_plotData = FALSE, show_runchart = TRUE) {

    metric <- metric_data[metric_data$measure_id == measure,]

    plotData <- pd(dag=dag,
                   num=metric$numerator_field,
                   den=metric$denominator_field
    )
    beeswarm_plot(plotData, metric$full_name, program_name
    )

    # generate kable
    if(show_plotData) {
        show_plotData(measure, program_name )
    }


    # generate kable
    if(show_runchart) {
        show_runchart(measure, program_name )
    }


}
