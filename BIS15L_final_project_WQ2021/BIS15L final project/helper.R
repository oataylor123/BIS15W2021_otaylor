
quizWorth = rep(5, 10); names(quizWorth) = paste("Q", 1:10, sep="")
labWorth = rep(10, 8); names(labWorth) = paste("LAB", 1:8, sep="")
labpresentationWorth = rep(5, 2); names(labpresentationWorth) = paste("LAB PRESENTATION", 4:5, sep="")
labpresentation8Worth = 15; names(labpresentation8Worth) = "LAB PRESENTATION8"
labpracticalWorth = 85; names(labpracticalWorth) = "LABPRACTICAL"
midtermWorth = rep(90, 3); names(midtermWorth) = paste("MIDTERM", 1:3, sep="")
cutoff = c(0, 60, 70, 80, 90, 100)
chronLabel = c("Q1", "LAB1", "Q2", "LAB2", "Q3",  "LAB3", "MIDTERM1",
               "Q4", "LAB4", "LAB PRESENTATION4", "LAB5", "LAB PRESENTATION5", "Q5", "LAB6", "Q6", "MIDTERM2", "LAB7", "Q7"
,                "LAB8", "LAB PRESENTATION8","Q8", "Q9", "Q10", "LABPRACTICAL", "MIDTERM3")

worth_chron = c(quizWorth,  labWorth,  labpracticalWorth, labpresentationWorth, labpresentation8Worth, midtermWorth)[match(chronLabel, names(c(quizWorth,  labWorth,  labpracticalWorth, labpresentationWorth, labpresentation8Worth, midtermWorth)))]
worthCumsum_chron = cumsum(worth_chron)



## Plot function
# Un-adjusted
PlotGrades = function(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades){
    
    
    ## Process the grades for plotting
    # Rearrage the grades in chronological order (same as <assignment_label>) 
    orderInd = match(chronLabel, names(c(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)))
    orderInd = orderInd[!is.na(orderInd)] # If the grades are not complete (say in the middle of the semester), the grades of the assignments yet assigned are NA
    grade_chron = c(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)[orderInd]
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
    
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(yLowLimit, yLowLimit, 90, 90), col="darkolivegreen4")
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(70, 70, 90, 90), col="darkseagreen3")
    polygon(c(1, xLen+0.5, xLen+0.5, 1), c(90, 90, 100, 100), col="cornflowerblue")
    
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
PlotGrades_adj = function(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades){
   
    
    if(length(c(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)) <= 1){
        PlotGrades(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)
    }else{
        minLabGrade = min(labGrades)
        
        ## Process the grades for plotting
        orderInd = match(chronLabel, names(c(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)))
        orderInd = orderInd[!is.na(orderInd)] # If the grades are not complete (say in the middle of the semester), the grades of the assignments yet assigned are NA
        # Individual percentages
        grade_chron = c(quizGrades,  labGrades,  labpracticalGrades, labpresentationGrades, labpresentation8Grades, midtermGrades)[orderInd]
        gradePct_chron = grade_chron / worth_chron[1:length(grade_chron)] * 100
        # Cumulative percentages: adjust retrospectively
        gradeCumsum_chron = c(grade_chron[1], cumsum(grade_chron)[-1] - minLabGrade)
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
        
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(yLowLimit, yLowLimit, 90, 90), col="darkolivegreen4")
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(70, 70, 90, 90), col="darkseagreen3")
        polygon(c(1, xLen+0.5, xLen+0.5, 1), c(90, 90, 100, 100), col="cornflowerblue")
        
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

