source("helperFunctions.R") #load helper functions file to load the checkAndLoad function

checkAndLoad('shiny')
checkAndLoad('wordcloud2')
checkAndLoad("dplyr")
checkAndLoad("tidyverse")
checkAndLoad("tidytext")
checkAndLoad("rjson")
checkAndLoad("tm")
checkAndLoad("textclean")
checkAndLoad("shinythemes")
checkAndLoad("httr")
checkAndLoad("rtweet")
checkAndLoad("DT")
checkAndLoad("syuzhet")
checkAndLoad("shinyalert")
checkAndLoad("caret")

source("twitterBackend.r") #load twitter backend
source("knn.r") # load KNN stuff
source("svm.r") # load SVM stuff
source("mineSentimentTrainingData.r")