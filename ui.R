library(shiny)



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("P-value Calculator"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      helpText(strong("Obtain a p-value for a test statistic that follows a standard normal distribution.")),
      
      numericInput("testStat", 
                  label = h5("Your computed test statistic (z*):"),
                  value = 0.00, step=.01),
      
      radioButtons("numTails", label = h5("Type of Test:"),
                   choices = list("Lower-Tailed"="lower", "Upper-Tailed" = "upper",
                                  "Two-Tailed" = "two"),selected = "two")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(tabsetPanel(
      tabPanel("Results", div(h4(textOutput("thePvalue")), style = "color:blue"),
                          br(),
                          plotOutput("distPlot")
               ),
      tabPanel("Help/Example", withMathJax(),
                               helpText("Use this App to compute a p-value for a hypothesis test whose test statistic follows a standard normal distribution.                               
                                   For example, suppose you are conducting a one sample z test with a known population standard deviation \\(\\sigma\\) = 4."), 
                               helpText("Your sample mean M = 8 and sample size n = 25. Your null and alternative hypotheses are: $$H_0:\\mu = 10;    H_a:\\mu < 10$$"),
                               helpText("Then your test statistic z* is:$$z^* = \\frac{M-\\mu}{\\left(\\frac{\\sigma}{\\sqrt{n}}\\right)} = \\frac{8-10}{\\left(\\frac{4}{\\sqrt{25}}\\right)} = -2.5$$"),
                               helpText("Enter z* = -2.5 in the test statistic box. Since \\(H_a\\) is <, select Lower-Tailed as the type of test. (Use Upper-Tailed when \\(H_a\\) is > and Two-Tailed when \\(H_a\\) is \\(\\neq\\).)"),
                               helpText("The results give the P-value as 0.0062 and shades the corresponding area under the z curve to help you visualize how a probability corresponds to an area under the z curve.
                                   You can interpret this P-value as describing the probability of drawing a sample that produces a sample mean of M = 8.0 or smaller, if the actual population mean is \\(\\mu\\) = 10.
                                   If your significance level is say \\(\\alpha\\) = 0.05, you would reject \\(H_0\\) because 0.0062 < 0.05. That is, you would conclude that \\(\\mu\\) < 10.")
      )
    )
    )
)))
