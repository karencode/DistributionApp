library(shiny)
library(ggplot2)

#A helper function to use in stat_function to shade particular areas under the curve. 
#This is called by the renderPlot statement below
shade_end <-function (fun,limit,direction) {
  function (x) {
    # for selecting the areas for shading under the distribution of interest as defined by fun
    y <- fun(x)
    if (direction=="upper") y[x < limit] <- NA 
    else y[x>limit] <- NA
    return(y)
  }
}

shinyServer(function(input, output) {
  
  # First compute the p-value given the test statistic and the type of test
  # Then output it as text.
  
  
  
  output$thePvalue <- renderText({ 
    tailed <- "two-tailed"
    if (input$numTails=="lower") {
      pVal <- pnorm(input$testStat,lower.tail=TRUE)
      tailed <-"lower-tailed"
    }
    else 
      if (input$numTails=="upper") {
        pVal <- pnorm(input$testStat,lower.tail=FALSE)
        tailed <- "upper-tailed"
      }
      else pVal <- 2*pnorm(abs(input$testStat),lower.tail=FALSE)  #two-tailed
    
    paste("The p-value for a ",tailed," test with z* = ", input$testStat," is: ",round(pVal,digits=4),".",sep="")
  })
  
  
  
  output$distPlot <- renderPlot({
    
    # draw the normal distribution with the areas beyond the test statistic shaded
    
    p <- ggplot(data.frame(x=c(-4,4)),aes(x=x)) + stat_function(fun=dnorm) + xlab("z") + ylab("")
    p <- p + annotate("segment",x=input$testStat,xend=input$testStat,y=0,yend=dnorm(input$testStat))
    if (input$numTails=="two") {
      p<- p + stat_function(fun=shade_end(dnorm,abs(input$testStat),"upper"),geom="area",fill="blue",alpha=0.2)
      p<-p + stat_function(fun=shade_end(dnorm,-abs(input$testStat),"lower"),geom="area",fill="blue",alpha=0.2)
      p <- p + annotate("segment",x=-input$testStat,xend=-input$testStat,y=0,yend=dnorm(input$testStat))  
      p<-p + annotate("text",x=abs(input$testStat),y=-.01,label=paste("z* =",round(abs(input$testStat),2)))
      p<-p + annotate("text",x=-abs(input$testStat),y=-.01,label=paste("z* =",round(-abs(input$testStat),2)))
    }
    else {
      p<-p + stat_function(fun=dnorm) + stat_function(fun=shade_end(dnorm,input$testStat,input$numTails),geom="area",fill="blue",alpha=0.2)
      p<-p + annotate("text",x=input$testStat,y=-.01,label=paste("z* =",round(input$testStat,2)))
    }
    return(p)
    },height=280,width=460) 
})