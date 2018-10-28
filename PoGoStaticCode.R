library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(RCurl)
library(png)
library(knitr)

bossName<-"Mewtwo"

#Read in advantages chart
url1<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoAdvantageChart.csv"
advantages<-read.csv(quote="",text=getURL(url1),header=TRUE)
row.names(advantages)<-advantages[,1]
colnames(advantages)[20]<-"noType2"


#Read in Individual Pokemon Data
url2<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoIndividualData.csv"
pogo<-read.csv(text=getURL(url2),header=TRUE)

advantages["Electric","Psychic"]

g<-pogo%>%ggplot()
g+geom_point(aes(x=pogo$Type1,y=pogo$DPS))

#Bring in pogo png
url3<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/Pokemon_GO_logo.svg.png"
pogoLogo<-readPNG(getURLContent(url3))
include_graphics(pogoLogo)

newData<-pogo

bossName

#Code to find type1 of raid boss
bossType1<-as.character(pogo[which(pogo$Pokemon==bossName)[1],2])
bossType1

#Code to find type2 of raid boss

  
bossType2<-ifelse(as.character(pogo[which(pogo$Pokemon==bossName)[1],3])=="","noType2",as.character(pogo[which(pogo$Pokemon==bossName)[1],3]))
bossType2

bossAdvantages<-advantages[c(bossType1,bossType2)]
bossAdvantages








