
library(shiny)
library(shinythemes)

cylinders = levels(as.factor(mtcars$cyl))
gears = levels(as.factor(mtcars$gear))

####################################################
## Interfaz de usuario
####################################################


shinyUI(fluidPage(
  titlePanel(
    title = "Workshop Córdoba - Webapp básica",
    windowTitle = "Héritas CARDIO EXPLORER"
  ),
  list(
    fluidRow(column(12,
                    wellPanel(
                      fluidRow(
                        column(
                          12,
                          selectizeInput(
                            'cyl',
                            "Cylinders",
                            cylinders,
                            selected = cylinders[1]
                          ),
                          selectizeInput(
                            'gear',
                            "Number of Gears",
                            gears,
                            selected = gears[1]
                          )
                        )
                      )
                    ))),
    tabsetPanel(
      tabPanel("Plot", plotlyOutput('trendPlot', height = "500px"))
    )
  )
  # ,
  # shinythemes::themeSelector()
))