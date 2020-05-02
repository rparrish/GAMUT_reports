#'
#' beeswarm_plot
#'
#' build a horizontal beeswarm plot with error bars for individual program
#'
#' @param x dataframe from get_CI() function
#' @author Rollie Parrish
#' @export


beeswarm_plot <- function(x, metric = metric, ...)
{




             beeswarm(x$est,
                      pch=1,
                      horizontal = TRUE,
                      xaxt = "n",
                      bty = "n",
                      main = metric,
                      method="hex"
                      )



indiv_points <-
    x %>%
    filter(group == params$program_name)

arrows(x0 = indiv_points$lower, y0=1.3,
       x1 = indiv_points$upper, y1=1.3,
       code = 3, angle = 90, col = "blue",
       length =.1)
points(y = 1.3,x=indiv_points$est, pch=19, cex = 1.2, col = "blue") # add mean

overall_mean <- sum(x$k)/sum(x$n)*100

# add mean
segments(y0 = .0, x0=overall_mean,
         y1 = 1.4, x1 = overall_mean,
         pch=16, lty = "dashed",
         col = "darkgrey")

# add text labels
text(x = indiv_points$est, y = 1.45, paste0("  ", round(indiv_points$est,3),"%"),
     col = "blue")

#text(x = overall_mean - 12, y = .55, paste0("Overall: ", round(overall_mean,1),"%"))
mtext(paste0("Overall: ", round(overall_mean,1),"%"), side = 1, line = 3)
axis(1, at=pretty(x$est),
     lab=paste0(pretty(x$est), "%"),
     las=TRUE)


  #invisible(p)
}
