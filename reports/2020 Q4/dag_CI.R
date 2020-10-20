



#' dag_CI
#'
#' Determine the confidence intervals for each program in a data access goup
#' based on numerators/denominators.
#'
#' @param dag
#' @param num
#' @param den
#'
#' @return returns the individual program names
#' @export
#'
#' @examples
dag_CI <- function (mydata)
{
    getIndividualCI <- function(x, n) {
        cidata <- prop.test(x, n)
        return(data.frame(lower = cidata$conf.int[1],
                          est = cidata$estimate,
                          upper = cidata$conf.int[2]))
    }

    results <-
        mydata %>%
        rowwise() %>%
        mutate(lower = getIndividualCI(num, den)$lower,
               est = getIndividualCI(num, den)$est,
               upper = getIndividualCI(num, den)$upper)


    # temp <- data.frame(t(mapply(getIndividualCI, num, den)))
    # results <- data.frame(group = paste0(program_name), n = den,
    #                       k = num,
    #                       lower = round(unlist(temp$lower) * 100, 1),
    #                       est = round(unlist(temp$est) * 100, 1),
    #                       upper = round(unlist(temp$upper) * 100, 1))
    #
    return(results)
}

