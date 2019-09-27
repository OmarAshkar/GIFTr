
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GIFTr

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/omarelashkar/GIFTr.svg?branch=master)](https://travis-ci.org/omarelashkar/GIFTr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/omarelashkar/GIFTr?branch=master&svg=true)](https://ci.appveyor.com/project/omarelashkar/GIFTr)
<!-- badges: end -->

GIFTr package in intended to help course creators to upload questions to
MOODLE and other LMS for quizzes. GIFTr takes dataframe or tibble of
questions of four types: mcq, numerical questions, true or false and
short answer,and export it a text file formatted in MOODLe GIFT format.
You can prepare a spreadsheet in any software and import it in R and
generate any number of questions with HTML, markdown and LATEX support.

## Installation

from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("omarelashkar/GIFTr" , build_vignettes = TRUE)
```

## Example

``` r
library(GIFTr)
# load GIFTrData
data("GIFTrData")

# See the structure of the data
head(GIFTrData , 2)
#>   categories names                                          question
#> 1  Ques/hist    Q1                 Who's buried in **Grant's tomb**?
#> 2  Ques/hist    Q2 What two people are entombed in **Grant's tomb?**
#>        A
#> 1 *Grant
#> 2 No one
#>                                                                                   B
#> 1 no one#Was true for 12 years, but Grant's remains were buried in the tomb in 1897
#> 2                                                                            *Grant
#>                                  C                                  D
#> 1 Napoleon#He was buried in France Churchill#He was buried in England
#> 2                    *Grant's wife                     Grant's father
#>                                       E question_type
#> 1 Mother Teresa#She was buried in India           mcq
#> 2                                  <NA>           mcq
str(GIFTrData)
#> 'data.frame':    11 obs. of  9 variables:
#>  $ categories   : chr  "Ques/hist" "Ques/hist" "Ques/hist" "Ques/science" ...
#>  $ names        : chr  "Q1" "Q2" "Q3" "Q4" ...
#>  $ question     : chr  "Who's buried in **Grant's tomb**?" "What two people are entombed in **Grant's tomb?**" "Grant was buried in a tomb in New York City" "The sun rises in the West." ...
#>  $ A            : chr  "*Grant" "No one" "T" "F" ...
#>  $ B            : chr  "no one#Was true for 12 years, but Grant's remains were buried in the tomb in 1897" "*Grant" NA NA ...
#>  $ C            : chr  "Napoleon#He was buried in France" "*Grant's wife" NA NA ...
#>  $ D            : chr  "Churchill#He was buried in England" "Grant's father" NA NA ...
#>  $ E            : chr  "Mother Teresa#She was buried in India" NA NA NA ...
#>  $ question_type: chr  "mcq" "mcq" "tf_q" "tf_q" ...

#Create quiz.txt file with GIFT format 
GIFTr::GIFTr(data = GIFTrData, questions = 3, answers = c(4:8), 
             categories = 1, question_type = 9, output = 'quiz.txt')
#> Total Number of Questions passed:  11              
#>                mcq num_q short_ans tf_q Sum
#>   Ques/hist      2     2         1    1   6
#>   Ques/math      0     3         1    0   4
#>   Ques/science   0     0         0    1   1
#>   Sum            2     5         2    2  11
#> 
#> ==== 
#> ==== 
#> ==== 
#> ====
#> MCQ questions Input Count =2
#> MCQ with Multiple Answers = 1
#>  MCQ with single answers = 1
#>  Invalid questions = 0
#>  Invaild Answers = 0
#>  Total MCQ Failed = 0
#> 
#> ==== 
#> ==== 
#> ==== 
#> Done MCQ! 
#> ===
#> total questions passed is 5. 
#> single answer: 4 
#> two answer: 1 
#> error in 0 
#> 0 no question has been found 
#> 0 no valid answer has been found
#> ==== 
#> ==== 
#> ==== 
#> Done Numerical questions! 
#> ====
#> total questions passed is 2. 
#> Valid answer: 2 
#> error in 0 
#> 0 no question has been found 
#> 0 no valid answer has been found
#> ==== 
#> ==== 
#> ==== 
#> Done Short Answer questions! 
#> ====
#> T/F questions passed input: 2 
#> T/F questions Passed: 2 
#> Error found: 0 
#> No question found : 0 
#> No valid answer found: 0
#> 
#> ==== 
#> ==== 
#> ==== 
#> Done T/F questions!
#>  
#> ====
```

The generated file can be imported easily by MOODLE or any other LMS
that supports GIFT.

For further documenation instructions, check the package vingette and
documentation.

``` r
#open vingette
vignette("GIFTr_tutorial")
```
