bayesCMCacheFile <- "./cache/bayesCMCacheFile.rdata"
bayesModelCacheFile <- "./cache/bayesModelCacheFile.rdata"

getBayesTrainedSentimentAnalysisModel <- function(useCache = TRUE) {
  if(useCache && file.exists(bayesModelCacheFile)) {
    load(bayesModelCacheFile)
    return(fit)
  }
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p = 0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s ~ ., trainDf, method = "nb")
  save(fit, file = bayesModelCacheFile)
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
  fit <- train(s ~ ., trainDf, method = "nb")
  predictions <- predict(fit, testDf)
  cm <- confusionMatrix(predictions, testDf$s)
  save(cm, file = bayesCNCacheFile)
  return(cm)
}
