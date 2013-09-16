library(shiny)
library(ggplot2)
source("SABR.R")

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    x <- calculateIV()
    print(ggplot(data=x$data, aes(x=Strike, y=IV, colour=Tag))
          + geom_point(size=4)+geom_line(size=1) + theme_grey(base_size=24))
  })
  calculateIV <- reactive({
    forward  <- input$forward
    maturity <- input$maturity
    x <- input$marketData
    # convert string(ex:"12,0.346\n15,0.28\n17,0.243...") to data.frame
    x <- t(sapply(unlist(strsplit(x, "\n")), function(x) as.numeric(unlist(strsplit(x, ",")))))
    strike    <- x[,1]
    iv.market <- x[,2]
    SABR.parameter <- SABR.calibration(maturity, forward, strike, iv.market)
    iv.model <- SABR.BSIV(
      maturity, forward, strike, SABR.parameter[1], SABR.parameter[2], SABR.parameter[3], SABR.parameter[4])
    #
    list(
      parameter=SABR.parameter,
      data=rbind(
        data.frame(Strike=strike, IV=iv.model,  Tag="SABR"),
        data.frame(Strike=strike, IV=iv.market, Tag="Market")
      )
    )
  })
  output$summary <- renderPrint({
    x <- calculateIV()
    print(x$parameter)
  })
})
