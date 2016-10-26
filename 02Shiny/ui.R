#ui.R 
# PROJECT 4

library(shiny)
require(shinydashboard)

shinyUI(pageWithSidebar(

# Application title
headerPanel("Project 4!"),

# Sidebar with a slider input for number of observations
  sidebarPanel(

    # Dropdown to decide which colum to plot the histogram of 
    h3("Histogram Options"),
    selectInput('hist_col_name', 'Variable To Plot Histogram Of', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="RESTEMP"),
    numericInput("num_of_bins", label = ("Enter The Number of Bins"), value = 10),
    actionButton(inputId="plotHistogram", label="Plot or Update Histogram"),
    
    # Dropdown to decide which colum to plot the k-means of _
    h3("K-means Clustering Options"),
    selectInput('x_col_name', 'X Variable', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="AVPOR"),
    selectInput('y_col_name', 'Y Variable', list("AVPOR","LOPOR","HIPOR","AVPERM","LOPERM","HIPERM","RESTEMP"),selected="AVPERM"),

    numericInput("num_of_clusters", label = ("Enter The Amount of Clusters"), value = 3),
    actionButton(inputId="plotClusters", label="Plot or Update Clusters"),
    
    
    h3("Main Filtering Options"),
    sliderInput("range_of_x_variable", 
                label = ("Min and Max of X Variable"), 
                min = 0, 
                max = 100, 
                value = c(40, 60)),
    sliderInput("range_of_y_variable", 
                label = ("Min and Max of Y Variable"), 
                min = 0, 
                max = 100, 
                value = c(40, 60)),
    uiOutput("campSelector")
  
    ),

# Show a plot of the generated distribution
  mainPanel(
    plotOutput("histPlot"),
    plotOutput("clusterPlot")
  )
))
