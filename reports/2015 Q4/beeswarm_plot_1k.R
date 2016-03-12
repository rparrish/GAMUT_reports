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


beeswarm_plot1k <- function(data = NULL, title = "GAMUT Metric title", ...)  {
    beeswarm_data <- filter(data, den >=5)

    indiv_data <-
        beeswarm_data %>%
        filter(program_name == params$program_name)

    program_rate_title <- " insufficient data"

    scale_text <- " per 1000 "


    if(nrow(indiv_data) > 0) {
        indiv_points <-
            indiv_data %>%
            with(., prop.test(num, den))

        program_rate_title <- paste0(round(indiv_points$estimate*1000,1),
                                scale_text,
                                " (", indiv_data$num, "/", indiv_data$den, ")")
    }

    par(mar = c(5.1,2,2.0,3.1))
    par(oma = c(0,0,0,0))


    p <- {
        #plot(1, type="n", xlab="", ylab="", xlim=c(0, 1), xts = "", yts = "" )

    beeswarm(beeswarm_data$num/beeswarm_data$den*1000,
             pch=16, horizontal = TRUE,
             #xaxt = "n",
             bty = "n",
             #corral = "random",
             #corralWidth = .25,
             main = "",
             xlab = paste0("\nGAMUT Overall: ",
                           round(sum(data$num)/sum(data$den)*1000,1),
                           scale_text, " (",
                           sum(data$num), "/",
                           sum(data$den), ")",
                           "\nProgram rate: ", program_rate_title),
             method="hex",
             ...
    )

    if(nrow(indiv_data) > 0) {

     arrows(x0 = indiv_points$conf.int[1]*1000, y0=1.1, #1.3,
            x1 = indiv_points$conf.int[2]*1000, y1=1.1, #1.3,
            code = 3, angle = 90, col = "blue",
            lwd = 2,
            length =.1)

    points(y = 1.1, #1.3,
           x=indiv_points$estimate*1000, pch=19, cex = 1.2, col = "blue") # add mean

    # add text labels
    text(x = indiv_points$estimate*1000,
         y = 1.30,
         paste0(round(indiv_points$estimate*1000,1)),
         #paste0("  ", round(indiv_points$estimate*10000,1),scale_text),
         col = "blue")
 }

    overall_mean <- sum(data$num)/sum(data$den)*1000

    # add mean
    segments(y0 = .6, x0=overall_mean,
             y1 = 1.4, x1 = overall_mean,
             pch=16, lty = "dashed",
             col = "darkgrey")




     }


    # axis(1,
    #      at =  pretty(c(0, data$num/data$den*10000, 1)),
    #      labels =  paste0(pretty(c(0, data$num/data$den*10000, 1)), "%"),
    #      xlim = c(0,1),
    #      las=TRUE
    # )

    title(main = list(paste(title), cex = 1,
                      col = "red", font = 3))
    #print(p)
    invisible(p)
}
