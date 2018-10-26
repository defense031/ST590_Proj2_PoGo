library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(RCurl)

url1<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoAdvantageChart.csv"
advantages<-read.csv(quote="",text=getURL(url1),header=TRUE)
row.names(advantages)<-advantages[,1]

advantages["Electric","Psychic"]

help(read.csv)
