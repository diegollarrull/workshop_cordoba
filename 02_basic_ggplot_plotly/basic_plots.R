library(plotly)
library(ggplot2)

p <- plot_ly(midwest,
             y = ~ percollege,
             color = ~ state,
             type = "box")
p


gp2 <-
  ggplot(midwest, aes(y = percollege, x = state, fill = state)) + geom_boxplot() + scale_fill_brewer(palette = "Pastel1")
p2 <- ggplotly(gp2)
p2