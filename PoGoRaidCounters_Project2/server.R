library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(RCurl)
library(png)
library(knitr)


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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
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
  
  if(input$leg==FALSE){
    filterData<-filter(newData,Legendary==FALSE)
  }else{filterData<-pogo}

  #Code to find type1 of raid boss
  bossType1<-as.character(pogo[which(pogo$Pokemon==input$bossName)[1],2])
  #Code to find type2 of raid boss
  bossType2<-ifelse(as.character(pogo[which(pogo$Pokemon==input$bossName)[1],3])=="","noType2",as.character(pogo[which(pogo$Pokemon==input$bossName)[1],3]))
  #boss advantages chart for raid boss
  bossAdvantages<-advantages[c(bossType1,bossType2)]
  
  #Initialize vector to catch fastType, fastAdv, chargeType
  
  for(i in 1:length(filterData$Pokemon)){
    #Find fast type advantage for each Pokemon
    filterData$fastAdv[i]<-bossAdvantages[as.character(filterData$FastType[i]),bossType1]*bossAdvantages[as.character(filterData$FastType[i]),bossType2]
    #Find charge type advantage for each Pokemon
    filterData$chargeAdv[i]<-bossAdvantages[as.character(filterData$ChargedMoveType[i]),bossType1] * bossAdvantages[as.character(filterData$ChargedMoveType[i]),bossType2]
    #Find DPS Modifier for each Pokemon
    filterData$totAdv[i]<-mean(c(filterData$chargeAdv[i],filterData$fastAdv[i]))
    filterData$newDPS[i]<-filterData$DPS[i]*filterData$totAdv[i]
  }
  #Now find top 10 in adjusted DPS vs raid boss
  top10<-arrange(filterData,desc(newDPS))[1:10,]
  nameCat<-paste0(top10$Pokemon," ",top10$FastMove," ",top10$ChargedMove)
  top10<-cbind(top10,nameCat)
  top10<-top10
  
})


#Create plot
  output$DPSPlot<-renderPlot({
    top10<-getData()
    g<-ggplot(data=top10)
    g+geom_point(aes(x=top10$nameCat,y=top10$newDPS),color=top10$TypeColor,
                 size=10*percent_rank(top10$TDO))+
      theme(axis.text.x=element_text(angle=60,hjust=1))+
      xlab("")+ylab("Adjusted DPS")
  })
  
#Create output of observations    
  output$DPStable <- renderTable({
    top10<-getData()
    sumTable<-top10[,c(1,2,3,4,6,8,9,10,18,12,16)]
    sumTable[,9]<-round(sumTable[,9],digits=1)
    colnames(sumTable)<-c("Pokemon","Type 1", "Type 2","Fast Move", "Charged Move","Stamina","Attack","Defense","Adj. DPS","Total Damage Output","Leg.")
    sumTable
  })
  
})
  

