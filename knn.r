knnCNCacheFile <- "./cache/knnCNCacheFile"

getKNNTrainedSentimentAnalysisModel <- function(size=100){
  df <- getTrainingData()
  trainDataIndex <- createDataPartition(df$s, p=0.6, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  fit <- train(s~., trainDf, method="knn")
  return(fit)
}

getKNNConfusionMatrix <- function(size = 100, useCache = TRUE, p = 0.5) {
  if(file.exists(knnCNCacheFile) && !useCache) {
    file.remove(knnCNCacheFile)
  }
  if(file.exists(knnCNCacheFile) && useCache) {
    load(knnCNCacheFile)
    return(cm)
  }
  df <- getTrainingData(size = size)
  trainDataIndex <- createDataPartition(df$s, p=p, list = FALSE)
  trainDf <- df[trainDataIndex, ]
  testDf <- df[-trainDataIndex, ]
  set.seed(1337)
  fit <- train(s~., trainDf, method="knn")
  predictions <- predict(fit, testDf)
  cm <- confusionMatrix(predictions, testDf$s)
  save(cm, file = knnCNCacheFile)
  return(cm)
}
