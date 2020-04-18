compareSVMKNN <- function() {
  comparisonCacheFile <- "./cache/comparisonCache.rdata"
  if(file.exists(comparisonCacheFile)) {
    load(comparisonCacheFile)
    ret(comparisonDf)
  }
  accuracyVectSVM <- vector("numeric")
  accuracyVectKNN <- vector("numeric")
  n <- c(20, 40, 60, 80, 100)
  for(i in n) {
    svmCM <- getSVMConfusionMatrix(size = i)
    knnCM <- getKNNConfusionMatrix(size = i)
    accuracyVectKNN <- c(accuracyVectKNN, knnCM[["overall"]][["Accuracy"]])
    accuracyVectSVM <- c(accuracyVectSVM, svmCM[["overall"]][["Accuracy"]])
  }
  comparisonDf <- rbind(data.frame(accuracy=accuracyVectKNN, method="KNN", n=n), 
              data.frame(accuracy=accuracyVectSVM, method="SVM", n=n))
  save(comparisonDf, file=comparisonCacheFile)
  return(comparisonDf)
}
