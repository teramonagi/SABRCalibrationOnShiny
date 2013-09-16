library(shiny)
# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  headerPanel("SABR calibration on Shiny"),
  #a('https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png', href='https://github.com/timelyportfolio/rCharts_nvd3_perf'),
  sidebarPanel(
    numericInput("forward", "Forward:", 22, min=1, max=100, step=1),
    numericInput("maturity", "Maturity(year):", 1, min=0.5, max=20, step=0.5),
    h5("Comma separated text(Strike, Market IV(log normal)"),
    tags$textarea(id="marketData", rows=20, cols=70, 
      "12,0.346
15,0.28
17,0.243
19.5,0.208
20,0.203
22,0.192
22.5,0.192
24.5,0.201
25,0.205
27,0.223
27.5,0.228
29.5,0.247
30,0.252
32,0.271
32.5,0.275
34.5,0.293
37,0.313")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Main", 
        h3("Implied volatility smile(market and SABR model)"),
        plotOutput("distPlot"),
        h3("Calibrated parameters via market IVs"),
        verbatimTextOutput("summary")
      ),
      tabPanel("About",
        p('This application demonstrates to what extent',
         a("SABR model", href="http://en.wikipedia.org/wiki/SABR_volatility_model", target="_blank"),
         'can fit the market IV structures.'),
        br(),
        strong('Code'),
        p('Souce code for this application at',
          a('GitHub', href='https://github.com/teramonagi/SABRCalibrationOnShiny', target="_blank")),
        p('If you want to run this code on your computer, run the code below:',
          br(),
          code('library(shiny)'),br(),
          code('runGitHub("SABRCalibrationOnShiny","teramonagi")')
        ),br(),
        strong('References'),
        p(HTML('<ul>'),
        HTML('<li>'),a('Managing Smile Risk, P. Hagan et al(pdf)', href="http://www.math.columbia.edu/~lrb/sabrAll.pdf", target="_blank"),HTML('</li>'),
        HTML('</ul>'))
      )
    )
  )
))
