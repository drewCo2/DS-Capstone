# A.Ritz
# 4/2016

library(shiny)
data(mtcars)

varNames<-colnames(mtcars)

shinyUI(
  

  fluidPage(
    
    # Main page title
    titlePanel("MTCars Data Explorer"),
    
    sidebarLayout(
        sidebarPanel(
        selectInput("var1", "First Variable:", choices=varNames),
        selectInput("var2", "Second Variable:", choices=varNames),
        hr(),
        helpText("Choose two variables to see how they are related on the plot to the right.")
      ),
    
      mainPanel(
        plotOutput("relPlot"),
        verbatimTextOutput("warnMsg"),
        
        span("Slope + Intercept of fitted line:"),
        verbatimTextOutput("slope"),
        verbatimTextOutput("intercept")
      )
    )
  )
)
