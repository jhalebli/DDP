
library(UsingR)
library(rworldmap)
library(datasets)
library(ggplot2)
setwd('D:\\rshome\\DDP')
ctwdt <- read.csv('CTW\\sz-wl-pov2.csv',header=TRUE,sep=",", na.strings="n/a")
colnames(ctwdt) <- c('country','ccode','region','population','gdpp32011','gdpdol2012','gdpp3pcap', 'gdpdolpcap', 'hdi')
qua <- with(ctwdt, cut(population,breaks=quantile(population, probs=seq(0,1, by=0.10),na.rm=TRUE), include.lowest=TRUE, labels=1:10))
qua <- as.numeric(qua)
ctwdt <- cbind(ctwdt,qua)

shinyServer(
  function(input, output) {
    output$newHist <- renderImage({
      decile <- input$decile
      hdi <- input$hdi
      ctout <- ctwdt[ctwdt$hdi<=hdi[2] & ctwdt$hdi >= hdi[1],]
      ctout <- ctout[ctout$qua<=decile[2] & ctout$qua >= decile[1],]
      
      outfile <- tempfile(fileext='.png')
      
      sPDF <- joinCountryData2Map( ctout, joinCode="ISO3", nameJoinColumn="ccode", nameCountryColumn="country")
      mapDevice(device="png", file=outfile, width=800, height=800)
      maptitle <- "Map of GDP per capita based on PPP"
      mapBubbles(sPDF,nameZSize="population",nameZColour="gdpp3pcap",colourPalette="heat",oceanCol="lightBlue",landCol="wheat",main=maptitle,
                 catMethod="logFixedWidth",numCats=6,width=800,height= 600, colourLegendTitle="GDP per capita, PPP (millions)", legendTitle="Population (millions)")
      dev.off()

      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 800,
           alt = "This is alternate text")
    }, deleteFile = TRUE)
    output$text1 <- renderText({
      decile <- input$decile
      hdi <- input$hdi
      ctout <- ctwdt[ctwdt$hdi<=hdi[2] & ctwdt$hdi>=hdi[1],]
      ctout <- ctout[ctout$qua<=decile[2] & ctout$qua >= decile[1],]
      paste('Number of countries displayed: ',nrow(ctout), 'of', nrow(ctwdt))
    })
  }
)
