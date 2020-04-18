server <- function(input, output) {
  getHashtag <- reactive({
    if (input$hashtag == "") {
      shinyalert(
        title = "Oops!",
        text = "Please enter a hashtag",
        type = "error"
      )
    }
    validate(
      need(input$hashtag != "", message = "")
    )
    input$hashtag
  })

  # reactive expression to get tweets
  tweets <- reactive({
    if (input$sampleSize < 100 || input$sampleSize > 1000) {
      shinyalert(
        title = "Oops!",
        text = "Please enter a valid sample size",
        type = "error"
      )
    }
    validate(
      need(input$sampleSize >= 100 && input$sampleSize <= 1000, message = "")
    )
    getTweets(getHashtag(), input$sampleSize)
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
    cm <- getKNNConfusionMatrix(size = as.integer(input$sampleSizeML / 2) , 
                                useCache = FALSE, 
                                p = input$trainTestRatio)
    on.exit(p$close())
    return(cm)
  })
  
  # reactive expression for getting SVN confusion matrix
  getSVNCF <- reactive({
    p <- shiny::Progress$new()
    p$set(message = "Training and testing model to compute confusion matrix")
    cm <- getSVMConfusionMatrix(size = as.integer(input$sampleSizeML / 2), 
                                useCache = FALSE, 
                                p = input$trainTestRatio)
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
    compact <- data.frame(date = df$created_at, userid = df$screen_name, tweet = df$text)
    compact
  })

  # output ploit for sentiment analysis
  output$sentimentAnalysisPlot <- renderPlot({
    df <- sentimentDf()
    barplot(colSums(df),
      las = 2,
      col = rainbow(10),
      ylab = "Count",
      main = paste("Sentiment Scores for", paste("#", getHashtag(), sep = ""), "Tweets")
    )
  })

  # output plot for KNN confusion matrix
  
  output$knnCMPlot <- renderPlot({
    cm <- getKNNCF()
    fourfoldplot(cm[["table"]], main = "KNN Confusion matrix", conf.level = 0, margin = 1)
  })
  
  # output plot for SVN confusion matrix
  output$svnCMPlot <- renderPlot({
    cm <- getSVNCF()
    fourfoldplot(cm[["table"]], main = "SVM Confusion matrix", conf.level = 0, margin = 1)
  })
}
