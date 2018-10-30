#Austin Semmel Project 2
library(shiny)
library(dplyr)
library(ggplot2)
library(knitr)
library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("darkly"),
  
  # Application title
  titlePanel( 
    uiOutput("titleText")
    ),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      textInput("bossName","What Pokemon are you battling against?",value="Charizard"),
      br(),
     checkboxInput("leg","Do you want to include legendaries?",value=TRUE),
      br(),
     #Generation conditional panel
     checkboxInput("includeGens","Do you want to separate by Generation?",value=FALSE),
     conditionalPanel(condition="input.includeGens=='1'",
      checkboxGroupInput("gens","Which Generations do you want to include?",
                       choices=c("I","II","III","IV","Alolan","V (unreleased)","Mega (unreleased)"))
      ),
    br()
    ),
    #Main Panel
    mainPanel(
      
      plotOutput("DPSPlot"),
      tableOutput("DPStable")
      
      
    )
  )
))
