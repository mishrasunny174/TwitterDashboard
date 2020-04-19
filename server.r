server <- function(input, output) {
  # reactive expression to handle hashtag input in SYUZNET approach
  getHashtag <- reactive({
    if (input$hashtag == "") {
      shinyalert(title = "Oops!",
                 text = "Please enter a hashtag",
                 type = "error")
    }
    validate(need(input$hashtag != "", message = ""))
    input$hashtag
  })
  
  # reactive expression to handle hashtag input in ML approach
  getHashtagML <- reactive({
    if (input$hashtagML == "") {
      shinyalert(title = "Oops!",
                 text = "Please enter a hashtag",
                 type = "error")
    }
    validate(need(input$hashtagML != "", message = ""))
    input$hashtagML
  })
  
  # reactive expression to get tweets
  tweets <- reactive({
    if (input$sampleSize < 100 || input$sampleSize > 1000) {
      shinyalert(title = "Oops!",
                 text = "Please enter a valid sample size",
                 type = "error")
    }
    validate(need(input$sampleSize >= 100 &&
                    input$sampleSize <= 1000, message = ""))
    getTweets(getHashtag(), input$sampleSize)
  })
  
  # reactive expression for ML sample size input
  tweetsML <- reactive({
    if (input$sampleSizeML < 100 || input$sampleSizeML > 1000) {
      shinyalert(title = "Oops!",
                 text = "Please enter a valid sample size",
                 type = "error")
    }
    validate(need(
      input$sampleSizeML >= 100 &&
        input$sampleSizeML <= 1000,
      message = ""
    ))
    getTweets(getHashtagML(), input$sampleSizeML)
  })
  
  # reactive expression to calculate the word tweet frequency
  tweetsFreqDf <- reactive({
    df <- getTweetsFreqDf(tweets())
    data.frame(Word = df$word, Frequency = df$freq)
  })
  
  # reactive expression to calculate the sentiments
  sentimentDf <- reactive({
    tweetsText <- tweets()$cleanText
    get_nrc_sentiment(tweetsText)
  })
  
  # get knn confusion matrix
  getKNNCF <- reactive({
    p <- shiny::Progress$new()
    p$set(message = "Training and testing model to compute confusion matrix")
    cm <- getKNNConfusionMatrix(useCache = input$useCache)
    on.exit(p$close())
    return(cm)
  })
  
  # reactive expression for getting SVN confusion matrix
  getSVNCF <- reactive({
    p <- shiny::Progress$new()
    p$set(message = "Training and testing model to compute confusion matrix")
    cm <- getSVMConfusionMatrix(useCache = input$useCache)
    on.exit(p$close())
    return(cm)
  })
  
  # callback for frequencyTable TAB
  output$frequencyTable <- renderDataTable(tweetsFreqDf())
  
  # callback for wordcloud TAB
  output$wordcloud <- renderWordcloud2({
    wordcloud2(tweetsFreqDf()[1:100, ])
  })
  
  # callback for tweets TAB
  output$tweets <- renderDataTable({
    df <- tweets()
    compact <-
      data.frame(
        date = df$created_at,
        userid = df$screen_name,
        tweet = df$text
      )
    compact
  })
  
  # output ploit for sentiment analysis
  output$sentimentAnalysisPlot <- renderPlot({
    df <- sentimentDf()
    barplot(
      colSums(df),
      las = 2,
      col = rainbow(10),
      ylab = "Count",
      main = paste(
        "Sentiment Scores for",
        paste("#", getHashtag(), sep = ""),
        "Tweets"
      )
    )
  })
  
  # output plot for KNN confusion matrix
  output$knnCMPlot <- renderPlot({
    cm <- getKNNCF()
    fourfoldplot(cm[["table"]],
                 main = "KNN Confusion matrix",
                 conf.level = 0,
                 margin = 1)
  })
  
  # Output SVM plot
  output$svmPlot <- renderPlot({
    p <- shiny::Progress$new()
    p$set(message = "Training model and plotting graph")
    on.exit(p$close())
    plot(getSVMTrainedSentimentAnalysisModel(useCache = input$useCache))
  })
  
  # Output KNN plot
  output$knnPlot <- renderPlot({
    p <- shiny::Progress$new()
    p$set(message = "Training model and plotting graph")
    on.exit(p$close())
    plot(getKNNTrainedSentimentAnalysisModel(useCache = input$useCache))
  })
  
  # output plot for SVN confusion matrix
  output$svmCMPlot <- renderPlot({
    cm <- getSVNCF()
    fourfoldplot(cm[["table"]],
                 main = "SVM Confusion matrix",
                 conf.level = 0,
                 margin = 1)
  })
  
  # sentiment analysis plot using SVM
  output$mlSentimentPlotSVM <- renderPlot({
    p <- shiny::Progress$new()
    p$set(message = "Gathering Tweets and analyzing sentiment")
    on.exit(p$close())
    tweetsDf <- tweetsML()
    tweetsDf$s <- svmPredict(tweetsDf$text)
    ggplot(data = tweetsDf) + labs(title = "SVM Sentiment analysis",
                                   xlabel = "Sentiment",
                                   ylabel = "Count") + geom_histogram(
                                     mapping = aes(x = s,),
                                     fill = "#42a5f5",
                                     color = "white",
                                     stat = "count"
                                   )
    
  })
  
  # sentiment analysis plot using KNN
  output$mlSentimentPlotKNN <- renderPlot({
    p <- shiny::Progress$new()
    p$set(message = "Gathering Tweets and analyzing sentiment")
    on.exit(p$close())
    tweetsDf <- tweetsML()
    tweetsDf$s <- knnPredict(tweetsDf$text)
    ggplot(data = tweetsDf) + labs(title = "KNN Sentiment analysis",
                                   xlabel = "Sentiment",
                                   ylabel = "Count") + geom_histogram(
                                     mapping = aes(x = s),
                                     fill = "#42a5f5",
                                     color = "white",
                                     stat = "count",
                                   )
  })
}
