library(shiny)
source("helper.R")

# validQuizGrade = function(quizGrade){
#     if(quizGrade<0 || quizGrade>15)
#         "Invalid quiz grade !"
# }

shinyServer(
    function(input, output, session){    
        # Capture user inputs, which will be used repeated later
        # Note: the list is retrieved by calling "userGrades()", i.e. a function-like call.
        userGrades <- reactive({
            input$submitButton
            
            isolate({
                #                 validate(
                #                     need(input$quiz1 <= 15, "Quiz 1 grade should be a number between 0 and 15 !")
                #                 )
                
                #                 validate(
                #                     validQuizGrade(input$quiz1)    
                #                 )
                
                quizGrades = c(input$quiz1, input$quiz2, input$quiz3, input$quiz4, input$quiz5, input$quiz6, input$quiz7, input$quiz8, input$quiz8, input$quiz9, input$quiz10)
                names(quizGrades) = paste("Quiz", 1:10, sep="")
                quizGrades = quizGrades[!is.na(quizGrades)]
                labGrades = c(input$lab1, input$lab2, input$lab3, input$lab4, input$lab5, input$lab6, input$lab7, input$lab8)
                names(labGrades) = c(paste("Lab", 1:8, sep=""))
                labGrades = labGrades[!is.na(labGrades)]
                labpresentationGrades = c(input$labpresentation4, input$labpresentation5, input$labpresentation8)
                names(labpresentationGrades) = paste("Lab Presentations", 1:3)
                labpresentationGrades = labpresentationGrades[!is.na(labpresentationGrades)]
                labpracticalGrade = input$labpractical
                names(labpracticalGrade) = "Labpractical"
                labpracticalGrade = labpracticalGrade[!is.na(labpracticalGrade)]
                midtermGrades = c(input$midterm1, input$midterm2, input$midterm3, input$lalpractical)
                names(midtermGrades) = "Midterm"
                midtermGrades = midtermGrade[!is.na(midtermGrade)]
                list(quizGrades, labGrades, labpracticalGrades, midtermGrades)
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
                PlotGrades(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]], userGrades()[[5]])
            }) 
        })
        # Adjusted grade plot
        output$gradePlot_adj = renderPlot({
            input$submitButton
            
            isolate({
                PlotGrades_adj(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]], userGrades()[[5]])
            })
        })
        
        # Numerical facts
        output$totalEarned_text = renderText({
            input$submitButton
            
            isolate({
                quizGrades = userGrades()[[1]]
                labGrades = userGrades()[[2]]
                labpracticalGrade = userGrades()[[3]]
                midtermGrades = userGrades()[[4]]
                labpresentationGrades = userGrades()[[5]]
               
                
                orderInd = match(chronLabel, names(c(quizGrades, labGrades, labpracticalGrade, midtermGrades, labpresentationGrades)))
                orderInd = orderInd[!is.na(orderInd)]
                # Total possible grades so far
                worthSoFar = worth_chron[orderInd]
                totalWorthSoFar = sum(worthSoFar)
                if(is.na(totalWorthSoFar))
                    totalWorthSoFar = "N/A"
                # Total earned grades so far
                grade_chron = c(quizGrades, labGrades, labpracticalGrade, midtermGrades, labpresentationGrades)[orderInd]
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
                if(length(c(quizGrades, labGrades, labpracticalGrade, midtermGrades, labpresentationGrades)) <= 1){
                    totalWorthSoFar_adj = totalWorthSoFar
                    totalGradeSoFar_adj = totalGradeSoFar
                    totalGradeSoFarPct_adj = totalGradeSoFarPct
                    letterGradeSoFar_adj = letterGradeSoFar
                }else{
                    minlabGrade = min(labGrades)
                    totalWorthSoFar_adj = totalWorthSoFar - 15
                    totalGradeSoFar_adj = totalGradeSoFar - minlabGrade
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
                
                updateNumericInput(session, "labpresentation", value="")
                
                updateNumericInput(session, "lab", value="")
                
                
                quizIDs = paste("quiz", 1:10, sep='')
                for(quizID in quizIDs){
                    updateNumericInput(session, quizID, value="")
                }
                
                midtermIDs = paste("midterm", 1:8, sep='')
                for(midtermID in midtermIDs){
                    updateNumericInput(session, midtermID, value="")
                }
                
                labpracticalIDs = paste("labpractical", 1:1, sep='')
                for(labpracticalID in labpracticalIDs){
                    updateNumericInput(session, labpracticalID, value="")
                    
                labpracticalIDs = paste("labpresentation", 1:1, sep='')
                for(labpresentationID in labpresentationIDs){
                     updateNumericInput(session, labpresentationID, value="")    
                    
                labIDs = paste("lab", 1:1, sep='')
                for(labID in labIDs){
                    updateNumericInput(session, labID, value="")     
                    
                    
                }
                }
                })
            })
        
        }) 
})


