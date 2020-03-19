source("helperFunctions.R") #load helper functions file to load the checkAndLoad function

checkAndLoad('shiny')
checkAndLoad('wordcloud2')
checkAndLoad("dplyr")
checkAndLoad("tidyverse")
checkAndLoad("tidytext")
checkAndLoad("rjson")
checkAndLoad("tm")
checkAndLoad("textclean")
checkAndLoad("httr")
checkAndLoad("rtweet")
checkAndLoad("DT")

source("twitterBackend.r")
source("ui.r") #load ui object
source("server.r") #load server function

shinyApp(ui = ui, server = server)
