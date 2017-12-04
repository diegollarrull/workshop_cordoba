library(shiny)
library(shinythemes)
library(plotly)
library(RColorBrewer)
library(dplyr)

setwd("/home/diegollarrull/workspace/heritas_talks/cordoba/code/04_more_complex_webapp/")
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
    if (input$virusfilter) {
      sliderInput(
        "virusslider",
        label = "valor",
        min = floor(min(datos$Virus)),
        max = ceiling(max(datos$Virus)),
        value = abs(max(datos$Virus) - min(datos$Virus))
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
    if (input$tipodato == "porlinea") {
      selectizeInput(
          'linea',
          "Linea",
          lineas,
          selected = lineas[1])
    } else if (input$tipodato == "porsnp") {
      selectizeInput(
        'snp',
        "SNP",
        snps,
        selected = snps[1]
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
  p
  
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
    
    
    if (input$tipodato == "porlinea"){
      if (input$virusfilter){
        return(datos[datos$Linea == input$linea & datos$Virus < input$virusslider,])
      }
      else{
        return(datos[datos$Linea == input$linea,])
      }
    }
    else{
      if (input$virusfilter){
        return(datos[datos$Snp == input$snp & datos$Virus < input$virusslider,])
      }
      else{
        return(datos[datos$Snp == input$snp,])
      }
    }
    return (datos)(s)
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
