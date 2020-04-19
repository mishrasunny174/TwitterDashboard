source("dependencies.r") # load dependencies

source("ui.R") #load ui object
source("server.R") #load server function

shinyApp(ui = ui, server = server)
