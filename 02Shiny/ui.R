#ui.R 
# PROJECT 4

library(shiny)
require(shinydashboard)

shinyUI(pageWithSidebar(

# Application title
headerPanel("Hello Shiny!"),

# Sidebar with a slider input for number of observations
  sidebarPanel(
    
    # Dropdown to decide which colum to plot the histogram of 
    selectInput('hist_col_name', 'Variable To Plot Histogram Of', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="RESTEMP"),

    # Dropdown to decide which colum to plot the k-means of _
    selectInput('x_col_name', 'X Variable', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="AVPOR"),
    selectInput('y_col_name', 'Y Variable', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="AVPERM"),

    #uiOutput("xSelector"),
    
    sliderInput("RangeX", 
                "Min and Max of X Variable:", 
                min = 1,
                max = 4750, 
                value = 4750),
    sliderInput("RangeY", 
                "Min and Max of Y Variable:", 
                min = 4750,
                max = 5000, 
                value = 5000),
    
    numericInput("num_of_clusters", label = h3("Enter The Amount of Clusters"), value = 3)),

# Show a plot of the generated distribution
  mainPanel(
    plotOutput("clusterPlot")
    #plotOutput("distTable")
  )
))
