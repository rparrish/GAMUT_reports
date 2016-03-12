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


beeswarm_plot <- function(data = NULL, title = "GAMUT Metric title", plot_scale = 100, ...)  {
    beeswarm_data <- filter(data, den >=5)

    indiv_data <-
        beeswarm_data %>%
        filter(program_name == params$program_name)

    program_rate_title <- " insufficient data"

    scale_text <-  "% "

    if(nrow(indiv_data) > 0) {
        indiv_points <-
            indiv_data %>%
            with(., prop.test(num, den))

        program_rate_title <- paste0(round(indiv_points$estimate*plot_scale,1),
                                scale_text,
                                " (", indiv_data$num, "/", indiv_data$den, ")")

    }

    par(mar = c(5.1,2,2.0,3.1))
    par(oma = c(0,0,0,0))


    p <- {
        #plot(1, type="n", xlab="", ylab="", xlim=c(0, 1), xts = "", yts = "" )

    beeswarm(beeswarm_data$num/beeswarm_data$den,
             pch=16, horizontal = TRUE,
             xaxt = "n",
             bty = "n",
             xlim = c(0,1),
             #corral = "random",
             #corralWidth = .25,
             main = "",
             xlab = paste0("\nGAMUT Overall: ",
                           round(sum(data$num)/sum(data$den)*100,1),
                           scale_text, " (",
                           sum(data$num), "/",
                           sum(data$den), ")",
                           "\nProgram rate: ", program_rate_title),
             method="hex",
             ...
    )

    if(nrow(indiv_data) > 0) {

    arrows(x0 = indiv_points$conf.int[1], y0=1.1, #1.3,
           x1 = indiv_points$conf.int[2], y1=1.1, #1.3,
           code = 3, angle = 90, col = "blue",
           lwd = 2,
           length =.1)
    points(y = 1.1, #1.3,
           x=indiv_points$estimate, pch=19, cex = 1.2, col = "blue") # add mean

    # add text labels
    shadowtext(x = indiv_points$estimate,
         y = 1.30,
         paste0("  ", round(indiv_points$estimate*100,1),scale_text),
         col = "blue",
         bg = "white",
         cex = 1,
         r = 0.4)
 }

    overall_mean <- sum(data$num)/sum(data$den)

    # add mean
    segments(y0 = .6, x0=overall_mean,
             y1 = 1.4, x1 = overall_mean,
             pch=16, lty = "dashed",
             col = "grey20")
    }

    axis(1,
            labels = paste0(pretty(c(0, data$num/data$den*100)), "%"),
            at     = pretty(c(0, data$num/data$den, 1)),
            xlim   = c(0,1),
            las    = TRUE)

    title(main = list(paste(title), cex = 1,
                      col = "red", font = 3))
    #print(p)
    invisible(p)
}
