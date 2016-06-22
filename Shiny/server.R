# A.Ritz
# 6/2016

source("PredictionFuncs.R")
textModel<-readRDS("tm2.RDS")


shinyServer(
  function(input,output) 
  { 
    
    output$nextWord<-renderText({
      word<-input$text
      if (word == "")
      {
       res <- "the"
      }
      else
      {
      res<-guessWord(textModel, word)
      }
      res
      
    })
    
#     doIt<-reactive({
#     })
#     
#     # Let's make a prediction....
#     output$nextWord<-doIt({
#       
#     })
          
#    input<-input$text
#    word<-input
#        output$nextWord<-renderText(word)

    # guessWord()
    
#    guessWord()
#    word<-guessWord(input$text)
    
#    output$nextWord<-renderText(word)
  }
)
