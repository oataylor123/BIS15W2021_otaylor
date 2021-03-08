library(shiny)

shinyUI(
    fluidPage(
        # Application title
        titlePanel("Grade Calculator for BIS2C (Winter 2021)"),
        # Sidebar with data inputs
        sidebarLayout(
            sidebarPanel(
                h3("Please input your grades"),
                # By using <fluidRow>, one can add columns
                fluidRow(
                    column(3, 
                        h4("Quizzes", align="center"),   
                        numericInput("quiz1", "Quiz 1:", value='', min=0, max=15, step=0.5),
                        numericInput("quiz2", "Quiz 2:", '', min=0, max=5, step=0.5),
                        numericInput("quiz3", "Quiz 3:", '', min=0, max=5, step=0.5),
                        numericInput("quiz4", "Quiz 4:", '', min=0, max=5, step=0.5),
                        numericInput("quiz5", "Quiz 5:", '', min=0, max=5, step=0.5),
                        numericInput("quiz6", "Quiz 6:", '', min=0, max=5, step=0.5),
                        numericInput("quiz7", "Quiz 7:", '', min=0, max=5, step=0.5),
                        numericInput("quiz8", "Quiz 8:", '', min=0, max=5, step=0.5),
                        numericInput("quiz9", "Quiz 9:", '', min=0, max=5, step=0.5),
                        numericInput("quiz10", "Quiz 10:", '', min=0, max=5, step=0.5)
                        
                    ),
                    column(1),
                    column(3,
                        h4("Labs", align="center"),
                        numericInput("lab1", "Lab 1:", '', min=0, max=10, step=0.5),
                        numericInput("lab2", "Lab 2:", '', min=0, max=10, step=0.5),
                        numericInput("lab3", "Lab 3:", '', min=0, max=10, step=0.5),
                        numericInput("lab4", "Lab 4:", '', min=0, max=10, step=0.5),
                        numericInput("lab5", "Lab 5:", '', min=0, max=10, step=0.5),
                        numericInput("lab6", "Lab 6:", '', min=0, max=10, step=0.5),
                        numericInput("lab7", "Lab 7:", '', min=0, max=10, step=0.5),
                        numericInput("lab8", "Lab 8:", '', min=0, max=10, step=0.5),
                        numericInput("labpresentation4", "Lab Presentation 4:", '', min=0, max=5, step=0.5),
                        numericInput("labpresentation5", "Lab Presentation 5:", '', min=0, max=5, step=0.5)
                        
                    ), 
                    column(1),
                    column(3,
                           h4(align="center"),
                           numericInput("labpresentation8", "Lab Presentation 8:", '', min=0, max=15, step=0.5)
                           
                        
                        
                    ),
                    column(1),
                    column(3,
                        h4("Midterms", align="center"),
                        numericInput("midterm1", "Midterm 1:", '', min=0, max=90, step=0.5),
                        numericInput("midterm2", "Midterm 2:", '', min=0, max=90, step=0.5),
                        numericInput("midterm3", "Midterm 3:", '', min=0, max=90, step=0.5),
                        numericInput("labpractical", "Lab Practical:", '', min=0, max=45, step=0.5),
                        br(),
                        br()
                    )
                ), # END fluidRow
                #submitButton("Submit")
                fluidRow(
                    column(2, actionButton("submitButton", "Submit")),
                    column(2),
                    column(2, actionButton("clearButton", "Clear"))
                )
                
            ), # END sidebarPanel
            # Show the results
            mainPanel(
                h3("Your progress report"),
                textOutput("totalEarned_text"),
                HTML("<br/>"),
                p("The following plots show your progress for each assignment (dashed line) and overall performance (solid line), before and after dropping the lowest lab grade."),
                HTML("<br/>"),
                h4("Percentages with All Grades", align="center"),
                plotOutput("gradePlot"),
                h4("Percentages w/o Lowest Lab", align="center"),
                plotOutput("gradePlot_adj")
            )       
        )
    )    
)