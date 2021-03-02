## Syllabus
quizWorth = rep(15, 8); names(quizWorth) = paste("Q", 1:8, sep="")
hwWorth = rep(25, 5); names(hwWorth) = paste("HW", 1:5, sep="")
examWorth = c(rep(100, 2), 125); names(examWorth) = c(paste("Exam", 1:2, sep=""), "Final")
cpWorth = 15; names(cpWorth) = "CP" # class participation
cutoff = c(0, 60, 70, 80, 90, 100)
chronLabel = c("Q1", "HW1", "Q2", "HW2", "Q3", "Exam1", 
               "Q4", "Q5", "HW3", "Q6", "HW4", "Exam2",
               "Q7", "Q8", "HW5", "Final", "CP")

worth_chron = c(quizWorth, hwWorth, examWorth, cpWorth)[match(chronLabel, names(c(quizWorth, hwWorth, examWorth, cpWorth)))]
worthCumsum_chron = cumsum(worth_chron)

# ## Sample grades
# quizGrade = c(10.5, 15, 11, 12, 13, 8, 9, 15); names(quizGrade) = paste("Q", 1:8, sep="")
# hwGrade = c(23, 24, 22, 21.5, 25); names(hwGrade) = paste("HW", 1:5, sep="")
# examGrade = c(80, 90.5, 110); names(examGrade) = c(paste("Exam", 1:2, sep=""), "Final")
# cpGrade = 15; names(cpGrade) = "CP"
# # Sample grades with missing value
# quizGrade = c(10.5); names(quizGrade) = paste("Q", 1, sep="")
# hwGrade = c(23); names(hwGrade) = paste("HW", 1, sep="")
# examGrade = c()
# cpGrade = c()

## Plot function
# Un-adjusted
PlotGrades = function(quizGrade, hwGrade, examGrade, cpGrade){
    ### ====
    # Given the three vectors: quiz grades, hw grades, exam grades, and participation grade,
    # plot the un-adjusted individual and cumulative percentages as times series.
    # 
    # Input:
    #    quizGrade, hwGrade, examGrade, cpGrade: grade vectors with names
    ### ====
    
    ## Process the grades for plotting
    # Rearrage the grades in chronological order (same as <assignment_label>) 
    orderInd = match(chronLabel, names(c(quizGrade, hwGrade, examGrade, cpGrade)))
    orderInd = orderInd[!is.na(orderInd)] # If the grades are not complete (say in the middle of the semester), the grades of the assignments yet assigned are NA
    grade_chron = c(quizGrade, hwGrade, examGrade, cpGrade)[orderInd]
    #grade_chron = c(quizGrade, hwGrade, examGrade)[match(chronLabel, names(c(quizGrade, hwGrade, examGrade)))]
    gradePct_chron = grade_chron / worth_chron[1:length(grade_chron)] * 100
    # Cumulative sum of the grades
    gradeCumsum_chron = cumsum(grade_chron)
    gradeCumsumPct_chron = gradeCumsum_chron / worthCumsum_chron[1:length(grade_chron)] * 100
    
    ## Plot grades (individual and cumulative)
    par(mex=1.5, # Axes margins will be twice the normal size (so that y label and ticks won't overlap)
        mar=c(7.1, 4.1, 1, 4.1)) # Add extra space to right of plot area (to leave space for legend)
    
    if(length(gradePct_chron)==0){
        yLowLimit = 60
    }else{
        yLowLimit = min(min(gradeCumsumPct_chron, gradePct_chron)*0.8, 60)
    }
    xLen = length(chronLabel)
    
    plot(0, 0, type="o", 
         axes=F, # suppress the axes (to be customized and added later) 
         xlim=c(1, xLen), ylim=c(yLowLimit, 100),
         xlab="Assignments", ylab="Percentage (%)")
    axis(1, at=1:xLen, labels=chronLabel)
    axis(2, at=c(60, 70, 80, 90, 100), labels=c("60 (D)", "70 (C)", "80 (B)", "90 (A)", "100"), las=2)
    box()
    
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(yLowLimit, yLowLimit, 90, 90), col="red")
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(70, 70, 90, 90), col="lightyellow")
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(90, 90, 100, 100), col="lightgreen")
    
    # Add reference lines
    # for(yVal in c(60, 70, 80, 90)){
    #     abline(h=yVal)
    # }
    abline(h=60, col="grey")
    for(x in 1:xLen){
        abline(v=x, col="grey")
    }
    
    # Add the line of individual percentages
    lines(gradePct_chron, type="b", lwd=2, pch=18, lty="dotted")
    # Add the line of cumulative percentages
    lines(gradeCumsumPct_chron, type="b", lwd=2, pch=20, col="blue")
    # Add legend
    legend("bottom", inset=c(0, -0.55), legend=c("Individual","Cumulative"), 
           pch=c(18,20), lty=c("dotted", "solid"), col=c("black", "blue"), 
           horiz=T,
           cex=1,
           title="Grade type", 
           xpd=T) # enable plot the legend outside the main figure
}

