getDictionary <- function() {
  posWordsFile <- "./data/pswords.txt"
  negWordsFile <- "./data/ngwords.txt"
  posWords <- readLines(posWordsFile)
  negWords <- readLines(negWordsFile)
  return(c(posWords, negWords))
}

getMovieSentimentDf <- function() {
  posBase = "./data/txt_sentoken/pos/"
  negBase = "./data/txt_sentoken/neg/"
  posFiles = dir(posBase)
  negFiles = dir(negBase)
  
  posReviewsVector = vector("character")
  negReviewsVector = vector("character")
  
  for (pFile in posFiles) {
    posReviewsVector = c(posReviewsVector, read_file(paste(posBase, pFile, sep = "")))
  }
  
  for(nFile in negFiles) {
    negReviewsVector = c(negReviewsVector, read_file(paste(negBase, nFile, sep = "")))
  }
  # posReviewsVector = sample(posReviewsVector, size = size, replace = FALSE)
  # negReviewsVector = sample(negReviewsVector, size = size, replace = FALSE)
  positiveDf <- data.frame(text = posReviewsVector, sentiment = c("pos"))
  negativeDf <- data.frame(text = negReviewsVector, sentiment = c("neg"))
  reviewDf <- rbind(positiveDf, negativeDf)
  return(reviewDf)
}  

getCleanMovieSentimentDf <- function () {
  cleanReviewsFilename <- paste("./data/cleanReviews",".csv", sep="")
  if(file.exists(cleanReviewsFilename)){
    df <- read.csv(cleanReviewsFilename)
    return(data.frame(text=df$text, sentiment=df$sentiment)) 
  }
  uncleanDf <- getMovieSentimentDf()
  uncleanDf$cleanText <- gsub("(ftp|http(s)*)://.*", " ", uncleanDf$text) # remove urls if there any in the dataset
  uncleanDf$cleanText <- removePunctuation(uncleanDf$cleanText) # remove puntuations
  uncleanDf$cleanText <- replace_internet_slang(uncleanDf$cleanText) # remove internet slang
  uncleanDf$cleanText <- replace_emoji(uncleanDf$cleanText) # replace emoji with their equivalent words
  uncleanDf$cleanText <- replace_contraction(uncleanDf$cleanText)
  uncleanDf$cleanText <- removeWords(uncleanDf$cleanText, stopwords())
  uncleanDf$cleanText <- gsub(pattern="\\d", replace=" ", uncleanDf$cleanText) # remove all the numbers
  uncleanDf$cleanText <- gsub("[[:punct:]]", " ", uncleanDf$cleanText) # remove all the special characters
  uncleanDf$cleanText <- gsub(pattern="\\b[a-z]\\b{1}", "", uncleanDf$cleanText) # remove all single chars
  uncleanDf$cleanText <- stripWhitespace(uncleanDf$cleanText) # remove whitespaces
  uncleanDf$cleanText <- tolower(uncleanDf$cleanText)
  cleanDf <- data.frame(text=uncleanDf$cleanText, sentiment=uncleanDf$sentiment)
  write.csv(cleanDf, file=cleanReviewsFilename)
  return(cleanDf)
}

cleanText <- function(text) {
  cleanText <- gsub("(ftp|http(s)*)://.*", " ", text) # remove urls if there any in the dataset
  cleanText <- removePunctuation(cleanText) # remove puntuations
  cleanText <- replace_internet_slang(cleanText) # remove internet slang
  cleanText <- replace_emoji(cleanText) # replace emoji with their equivalent words
  cleanText <- replace_contraction(cleanText)
  cleanText <- removeWords(cleanText, stopwords())
  cleanText <- gsub(pattern="\\d", replace=" ", cleanText) # remove all the numbers
  cleanText <- gsub("[[:punct:]]", " ", cleanText) # remove all the special characters
  cleanText <- gsub(pattern="\\b[a-z]\\b{1}", "", cleanText) # remove all single chars
  cleanText <- stripWhitespace(cleanText) # remove whitespaces
  cleanText <- tolower(cleanText)
  return(cleanText)
}

getTrainingData <- function() {
  df <- getCleanMovieSentimentDf()
  df <- data.frame(text = df$text, s = df$sentiment)
  textCorpus = VCorpus(VectorSource(df$text))
  tdm <- DocumentTermMatrix(textCorpus, control = list(dictionary = getDictionary()))
  trainingMatrix <- as.matrix(tdm)
  trainingDf <- as.data.frame(trainingMatrix)
  trainingDf$s <- df$s
  trainingDf$s <- as.factor(trainingDf$s)
  return(trainingDf)
}

