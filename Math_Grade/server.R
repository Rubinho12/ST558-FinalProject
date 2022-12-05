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
  
#################################################################################################################################   
  ## FIRST PAGE (About the App)
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
   
   
 ###############################################################################################################################
  ## SECOND PAGE (Data Exploration)
   
   # Conditional logic
   exploration_data <- reactive({
    if(input$school == "Gabriel Pereira"){
      return(math %>% filter(school == "GP") %>% select(input$vars))
      
    } else if (input$school == "Mozinho Da Silveira"){
      return(math %>% filter(school == "MS") %>% select(input$vars))
    }
     
     
   })
   
   # Numerical summaries
   output$Table <- renderTable({
     stat <- quo(!!sym(input$vars))
     num_stats <- exploration_data() %>% select(!!stat) %>% 
                  summarise(Minimum = min(!!stat), Median = median(!!stat), Mean = mean(!!stat), Maximum=max(!!stat),
                           Variance = var(!!stat), Deviation = sd(!!stat))
     num_stats
   })
   
   # Convert the data into data frame
   exp_data <- as.data.frame(exploration_data)
   df_math <- reactive({as.data.frame(math)})
   
   
   # Graphical summaries
   graphs <- reactive({
     
     if (input$plot == "Density"){
       ggraph <- ggplot(data = exp_data(), aes(x = exp_data()[,input$vars])) +
         geom_density(kernel ='gaussian', color = 'red', size = 2)+
         ggtitle("Density Plot of", input$vars)+
         labs(x = input$vars)
       
     } else if (input$plot == "Scatterplot"){
       ggraph <- ggplot(data = df_math(), aes(y = G3, x = df_math()[,input$vars]))+
        geom_point(aes(color= G3))+
        ggtitle("Scatterplot of", input$vars)+
         labs( x = input$vars, y = 'Final Grade')
       
     } else if (input$plot == "Histogram"){
       ggraph <- ggplot(data = exp_data(), aes(x = exp_data()[,input$vars]))+
         geom_histogram(bins = 20, fill = "green")+
         ggtitle("Histogram of", input$vars)+
         labs(x = input$vars)
     }
     return(ggraph)
     
   })
   
   # Display the graphs
   output$plots <- renderPlot({
     graphs()
     })
   
####################################################################################################################################
  ## THIRD PAGE (Modelling) 
   
   
   
   
   
 ###################################################################################################################################  
  ## FOURTH PAGE
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
   # schol <- schoolChoice()
   # if(schol == 'GP'){
   #   return(math %>% select(sex, age, internet) %>% datatable())
   # } else{
   #   return(math %>% filter(school == schol) %>% select(input$school) %>% datatable())
   # }
  
  #    if (input$school == 'GP'){
  #     math %>%  filter(school = 'GP') %>% select(sex,age) %>% datatable()
  #   } else if(input$school == 'MS'){
  #     math %>% filter(school ='MS') %>% select(sex,age) %>% datatable()
  #   }
  #
    })
  
  #output$mathData <- downloadHandler(filename = "student-math.csv",content = function(file){write.csv(math,file)})
  
  

}) # Close shiny server
