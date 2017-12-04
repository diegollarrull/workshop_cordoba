library(plotly)
library(shiny)
library(shinythemes)

setwd("/home/diegollarrull/workspace/heritas_talks/cordoba/code/04_more_complex_webapp/")
source("include/datos.R", local=T)

####################################################
## Interfaz de usuario
####################################################

shinyUI(fluidPage(
  titlePanel(
    title = HTML(
      "<div id='sub-left'>
      <h1 margin-bottom = '0px' style = 'margin-top:28px;font-family:&quot;Helvetica Neue&quot;,Helvetica,Arial,sans-serif;font-weight:200;color:#a29ed1;'>Workshop Córdoba</h1>
      <h4 style =  'font-family:&quot;Helvetica Neue&quot;,Helvetica,Arial,sans-serif;font-weight:200;color:#a29ed1;'><i>Una app un poco más compleja</i></h4>
      </div>
      <div class='clear-both'></div>"
    ),
    windowTitle = "Una app un poco más compleja"
  ),
  list(
    fluidRow(column(6,
                    wellPanel(fluidRow(
                        column(8,
                          fluidRow(column(3,
                              radioButtons(
                                "tipodato",
                                "Filter type:",
                                c(
                                  "Linea" = "porlinea",
                                  "SNP" = "porsnp"
                                )
                          )),
                          column(9, uiOutput("pcombo"))
                        )),
                        column(
                          4,
                          checkboxInput('virusfilter', 'Filtrar por virus', FALSE),
                          uiOutput("ui"),
                          align = "center",
                          style = "vertical-align: bottom;",
                          actionButton("update", "Actualizar")
                        )
                      )
                    )),
             column(
               6, wellPanel(fluidRow(
                 column(
                   7,
                   selectizeInput('xaxis', "X Axis", ejes, selected = ejes[1]),
                   selectizeInput('yaxis', "Y Axis", ejes, selected = ejes[2])
                 ),
                 column(
                   5,
                   checkboxInput('threed', 'Use 3rd Axis', FALSE),
                   selectizeInput('zaxis', "Z Axis", ejes, selected = ejes[3])
                 )
               )),
               fluidRow(
                 column(10, tags$p("Numero de muestras:"), align = "right")
                 ,
                 column(2, verbatimTextOutput("pakno"))
               )
             )),
    tabsetPanel(
      tabPanel("Plot", plotlyOutput('trendPlot', height = "500px")),
      tabPanel(
        "Datos en CSV",
        dataTableOutput('muttable'),
        downloadButton('MutationExplorerFilterExport.csv', 'Download Current Filter')
      )),
   shinythemes::themeSelector()
)))