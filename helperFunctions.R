checkAndLoad <- function(packageName) {
  if(!(packageName %in% rownames(installed.packages())))
    install.packages(packageName)
  library(packageName, character.only = TRUE)
}

