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
  
   ## Split the data into train and test set
    dat.split <- reactive({
     set.seed(12)
     index <- initial_split(math, prop = input$proportion)
     train.set <- training(index)
     test.set <- testing(index)
     return(list(train.set = train.set, test.set = test.set))
   }) 
   
   ## Set formulas
   F1 <- reactive({
     n <- length(input$predictors)
     if (n==0){
       return(formula(paste0(input$predictors, '~','(school + sex + age + studytime + internet + freetime + abscences + romantic
                             + health + G1 + G2)')))
     } else {
       f1 <- paste0(input$predictors, c(rep("+", n-1), ""))
       f2 <- paste0(f1, collapse = "")
       return(formula(paste0(input$response, '~', f2)))
     }
   })
   
   F2 <- reactive({
     n <- length(input$predictors)
     if (n==0){
       return(formula(paste0(input$predictors, '~','(school + sex + age + studytime + internet + freetime + abscences + romantic
                             + health + G1 + G2)')))
     } else {
       f3 <- paste0(input$predictors, c(rep("*", n-1), ""))
       f4 <- paste0(f3, collapse = "")
       return(formula(paste0(input$response, '~', f4)))
     }
   })
   
   ## Fit the models
    # MLR
   mlr <- eventReactive(input$runmodel,{
     mlr_mod <- train(F1(),data = dat.split()[["train.set"]],
                      method = 'lm',
                      preProcess = c('center', 'scale'),
                      trControl = trainControl(method = 'cv', number = input$cvfold))
     return(mlr_mod)
   })
   
    # Regression tree
   rt <- eventReactive(input$runmodel,{
     rtree_mod <- train(F2(), data = dat.split()[["train.set"]], 
                        method = "rpart",
                        trControl = trainControl(method = "repeatedcv", number = input$cvfold, repeats = 3),
                        preProcess = c("center", "scale"),
                        tuneGrid = data.frame(cp = (input$min_cp:input$max_cp)))
     return(rtree_mod)
   })
   
    # Random Forest 
   rf <- eventReactive(input$runmodel,{
     rf_mod <- train(F2(), data = dat.split()[["train.set"]], 
                    method = "rf",
                    trControl = trainControl(method = "repeatedcv", number = input$cvfold, repeats = 3),
                    preProcess = c("center", "scale"),
                    tuneGrid = data.frame(mtry = input$min_mtry:input$max_mtry))
     return(rf_mod)
     
   })
   
   ## Summaries for the three models
   output$MLR_sum <- renderPrint({
     if(input$runmodel){summary(mlr())}
       })
   
   output$RTree_sum <- renderPrint({
     if(input$runmodel){summary(rt())}
   })
   
   output$RF_sum <- renderPrint({
     if(input$runmodel){summary(rf())}
   })
   
   
  ## RMSE for the three models
   output$MLR_RMSE <- renderPrint({
     mlr <- mlr()
     MLR.rmse <- as.data.frame(min(mlr()$results['RMSE']))
     names(MLR.rmse) <- 'RMSE'
     return(MLR.rmse)
   })
   
   output$RTree_RMSE <- renderPrint({
     rt <- rt()
     RTree.rmse <- as.data.frame(min(rt()$results['RMSE']))
     names(RTree.rmse) <- 'RMSE'
     return(RTree.rmse)
   })
   
   output$RF_RMSE <- renderPrint({
     rf <- rf()
     RF.rmse <- as.data.frame(min(rf()$results['RMSE']))
     names(RF.rmse) <- 'RMSE'
     return(RF.rmse)
   })
   
  ## Predictions
   output$G3pred <- eventReactive(input$prediction, {
     pred.dat <- dat.split()[["test.set"]]
     pred.dat$age <- input$age_pred ; pred.dat$absences <- input$absc_pred ; pred.dat$G1 <- input$G1_pred
     pred.dat$G2 <- input$G2_pred ; pred.dat$sex <- input$sex_pred ; pred.dat$internet <- input$internet_pred
     pred.dat$school <- input$school_pred ; pred.dat$romantic <- input$rom_pred ; pred.dat$health <- input$health_pred
     pred.dat$freetime <- input$freetime_pred ; pred.dat$studytime <- input$studytime_pred
    
    
   if (input$modelSelection == "Multiple Linear Regression"){
     mlr.predict <- (predict(mlr(), newdata = pred.dat))[1]
     return(as.numeric(mlr.predict))
     
   } else if (input$modelSelection == "Regression Tree"){
     rtree.predict <- (predict(rt(), newdata = pred.dat))[1]
     return(as.numeric(rtree.predict))
     
   } else if(input$modelSelection == "Random Forest"){
     rf.predict <- (predict(rf(), newdata = pred.dat))[1]
     return(as.numeric(rf.predict))
   }
     
   })
   
   
   
 ###################################################################################################################################  
  ## FOURTH PAGE
  
    # Subset the data
   output$table <- renderDataTable({
     sub <- math1 %>% select(input$features) %>% filter(numbers <= input$row)
   })
   
   subdata <- reactive({
     sub <- math1 %>% select(input$features) %>% filter(numbers <= input$row)
   })
   
   # Download the subset data
   output$mathData <- downloadHandler(filename = "Subset of Math data.csv",
                                      content = function(file){write.csv(subdata(),file)})

}) # Close shiny server
