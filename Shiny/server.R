# A.Ritz
# 6/2016

source("PredictionFuncs.R")
textModel<-readRDS("textModel.RDS")


shinyServer(
  function(input,output) 
  { 
    
    output$nextWord<-renderText({
      if (input$text == "")
      {
        word <- "the"
        nextBest = character()  
      }
      else
      {
        res<-guessWord(textModel, input$text)
        word<-res$bestWord
        nextBest<-res$nextBest
      }
        
      output$nextBest<-renderText(paste0(nextBest, collapse=", "))
      
      word
      
  })
})
