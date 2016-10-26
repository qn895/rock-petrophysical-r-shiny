# server.R
# PROJECT 4
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {
  # CREATE A DICTIONARY FOR COLUMN NAMES
  key = c("STATE",
          "FLDNAME",
          "RESNAME",
          "R_STUDY",
          "PLAYNAME",
          "PLAYCOD",
          "ERANM",
          "SUBPLAYN",
          "SYSNM",
          "SERNM",
          "S_POR",
          "S_PERM",
          "LINKA",
          "AVPOR",
          "LOPOR",
          "HIPOR",
          "AVPERM",
          "LOPERM",
          "HIPERM",
          "RESTEMP") 
  
  desc = c("State",
           "Doe/Eia Field Name",
           "Reservoir Name",
           "Reservoir Source (Atlas, Reserv. Study, Totl)",
           "Gas Atlas Geologic Play Name",
           "Gas Atlas Geologic Play Code",
           "Geologic Era Name",
           "Gas Atlas Subplay Name",
           "Geologic System Name",
           "Geologic Series Name",
           "Data Source For Porosity",
           "Data Source For Permeability",
           "Unique Key For Reservoir Data System",
           "Average Porosity Of Pay Interval",
           "Porosity Range Minimum -Net Pay",
           "Porosity Range Maximum -Net Pay",
           "Average Permeability Of Pay Interval",
           "Permeability Range Minimum",
           "Permeability Range Maximum",
           "Average Reservoir Temperature")
  col_dictionary <- as.list(desc)
  names(col_dictionary) <- key
  
  # PROCESSING INPUT VARIABLES
  hist_col_name <- reactive({input$hist_col_name})
  x_col_name <- reactive({input$x_col_name})    
  y_col_name <- reactive({input$y_col_name})

  df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  
  subset(df)
  
  selectedHistData <- reactive({
    df[, c(input$hist_col_name)]
  })
  
  
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
         xlab = col_dictionary[[input$x_col_name]],
         ylab = col_dictionary[[input$y_col_name]],
         main = "K-means Clustering",
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    
  })
  
  # PLOT THE HISTOGRAM WHERE THE COLUMN AND THE NUMBER OF BINS IS REACTIVE
  output$histPlot <- renderPlot({
    hist(selectedHistData(),
        probability = FALSE,
        breaks = as.numeric(input$num_of_bins),
        main = paste("Frequency (or Count) of", col_dictionary[[input$hist_col_name]]),
        xlab=col_dictionary[[input$hist_col_name]])
  })

  # CREATE A SHINY UI ELEMENT THAT LISTS THE STATES FOR THE HISTOGRAM
  output$stateSelector <- renderUI({
    states <- unique(df['STATE'])
    selectInput("state", "Choose State To Filter Data By:", as.list(states),selected="TEXAS") 
  })
  
  df2 <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA where RESTEMP IS NOT NULL and RESTEMP > 0 and SYSNM IS NOT NULL and ERANM IS NOT NULL AND STATE IS NOT NULL"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  
  
  formulaText <- reactive({
    paste("RESTEMP ~", input$variable)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  output$boxPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = df2,
            outline = input$outliers,
            main = paste("Reservoir Temperatures by", col_dictionary[[input$variable]]),
            las = 2)
  })
  
  })
