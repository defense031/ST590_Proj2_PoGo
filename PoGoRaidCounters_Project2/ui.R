#Austin Semmel Project 2
library(shiny)
library(dplyr)
library(ggplot2)
library(knitr)

shinyUI(fluidPage(
  
  # Application title
  titlePanel( 
    uiOutput("titleText")
    ),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      textInput("bossName","What Pokemon are you battling against?"),
      br(),
     checkboxInput("leg","Do you want to include legendaries?",value=FALSE),
      br(),
    checkboxGroupInput("gens","Which Generations do you want to include?",
                       choices=c("I","II","III","IV","V (unreleased)","Alolan","Mega (unreleased)")),
    br(),
    textInput("exclude","Type any Pokemon you don't want to include (separated by commas)")
    ),
    mainPanel(
      
      plotOutput("DPSPlot"),
      print(pogo[1,])
    )
  )
))
