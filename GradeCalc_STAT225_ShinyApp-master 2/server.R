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
                
                quizGrades = c(input$quiz1, input$quiz2, input$quiz3, input$quiz4, input$quiz5, input$quiz6, input$quiz7, input$quiz8)
                names(quizGrades) = paste("Q", 1:8, sep="")
                quizGrades = quizGrades[!is.na(quizGrades)]
                hwGrades = c(input$hw1, input$hw2, input$hw3, input$hw4, input$hw5)
                names(hwGrades) = paste("HW", 1:5, sep="")
                hwGrades = hwGrades[!is.na(hwGrades)]
                examGrades = c(input$exam1, input$exam2, input$final)
                names(examGrades) = c(paste("Exam", 1:2, sep=""), "Final")
                examGrades = examGrades[!is.na(examGrades)]
                cpGrade = input$cp
                names(cpGrade) = "CP"
                cpGrade = cpGrade[!is.na(cpGrade)]
                
                list(quizGrades, hwGrades, examGrades, cpGrade)
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
                PlotGrades(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]])
            }) 
        })
        # Adjusted grade plot
        output$gradePlot_adj = renderPlot({
            input$submitButton
            
            isolate({
                PlotGrades_adj(userGrades()[[1]], userGrades()[[2]], userGrades()[[3]], userGrades()[[4]])
            }) 
        })
        
        # Numerical facts
        output$totalEarned_text = renderText({
            input$submitButton
            
            isolate({
                quizGrades = userGrades()[[1]]
                hwGrades = userGrades()[[2]]
                examGrades = userGrades()[[3]]
                cpGrade = userGrades()[[4]]
                
                orderInd = match(chronLabel, names(c(quizGrades, hwGrades, examGrades, cpGrade)))
                orderInd = orderInd[!is.na(orderInd)]
                # Total possible grades so far
                worthSoFar = worth_chron[orderInd]
                totalWorthSoFar = sum(worthSoFar)
                if(is.na(totalWorthSoFar))
                    totalWorthSoFar = "N/A"
                # Total earned grades so far
                grade_chron = c(quizGrades, hwGrades, examGrades, cpGrade)[orderInd]
                totalGradeSoFar = sum(grade_chron)
                if(is.na(totalGradeSoFar))
                    totalGradeSoFar = "N/A"
                totalGradeSoFarPct = totalGradeSoFar/totalWorthSoFar*100
                if(is.na(totalGradeSoFarPct))
                    totalGradeSoFarPct = "N/A"
                # Assign letter grade
                letterGradeSoFar = AssignLetterGrade(totalGradeSoFarPct)
                
                str1 = paste("Before adjustment, total points earned (out of ", totalWorthSoFar, ") are: ", totalGradeSoFar, 
                             " (", format(totalGradeSoFarPct, digits=4), "%).", sep="")
                str2 = paste("This corresponds to a letter grade: ", letterGradeSoFar, ".", sep="")
                
                # Adjusted grades
                if(length(c(quizGrades, hwGrades, examGrades, cpGrade)) <= 1){
                    totalWorthSoFar_adj = totalWorthSoFar
                    totalGradeSoFar_adj = totalGradeSoFar
                    totalGradeSoFarPct_adj = totalGradeSoFarPct
                    letterGradeSoFar_adj = letterGradeSoFar
                }else{
                    minQuizGrade = min(quizGrades)
                    totalWorthSoFar_adj = totalWorthSoFar - 15
                    totalGradeSoFar_adj = totalGradeSoFar - minQuizGrade
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
                updateNumericInput(session, "cp", value="")
                updateNumericInput(session, "final", value="")
                
                quizIDs = paste("quiz", 1:8, sep='')
                for(quizID in quizIDs){
                    updateNumericInput(session, quizID, value="")
                }
                
                hwIDs = paste("hw", 1:5, sep='')
                for(hwID in hwIDs){
                    updateNumericInput(session, hwID, value="")
                }
                
                examIDs = paste("exam", 1:2, sep='')
                for(examID in examIDs){
                    updateNumericInput(session, examID, value="")
                }
            })
        })
        
    }    
)