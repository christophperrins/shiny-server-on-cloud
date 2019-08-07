library(shiny)

# Define UI for application that plots random distributions 
shinyUI(
 fluidPage(
  # Give the page a title
 titlePanel("Telephones by region"),

  # Generate a row with a sidebar
  sidebarLayout(

    # Define the sidebar with one input
   sidebarPanel(
    selectInput("region", "Region:", choices=colnames(WorldPhones)),
    hr(),
    helpText("Data from AT&T (1961) The World's Telephones.")
   ),

    # Create a spot for the barplot
   mainPanel(
    plotOutput("phonePlot")
   )
  )
 )
)
