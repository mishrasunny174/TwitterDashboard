knnCNCacheFile <- "./cache/knnCNCacheFile.rdata"
knnModelCacheFile <- "./cache/knnModelCacheFile.rdata"

getKNNTrainedSentimentAnalysisModel <- function(useCache = TRUE){
  if(file.exists(knnModelCacheFile) && useCache){
    load(knnModelCacheFile)
    return(fit)
  }
  df <- getTrainingData()
  fit <- train(s~., df, method="knn")
  save(fit, file = knnModelCacheFile)
  return(fit)
}

knnPredict <- function(text) {
  text <- cleanText(text)
  corpus <- VCorpus(VectorSource(c(text)))
  tdm <- DocumentTermMatrix(corpus, control = list(dictionary = getDictionary()))
  test <- as.matrix(tdm)
  predictions <- predict(getKNNTrainedSentimentAnalysisModel(useCache = TRUE), newdata=test)
  return(predictions)
}

getKNNConfusionMatrix <- function(useCache = TRUE) {
  if(file.exists(knnCNCacheFile) && !useCache) {
    file.remove(knnCNCacheFile)
  }
  if(file.exists(knnCNCacheFile) && useCache) {
    load(knnCNCacheFile)
    return(cm)
  }
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p=0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  set.seed(1337)
  fit <- train(s~., trainDf, method="knn")
  predictions <- predict(fit, testDf)
  cm <- confusionMatrix(predictions, testDf$s)
  save(cm, file = knnCNCacheFile)
  return(cm)
}
