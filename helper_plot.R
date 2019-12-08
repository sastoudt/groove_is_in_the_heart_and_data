helperPlot <- function(base) {
  grid.min <- 0 # , # 10,
  grid.mid <- 0.5 # , # 50,
  grid.max <- 1 # , # 100,
  centre.y <- grid.min - ((1 / 9) * (grid.max - grid.min))
  plot.data <- as.data.frame(toP[nrow(toP), ])
  names(plot.data)[1] <- "group"
  
  
  if (!is.factor(plot.data[, 1])) {
    plot.data[, 1] <- as.factor(as.character(plot.data[, 1]))
  }
  
  plot.data.offset <- plot.data
  plot.data.offset[, 2:ncol(plot.data)] <- plot.data[, 2:ncol(plot.data)] + abs(centre.y)
  # print(plot.data.offset)
  # (b) convert into radial coords
  group <- NULL
  group$path <- CalculateGroupPath(plot.data.offset)
  
  group.line.width <- 1.5
  group.point.size <- 6
  # ... + group (cluster) 'paths'
  base <- base + geom_path(
    data = group$path, aes(x = x, y = y, group = group),
    size = group.line.width, lty = 2, col = "black"
  )
  
  # ... + group points (cluster data)
  
  base <- base + geom_point(data = group$path, aes(x = x, y = y, group = group), size = group.point.size, alpha = 0.5, col = "black")
  
  return(base)
}