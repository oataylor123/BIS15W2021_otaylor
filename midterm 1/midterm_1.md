---
title: "Midterm 1"
author: "Olivia Taylor"
date: "2021-02-09"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your code should be organized, clean, and run free from errors. Be sure to **add your name** to the author header above. You may use any resources to answer these questions (including each other), but you may not post questions to Open Stacks or external help sites. There are 12 total questions.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

This exam is due by **12:00p on Thursday, January 28**.  

## Load the tidyverse
If you plan to use any other libraries to complete this assignment then you should load them here.

```r
library(tidyverse)
```

## Questions
**1. (2 points) Briefly explain how R, RStudio, and GitHub work together to make work flows in data science transparent and repeatable. What is the advantage of using RMarkdown in this context?**  

R is an open source scripting language specialzed for computing and analyzing biological data. RStudio is what is called a “GUI”, or a “graphical user interface” designed to make interacting with the R environment more user-friendly. Github is a platform that allows programmers to share bits of their code, store it, and work together on projects.RMarkdown allows for you to save your work and push it to Github so that an earlier version can be worked on if code is lost. It also allows the user to save the file in different formats such as html, rmd, pdf, and can keep the original markdown source file for different purposes. 

**2. (2 points) What are the three types of `data structures` that we have discussed? Why are we using data frames for BIS 15L?**

So far we have gone over vectors, matrices and data frames. It's important to learn how to manipulate and extract information from data frames in order to efficiently analyze biological data sets. 

