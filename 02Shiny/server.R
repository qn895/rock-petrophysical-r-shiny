# server.R
# PROJECT 4
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {
  x_col_name <- reactive({input$x_col_name})    
  y_col_name <- reactive({input$y_col_name})

  # GET DATA
  df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  
  # GET DATA, FILTERED BY SELECTED X_COL_NAME AND Y_COL_NAME
  selectedXData <- reactive({
    df[, c(input$x_col_name)]
  })
  
  selectedYData <- reactive({
    df[, c(input$y_col_name)]
  })
  
  # UPDATE DATA AS NEEDED
  selectedXandY <- reactive({
    df[, c(input$x_col_name, input$y_col_name)]
  })
  
  # CLUSTER THE DATA
  clusters <- reactive({
    kmeans(selectedXandY(),input$num_of_clusters)
  })

  # PLOT THE CLUSTERED DATA
  output$clusterPlot <- renderPlot({
    plot(selectedXandY(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    
  })
  
  output$xSelector <- renderUI({
    sliderInput("RangeX", 
                "Min and Max of X Variable:", 
                min = min(selectedXData()),
                max = max(selectedXData()), 
                value = mean(selectedXData(),na.rm = TRUE))
    })
  
  })
