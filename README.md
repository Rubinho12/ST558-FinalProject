# ST558_Final_Project

  # * Brief description of the app  
  The Math_Grade app predicts the final year grade in Mathematics for secondary students at two different Portugese schools,(Gabriel Pereira and Mousinho Da Silveira),     based on various factors including but not limited to the first and second periods grades, the amount of free time after school, the health of the student, etc... 
  This app read in the Student Performance data set, which is divided into a train and test set after some cleaning. With the app, the user can create some numerical and   graphical summaries according to the inputs of his/her choice, fit three different models on the train set then predicts them on the test set. The model with the lower
  test metric is the winner model, and the final math grade of the student can be predicted using any model of choice.  
  
  A data page let the user scroll through the data , subset it by row and column, and download it as a CSV file. The use of the Math_Grade app is not only limited to the
  two schools mentioned above, but can be used to predict the final math grade for any students at any school, using the right and appropriate variables in this application.  
  
  # * Lists of the packages necessary to run this app
  library(shiny)  
  library(shinydashboard)  
  library(tidyverse)  
  library(ggplot2)  
  library(DT)  
  library(Metrics)  
  library(caret)  
  library(rsample)  
  
  The above packages can be installed using the following line of code  
  `install.packages(c('shiny', 'shinydashboard' , 'tidyverse' ,'ggplot2' ,'DT' , 'Metrics' , 'caret' , 'rsample'))`  
  
  Code to run the app  
  `shiny::runGitHub("ST558-FinalProject", "Rubinho12", subdir = "Math_Grade/")`
 
  
