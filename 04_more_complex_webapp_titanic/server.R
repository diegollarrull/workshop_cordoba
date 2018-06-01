library(shiny)
library(shinythemes)
library(plotly)
library(RColorBrewer)
library(dplyr)

setwd(
  "/home/diegollarrull/workspace/heritas_talks/cordoba/code/04_more_complex_webapp_titanic/"
)
source("include/datos.R", local = T)

#-----------------------------------------
# Configuración de credenciales de Plotly
#-----------------------------------------


####################################################
####################################################
## SERVIDOR
####################################################
####################################################

shinyServer(function(input, output, session) {
  output$filtroedad <- renderUI({
    if (input$filtroedad) {
      sliderInput(
        "edadslider",
        label = "Edad",
        min = floor(min(datos$Age)),
        max = ceiling(max(datos$Age)),
        value = abs(max(datos$Age) - min(datos$Age))
      )
    }
    else{
      return()
    }
  })
  
  
  ##########################################
  ## Elementos dinámicos de la interfaz
  ##########################################
  
  output$pcombo <- renderUI({
    if (input$tipodato == "clase") {
      selectizeInput('selectclase',
                     "Clase de Embarque",
                     clase,
                     selected = clase[1])
    } else if (input$tipodato == "sobreviviente") {
      selectizeInput(
        'selectsobreviviente',
        "Sobreviviente (1 si sobrevivió, 0 si no)",
        sobrevivientes,
        selected = sobrevivientes[1]
      )
    }
  })
  
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
    paste0(as.character(dim(dd())[1]), "/", as.character(dim(datos)[1]))
  })
  
  
  
  ####################################################
  ## Actualización del dataset para plotear
  ####################################################
  
  dd <-  eventReactive(input$update, {
    print(datos[1])
    
    
    if (input$tipodato == "clase") {
      if (input$filtroedad) {
        return(datos[datos$Pclass == input$selectclase &
                       datos$Age < input$edadslider, ])
      }
      else{
        return(datos[datos$Pclass == input$selectclase, ])
      }
    }
    else{
      if (input$filtroedad) {
        return(datos[datos$Survived == input$selectsobreviviente &
                       datos$Age < input$edadslider, ])
      }
      else{
        return(datos[datos$Survived == input$selectsobreviviente, ])
      }
    }
    return (datos)
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
        x = xax,
        y = yax,
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
        x = xax,
        y = yax,
        z = zax,
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
