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

# Define server logic required
shinyServer(function(input, output, session) {
    
  ## First page
    # Link to the website
   output$mathLink <- renderUI({
     tagList(a("Student performance data set", 
               href= "https://archive.ics.uci.edu/ml/datasets/Student+Performance"))
   }) 
   
   # Images of both schools
   output$Gabriel_school_picture <- renderImage({
     list(src= 'Gabriel Pereira school.png', align = "left")
   }, deleteFile = F)
   
   output$Mouzinho_school_picture <- renderImage({
     list(src= 'Mouzinho Da Silveira .png', align = "left")
   }, deleteFile = F)
  
    
   
  ## Fourth page
  schoolChoice <- reactive({ 
    switch (input$chool, 
    'Gabriel Pereira' = 'GP',
    'Mozinho Da Silveira' = 'MS')
  
    })
  varChoice <- reactive({
   switch(input$vars,
          'Sex' = 'sex',
          "Age" = 'age',
          "Study time" = 'studytime',
          "Internet" = 'internet',
          "Free time" = 'freetime',
          "Absences" = 'absences',
          "Romantic" = 'romantic',
          "Health" = 'health',
          "G1" = 'G1',
          "G2" = 'G2',
          "G3" = 'G3')
          
          
           })
  
  output$table <- renderDataTable({
   schol <- schoolChoice()
   if(schol == 'GP'){
     math %>% select(sex, age, internet) %>% datatable()
   } else{
     math %>% filter(school ==schol) %>% select(input$school) %>% datatable()
   }
  
  #    if (input$school == 'GP'){
  #     math %>%  filter(school = 'GP') %>% select(sex,age) %>% datatable()
  #   } else if(input$school == 'MS'){
  #     math %>% filter(school ='MS') %>% select(sex,age) %>% datatable()
  #   }
  # 
    })
  
  output$mathData <- downloadHandler(filename = "student-math.csv",content = function(file){write.csv(data,file)})
  
  

}) # Close shiny server
