---
title: "shiny app rough 2"
author: "Olivia Taylor"
date: "2/28/2021"
output: 
  html_document: 
    keep_md: yes
---





## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:
project_scores <- reactive(c(input$project_1,
                            input$project_2,
                            input$project_3,
                            input$project_4,
                            input$project_5))

```
## 
## Attaching package: 'shinydashboard'
```

```
## The following object is masked from 'package:graphics':
## 
##     box
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.0     ✓ dplyr   1.0.4
## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


```r
ui <- dashboardPage(
  dashboardHeader(title = "BIS2C Grade"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Quiz", tabName = "Quiz", icon = icon("tree")),
      menuItem("Lab", tabName = "Lab", icon = icon("tree")),
      menuItem("Lab Practical & Final", tabName = "Lab Practical & Final", icon = icon("tree")),
        menuItem("Total", tabName = "Total", icon = icon("tree"))
    )),
  dashboardBody(
    tabItems(
      tabItem("Quiz",
              h1(sliderInput("quiz_1", "Quiz 1:", min = 0, max = 75, value = 40),
                 sliderInput("quiz_2", "Quiz 2:", min = 0, max = 75,value = 40),
                 sliderInput("quiz_3", "Quiz 3:", min = 0, max = 75,value = 40),
                 sliderInput("syllabus_quiz", "Syllabus Quiz:", min = 0,max = 5,value = 5)
                 )),
      tabItem("Lab",
               h2(sliderInput("prelab_1", "PreLab 1:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_1", "Postlab 1:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_2", "PreLab 2:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_2", "Postlab 2:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_33", "PreLab 3:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_3", "Postlab 3:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_4", "PreLab 4:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_4", "Postlab 4:", min = 0,max = 5, value = 5),
                  sliderInput("prelab_55", "PreLab 5:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_5", "Postlab 5:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_6", "PreLab 6:", min  = 0, max = 5, value = 5),
                  sliderInput("postab_6", "Postlab 6:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_7", "PreLab 7:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_7", "Postlab 7:", min = 0, max = 5, value = 5),
                  sliderInput("prelab_8", "PreLab 8:", min  = 0, max = 5, value = 5),
                  sliderInput("postlab_8", "Postlab 8:", min = 0, max = 5, value = 5)
               )),
                  
      tabItem("Lab Practical & Final",
              h3(sliderInput("final", "Final:", min = 0,max = 125, value = 75),
                 sliderInput("lab_practical", "Lab Practical:", min = 0, max = 45, value = 25)
                 )),
      
                 
      tabItem("Total"))
      ))
server <- function(input, output, session) {
  
}
shinyApp(ui, server)
```

`<div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div>`{=html}

