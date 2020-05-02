#'
#' beeswarm_plot
#'
#' build a horizontal beeswarm plot with error bars for individual program
#'
#' @param data dataframe from pd() function that contains program_name, ID, redcap_data_access_group, num, den, label, and mark
#' @param title plot title
#' @return returns a beeswarm plot
#' @author Rollie Parrish
#' @export


beeswarm_plot <- function(data = NULL, title = "GAMUT Metric title", program = NULL, unit = "Percent",  ...)  {
    beeswarm_data <- filter(data, den >=5)

    indiv_data <-
        beeswarm_data %>%
        filter(program_name == program)

    program_rate_title <- " insufficient data"

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

    if(nrow(indiv_data) > 0) {
        indiv_points <-
            indiv_data %>%
            with(., prop.test(num, den))

        program_rate_title <- paste0(round(indiv_points$estimate*plot_scale,1),
                                scale_text,
                                " (", indiv_data$num, "/", indiv_data$den, ")")

    }

    par(mar = c(5.1,2,2.5,3.1))
    par(oma = c(0,0,0,0))


    p <- {
        #plot(1, type="n", xlab="", ylab="", xlim=c(0, 1), xts = "", yts = "" )

    beeswarm(beeswarm_data$num/beeswarm_data$den*plot_scale,
             pch=16, horizontal = TRUE,
             xaxt = "n",
             bty = "n",
             xlim = c(0, plot_xlim),
             #corral = "random",
             #corralWidth = .25,
             main = "",
             xlab = paste0("\nGAMUT Overall: ",
                           round(sum(beeswarm_data$num)/sum(beeswarm_data$den)*plot_scale,1),
                           scale_text, " (",
                           sum(beeswarm_data$num), "/",
                           sum(beeswarm_data$den), ")",
                           "\nProgram rate: ", program_rate_title),
             method="hex"
    )

    if(nrow(indiv_data) > 0) {

    arrows(x0 = indiv_points$conf.int[1]*plot_scale, y0=1.1, #1.3,
           x1 = indiv_points$conf.int[2]*plot_scale, y1=1.1, #1.3,
           code = 3, angle = 90,
           col = rgb(093, 165, 218, maxColorValue = 255),  #"blue",
           lwd = 2,
           length =.1)
    points(y = 1.1, #1.3,
           x=indiv_points$estimate*plot_scale, pch=19, cex = 1.2,
           col = rgb(093, 165, 218, maxColorValue = 255)  #"blue",
           )# add mean

    # add text labels
    shadowtext(x = indiv_points$estimate*plot_scale,
         y = 1.30,
         paste0("  ", round(indiv_points$estimate*plot_scale,1),scale_text),
         col = rgb(093, 165, 218, maxColorValue = 255),  #"blue",
         bg = "white",
         cex = 1,
         r = 0.4)
 }

    overall_mean <- sum(beeswarm_data$num)/sum(beeswarm_data$den)*plot_scale

    # add mean
    segments(y0 = .6, x0=overall_mean,
             y1 = 1.4, x1 = overall_mean,
             pch=16, lty = "dashed",
             col = "grey20")
    }

    axis(1,
            labels = paste0(pretty(c(0, beeswarm_data$num/beeswarm_data$den, plot_xlim)), scale_text),
            at     = pretty(c(0, beeswarm_data$num/beeswarm_data$den, plot_xlim)),
            xlim   = c(0, plot_xlim),
            las    = TRUE)

    title(main = list(paste(strwrap(title), collapse = "\n"), cex = 1,
                      col = rgb(093, 165, 218, maxColorValue = 255),  #"blue",
                      font = 3))
    invisible(p)
}
