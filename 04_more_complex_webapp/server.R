library(shiny)
library(shinythemes)
library(plotly)
library(RColorBrewer)
library(dplyr)

source("include/datos.R", local=T)

#-----------------------------------------
# Configuración de credenciales de Plotly
#-----------------------------------------


####################################################
####################################################
## SERVIDOR
####################################################
####################################################

shinyServer(function(input, output, session) {
  output$ui <- renderUI({
    if (input$exacfilter) {
      sliderInput(
        "exacslider",
        label = "valor",
        min = min(mtcars$mpg),
        max = max(mtcars$mpg),
        value = max(mtcars$mpg) - min(mtcars$mpg)
      )
    }
    else{
      return()
    }
  })
  
  
  ##########################################
  ## Elementos dinámicos de la interfaz
  ##########################################
  
  
  #-------------------------------
  # Botones de descarga de .csv
  #-------------------------------
  
  output$MutationExplorerFilterExport.csv <- downloadHandler(
    filename = function() {
      "MutationExplorerFilterExport.csv"
    },
    content = function(file) {
      write.csv(dd(), file)
    }
  )
  
  
  ##########################################
  ## Tablas de datos
  ##########################################
  
  #-------------------------------
  # Tabla Current Filter
  #-------------------------------
  
  output$muttable = renderDataTable({
    dd()
  })
  
  
  output$selectiontable = renderDataTable({
    selection()
  }, options = list(autoWidth = TRUE))
  
  
  #------------------------------------------------------------------
  # Textbox con número de pacientes luego del filtro
  #------------------------------------------------------------------
  
  output$pakno <- renderText({
    paste0(as.character(dim(dd())[1]), "/", as.character(dim(mtcars)[1]))
  })
  
  
  
  ####################################################
  ## Actualización del dataset para plotear
  ####################################################
  
  dd <-  eventReactive(input$update, {
    if (input$exacfilter){
      return (mtcars[mtcars$cyl == input$cyl & mtcars$gear == input$gear & mtcars$mpg <= input$exacslider,]) 
    }
    return (mtcars[mtcars$cyl == input$cyl & mtcars$gear == input$gear,])
  })
  
  
  
  ####################################################
  ## Actualización del plot con el nuevo dataset
  ####################################################
  
  output$trendPlot <- renderPlotly ({
    print (input$update)
    
    print("Plotting...")
    
    if (!input$threed && input$update) {
      #-----------------------
      # Plot 2D
      #-----------------------
      
      print("Twod")
      d <- dd()
      xax <- d[, input$xaxis]
      yax <- d[, input$yaxis]
      
      
      plot <- plot_ly(
        x = factor(xax),
        y = factor(yax),
        type = 'scatter',
        mode = 'markers'
      )
    }
    else if (input$threed && input$update) {
      #-----------------
      # Plot 3D
      #-----------------
      
      print("Threed")
      d <- dd()
      xax <- d[, input$xaxis]
      yax <- d[, input$yaxis]
      zax <- d[, input$zaxis]
    
      
      plot <- plot_ly(
        x = factor(xax),
        y = factor(yax),
        z = factor(zax),
        type = 'scatter3d',
        mode = 'markers'
      )
    }
    else{
      plot <- c()
    }
    print("Exiting plot...")
    return(plot)
  })
  
})
