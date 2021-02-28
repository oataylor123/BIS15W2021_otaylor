---
title: "rshiny app rough"
author: "Olivia Taylor"
date: "2/28/2021"
output: 
  html_document: 
    keep_md: yes
---



## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


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
       menuItem("Playposit", tabName = "Playposit", icon = icon("tree")),
      menuItem("Quiz", tabName = "Quiz", icon = icon("tree")),
      menuItem("Lab", tabName = "Lab", icon = icon("tree")),
      menuItem("Lab Practical & Final", tabName = "Lab Practical & Final", icon = icon("tree")),
        menuItem("Total", tabName = "Total", icon = icon("tree"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("Quiz"),
      tabItem("Lab")
             
     )
  )
)

server <- function(input, output){
  
}

shinyApp(ui, server)
```

`<div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div>`{=html}
