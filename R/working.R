


plot(c(100, 250), c(300, 450), type = "n",
     main = "11 rectangles using `rect(120+i,300+i,  177+i,380+i)'")
i <- 4*(0:10)
## draw rectangles with bottom left (120, 300)+i  and top right (177, 380)+i
rect(120+i, 300+i, 177+i, 380+i, col=rainbow(11, start=.7,end=.1))

opar <- par
#x11(width=4, height=2)

pdf(file="mygraphic.pdf",width=3,height=1)
par(oma = c(1,0,0,0),
    mar = c(0,0,0,0)
)

mid <- 25
plot(c(mid-30, mid+30), c(-5,50), type = "n",
     bty="n", # hide outlining box
     pin = c(6,2),
     xlab = NA, ylab = NA,
     axes = FALSE
     )
rect(mid-10,4,mid+10,10.25)
segments(mid-15,10.25,mid+15,10.25)
points(mid,8, pch = "|", cex = 1)
text(mid+10, 0, "98.2%", cex = .75)
Arrows(28, 10.25, 28, 25, arr.length = .4, code = 1,
       arr.adj = 1,
       arr.type = "curved")
dev.off()
# http://www.inside-r.org/packages/cran/shape/docs/Arrows
