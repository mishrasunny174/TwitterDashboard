source("helperFunctions.R") #load helper functions file to load the checkAndLoad function

library(shiny)
library(wordcloud2)
library(dplyr)
library(tidyverse)
library(tidytext)
library(rjson)
library(tm)
library(textclean)
library(shinythemes)
library(httr)
library(rtweet)
library(DT)
library(syuzhet)
library(shinyalert)
library(caret)
library(e1071)
library(lattice)
library(NLP)
library(readr)
library(purrr)
library(stringr)
library(forcats)
library(tibble)

source("twitterBackend.r") #load twitter backend
source("knn.r") # load KNN stuff
source("svm.r") # load SVM stuff
source("mineSentimentTrainingData.r")