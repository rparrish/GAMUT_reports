



#' Shadowtext.R
#'
#' adds white around text label
#' http://stackoverflow.com/questions/25631216/r-is-there-any-way-to-put-border-shadow-or-buffer-around-text-labels-en-r-plot
#'
#' @param x, y  numeric vectors of coordinates where the text labels should be
#'   written. If the length of x and y differs, the shorter one is recycled.
#' @param labels a character vector or expression specifying the text to be
#'   written. An attempt is made to coerce other language objects (names and
#'   calls) to expressions, and vectors and other classed objects to character
#'   vectors by as.character. If labels is longer than x and y, the coordinates
#'   are recycled to the length of labels.
#' @param col, bg the foreground and background color to be used, possibly vectors.
#'   These default to the values of the global graphical parameters in par().
#' @param theta Angles for plotting the background
#' @param r Thickness of the shadow relative to plotting size
#' @param ... Additional arguments passed on to text
#' @return
#' @export

shadowtext <- function(x, y=NULL, labels, col='white', bg='black',
                       theta= seq(0, 2*pi, length.out=50), r=0.1, ... ) {

    xy <- xy.coords(x,y)
    xo <- r*strwidth('A')
    yo <- r*strheight('A')

    # draw background text with small shift in x and y in background colour
    for (i in theta) {
        text( xy$x + cos(i)*xo, xy$y + sin(i)*yo, labels, col=bg, ... )
    }
    # draw actual text in exact xy position in foreground colour
    text(xy$x, xy$y, labels, col=col, ... )
}

