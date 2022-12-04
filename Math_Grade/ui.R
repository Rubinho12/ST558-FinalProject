#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("global.R")

# Define UI for application that predict final grades
dashboardPage(skin = 'red',
          
          # Application title
          dashboardHeader(title = 'Final Year Math Grade for Secondary Students', titleWidth=450),
          
          # define sidebar items
          dashboardSidebar(sidebarMenu(
            menuItem("About", tabName = "Tab1"),
            menuItem("Data Exploration", tabName = "Tab2"),
            menuItem("Modeling", tabName = "Tab3"),
            menuItem("Data ", tabName = "Tab4")
          )),
          
          # # define the body of the app 
          dashboardBody(
            tabItems(
              tabItem(tabName = "Tab1",

                column(4, h1("Purpose of the App"), box(width=10,
                          h4("This app predicts the final year grade in Mathematics for secondary 
                             students at 2 different Portugese schools,(Gabriel Pereira and Mousinho Da Silveira), 
                             based on various factors including but not limited to the first and second periods 
                             grades, the amount of free time after school, the health of the student, etc..."))),

                      column(4, h1("About the data"), box(width=12,
                             h4("The data was obtained from the UCI Machine Learning Repository.
                                The data approachs student achievement in secondary education
                                of two Portugese schools. Records on students age, sex, family
                                size, parents' education and much more were obtained in order
                                to analyze the factors that affect student performance in 
                                school."),
                             br(),
                             h4("Below is the link to the website of the data:"),
                             h4(uiOutput("mathLink")))),

                      column(4,h1("Purpose of each page of the App"), box(width=10,
                             h4("The first page of the App gives an overview of the whole
                                application, the  purpose of the App, information about
                                the data, and what we can expect to see on the other 
                                pages. It is like the map of the application."),
                             br(),
                             h4("The second page of the App is about data exploration. There,
                                one can expect to see some numerical and graphical summaries, and 
                                according to the user's input, he/she would be able to generate
                                different results."),
                             br(),
                             h4("The third page deals with the modeling of the data. This is where
                                three different models will be fit on a train set, then evaluated 
                                on the test set,in order to predict the final year grade.
                                Note that the train and test sets are the sets that the whole
                                data is divided into."),
                             br(),
                             h4("The last page lets the user scroll through the data set, 
                                subset  it and save it as a file."))),

                      #column(4,
                             h1("Gabriel Pereira"),
                             imageOutput(outputId = "Gabriel_school_picture"),
                
                             h1("Mouzinho Da Silveira"),
                             imageOutput(outputId = "Mouzinho_school_picture")

            ),
          
        
        
            tabItem(tabName = "Tab4",
                    
                    column(4, h1("look")),
                    column(4, h1("boss")))
)
        
        
          )   
        
        
        
)
          

  
      

