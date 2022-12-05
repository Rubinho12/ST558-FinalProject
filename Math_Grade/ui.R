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
            
          )), # Closes dashboardSidebar
          
          ## Define the body of the app 
          dashboardBody(
            tabItems(
              
              # First page (About the App)
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

            ), # End of the first page
            
            
###########################################################################################################################          
              # Second page(Data exploration)
              tabItem(tabName = "Tab2",
                    fluidRow (
                    box(width = 4, 
                        h4("Here we will get some numerical summaries and plots"),
                        br(),
                        h4("Filter the data by school"),
                        selectizeInput(inputId = "school", 
                                       label="Select the school of your choice",
                                       choices = c("Gabriel Pereira", "Mozinho Da Silveira"))),
                    
                    box(width = 10,
                        h4("Filter the data by variables"),
                        selectizeInput(inputId = "vars",
                                       label="Select the variables of your choice",
                                       choices = names(math)[c(3,7,10,11,12)])),
                    
                    column(4, h4(strong('Meaning of the Variables')), box(width = 10,
                                h4(strong("Age :"), "Age of the student"),
                                h4(strong("Absences:"), "the number of time the student was absent from school"),
                                h4(strong("G1:"), "first period grade"),
                                h4(strong("G2:"), "second period grade"),
                                h4(strong("G3:"), "final grade"))),
                    
                    
                    column(10, h4("Numerical summaries"), box(width = 8, tableOutput("Table"))),
                    
                    box(width = 5,
                        radioButtons(inputId = "plot", label = "Select the plot of your choice",
                                     choices = c("Density", "Scatterplot", "Histogram"),
                                     selected = "Density"),
                    
                    plotOutput("plots"))),
                    
                    box(width = 5,
                        h4("A scatter plot allows us to see the relationship between two 
                        numeric variabes. A strong relationship shows a more linear trend, whereas
                        a weak relation shows points that are scattered"),
                        
                        h4("A density plot shows the distribution of the data or the variable.
                           A symmetric plot says that the variable is normally distributed, 
                           a right skewed plot says that 50% of the variable values are less
                           than the mean, and in a left skewed plot the mean is less than
                           the median"),
                        
                        h4("A histogram is similar to a density plot, as it tells us the 
                           distribution of the data or variable."))
                    
                    ), # End of second page
            
            
            
#####################################################################################################################            
              # Fourth page (The Data page)
            tabItem(tabName = "Tab4",
                    
                    # Subset by row, choose the school
                    column(4, h4("Subset the data by school name"),
                           selectizeInput(inputId = "school", 
                                       label = "Select the school of your choice",
                                       choices = c("Gabriel Pereira", "Mozinho Da Silveira"))),
                    
                    # Subset by columns, choose the variables
                    column(4, h4("Subset the data by the features"),
                           selectInput(inputId = "features",
                                       label = "Select the variables of your choice",
                                       choices = c( 'Sex', 'Age', 'Study time', 'Internet', 
                                                   'Free time', 'Absences','Romantic', 'Health', 'G1', 'G2', 'G3'))),
                    
                    # Download the data
                    downloadButton(outputId = "mathData", label = "Download data"),
                    
                    dataTableOutput("table"),
                    
                    column(4, h4(strong('Meaning of the Variables')), box(width = 10,
                           h4(strong('Sex :'), 'the gender of the student; male or female'),
                           h4(strong("Age :"), "Age of the student"),
                           h4(strong("Study time:"), "the amount of time the student studies after class "),
                           h4(strong("Internet:"), "whether the student has an internet connection at home or not"),
                           h4(strong("Free time:"), "the amount of free time the student has outside of class"),
                           h4(strong("Absences:"), "the number of time the student was absent from school"),
                           h4(strong("Romantic:"), "whether the student is in a romantic relationship or not"),
                           h4(strong("Health:"), "the health status of the student"),
                           h4(strong("G1:"), "first period grade"),
                           h4(strong("G2:"), "second period grade"),
                           h4(strong("G3:"), "final grade")))

                   
                    
                    ) # End of the 4th page
            
            
            
            
    ) # Closes tabItems
        
          ) # Closes dashboardBody   
        
) # Closes dashboardPage
          

  
      

