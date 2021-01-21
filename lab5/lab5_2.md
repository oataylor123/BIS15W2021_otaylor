---
title: "dplyr Superhero"
date: "2021-01-21"
output:
  html_document: 
    theme: spacelab
    toc: yes
    toc_float: yes
    keep_md: yes
---

## Breakout Rooms  
Please take 5-8 minutes to check over your answers to the HW in your group. If you are stuck, please remember that you can check the key in [Joel's repository](https://github.com/jmledford3115/BIS15LW2021_jledford).  

## Learning Goals  
*At the end of this exercise, you will be able to:*    
1. Develop your dplyr superpowers so you can easily and confidently manipulate dataframes.  
2. Learn helpful new functions that are part of the `janitor` package.  

## Instructions
For the second part of lab 5 today, we are going to spend time practicing the dplyr functions we have learned and add a few new ones. We will spend most of the time in our breakout rooms. Your lab 5 homework will be to knit and push this file to your repository.  

## Load the tidyverse

```r
library("tidyverse")
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.0.4     ✓ dplyr   1.0.2
## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.0
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

## Load the superhero data
These are data taken from comic books and assembled by fans. The include a good mix of categorical and continuous data.  Data taken from: https://www.kaggle.com/claudiodavi/superhero-set  

Check out the way I am loading these data. If I know there are NAs, I can take care of them at the beginning. But, we should do this very cautiously. At times it is better to keep the original columns and data intact.  

```r
superhero_info <- readr::read_csv("data/heroes_information.csv", na = c("", "-99", "-"))
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   name = col_character(),
##   Gender = col_character(),
##   `Eye color` = col_character(),
##   Race = col_character(),
##   `Hair color` = col_character(),
##   Height = col_double(),
##   Publisher = col_character(),
##   `Skin color` = col_character(),
##   Alignment = col_character(),
##   Weight = col_double()
## )
```

```r
superhero_powers <- readr::read_csv("data/super_hero_powers.csv", na = c("", "-99", "-"))
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   .default = col_logical(),
##   hero_names = col_character()
## )
## ℹ Use `spec()` for the full column specifications.
```

## Data tidy
1. Some of the names used in the `superhero_info` data are problematic so you should rename them here.  

```r
superhero_info <- rename(superhero_info, gender = "Gender", eye_color = "Eye color", race = "Race", hair_color = "Hair color", height = "Height", publisher = "Publisher", skin_color = "Skin color", alignment = "Alignment", weight = "Weight")
```

Yikes! `superhero_powers` has a lot of variables that are poorly named. We need some R superpowers...

```r
head(superhero_powers)
```

```
## # A tibble: 6 x 168
##   hero_names Agility `Accelerated He… `Lantern Power … `Dimensional Aw…
##   <chr>      <lgl>   <lgl>            <lgl>            <lgl>           
## 1 3-D Man    TRUE    FALSE            FALSE            FALSE           
## 2 A-Bomb     FALSE   TRUE             FALSE            FALSE           
## 3 Abe Sapien TRUE    TRUE             FALSE            FALSE           
## 4 Abin Sur   FALSE   FALSE            TRUE             FALSE           
## 5 Abominati… FALSE   TRUE             FALSE            FALSE           
## 6 Abraxas    FALSE   FALSE            FALSE            TRUE            
## # … with 163 more variables: `Cold Resistance` <lgl>, Durability <lgl>,
## #   Stealth <lgl>, `Energy Absorption` <lgl>, Flight <lgl>, `Danger
## #   Sense` <lgl>, `Underwater breathing` <lgl>, Marksmanship <lgl>, `Weapons
## #   Master` <lgl>, `Power Augmentation` <lgl>, `Animal Attributes` <lgl>,
## #   Longevity <lgl>, Intelligence <lgl>, `Super Strength` <lgl>,
## #   Cryokinesis <lgl>, Telepathy <lgl>, `Energy Armor` <lgl>, `Energy
## #   Blasts` <lgl>, Duplication <lgl>, `Size Changing` <lgl>, `Density
## #   Control` <lgl>, Stamina <lgl>, `Astral Travel` <lgl>, `Audio
## #   Control` <lgl>, Dexterity <lgl>, Omnitrix <lgl>, `Super Speed` <lgl>,
## #   Possession <lgl>, `Animal Oriented Powers` <lgl>, `Weapon-based
## #   Powers` <lgl>, Electrokinesis <lgl>, `Darkforce Manipulation` <lgl>, `Death
## #   Touch` <lgl>, Teleportation <lgl>, `Enhanced Senses` <lgl>,
## #   Telekinesis <lgl>, `Energy Beams` <lgl>, Magic <lgl>, Hyperkinesis <lgl>,
## #   Jump <lgl>, Clairvoyance <lgl>, `Dimensional Travel` <lgl>, `Power
## #   Sense` <lgl>, Shapeshifting <lgl>, `Peak Human Condition` <lgl>,
## #   Immortality <lgl>, Camouflage <lgl>, `Element Control` <lgl>,
## #   Phasing <lgl>, `Astral Projection` <lgl>, `Electrical Transport` <lgl>,
## #   `Fire Control` <lgl>, Projection <lgl>, Summoning <lgl>, `Enhanced
## #   Memory` <lgl>, Reflexes <lgl>, Invulnerability <lgl>, `Energy
## #   Constructs` <lgl>, `Force Fields` <lgl>, `Self-Sustenance` <lgl>,
## #   `Anti-Gravity` <lgl>, Empathy <lgl>, `Power Nullifier` <lgl>, `Radiation
## #   Control` <lgl>, `Psionic Powers` <lgl>, Elasticity <lgl>, `Substance
## #   Secretion` <lgl>, `Elemental Transmogrification` <lgl>,
## #   `Technopath/Cyberpath` <lgl>, `Photographic Reflexes` <lgl>, `Seismic
## #   Power` <lgl>, Animation <lgl>, Precognition <lgl>, `Mind Control` <lgl>,
## #   `Fire Resistance` <lgl>, `Power Absorption` <lgl>, `Enhanced
## #   Hearing` <lgl>, `Nova Force` <lgl>, Insanity <lgl>, Hypnokinesis <lgl>,
## #   `Animal Control` <lgl>, `Natural Armor` <lgl>, Intangibility <lgl>,
## #   `Enhanced Sight` <lgl>, `Molecular Manipulation` <lgl>, `Heat
## #   Generation` <lgl>, Adaptation <lgl>, Gliding <lgl>, `Power Suit` <lgl>,
## #   `Mind Blast` <lgl>, `Probability Manipulation` <lgl>, `Gravity
## #   Control` <lgl>, Regeneration <lgl>, `Light Control` <lgl>,
## #   Echolocation <lgl>, Levitation <lgl>, `Toxin and Disease Control` <lgl>,
## #   Banish <lgl>, `Energy Manipulation` <lgl>, `Heat Resistance` <lgl>, …
```

```r
class(names)
```

```
## [1] "function"
```

## `janitor`
The [janitor](https://garthtarr.github.io/meatR/janitor.html) package is your friend. Make sure to install it and then load the library.  

```r
library("janitor")
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

The `clean_names` function takes care of everything in one line! Now that's a superpower!

```r
superhero_powers <- janitor::clean_names(superhero_powers)
```

## `tabyl`
The `janitor` package has many awesome functions that we will explore. Here is its version of `table` which not only produces counts but also percentages. Very handy! Let's use it to explore the proportion of good guys and bad guys in the `superhero_info` data.  

```r
tabyl(superhero_info, alignment)
```

```
##  alignment   n     percent valid_percent
##        bad 207 0.282016349    0.28473177
##       good 496 0.675749319    0.68225585
##    neutral  24 0.032697548    0.03301238
##       <NA>   7 0.009536785            NA
```

2. Notice that we have some neutral superheros! Who are they?

```r
superhero_info %>%
  select(alignment, name) %>%
  filter(alignment == "neutral")
```

```
## # A tibble: 24 x 2
##    alignment name        
##    <chr>     <chr>       
##  1 neutral   Bizarro     
##  2 neutral   Black Flash 
##  3 neutral   Captain Cold
##  4 neutral   Copycat     
##  5 neutral   Deadpool    
##  6 neutral   Deathstroke 
##  7 neutral   Etrigan     
##  8 neutral   Galactus    
##  9 neutral   Gladiator   
## 10 neutral   Indigo      
## # … with 14 more rows
```

## `superhero_info`
3. Let's say we are only interested in the variables name, alignment, and "race". How would you isolate these variables from `superhero_info`?

```r
superhero_info_new <- select(superhero_info, "name", "race", "alignment")
superhero_info_new
```

```
## # A tibble: 734 x 3
##    name          race              alignment
##    <chr>         <chr>             <chr>    
##  1 A-Bomb        Human             good     
##  2 Abe Sapien    Icthyo Sapien     good     
##  3 Abin Sur      Ungaran           good     
##  4 Abomination   Human / Radiation bad      
##  5 Abraxas       Cosmic Entity     bad      
##  6 Absorbing Man Human             bad      
##  7 Adam Monroe   <NA>              good     
##  8 Adam Strange  Human             good     
##  9 Agent 13      <NA>              good     
## 10 Agent Bob     Human             good     
## # … with 724 more rows
```

## Not Human
4. List all of the superheros that are not human.

```r
superhero_info %>%
  select(name, race) %>%
  filter(race != "human")
```

```
## # A tibble: 430 x 2
##    name          race             
##    <chr>         <chr>            
##  1 A-Bomb        Human            
##  2 Abe Sapien    Icthyo Sapien    
##  3 Abin Sur      Ungaran          
##  4 Abomination   Human / Radiation
##  5 Abraxas       Cosmic Entity    
##  6 Absorbing Man Human            
##  7 Adam Strange  Human            
##  8 Agent Bob     Human            
##  9 Ajax          Cyborg           
## 10 Alex Mercer   Human            
## # … with 420 more rows
```

## Good and Evil
5. Let's make two different data frames, one focused on the "good guys" and another focused on the "bad guys".

```r
good_superheros <- superhero_info %>%
  select(alignment, name, race, height, hair_color) %>%
  filter(alignment == "good")
good_superheros
```

```
## # A tibble: 496 x 5
##    alignment name         race          height hair_color
##    <chr>     <chr>        <chr>          <dbl> <chr>     
##  1 good      A-Bomb       Human            203 No Hair   
##  2 good      Abe Sapien   Icthyo Sapien    191 No Hair   
##  3 good      Abin Sur     Ungaran          185 No Hair   
##  4 good      Adam Monroe  <NA>              NA Blond     
##  5 good      Adam Strange Human            185 Blond     
##  6 good      Agent 13     <NA>             173 Blond     
##  7 good      Agent Bob    Human            178 Brown     
##  8 good      Agent Zero   <NA>             191 <NA>      
##  9 good      Alan Scott   <NA>             180 Blond     
## 10 good      Alex Woolsly <NA>              NA <NA>      
## # … with 486 more rows
```

```r
bad_superheros <- superhero_info %>%
  select(name, alignment, race, height, gender, hair_color) %>%
  filter(alignment == "bad")
bad_superheros
```

```
## # A tibble: 207 x 6
##    name          alignment race              height gender hair_color
##    <chr>         <chr>     <chr>              <dbl> <chr>  <chr>     
##  1 Abomination   bad       Human / Radiation    203 Male   No Hair   
##  2 Abraxas       bad       Cosmic Entity         NA Male   Black     
##  3 Absorbing Man bad       Human                193 Male   No Hair   
##  4 Air-Walker    bad       <NA>                 188 Male   White     
##  5 Ajax          bad       Cyborg               193 Male   Black     
##  6 Alex Mercer   bad       Human                 NA Male   <NA>      
##  7 Alien         bad       Xenomorph XX121      244 Male   No Hair   
##  8 Amazo         bad       Android              257 Male   <NA>      
##  9 Ammo          bad       Human                188 Male   Black     
## 10 Angela        bad       <NA>                  NA Female <NA>      
## # … with 197 more rows
```


6. For the good guys, use the `tabyl` function to summarize their "race".

```r
tabyl(good_superheros, race)
```

```
##               race   n     percent valid_percent
##              Alien   3 0.006048387   0.010752688
##              Alpha   5 0.010080645   0.017921147
##             Amazon   2 0.004032258   0.007168459
##            Android   4 0.008064516   0.014336918
##             Animal   2 0.004032258   0.007168459
##          Asgardian   3 0.006048387   0.010752688
##          Atlantean   4 0.008064516   0.014336918
##         Bolovaxian   1 0.002016129   0.003584229
##              Clone   1 0.002016129   0.003584229
##             Cyborg   3 0.006048387   0.010752688
##           Demi-God   2 0.004032258   0.007168459
##              Demon   3 0.006048387   0.010752688
##            Eternal   1 0.002016129   0.003584229
##     Flora Colossus   1 0.002016129   0.003584229
##        Frost Giant   1 0.002016129   0.003584229
##      God / Eternal   6 0.012096774   0.021505376
##             Gungan   1 0.002016129   0.003584229
##              Human 148 0.298387097   0.530465950
##    Human / Altered   2 0.004032258   0.007168459
##     Human / Cosmic   2 0.004032258   0.007168459
##  Human / Radiation   8 0.016129032   0.028673835
##         Human-Kree   2 0.004032258   0.007168459
##      Human-Spartoi   1 0.002016129   0.003584229
##       Human-Vulcan   1 0.002016129   0.003584229
##    Human-Vuldarian   1 0.002016129   0.003584229
##      Icthyo Sapien   1 0.002016129   0.003584229
##            Inhuman   4 0.008064516   0.014336918
##    Kakarantharaian   1 0.002016129   0.003584229
##         Kryptonian   4 0.008064516   0.014336918
##            Martian   1 0.002016129   0.003584229
##          Metahuman   1 0.002016129   0.003584229
##             Mutant  46 0.092741935   0.164874552
##     Mutant / Clone   1 0.002016129   0.003584229
##             Planet   1 0.002016129   0.003584229
##             Saiyan   1 0.002016129   0.003584229
##           Symbiote   3 0.006048387   0.010752688
##           Talokite   1 0.002016129   0.003584229
##         Tamaranean   1 0.002016129   0.003584229
##            Ungaran   1 0.002016129   0.003584229
##            Vampire   2 0.004032258   0.007168459
##     Yoda's species   1 0.002016129   0.003584229
##      Zen-Whoberian   1 0.002016129   0.003584229
##               <NA> 217 0.437500000            NA
```

7. Among the good guys, Who are the Asgardians?

```r
good_superheros %>%
  select(race, name) %>%
  filter(race == "Asgardian")
```

```
## # A tibble: 3 x 2
##   race      name     
##   <chr>     <chr>    
## 1 Asgardian Sif      
## 2 Asgardian Thor     
## 3 Asgardian Thor Girl
```

8. Among the bad guys, who are the male humans over 200 inches in height?

```r
bad_superheros %>%
  select(name, height, gender, race) %>%
  filter(race == "human" | height >= "200" | gender == "male")
```

```
## # A tibble: 28 x 4
##    name         height gender race             
##    <chr>         <dbl> <chr>  <chr>            
##  1 Abomination   203   Male   Human / Radiation
##  2 Alien         244   Male   Xenomorph XX121  
##  3 Amazo         257   Male   Android          
##  4 Anti-Monitor   61   Male   God / Eternal    
##  5 Apocalypse    213   Male   Mutant           
##  6 Bane          203   Male   Human            
##  7 Bloodaxe      218   Female Human            
##  8 Bloodwraith    30.5 Male   <NA>             
##  9 Darkseid      267   Male   New God          
## 10 Doctor Doom   201   Male   Human            
## # … with 18 more rows
```

9. OK, so are there more good guys or bad guys that are bald (personal interest)? There are more bald superheros! (but only 2 more...)

```r
nrow(bad_superheros %>%
  select(hair_color, name) %>%
  filter(hair_color == "No Hair"))
```

```
## [1] 35
```

```r
nrow(good_superheros %>%
       select(hair_color, name) %>%
       filter(hair_color == "No Hair"))
```

```
## [1] 37
```

10. Let's explore who the really "big" superheros are. In the `superhero_info` data, which have a height over 200 or weight over 300?

```r
superhero_info %>%
  select(height, weight, name) %>%
  filter(height >= "300" | weight >= "450")
```

```
## # A tibble: 350 x 3
##    height weight name             
##     <dbl>  <dbl> <chr>            
##  1    191     65 Abe Sapien       
##  2    185     90 Abin Sur         
##  3    185     88 Adam Strange     
##  4    173     61 Agent 13         
##  5    178     81 Agent Bob        
##  6    193     90 Ajax             
##  7    180     90 Alan Scott       
##  8    178     72 Alfred Pennyworth
##  9    183     68 Angel            
## 10    165     57 Angel Dust       
## # … with 340 more rows
```

11. Just to be clear on the `|` operator,  have a look at the superheros over 300 in height...

```r
superhero_info %>%
  select(name, height) %>%
  filter(height >= "300")
```

```
## # A tibble: 14 x 2
##    name            height
##    <chr>            <dbl>
##  1 Anti-Monitor      61  
##  2 Fin Fang Foom    975  
##  3 Galactus         876  
##  4 Giganta           62.5
##  5 Groot            701  
##  6 Howard the Duck   79  
##  7 Jack-Jack         71  
##  8 Krypto            64  
##  9 MODOK            366  
## 10 Onslaught        305  
## 11 Sasquatch        305  
## 12 Wolfsbane        366  
## 13 Ymir             305. 
## 14 Yoda              66
```

12. ...and the superheros over 450 in weight. Bonus question! Why do we not have 16 rows in question #10? Because some superheros have either a weight over 450 or a height over 300. 

```r
superhero_info %>%
  select(name, weight) %>%
  filter(weight >= "450")
```

```
## # A tibble: 339 x 2
##    name              weight
##    <chr>              <dbl>
##  1 Abe Sapien            65
##  2 Abin Sur              90
##  3 Adam Strange          88
##  4 Agent 13              61
##  5 Agent Bob             81
##  6 Ajax                  90
##  7 Alan Scott            90
##  8 Alfred Pennyworth     72
##  9 Angel                 68
## 10 Angel Dust            57
## # … with 329 more rows
```

## Height to Weight Ratio
13. It's easy to be strong when you are heavy and tall, but who is heavy and short? Which superheros have the highest height to weight ratio?

```r
superhero_info %>%
  mutate(height_weight_ratio=height/weight) %>%
  select(name, height_weight_ratio) %>%
  arrange(desc(height_weight_ratio))
```

```
## # A tibble: 734 x 2
##    name            height_weight_ratio
##    <chr>                         <dbl>
##  1 Groot                        175.  
##  2 Galactus                      54.8 
##  3 Fin Fang Foom                 54.2 
##  4 Longshot                       5.22
##  5 Jack-Jack                      5.07
##  6 Rocket Raccoon                 4.88
##  7 Dash                           4.52
##  8 Howard the Duck                4.39
##  9 Swarm                          4.17
## 10 Yoda                           3.88
## # … with 724 more rows
```


## `superhero_powers`
Have a quick look at the `superhero_powers` data frame.  

```r
glimpse(superhero_powers)
```

```
## Rows: 667
## Columns: 168
## $ hero_names                   <chr> "3-D Man", "A-Bomb", "Abe Sapien", "Abin…
## $ agility                      <lgl> TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ accelerated_healing          <lgl> FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, F…
## $ lantern_power_ring           <lgl> FALSE, FALSE, FALSE, TRUE, FALSE, FALSE,…
## $ dimensional_awareness        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ cold_resistance              <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ durability                   <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, …
## $ stealth                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ energy_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ flight                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ danger_sense                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ underwater_breathing         <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ marksmanship                 <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ weapons_master               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ power_augmentation           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ animal_attributes            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ longevity                    <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, …
## $ intelligence                 <lgl> FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, F…
## $ super_strength               <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRU…
## $ cryokinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ telepathy                    <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ energy_armor                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ energy_blasts                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ duplication                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ size_changing                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ density_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ stamina                      <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FA…
## $ astral_travel                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ audio_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ dexterity                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ omnitrix                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ super_speed                  <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, F…
## $ possession                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ animal_oriented_powers       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ weapon_based_powers          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ electrokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ darkforce_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ death_touch                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ teleportation                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ enhanced_senses              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ telekinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ energy_beams                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ magic                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ hyperkinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ jump                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ clairvoyance                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ dimensional_travel           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ power_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ shapeshifting                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ peak_human_condition         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ immortality                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, …
## $ camouflage                   <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE,…
## $ element_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ phasing                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ astral_projection            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ electrical_transport         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ fire_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ projection                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ summoning                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ enhanced_memory              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ reflexes                     <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ invulnerability              <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, …
## $ energy_constructs            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ force_fields                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ self_sustenance              <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE,…
## $ anti_gravity                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ empathy                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ power_nullifier              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ radiation_control            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ psionic_powers               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ elasticity                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ substance_secretion          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ elemental_transmogrification <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ technopath_cyberpath         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ photographic_reflexes        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ seismic_power                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ animation                    <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,…
## $ precognition                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ mind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ fire_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ power_absorption             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ enhanced_hearing             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ nova_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ insanity                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ hypnokinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ animal_control               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ natural_armor                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ intangibility                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ enhanced_sight               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ molecular_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ heat_generation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ adaptation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ gliding                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ power_suit                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ mind_blast                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ probability_manipulation     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ gravity_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ regeneration                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ light_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ echolocation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ levitation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ toxin_and_disease_control    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ banish                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ energy_manipulation          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ heat_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ natural_weapons              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ time_travel                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ enhanced_smell               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ illusions                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ thirstokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ hair_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ illumination                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ omnipotent                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ cloaking                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ changing_armor               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ power_cosmic                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,…
## $ biokinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ water_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ radiation_immunity           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_telescopic            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ toxin_and_disease_resistance <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ spatial_awareness            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ energy_resistance            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ telepathy_resistance         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ molecular_combustion         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ omnilingualism               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ portal_creation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ magnetism                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ mind_control_resistance      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ plant_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ sonar                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ sonic_scream                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ time_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ enhanced_touch               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ magic_resistance             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ invisibility                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ sub_mariner                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ radiation_absorption         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ intuitive_aptitude           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_microscopic           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ melting                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ wind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ super_breath                 <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,…
## $ wallcrawling                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_night                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_infrared              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ grim_reaping                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ matter_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ the_force                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ resurrection                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ terrakinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_heat                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vitakinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ radar_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ qwardian_power_ring          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ weather_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_x_ray                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_thermal               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ web_creation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ reality_warping              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ odin_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ symbiote_costume             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ speed_force                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ phoenix_force                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ molecular_dissipation        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ vision_cryo                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ omnipresent                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
## $ omniscient                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
```

14. How many superheros have a combination of accelerated healing, durability, and super strength?

```r
superhero_powers %>%
  filter(accelerated_healing == "TRUE" & durability == "TRUE" & super_strength == "TRUE")
```

```
## # A tibble: 97 x 168
##    hero_names agility accelerated_hea… lantern_power_r… dimensional_awa…
##    <chr>      <lgl>   <lgl>            <lgl>            <lgl>           
##  1 A-Bomb     FALSE   TRUE             FALSE            FALSE           
##  2 Abe Sapien TRUE    TRUE             FALSE            FALSE           
##  3 Angel      TRUE    TRUE             FALSE            FALSE           
##  4 Anti-Moni… FALSE   TRUE             FALSE            TRUE            
##  5 Anti-Venom FALSE   TRUE             FALSE            FALSE           
##  6 Aquaman    TRUE    TRUE             FALSE            FALSE           
##  7 Arachne    TRUE    TRUE             FALSE            FALSE           
##  8 Archangel  TRUE    TRUE             FALSE            FALSE           
##  9 Ardina     TRUE    TRUE             FALSE            FALSE           
## 10 Ares       TRUE    TRUE             FALSE            FALSE           
## # … with 87 more rows, and 163 more variables: cold_resistance <lgl>,
## #   durability <lgl>, stealth <lgl>, energy_absorption <lgl>, flight <lgl>,
## #   danger_sense <lgl>, underwater_breathing <lgl>, marksmanship <lgl>,
## #   weapons_master <lgl>, power_augmentation <lgl>, animal_attributes <lgl>,
## #   longevity <lgl>, intelligence <lgl>, super_strength <lgl>,
## #   cryokinesis <lgl>, telepathy <lgl>, energy_armor <lgl>,
## #   energy_blasts <lgl>, duplication <lgl>, size_changing <lgl>,
## #   density_control <lgl>, stamina <lgl>, astral_travel <lgl>,
## #   audio_control <lgl>, dexterity <lgl>, omnitrix <lgl>, super_speed <lgl>,
## #   possession <lgl>, animal_oriented_powers <lgl>, weapon_based_powers <lgl>,
## #   electrokinesis <lgl>, darkforce_manipulation <lgl>, death_touch <lgl>,
## #   teleportation <lgl>, enhanced_senses <lgl>, telekinesis <lgl>,
## #   energy_beams <lgl>, magic <lgl>, hyperkinesis <lgl>, jump <lgl>,
## #   clairvoyance <lgl>, dimensional_travel <lgl>, power_sense <lgl>,
## #   shapeshifting <lgl>, peak_human_condition <lgl>, immortality <lgl>,
## #   camouflage <lgl>, element_control <lgl>, phasing <lgl>,
## #   astral_projection <lgl>, electrical_transport <lgl>, fire_control <lgl>,
## #   projection <lgl>, summoning <lgl>, enhanced_memory <lgl>, reflexes <lgl>,
## #   invulnerability <lgl>, energy_constructs <lgl>, force_fields <lgl>,
## #   self_sustenance <lgl>, anti_gravity <lgl>, empathy <lgl>,
## #   power_nullifier <lgl>, radiation_control <lgl>, psionic_powers <lgl>,
## #   elasticity <lgl>, substance_secretion <lgl>,
## #   elemental_transmogrification <lgl>, technopath_cyberpath <lgl>,
## #   photographic_reflexes <lgl>, seismic_power <lgl>, animation <lgl>,
## #   precognition <lgl>, mind_control <lgl>, fire_resistance <lgl>,
## #   power_absorption <lgl>, enhanced_hearing <lgl>, nova_force <lgl>,
## #   insanity <lgl>, hypnokinesis <lgl>, animal_control <lgl>,
## #   natural_armor <lgl>, intangibility <lgl>, enhanced_sight <lgl>,
## #   molecular_manipulation <lgl>, heat_generation <lgl>, adaptation <lgl>,
## #   gliding <lgl>, power_suit <lgl>, mind_blast <lgl>,
## #   probability_manipulation <lgl>, gravity_control <lgl>, regeneration <lgl>,
## #   light_control <lgl>, echolocation <lgl>, levitation <lgl>,
## #   toxin_and_disease_control <lgl>, banish <lgl>, energy_manipulation <lgl>,
## #   heat_resistance <lgl>, …
```

```r
view(superhero_powers)
```

## `kinesis`
15. We are only interested in the superheros that do some kind of "kinesis". How would we isolate them from the `superhero_powers` data? There are 9 types of kinesis. 


```r
superhero_powers %>%
  select(hero_names, ends_with("kinesis")) %>%
  filter_all(any_vars(.==TRUE))
```

```
## # A tibble: 112 x 10
##    hero_names cryokinesis electrokinesis telekinesis hyperkinesis hypnokinesis
##    <chr>      <lgl>       <lgl>          <lgl>       <lgl>        <lgl>       
##  1 Alan Scott FALSE       FALSE          FALSE       FALSE        TRUE        
##  2 Amazo      TRUE        FALSE          FALSE       FALSE        FALSE       
##  3 Apocalypse FALSE       FALSE          TRUE        FALSE        FALSE       
##  4 Aqualad    TRUE        FALSE          FALSE       FALSE        FALSE       
##  5 Beyonder   FALSE       FALSE          TRUE        FALSE        FALSE       
##  6 Bizarro    TRUE        FALSE          FALSE       FALSE        TRUE        
##  7 Black Abb… FALSE       FALSE          TRUE        FALSE        FALSE       
##  8 Black Adam FALSE       FALSE          TRUE        FALSE        FALSE       
##  9 Black Lig… FALSE       TRUE           FALSE       FALSE        FALSE       
## 10 Black Mam… FALSE       FALSE          FALSE       FALSE        TRUE        
## # … with 102 more rows, and 4 more variables: thirstokinesis <lgl>,
## #   biokinesis <lgl>, terrakinesis <lgl>, vitakinesis <lgl>
```

16. Pick your favorite superhero and let's see their powers!

```r
superhero_powers %>%
  filter(hero_names == "Wonder Woman")
```

```
## # A tibble: 1 x 168
##   hero_names agility accelerated_hea… lantern_power_r… dimensional_awa…
##   <chr>      <lgl>   <lgl>            <lgl>            <lgl>           
## 1 Wonder Wo… FALSE   TRUE             FALSE            FALSE           
## # … with 163 more variables: cold_resistance <lgl>, durability <lgl>,
## #   stealth <lgl>, energy_absorption <lgl>, flight <lgl>, danger_sense <lgl>,
## #   underwater_breathing <lgl>, marksmanship <lgl>, weapons_master <lgl>,
## #   power_augmentation <lgl>, animal_attributes <lgl>, longevity <lgl>,
## #   intelligence <lgl>, super_strength <lgl>, cryokinesis <lgl>,
## #   telepathy <lgl>, energy_armor <lgl>, energy_blasts <lgl>,
## #   duplication <lgl>, size_changing <lgl>, density_control <lgl>,
## #   stamina <lgl>, astral_travel <lgl>, audio_control <lgl>, dexterity <lgl>,
## #   omnitrix <lgl>, super_speed <lgl>, possession <lgl>,
## #   animal_oriented_powers <lgl>, weapon_based_powers <lgl>,
## #   electrokinesis <lgl>, darkforce_manipulation <lgl>, death_touch <lgl>,
## #   teleportation <lgl>, enhanced_senses <lgl>, telekinesis <lgl>,
## #   energy_beams <lgl>, magic <lgl>, hyperkinesis <lgl>, jump <lgl>,
## #   clairvoyance <lgl>, dimensional_travel <lgl>, power_sense <lgl>,
## #   shapeshifting <lgl>, peak_human_condition <lgl>, immortality <lgl>,
## #   camouflage <lgl>, element_control <lgl>, phasing <lgl>,
## #   astral_projection <lgl>, electrical_transport <lgl>, fire_control <lgl>,
## #   projection <lgl>, summoning <lgl>, enhanced_memory <lgl>, reflexes <lgl>,
## #   invulnerability <lgl>, energy_constructs <lgl>, force_fields <lgl>,
## #   self_sustenance <lgl>, anti_gravity <lgl>, empathy <lgl>,
## #   power_nullifier <lgl>, radiation_control <lgl>, psionic_powers <lgl>,
## #   elasticity <lgl>, substance_secretion <lgl>,
## #   elemental_transmogrification <lgl>, technopath_cyberpath <lgl>,
## #   photographic_reflexes <lgl>, seismic_power <lgl>, animation <lgl>,
## #   precognition <lgl>, mind_control <lgl>, fire_resistance <lgl>,
## #   power_absorption <lgl>, enhanced_hearing <lgl>, nova_force <lgl>,
## #   insanity <lgl>, hypnokinesis <lgl>, animal_control <lgl>,
## #   natural_armor <lgl>, intangibility <lgl>, enhanced_sight <lgl>,
## #   molecular_manipulation <lgl>, heat_generation <lgl>, adaptation <lgl>,
## #   gliding <lgl>, power_suit <lgl>, mind_blast <lgl>,
## #   probability_manipulation <lgl>, gravity_control <lgl>, regeneration <lgl>,
## #   light_control <lgl>, echolocation <lgl>, levitation <lgl>,
## #   toxin_and_disease_control <lgl>, banish <lgl>, energy_manipulation <lgl>,
## #   heat_resistance <lgl>, …
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
