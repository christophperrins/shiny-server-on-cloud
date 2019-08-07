library(shiny)

# Define server logic required to draw a histogram
shinyServer(
 function(input, output) {
 # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000,
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
 }
)