# Adjusted
PlotGrades_adj = function(quizGrade, hwGrade, examGrade, cpGrade){
    ### ====
    # Given the three vectors: quiz grades, hw grades, exam grades and participation grade, 
    # plot the individual and cumulative percentages as times series.
    #
    # Note:
    #   The adjustment is done retrospectively, meaning if a lower quiz grade occurs later on 
    #   the pervious cumulative percentages will be recalculated.
    #
    # Input:
    #    quizGrade, hwGrade, examGrade, cpGrade: grade vectors with names
    ### ====
    
    if(length(c(quizGrade, hwGrade, examGrade, cpGrade)) <= 1){
        PlotGrades(quizGrade, hwGrade, examGrade, cpGrade)
    }else{
        minQuizGrade = min(quizGrade)
        
        ## Process the grades for plotting
        # Rearrage the grades in chronological order (same as <assignment_label>) 
        orderInd = match(chronLabel, names(c(quizGrade, hwGrade, examGrade, cpGrade)))
        orderInd = orderInd[!is.na(orderInd)] # If the grades are not complete (say in the middle of the semester), the grades of the assignments yet assigned are NA
        # Individual percentages
        grade_chron = c(quizGrade, hwGrade, examGrade, cpGrade)[orderInd]
        gradePct_chron = grade_chron / worth_chron[1:length(grade_chron)] * 100
        # Cumulative percentages: adjust restrospectively
        gradeCumsum_chron = c(grade_chron[1], cumsum(grade_chron)[-1] - minQuizGrade)
        gradeCumsumPct_chron = gradeCumsum_chron / c(worthCumsum_chron[1], worthCumsum_chron[2:length(grade_chron)] - 15) * 100
        
        ## Plot grades (individual and cumulative)
        par(mex=1.5, # Axes margins will be twice the normal size (so that y label and ticks won't overlap)
            mar=c(7.1, 4.1, 1, 4.1)) # Add extra space to right of plot area (to leave space for legend)
        
        # x, y limit for plots
        yLowLimit = min(min(gradeCumsumPct_chron, gradePct_chron)*0.8, 60)
        xLen = length(chronLabel)
        
        # Set up the plotting area
        plot(0, 0, type="o", 
             axes=F, # suppress the axes (to be customized and added later) 
             xlim=c(1, xLen), ylim=c(yLowLimit, 100),
             xlab="Assignments", ylab="Percentage (%)")
        axis(1, at=1:xLen, labels=chronLabel)
        axis(2, at=c(60, 70, 80, 90, 100), labels=c("60 (D)", "70 (C)", "80 (B)", "90 (A)", "100"), las=2)
        box()
        
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(yLowLimit, yLowLimit, 90, 90), col="red")
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(70, 70, 90, 90), col="lightyellow")
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(90, 90, 100, 100), col="lightgreen")
        
        # Add reference lines
        # for(yVal in c(60, 70, 80, 90)){
        #     abline(h=yVal)
        # }
        abline(h=60, col="grey")
        for(x in 1:xLen){
            abline(v=x, col="grey")
        }
        
        # Add the line of individual percentages
        lines(gradePct_chron, type="b", lwd=2, pch=18, lty="dotted")
        # Add the line of cumulative percentages
        lines(gradeCumsumPct_chron, type="b", lwd=2, pch=20, col="blue")
        # Add legend
        legend("bottom", inset=c(0, -0.55), legend=c("Individual","Cumulative"), 
               pch=c(18,20), lty=c("dotted", "solid"), col=c("black", "blue"),
               horiz=T,
               cex=1,
               title="Grade type", 
               xpd=T) # enable plot the legend outside the main figure
    }
}

## Assign letter grade according to the syllabus
AssignLetterGrade = function(gradePct){
    if(gradePct == "N/A"){ # if no assignment has been graded yet
        letterGrade = "N/A"
    }else if(gradePct < 60){
        letterGrade = "F"
    }else if(gradePct < 70){
        letterGrade = "D"
    }else if(gradePct < 80){
        letterGrade = "C"
    }else if(gradePct < 90){
        letterGrade = "B"
    }else{
        letterGrade = "A"
    }
    
    return(letterGrade)
}