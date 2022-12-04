#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("global.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # Link to the website
   output$mathLink <- renderUI({
     tagList(a("Student performance data set", 
               href= "https://archive.ics.uci.edu/ml/datasets/Student+Performance"))
   }) 
   
   # Images of both schools
   output$Gabriel_school_picture <- renderImage({
     list(src= 'Gabriel Pereira school.png', align = "left")
   })
   
   output$Mouzinho_school_picture <- renderImage({
     list(src= 'Mouzinho Da Silveira .png', align = "left")
   })

})
