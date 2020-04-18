svmCMCacheFile <- "./cache/svmCMCached.rdata"

getSVNTrainedSentimentAnalysisModel <- function(){
    df <- getTrainingData()
    trainDataIndex <- createDataPartition(df$s, p=0.6, list = FALSE)
    trainDf <- df[trainDataIndex, ]
    testDf <- df[-trainDataIndex, ]
    fit <- train(s~., trainDf, method="svmLinear3")
    return(fit)
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
