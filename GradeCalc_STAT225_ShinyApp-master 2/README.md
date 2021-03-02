GradeCalc_STAT225_ShinyApp
==========================

This is an R Shiny app which calculates grades and produce report for students in STAT 225. 
The current version is based on Fall 2014 syllabus.

Current functionality:
- Ask a student to type the grades in the numeric input boxes. After clicking "Submit", a report is produced.
- Clear the input form by clicking "Clear".
- Calculate the total points earned and the percentages before and after the grade adjustment (i.e. dropping the lowest quiz).
- Show progress plots of the assignment grades before and after the adjustment. 
  Each plot shows the individual grades and cumulative grades.
- Save the grades that a user last submit for each session, though I am not sure yet how to get access through shinyapps.io.
  
TODO:
- Validate user's inputs. Quiz >=0 and <=15, homeword >=0 and <=25, exam >=0 and <=100, and final >=0 and <=120.
- Add the overall performance for individual and cumulative grades so that a student can benchmark his/her performance. 
  This could be done by setting up a database for students grades.
  Also, I need a good way to incorporate that into the existing plots.
- Assign each user a unique number, so that one can use it to retrieve his/her previous inputs.
