# A.Ritz
# 4/2016

library(shiny)
data(mtcars)

shinyServer(
  function(input,output) 
  { 

    output$relPlot <- renderPlot({

      #aliases
      v1<-input$var1
      v2<-input$var2
      
      # warning msg.
      if (v1 == v2)
      {
        output$warnMsg <- renderPrint(" Warning: Please choose two different varaibles")
      }
      else
      {
        output$warnMsg <- renderPrint("Selection OK")
      }
      
      # create a formula and fit a model.
      comp=formula(paste(v1,"~",v2))      
      fit<-lm(comp, data=mtcars)
      
      ce<-coef(fit)
      output$slope = renderPrint(ce[[2]])
      output$intercept = renderPrint(ce[[1]])
      
      #Plot variables.
      title<-paste(v1, "vs.", v2)
      
      plot(mtcars[,v2],mtcars[,v1], main=title, xlab=v2, ylab=v1)
      abline(fit,col="red",lwd=2)
      
    })    
    
        
  }
)



fit<-lm(mpg~disp,data=mtcars)
plot(mtcars[,"disp"],mtcars[,"mpg"])
abline(fit,col="red",lwd=2)

ce<-coef(fit)
slope = ce[[2]]
ce[[1]]
slope
