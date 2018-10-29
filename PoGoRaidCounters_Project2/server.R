library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(RCurl)
library(png)
library(knitr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Read in advantages chart
  url1<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoAdvantageChart.csv"
  advantages<-read.csv(quote="",text=getURL(url1),header=TRUE)
  row.names(advantages)<-advantages[,1]
  
  #Read in Individual Pokemon Data
  url2<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoIndividualData.csv"
  pogo<-read.csv(text=getURL(url2),header=TRUE)
  newData<-pogo
  
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
  
getData<- reactive({
  #Code to find type1 of raid boss
  bossType1<-as.character(pogo[which(pogo$Pokemon==bossName)[1],2])
  #Code to find type2 of raid boss
  bossType2<-ifelse(as.character(pogo[which(pogo$Pokemon==bossName)[1],3])=="","noType2",as.character(pogo[which(pogo$Pokemon==bossName)[1],3]))
  #boss advantages chart for raid boss
  bossAdvantages<-advantages[c(bossType1,bossType2)]
  
  #Initialize vector to catch fastType, fastAdv, chargeType
  fastAdv<-rep(0,length(pogo$Pokemon))
  chargeAdv<-rep(0,length(pogo$Pokemon))
  totAdv<-rep(0,length(pogo$Pokemon))
  
  for(i in 1:length(pogo$Pokemon)){
    mon<-as.character(pogo$Pokemon[i])
    #Find fast type advantage
    fastAdv[i]<-advantages[as.character(pogo[which(pogo$Pokemon==mon),5]),bossType1]*advantages[as.character(pogo[which(pogo$Pokemon==mon),5]),bossType2]
    #Find charge type advantage
    chargeAdv[i]<-advantages[as.character(pogo[which(pogo$Pokemon==mon),7]),bossType1]*advantages[as.character(pogo[which(pogo$Pokemon==mon),7]),bossType2]
    #Find DPS Modifier
    totAdv[i]<-mean(c(chargeAdv[i],fastAdv[i]))
    pogo$newDPS[i]<-pogo$DPS[i]*totAdv[i]
    newData<-pogo
  }
  
})
  
#Create plot
  output$DPSPlot<-renderPlot({
    newData<-getData()
    g<-ggplot(data=newData)
    g+geom_point(aes(x=newData$Type1,y=newData$newDPS))
  })

  
})
