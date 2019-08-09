# How to set up an R shiny server on GCP

## Install R and shiny

``` sh
sudo apt update
sudo apt install -y r-base 
```

Next install shiny library to your machine
``` sh
sudo su - -c "R -e \"install.packages('shiny')\""
```
Here the superuser (su) is running a command (-c).

The command is going to call R to execute (-e) the following "install.packages("shiny").

## Install Shiny Server
First download the shiny-server.deb file - a common way of sharing installable content.
``` sh
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb
```

Next we need a way of extracting the information from the .deb file. I'll be using gdebi-core.

```sh
sudo apt install -y gdebi-core
sudo gdebi shiny-server-1.5.6.875-amd64.deb
```

To check that it is running you can use the following command:
``` sh
sudo systemctl status shiny-server.service
```

## Changing Configs
Currently the port it is listening at is port 3838. We want to change that to the default http port 80. Therefore at the location /etc/shiny-server/shiny-server.conf insert the following information

```
# Instruct Shiny Server to run applications as the user "shiny"
run_as shiny;

# Define a server that listens on port 3838
server {
  listen 80;

  # Define a location at the base URL
  location / {

    # Host the directory of Shiny Apps stored in this directory
    site_dir /srv/shiny-server;

    # Log all Shiny output to files in this directory
    log_dir /var/log/shiny-server;

    # When a user visits the base URL rather than a particular application,
    # an index of the applications available in this directory will be shown.
    directory_index on;
  }
}
```

After this restart the shiny-server.
``` sh
sudo service shiny-server restart
```

If you go the the host ip address - you should now see the default shiny-server webpage.

You can also see an example shiny page by going to:
> http://<IP ADDRESS>/sample-apps/hello

## Hosting the application
Inside the srv/shiny-server/ directory you will find a folder called sample-apps, which has a directory called hello, which has a two files - ui.R and server.R

### ui.R
The ui.R looks like this:
```
library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("It's Alive!"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot", height=250)
  )
))
```

A format more people are common with is the following:
```
library(shiny)

ui <- fluidPage(
  
  headerPanel("It's Alive!"),
  
  sidebarPanel(
    sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
  ),
  
  mainPanel(
    plotOutput("distPlot", height=250)
  )
)

shinyUI(ui)
```

Try replacing the ui.R file with the above text. You should see minimal changes if any.

### server.R
The server.R file contains the following which most people are already familiar with the layout:
```

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot

  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

})
```

## Changing the URL location
currently we have to go to http://<IP ADDRESS>/sample-apps/hello to see the application.

Run the following commands to get the ui and server at the default location

``` sh
sudo rm /srv/shiny-server/index.html
sudo mv /srv/shiny-server/sample-apps/hello/* /srv/shiny-server/
sudo rm -Rf /srv/shiny-server/sample-apps
```

By going to http://<IP ADDRESS>/ you will have your file displayed.

