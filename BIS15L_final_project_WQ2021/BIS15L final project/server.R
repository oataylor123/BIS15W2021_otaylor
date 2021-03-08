library(shiny)
source("helper.R")


shinyServer(
    function(input, output, session){    
        
        userGrades <- reactive({
            input$submitButton
            
            isolate({
                
                
                quizGrades = c(input$quiz1, input$quiz2, input$quiz3, input$quiz4, input$quiz5, input$quiz6, input$quiz7, input$quiz8, input$quiz9, input$quiz10)
                names(quizGrades) = paste("Q", 1:10, sep="")
                quizGrades = quizGrades[!is.na(quizGrades)]
                labGrades = c(input$lab1, input$lab2, input$lab3, input$lab4, input$lab5, input$lab6, input$lab7, input$lab8)
                names(labGrades) = c(paste("LAB", 1:8, sep=""))
                labGrades = labGrades[!is.na(labGrades)]
                labpresentationGrades = c(input$labpresentation4, input$labpresentation5)
                names(labpresentationGrades) = paste("LAB PRESENTATION", 4:5, sep="")
                labpresentationGrades = labpresentationGrades[!is.na(labpresentationGrades)]
                labpresentation8Grades = input$labpresentation8
                names(labpresentation8Grades) = "LAB PRESENTATION8"
                labpresentation8Grades = labpresentation8Grades[!is.na(labpresentation8Grades)]
                labpracticalGrade = input$labpractical
                names(labpracticalGrade) = "LABPRACTICAL"
                labpracticalGrade = labpracticalGrade[!is.na(labpracticalGrade)]
                midtermGrades = c(input$midterm1, input$midterm2, input$midterm3)
                names(midtermGrades) = paste("MIDTERM", 1:3, sep="")
                midtermGrades = midtermGrades[!is.na(midtermGrades)]
                list(quizGrades, labGrades, labpracticalGrade, labpresentation8Grades, midtermGrades, labpresentationGrades)
            })#END isolate
            
        })
        
        # Save user's input grades
        logfile <- paste('./userlogs/', 
                         format(Sys.time(), "%Y-%m-%d_%H-%M-%S"),
                         round(runif(1, min=10000, max=99999)),
                         '.csv',
                         sep='')
        observe({
            if(input$submitButton == 0)
                return()
            isolate({
                value = unlist(userGrades())
                write.csv(t(value), logfile, row.names=F)
            })
        })#END observe
        
        # Grade plot
        output$gradePlot = renderPlot({
            input$submitButton
            
            isolate({
                PlotGrades(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]], userGrades()[[5]], userGrades()[[6]])
            }) 
        })
        # Adjusted grade plot
        output$gradePlot_adj = renderPlot({
            input$submitButton
            
            isolate({
                PlotGrades_adj(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]], userGrades()[[5]], userGrades()[[6]])
            })
        })
        
        # Numerical facts
        output$totalEarned_text = renderText({
            input$submitButton
            
            isolate({
                quizGrades = userGrades()[[1]]
                labGrades = userGrades()[[2]]
                labpracticalGrade = userGrades()[[3]]
                labpresentation8Grades = userGrades()[[4]]
                midtermGrades = userGrades()[[5]]
                labpresentationGrades = userGrades()[[6]]
               
                orderInd = match(chronLabel, names(c(quizGrades, labGrades, labpracticalGrade, labpresentationGrades, labpresentation8Grades, midtermGrades)))
                orderInd = orderInd[!is.na(orderInd)]
                # Total possible grades so far
                worthSoFar = worth_chron[orderInd]
                totalWorthSoFar = sum(worthSoFar)
                if(is.na(totalWorthSoFar))
                    totalWorthSoFar = "N/A"
                # Total earned grades so far
                grade_chron = c(quizGrades, labGrades, labpracticalGrade, labpresentationGrades,  labpresentation8Grades, midtermGrades)[orderInd]
                totalGradeSoFar = sum(grade_chron)
                if(is.na(totalGradeSoFar))
                    totalGradeSoFar = "N/A"
                totalGradeSoFarPct = totalGradeSoFar/totalWorthSoFar*100
                if(is.na(totalGradeSoFarPct))
                    totalGradeSoFarPct = "N/A"
                # Assign letter grade
                letterGradeSoFar = AssignLetterGrade(totalGradeSoFarPct)
                
                str1 = paste("Before lowest lab dropped, total points earned (out of ", totalWorthSoFar, ") are: ", totalGradeSoFar, 
                             " (", format(totalGradeSoFarPct, digits=4), "%).", sep="")
                str2 = paste("This corresponds to a letter grade: ", letterGradeSoFar, ".", sep="")
                
                # Adjusted grades
                if(length(c(quizGrades, labGrades, labpracticalGrade, midtermGrades, labpresentationGrades, labpresentation8Grades)) <= 1){
                    totalWorthSoFar_adj = totalWorthSoFar
                    totalGradeSoFar_adj = totalGradeSoFar
                    totalGradeSoFarPct_adj = totalGradeSoFarPct
                    letterGradeSoFar_adj = letterGradeSoFar
                }else{
                    minLabGrade = min(labGrades)
                    totalWorthSoFar_adj = totalWorthSoFar - 10
                    totalGradeSoFar_adj = totalGradeSoFar - minLabGrade
                    totalGradeSoFarPct_adj = totalGradeSoFar_adj / totalWorthSoFar_adj * 100
                    letterGradeSoFar_adj = AssignLetterGrade(totalGradeSoFarPct_adj)
                }
                
                str3 = paste("After adjustment, total points earned (out of ", totalWorthSoFar_adj, ") are: ", totalGradeSoFar_adj, 
                             " (", format(totalGradeSoFarPct_adj, digits=4), "%).", sep="")
                str4 = paste("This corresponds to a letter grade: ", letterGradeSoFar_adj, ".", sep="")
                
                HTML(str1, str2, str3, str4)
            }) #END isolate   
        })
        
        # Clear inputs
        observe({
            input$clearButton
            
            isolate({
                updateNumericInput(session, "labpractical", value="")
                
                updateNumericInput(session, "midterm", value="")
                
                updateNumericInput(session, "quiz", value="")
                
                
                
               
                    
                labpresentationIDs = paste("labpresentation", 4:5, sep='')
                for(labpresentationID in labpresentationIDs){
                     updateNumericInput(session, labpresentationID, value="")  
                    
                }
                    
                labpresentation8IDs = "labpresentation8"
                for(labpresentation8ID in labpresentation8IDs){
                        updateNumericInput(session, labpresentation8ID, value="")  
                    
                }
                    
                labIDs = paste("lab", 1:8, sep='')
                for(labID in labIDs){
                    updateNumericInput(session, labID, value="")     
                    
                    
                }
            })
        })
        
    }    
)



