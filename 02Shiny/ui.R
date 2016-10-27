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
    selectInput('hist_col_name', 'Variable To Plot Histogram Of', list("Average Porosity Of Pay Interval" = "AVPOR",
                                                                       "Porosity Range Minimum -Net Pay" = "LOPOR",
                                                                       "Porosity Range Maximum -Net Pay" = "HIPOR",
                                                                       "Average Permeability Of Pay Interval" = "AVPERM",
                                                                       "Permeability Range Minimum" = "LOPERM",
                                                                       "Permeability Range Maximum" = "HIPERM",
                                                                       "Average Reservoir Temperature" = "RESTEMP"),selected="RESTEMP"),
    numericInput("num_of_bins", label = ("Enter The Number of Cells"), value = 20),
    
    # Dropdown to decide which colum to plot the k-means of _
    h3("K-means Clustering Options"),
    selectInput('x_col_name', 'X Variable', list("Average Porosity Of Pay Interval" = "AVPOR",
                                                 "Porosity Range Minimum -Net Pay" = "LOPOR",
                                                 "Porosity Range Maximum -Net Pay" = "HIPOR",
                                                 "Average Permeability Of Pay Interval" = "AVPERM",
                                                 "Permeability Range Minimum" = "LOPERM",
                                                 "Permeability Range Maximum" = "HIPERM",
                                                 "Average Reservoir Temperature" = "RESTEMP"),selected="AVPOR"),
    selectInput('y_col_name', 'Y Variable', list("Average Porosity Of Pay Interval" = "AVPOR",
                                                 "Porosity Range Minimum -Net Pay" = "LOPOR",
                                                 "Porosity Range Maximum -Net Pay" = "HIPOR",
                                                 "Average Permeability Of Pay Interval" = "AVPERM",
                                                 "Permeability Range Minimum" = "LOPERM",
                                                 "Permeability Range Maximum" = "HIPERM",
                                                 "Average Reservoir Temperature" = "RESTEMP"),selected="AVPERM"),

    numericInput("num_of_clusters", label = ("Enter The Amount of Clusters"), value = 3),

    h3("Box Plot Filters"),
    selectInput("variable", "Variable:",
                list("State" = "STATE", 
                     "Geologic Era" = "ERANM", 
                     "Geologic System" = "SYSNM")),
    
    checkboxInput("outliers", "Show outliers", FALSE)
  
),

# Show a plot of the generated distribution
  mainPanel(
    plotOutput("histPlot"),
    plotOutput("clusterPlot"),
    plotOutput("boxPlot")
  )
))
