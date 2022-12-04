library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(DT)
library(Metrics)
library(caret)


data <- read_delim("student-mat.csv", delim = ';')
head(data)

math <- data %>%
  select( school, sex, age, studytime, internet, freetime, absences, romantic, health, G1, G2, G3)


math$sex <- as.factor(math$sex)

math$studytime <- factor (math$studytime , levels = c(1,2,3,4), 
                          labels = c('Less than 2 hours', 'between 2 to 5 hours', 'between 5 to 10 hours', 'more than 10 hours'))

math$internet <- as.factor(math$internet)

math$freetime <- factor(math$freetime, levels = c(1,2,3,4,5), 
                        labels = c('Very low', 'Low', 'Moderate', 'High', 'Very high')) 

math$health <- factor(math$health, levels = c(1,2,3,4,5), 
                      labels = c('Very bad', 'Bad', 'Average', 'Good', 'Very good'))

math$romantic <- as.factor(math$romantic)

