


plot.metrics.wm <- function (metric= "metric name", group, wavg, rate.overall, reordering="decreasing", qlabel="") {
  
  x <- data.frame(group=group, est=wavg)

  #return(str(x))
  
    
  dotplot.No_errors(x
                 , main=paste(metric
                              , "\n"
                              , "Overall: "
                              , round(rate.overall,0)
                              , "min."
                 )
                 , reference.line=rate.overall
                 , reordering=reordering
                 , qlabel=qlabel
                 
  )
  
  # return(cbind(program_name, x[2:6]))
  
}
