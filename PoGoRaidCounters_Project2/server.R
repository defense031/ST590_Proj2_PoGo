library(shiny)
library(dplyr)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Read in advantages chart
  url1<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoAdvantageChart.csv"
  advantages<-read.csv(quote="",text=getURL(url1),header=TRUE)
  row.names(advantages)<-advantages[,1]
  
  #Read in Individual Pokemon Data
  url2<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoIndividualData.csv"
  pogo<-read.csv(text=getURL(url2),header=TRUE)
  
  #Create title page
  output$titleText<-renderUI({
    text<-paste0("Best Pokemon Go Raid Counters against of ",str_to_title(input$bossName))
    h3(text)
  })
  #Pokemon Go image
  url3<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/Pokemon_GO_logo.svg.png"
  output$pogoLogo<-renderPlot({
    readPNG(getURLContent(url3))
    dev.off()
  })
  
  newData<-pogo
  #getData <- reactive({
    #newData <- pogo %>% filter(vore == input$vore)
  
  output$DPSPlot<-renderPlot({
    g<-newData%>%ggplot()
    g+geom_point(aes(x=newData$Type1,y=newData$DPS))
  })

  
})
