source("helperFunctions.R")

checkAndLoad('shiny')
checkAndLoad('wordcloud2')

source("ui.r")
source("server.r")

shinyApp(ui = ui, server = server)
