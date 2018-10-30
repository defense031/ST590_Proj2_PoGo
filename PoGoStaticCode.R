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
pogo<-cbind(pogo,newDPS)
newData<-pogo


#Bring in pogo png
url3<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/Pokemon_GO_logo.svg.png"
pogoLogo<-readPNG(getURLContent(url3))
include_graphics(pogoLogo)

bossName<-"Charizard"


#Code to find type1 of raid boss
bossType1<-as.character(pogo[which(pogo$Pokemon==bossName)[1],2])
bossType1

#Code to find type2 of raid boss
bossType2<-ifelse(as.character(pogo[which(pogo$Pokemon==bossName)[1],3])=="","noType2",as.character(pogo[which(pogo$Pokemon==bossName)[1],3]))
bossType2
#Creates subset of advantages table with cols of boss type1 and type2 (if type2 is null, it returns a col of 1s for no modifier)
bossAdvantages<-advantages[c(bossType1,bossType2)]

advantages[c("Psychic","Normal")]
bossAdvantages

#Initialize vector to catch fastType, fastAdv, chargeType
fastAdv<-rep(0,length(pogo$Pokemon))
chargeAdv<-rep(0,length(pogo$Pokemon))
totAdv<-rep(0,length(pogo$Pokemon))

for(i in 1:length(pogo$Pokemon)){
  #Find fast type advantage for each Pokemon
  fastAdv[i]<-bossAdvantages[as.character(pogo$FastType[i]),bossType1]*bossAdvantages[as.character(pogo$FastType[i]),bossType2]
  #Find charge type advantage for each Pokemon
  chargeAdv[i]<-bossAdvantages[as.character(pogo$ChargedMoveType[i]),bossType1] * bossAdvantages[as.character(pogo$ChargedMoveType[i]),bossType2]
  #Find DPS Modifier for each Pokemon
  totAdv[i]<-mean(c(chargeAdv[i],fastAdv[i]))
  pogo$newDPS[i]<-pogo$DPS[i]*totAdv[i]
}

pogo$newDPS

g<-pogo%>%ggplot()
g+geom_point(aes(x=pogo$Type1,y=pogo$newDPS))

#This works but is not the best way to do it...no reason to search for row of each pokemon...
#Better to just call the index of each FastType and ChargedMoveType from within the data itself
                                            
       