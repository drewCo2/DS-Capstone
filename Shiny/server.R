# A.Ritz
# 6/2016

source("PredictionFuncs.R")
textModel<-readRDS("tm2.RDS")


shinyServer(
  function(input,output) 
  { 
    
    output$nextWord<-renderText({
      if (input$text == "")
      {
        word <- "the"
        nextBest = c("a", "b", "c", "d", "e")  
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
