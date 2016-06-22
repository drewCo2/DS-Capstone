# A.Ritz
# 6/2016

library(shiny)



shinyUI(
  fluidPage(
    
    # Main page title
    titlePanel("Text Guesser"),
    
    sidebarLayout(
        sidebarPanel(
        textInput("text", "Text:"),
        hr(),
        helpText("Please enter some text, and we will predict the next word.")
      ),
    
      mainPanel(
           verbatimTextOutput("nextWord")
      )
    )
  )
)
