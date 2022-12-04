#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source('global.R')

# Define UI for application that predict final grades
dashboardPage(skin = 'red',
          
          # Application title
          dashboardHeader(title = 'Final Math Grade'),
          
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
              tabItem(tabname = "Tab1",

                      column(4, h1("Purpose of the App"), box(width=12),
                             h4("This app")),

                      column(4, h1("About the data"), box(width=12),
                             h4("The data comes from")),
                             h4("Below is the link to the data"),
                             h4(uiOutput("mathLink")),

                      column(4,h1("Purpose of each page of the App"), box(width=12),
                             h4("the first page"),
                             h4("The second page"),
                             h4("The third page"),
                             h4("The last page")),

                      column(4,h1("Picture"), box(width=12),
                             imageOutput(outputId = "mathPicture"))

            )
          )
        ),
        
            tabItem(tabName = "Tab2")
        
        
        
        
        
        
)
          

  
      

