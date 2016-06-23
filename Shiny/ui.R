# A.Ritz
# 6/2016

library(shiny)



shinyUI(
  fluidPage(
    
    # Main page title
    titlePanel("Text Guesser"),
    p("This application will use an n-gram + backoff model to try and predict the next word that you will enter.
      the model has been optimized to predict in a timely fashion, and also to be as accurate as possible.  Text prediction,
      of course is not an easy problem so we may not always get it right, though we try our best."),

      sidebarLayout(
        sidebarPanel(
        textInput("text", "Text:"),
        hr(),
        helpText("Please enter some text, and we will predict the next word.")
      ),
    
      mainPanel(
           h6("Best Guess"),
           verbatimTextOutput("nextWord"),

           h6("Next Best Guesses"),
           verbatimTextOutput("nextBest")
      )
    )
  )
)



