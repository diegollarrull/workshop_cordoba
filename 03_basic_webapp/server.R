library(shiny)
library(shinythemes)
library(plotly)
library(RColorBrewer)
library(dplyr)



####################################################
####################################################
## SERVIDOR
####################################################
####################################################

shinyServer(function(input, output, session) {
  ####################################################
  ## Actualización del dataset para plotear
  ####################################################
  
  dd <- reactive({
    print("dd processing...")
    return (mtcars[mtcars$cyl == input$cyl &
                     mtcars$gear == input$gear, ])
  })
  
  
  ####################################################
  ## Actualización del plot con el nuevo dataset
  ####################################################
  
  output$trendPlot <- renderPlotly ({
    print("PLOTTING!")
    plot <- plot_ly(dd(), x = ~ mpg, y = ~ hp)
    plot <- ggplotly(plot)
    plot
    
    return(plot)
  })
})
