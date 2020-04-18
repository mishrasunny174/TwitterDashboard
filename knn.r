knnCNCacheFile <- "./cache/knnCNCacheFile"

getKNNTrainedSentimentAnalysisModel <- function(){
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p=0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s~., trainDf, method="knn")
  return(fit)
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
