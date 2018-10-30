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
  colnames(advantages)[20]<-"noType2"
  
  #Read in Individual Pokemon Data
  url2<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoIndividualData.csv"
  pogo<-read.csv(text=getURL(url2),header=TRUE)
  newDPS<-rep(0,length(pogo$Pokemon))
  fastAdv<-rep(0,length(pogo$Pokemon))
  chargeAdv<-rep(0,length(pogo$Pokemon))
  totAdv<-rep(0,length(pogo$Pokemon))
  pogo<-cbind(pogo,newDPS,fastAdv,chargeAdv,totAdv)
  newData<-pogo
  
  #Create title page
  output$titleText<-renderUI({
    text<-paste0("Best Pokemon Go Raid Counters against of ",str_to_title(input$bossName))
    h3(text)
  })
  
  #Pokemon Go image
  #url3<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/Pokemon_GO_logo.svg.png"
  #output$pogoLogo<-renderPlot({
    #readPNG(getURLContent(url3))
    #dev.off()
  #})

getData<- reactive({
  #Code to find type1 of raid boss
  bossType1<-as.character(pogo[which(pogo$Pokemon==input$bossName)[1],2])
  #Code to find type2 of raid boss
  bossType2<-ifelse(as.character(pogo[which(pogo$Pokemon==input$bossName)[1],3])=="","noType2",as.character(pogo[which(pogo$Pokemon==input$bossName)[1],3]))
  #boss advantages chart for raid boss
  bossAdvantages<-advantages[c(bossType1,bossType2)]
  
  #Initialize vector to catch fastType, fastAdv, chargeType
  
  for(i in 1:length(newData$Pokemon)){
    #Find fast type advantage for each Pokemon
    newData$fastAdv[i]<-bossAdvantages[as.character(newData$FastType[i]),bossType1]*bossAdvantages[as.character(newData$FastType[i]),bossType2]
    #Find charge type advantage for each Pokemon
    newData$chargeAdv[i]<-bossAdvantages[as.character(newData$ChargedMoveType[i]),bossType1] * bossAdvantages[as.character(newData$ChargedMoveType[i]),bossType2]
    #Find DPS Modifier for each Pokemon
    newData$totAdv[i]<-mean(c(newData$chargeAdv[i],newData$fastAdv[i]))
    newData$newDPS[i]<-newData$DPS[i]*totAdv[i]
    newData
  }
  #end getData()
})
  


#Create plot
  #output$DPSPlot<-renderPlot({
    #newData<-getData()
    #g+geom_point(aes(x=as.character(newData$Type1),y=newData$newDPS))
  #})
  
#Create output of observations    
  output$DPStable <- renderTable({
    newData<-getData()
  })

})

