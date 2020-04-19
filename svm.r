svmCMCacheFile <- "./cache/svmCMCached.rdata"
svmModelCacheFile <- "./cache/svmModelCached.rdata"

getSVMTrainedSentimentAnalysisModel <- function(useCache = TRUE){
    if(file.exists(svmModelCacheFile) && useCache) {
      load(svmModelCacheFile)
      return(fit)
    }
    df <- getTrainingData()
    fit <- train(s~., df, method="svmLinear3")
    save(fit, file=svmModelCacheFile)
    return(fit)
}

svmPredict <- function(text) {
  text <- cleanText(text)
  corpus <- VCorpus(VectorSource(c(text)))
  tdm <- DocumentTermMatrix(corpus, control = list(dictionary = getDictionary()))
  test <- as.matrix(tdm)
  predictions <- predict(getSVMTrainedSentimentAnalysisModel(useCache = TRUE), newdata=test)
  return(predictions)
}

getSVMConfusionMatrix <- function(useCache = TRUE) {
  if(file.exists(svmCMCacheFile) && useCache) {
    load(svmCMCacheFile)
    return(cm)
  }
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p=0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s~., data = trainDf, method="svmLinear3")
  predictions <- predict(fit, testDf)
  cm <- confusionMatrix(predictions, testDf$s)
  save(cm, file = svmCMCacheFile)
  return(cm)
}
