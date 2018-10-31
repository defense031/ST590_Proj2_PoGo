#Austin Semmel Project 2
library(shiny)
library(dplyr)
library(ggplot2)
library(knitr)
library(shinythemes)
library(shinydashboard)
library(shinydashboardPlus)

url2<-"https://raw.githubusercontent.com/defense031/ST590_Proj2_PoGo/master/PoGoIndividualData.csv"
pogo<-read.csv(text=getURL(url2),header=TRUE)

shinyUI(dashboardPagePlus(skin="blue",
  
  # Application title
  dashboardHeaderPlus( 
    title=uiOutput("titleText"),
    titleWidth=700,
    tags$li(class = "dropdown",
            tags$style(".main-header {max-height: 75}"),
            tags$style(".main-header .logo {height: 75;}"),
            tags$style(".sidebar-toggle {height: 75; padding-top: 1px !important;}"),
            tags$style(".navbar {min-height:75 !important}")
    )
  ),
  # Sidebar 
  dashboardSidebar(
    sidebarMenu(
      menuItem("About this App", tabname="about",icon=icon("question",lib="font-awesome")),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Data", icon = icon("th"), tabName = "data")
    ),
      br(),
      br(),
      textInput("bossName","What Pokemon are you battling against?",value="Charizard"),
      br(),
     checkboxInput("leg","Do you want to include legendaries?",value=TRUE),
      br(),
     #Generation conditional panel
     checkboxInput("includeGens","Do you want to separate by Generation?",value=FALSE),
     conditionalPanel(condition="input.includeGens=='1'",
      checkboxGroupInput("gens","Which Generations do you want to include?",
                       choices=levels(pogo$Generation),inline=TRUE)
      )
    ),
    #Main Panel
    dashboardBody(
      tabItems(
          tabItem(tabName="about"
                  #textOutput("firstInfo"))
          ),
          tabItem(tabName = "dashboard",
              fluidRow(plotOutput("DPSPlot"))
              
          ),
          tabItem(tabName="data",
              fluidRow(tableOutput("DPStable")),
              selectInput("dataset", "Choose a dataset:",
                          choices = c("Top Counters","Full Dataset")),
              downloadButton("downloadData","Download Data")
          )
    )
    )
)
)