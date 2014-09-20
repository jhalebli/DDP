shinyUI(fixedPage(
  titlePanel("World Population and GDP Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput('decile', 'From lowest to highest decile',value = c(1,10), min = 1, max = 10, step = 1,),
      helpText("Use the decile slider to limit the number",
               "and set of deciles summarized on the world map."),
      sliderInput('hdi', 'Human Development Index (poverty level)',value = c(0.4,1.0), min = 0.4, max = 1, step = .1,),
      helpText("Use the Human Development Index slider to",
               "limit the relative poverty range of the countries",
               "summarized after filtering by decile")
      ),
    mainPanel(
      imageOutput('newHist'),
      textOutput('text1'),
      helpText("GDP is based in PPP dollars, that is, Purchasing",
               "Power Parity dollars.")
    )
  )
))
