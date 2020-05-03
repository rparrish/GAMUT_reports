
#' map_gamut.R
#'
#' map of GAMUT participants
#'


map_gamut <- function(world = TRUE) {

    airports <- readr::read_csv("http://ourairports.com/data/airports.csv")

    map <- {
    newmap <- getMap(resolution = "low")
    plot(newmap, xlim = c(-170, 180), ylim = c(-70, 70), asp = 1)

    spokane <-
        airports %>%
        filter(type == "large_airport") %>%
        select(lon = longitude_deg, lat = latitude_deg)

    points(spokane, pch = 19, cex = .6, col = "blue")
    }

    #return(map)
}