In the midterm 1 folder there is a second folder called `data`. Inside the `data` folder, there is a .csv file called `ElephantsMF`. These data are from Phyllis Lee, Stirling University, and are related to Lee, P., et al. (2013), "Enduring consequences of early experiences: 40-year effects on survival and success among African elephants (Loxodonta africana)," Biology Letters, 9: 20130011. [kaggle](https://www.kaggle.com/mostafaelseidy/elephantsmf).  

**3. (2 points) Please load these data as a new object called `elephants`. Use the function(s) of your choice to get an idea of the structure of the data. Be sure to show the class of each variable.**


```r
elephants <- readr::read_csv("data/ElephantsMF.csv")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   Age = col_double(),
##   Height = col_double(),
##   Sex = col_character()
## )
```

```r
dim(elephants)
```

```
## [1] 288   3
```

```r
summary(elephants)
```

```
##       Age            Height           Sex           
##  Min.   : 0.01   Min.   : 75.46   Length:288        
##  1st Qu.: 4.58   1st Qu.:160.75   Class :character  
##  Median : 9.46   Median :200.00   Mode  :character  
##  Mean   :10.97   Mean   :187.68                     
##  3rd Qu.:16.50   3rd Qu.:221.09                     
##  Max.   :32.17   Max.   :304.06
```

```r
glimpse(elephants)
```

```
## Rows: 288
## Columns: 3
## $ Age    <dbl> 1.40, 17.50, 12.75, 11.17, 12.67, 12.67, 12.25, 12.17, 28.17, …
## $ Height <dbl> 120.00, 227.00, 235.00, 210.00, 220.00, 189.00, 225.00, 204.00…
## $ Sex    <chr> "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M…
```

```r
names(elephants)
```

```
## [1] "Age"    "Height" "Sex"
```

```r
class(elephants)
```

```
## [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```


**4. (2 points) Change the names of the variables to lower case and change the class of the variable `sex` to a factor.**

```r
elephants <- janitor::clean_names(elephants)
names(elephants)
```

```
## [1] "age"    "height" "sex"
```


```r
elephants$sex <- as.factor(elephants$sex)
class(elephants$sex)
```

```
## [1] "factor"
```

**5. (2 points) How many male and female elephants are represented in the data?** There are 150 females and 138 males.

```r
nrow(elephants %>% 
       select(sex) %>% 
       filter(sex == "F"))
```

```
## [1] 150
```

```r
nrow(elephants %>% 
        select(sex) %>% 
        filter(sex == "M"))
```

```
## [1] 138
```

_Aside from a small typo, this is correct but consider using count._

```r
elephants %>% count(sex)
```

```
## # A tibble: 2 x 2
##   sex       n
## * <fct> <int>
## 1 F       150
## 2 M       138
```

**6. (2 points) What is the average age all elephants in the data?** Almost 11 years old. 

```r
mean(elephants$age)
```

```
## [1] 10.97132
```

**7. (2 points) How does the average age and height of elephants compare by sex?** On average, the females ar both older and taller. 


```r
elephants %>% 
  select(sex, height, age) %>% 
  filter(sex == "F") %>% 
  summarize(mean_age_F = mean(age),
            mean_height_F = mean(height),
            total = n())
```

```
## # A tibble: 1 x 3
##   mean_age_F mean_height_F total
##        <dbl>         <dbl> <int>
## 1       12.8          190.   150
```

```r
elephants %>% 
  select(sex, height, age) %>% 
  filter(sex == "M") %>% 
  summarize(mean_age_M = mean(age),
            mean_height_M = mean(height),
            total = n())
```

```
## # A tibble: 1 x 3
##   mean_age_M mean_height_M total
##        <dbl>         <dbl> <int>
## 1       8.95          185.   138
```

**8. (2 points) How does the average height of elephants compare by sex for individuals over 25 years old. Include the min and max height as well as the number of individuals in the sample as part of your analysis.**

```r
elephants %>% 
  select(sex, height, age) %>% 
  filter(sex == "M", age > "25") %>% 
  summarize(mean_age_M = mean(age),
            mean_height_M = mean(height),
            min_height_M = min(height),
            max_height_M = max(height),
            total = n())
```

```
## # A tibble: 1 x 5
##   mean_age_M mean_height_M min_height_M max_height_M total
##        <dbl>         <dbl>        <dbl>        <dbl> <int>
## 1       9.53          195.         136.         304.    63
```

```r
elephants %>% 
  select(sex, height, age) %>% 
  filter(sex == "F", age > "25") %>% 
  summarize(mean_age_F = mean(age),
            mean_height_F = mean(height),
            min_height_F = min(height),
            max_height_F = max(height),
            total = n())
```

```
## # A tibble: 1 x 5
##   mean_age_F mean_height_F min_height_F max_height_F total
##        <dbl>         <dbl>        <dbl>        <dbl> <int>
## 1       15.3          201.         123.         278.    63
```

For the next series of questions, we will use data from a study on vertebrate community composition and impacts from defaunation in [Gabon, Africa](https://en.wikipedia.org/wiki/Gabon). One thing to notice is that the data include 24 separate transects. Each transect represents a path through different forest management areas.  

Reference: Koerner SE, Poulsen JR, Blanchard EJ, Okouyi J, Clark CJ. Vertebrate community composition and diversity declines along a defaunation gradient radiating from rural villages in Gabon. _Journal of Applied Ecology_. 2016. This paper, along with a description of the variables is included inside the midterm 1 folder.  

**9. (2 points) Load `IvindoData_DryadVersion.csv` and use the function(s) of your choice to get an idea of the overall structure. Change the variables `HuntCat` and `LandUse` to factors.**

```r
gabon <- readr::read_csv("data/IvindoData_DryadVersion.csv")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_double(),
##   HuntCat = col_character(),
##   LandUse = col_character()
## )
## ℹ Use `spec()` for the full column specifications.
```

```r
gabon <- janitor::clean_names(gabon)
```


```r
names(gabon)
```

```
##  [1] "transect_id"              "distance"                
##  [3] "hunt_cat"                 "num_households"          
##  [5] "land_use"                 "veg_rich"                
##  [7] "veg_stems"                "veg_liana"               
##  [9] "veg_dbh"                  "veg_canopy"              
## [11] "veg_understory"           "ra_apes"                 
## [13] "ra_birds"                 "ra_elephant"             
## [15] "ra_monkeys"               "ra_rodent"               
## [17] "ra_ungulate"              "rich_all_species"        
## [19] "evenness_all_species"     "diversity_all_species"   
## [21] "rich_bird_species"        "evenness_bird_species"   
## [23] "diversity_bird_species"   "rich_mammal_species"     
## [25] "evenness_mammal_species"  "diversity_mammal_species"
```

```r
dim(gabon)
```

```
## [1] 24 26
```

```r
glimpse(gabon)
```

```
## Rows: 24
## Columns: 26
## $ transect_id              <dbl> 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15, 16…
## $ distance                 <dbl> 7.14, 17.31, 18.32, 20.85, 15.95, 17.47, 24.…
## $ hunt_cat                 <chr> "Moderate", "None", "None", "None", "None", …
## $ num_households           <dbl> 54, 54, 29, 29, 29, 29, 29, 54, 25, 73, 46, …
## $ land_use                 <chr> "Park", "Park", "Park", "Logging", "Park", "…
## $ veg_rich                 <dbl> 16.67, 15.75, 16.88, 12.44, 17.13, 16.50, 14…
## $ veg_stems                <dbl> 31.20, 37.44, 32.33, 29.39, 36.00, 29.22, 31…
## $ veg_liana                <dbl> 5.78, 13.25, 4.75, 9.78, 13.25, 12.88, 8.38,…
## $ veg_dbh                  <dbl> 49.57, 34.59, 42.82, 36.62, 41.52, 44.07, 51…
## $ veg_canopy               <dbl> 3.78, 3.75, 3.43, 3.75, 3.88, 2.50, 4.00, 4.…
## $ veg_understory           <dbl> 2.89, 3.88, 3.00, 2.75, 3.25, 3.00, 2.38, 2.…
## $ ra_apes                  <dbl> 1.87, 0.00, 4.49, 12.93, 0.00, 2.48, 3.78, 6…
## $ ra_birds                 <dbl> 52.66, 52.17, 37.44, 59.29, 52.62, 38.64, 42…
## $ ra_elephant              <dbl> 0.00, 0.86, 1.33, 0.56, 1.00, 0.00, 1.11, 0.…
## $ ra_monkeys               <dbl> 38.59, 28.53, 41.82, 19.85, 41.34, 43.29, 46…
## $ ra_rodent                <dbl> 4.22, 6.04, 1.06, 3.66, 2.52, 1.83, 3.10, 1.…
## $ ra_ungulate              <dbl> 2.66, 12.41, 13.86, 3.71, 2.53, 13.75, 3.10,…
## $ rich_all_species         <dbl> 22, 20, 22, 19, 20, 22, 23, 19, 19, 19, 21, …
## $ evenness_all_species     <dbl> 0.793, 0.773, 0.740, 0.681, 0.811, 0.786, 0.…
## $ diversity_all_species    <dbl> 2.452, 2.314, 2.288, 2.006, 2.431, 2.429, 2.…
## $ rich_bird_species        <dbl> 11, 10, 11, 8, 8, 10, 11, 11, 11, 9, 11, 11,…
## $ evenness_bird_species    <dbl> 0.732, 0.704, 0.688, 0.559, 0.799, 0.771, 0.…
## $ diversity_bird_species   <dbl> 1.756, 1.620, 1.649, 1.162, 1.660, 1.775, 1.…
## $ rich_mammal_species      <dbl> 11, 10, 11, 11, 12, 12, 12, 8, 8, 10, 10, 11…
## $ evenness_mammal_species  <dbl> 0.736, 0.705, 0.650, 0.619, 0.736, 0.694, 0.…
## $ diversity_mammal_species <dbl> 1.764, 1.624, 1.558, 1.484, 1.829, 1.725, 1.…
```


```r
gabon$hunt_cat <- as.factor(gabon$hunt_cat)
class(gabon$hunt_cat)
```

```
## [1] "factor"
```

```r
gabon$land_use <- as.factor(gabon$land_use)
class(gabon$land_use)
```

```
## [1] "factor"
```

**10. (4 points) For the transects with high and moderate hunting intensity, how does the average diversity of birds and mammals compare?**

```r
gabon %>% 
  select(transect_id, diversity_mammal_species, diversity_bird_species, hunt_cat) %>% 
  filter(hunt_cat == "High" | hunt_cat == "Moderate") %>% 
  group_by(hunt_cat) %>% 
  summarize(mean_mammal_diversity = mean(diversity_mammal_species),
            mean_bird_diversity = mean(diversity_bird_species),
            total = n())
```

```
## # A tibble: 2 x 4
##   hunt_cat mean_mammal_diversity mean_bird_diversity total
## * <fct>                    <dbl>               <dbl> <int>
## 1 High                      1.74                1.66     7
## 2 Moderate                  1.68                1.62     8
```
**11. (4 points) One of the conclusions in the study is that the relative abundance of animals drops off the closer you get to a village. Let's try to reconstruct this (without the statistics). How does the relative abundance (RA) of apes, birds, elephants, monkeys, rodents, and ungulates compare between sites that are less than 5km from a village to sites that are greater than 20km from a village? The variable `Distance` measures the distance of the transect from the nearest village. Hint: try using the `across` operator.**  

```r
gabon %>% 
  filter(distance < 5 | distance > 20) %>% 
  group_by(distance<5) %>% 
  summarize(across(c(ra_apes, ra_monkeys, ra_elephant, ra_rodent, ra_ungulate),mean))
```

```
## # A tibble: 2 x 6
##   `distance < 5` ra_apes ra_monkeys ra_elephant ra_rodent ra_ungulate
## * <lgl>            <dbl>      <dbl>       <dbl>     <dbl>       <dbl>
## 1 FALSE             7.21       40.1      0.557       2.68        4.98
## 2 TRUE              0.08       24.1      0.0967      3.66        1.59
```

```r
gabon %>%
  filter(distance <5 | distance > 20)%>%
  group_by(distance<5) %>% 
  summarise(across(contains("ra"), mean, na.rm=TRUE))
```

```
## # A tibble: 2 x 8
##   `distance < 5` transect_id ra_apes ra_birds ra_elephant ra_monkeys ra_rodent
## * <lgl>                <dbl>   <dbl>    <dbl>       <dbl>      <dbl>     <dbl>
## 1 FALSE                 11      7.21     44.5      0.557        40.1      2.68
## 2 TRUE                  19.7    0.08     70.4      0.0967       24.1      3.66
## # … with 1 more variable: ra_ungulate <dbl>
```

**12. (4 points) Based on your interest, do one exploratory analysis on the `gabon` data of your choice. This analysis needs to include a minimum of two functions in `dplyr.`** How does land use affect the relative abundance of birds? 

```r
gabon %>% 
  select(ra_birds, land_use) %>% 
  group_by(land_use) %>% 
  summarize(mean_ra_birds= mean(ra_birds), sd_ra_birds = sd(ra_birds), n=n())
```

```
## # A tibble: 3 x 4
##   land_use mean_ra_birds sd_ra_birds     n
## * <fct>            <dbl>       <dbl> <int>
## 1 Logging           62.7       12.3     13
## 2 Neither           71.0       11.3      4
## 3 Park              44.0        8.61     7
```
Without doing any statistical inference, it looks like parks have a lower abundance of birds than areas dedicated to logging or to nothing. 
