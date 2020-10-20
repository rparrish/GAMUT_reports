


dag_results <- function(measure, dag = "", org = NA) {

    metric <- metric_data[metric_data$measure_id == measure,]
    unit <- metric$unit
    title <- metric$full_name

    if(is.null(org)) {org <- NA}
    if(is.null(dag)) {dag <- NA}

    plotData <- pd(dag=dag,
                   num=metric$numerator_field,
                   den=metric$denominator_field
    )


    dagData <- dd(plotData, dag = dag, org = org)$all_data

    if(nrow(dagData) > 2) {

    dagCI <- dag_CI(dagData)


    if(unit == "Percent") {
        plot_scale = 100
        plot_xlim  = 100
        scale_text <-  "% "
    }
    if(unit == "per 1000") {
        plot_scale = 1000
        plot_xlim  = 100
        scale_text <-  "  "
    }

    if(unit == "per 10000") {
        plot_scale = 10000
        plot_xlim = 1000
        scale_text <-  ""
    }
    rate.overall <- dagData %>%
        filter(group == "GAMUT") %>%
        select(prop)

    dag_plot <-
        dotplot_errors(dagCI,
                       main = list(paste(strwrap(title), collapse = "\n"), cex = 1,
                                   col = rgb(093, 165, 218, maxColorValue = 255),  #"blue",
                                   font = 3),
                       reference.line = rate.overall
                       #reordering = reordering,
                       #qlabel = qlabel,
                       )
    print(dag_plot)

    if(org != "AIM") {knitr::kable(dagData) }

     } else { cat("## insufficient data")}



    # results <-
    #     list(
    #          data_table = dagData,
    #          dag_plot = dag_plot
    #          )
    #
    # invisible(results)
}


