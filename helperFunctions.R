#helper function to load a package and install it if it's not installed

checkAndLoad <- function(packageName) {
  if(!(packageName %in% rownames(installed.packages())))
    install.packages(packageName)
  library(packageName, character.only = TRUE)
}

getTweetsFreqDf <- function(df) {
  tweetsCorpus <- Corpus(VectorSource(df$cleanText))
  tweetsTDM <- TermDocumentMatrix(tweetsCorpus)
  tweetsMatrix <- as.matrix(tweetsTDM)
  tweetsMatrix <- sort(rowSums(tweetsMatrix), decreasing = TRUE)
  tweetsFreqDf <- data.frame(word = names(tweetsMatrix), freq = tweetsMatrix)
  tweetsFreqDf
}
