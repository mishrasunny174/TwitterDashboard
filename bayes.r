bayesCMCacheFile <- "./cache/bayesCMCacheFile"

getBayesTrainedSentimentAnalysisModel <- function() {
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p = 0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s ~ ., trainDf, method = "nb")
  return(fit)
}

getBayesConfusionMatrix <- function(useCache = TRUE) {
  if (file.exists(bayesCMCacheFile) && !useCache) {
    file.remove(bayesCMCacheFile)
  }
  if (file.exists(bayesCMCacheFile) && useCache) {
    load(bayesCMCacheFile)
    return(cm)
  }
  df <- getTrainingData(useCache = useCache)
  trainDataIndex <- createDataPartition(df$s, p = 0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s ~ ., trainDf, method = "nb", trControl = trainControl(method = "cv", number = 10))
  predictions <- predict(fit, testDf)
  cm <- confusionMatrix(predictions, testDf$s)
  save(cm, file = bayesCNCacheFile)
  return(cm)
}
