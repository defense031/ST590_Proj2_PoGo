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

bossName<-"Mewtwo"


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

for(i in 1:length(newData$Pokemon)){
  #Find fast type advantage for each Pokemon
  fastAdv[i]<-bossAdvantages[as.character(pogo$FastType[i]),bossType1]*bossAdvantages[as.character(pogo$FastType[i]),bossType2]
  #Find charge type advantage for each Pokemon
  chargeAdv[i]<-bossAdvantages[as.character(pogo$ChargedMoveType[i]),bossType1] * bossAdvantages[as.character(pogo$ChargedMoveType[i]),bossType2]
  #Find DPS Modifier for each Pokemon
  totAdv[i]<-mean(c(chargeAdv[i],fastAdv[i]))
  newData$newDPS[i]<-pogo$DPS[i]*totAdv[i]
}

newData$newDPS
top10<-arrange(newData,desc(newDPS))[1:10,]
nameCat<-paste0(top10$Pokemon," ",top10$FastMove," ",top10$ChargedMove)
top10<-cbind(top10,nameCat)


g<-ggplot(data=top10)
g+geom_point(aes(x=top10$nameCat,y=top10$newDPS),color=top10$TypeColor,
             size=10*percent_rank(top10$TDO))+
  theme(axis.text.x=element_text(angle=60,hjust=1))+
  xlab("")+ylab("Adjusted DPS")
  

sumTable<-top10[,c(1,2,3,4,6,8,9,10,18,12)]
sumTable[,9]<-round(sumTable[,9],digits=1)
colnames(sumTable)<-c("Pokemon","Type 1", "Type 2","Fast Move", "Charged Move","Stamina","Attack","Defense","Total Damage Output","Adj. DPS")
sumTable

leg=FALSE

if(leg==FALSE){
  filterData<-filter(newData,Legendary==FALSE)
}else{filterData<-pogo}

gens<-c("I","II")
filterData<-filter(newData,Legendary==FALSE & Generation %in% switch())


a<-c("I","III")
switch(a,"I"=1,"II"=2,"III"=3,"IV"=4,"V (unreleased)"=5,
       "Mega (unreleased)"="Mega","Alolan"="Alolan")

levels(pogo$Generation)


gens<-c("1","3","2")
filterData<-filter(newData,Legendary==FALSE)
                   
filterData<-filter(newData[newData$Generation %in% gens,])
filterData<-filter(filterData,Legendary==FALSE)
length(filterData$Pokemon)
       