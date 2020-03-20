server <- function(input, output) {
  
  getHashtag <- reactive(
    {
      input$hashtag
    }
  )
  
  # reactive expression to get tweets
  tweets <- reactive(
    {
      getTweets(getHashtag(), input$sampleSize)
    }
  )
  
  #reactive expression to calculate the word tweet frequency 
  tweetsFreqDf <- reactive(
    {
      df <- getTweetsFreqDf(tweets())
      data.frame(Word=df$word, Frequency=df$freq)
    }
  )
  
  sentimentDf <- reactive(
    {
      tweetsText <- tweets()$cleanText
      get_nrc_sentiment(tweetsText)
    }
  )
  
  #callback for frequencyTable TAB
  output$frequencyTable <- renderDataTable(tweetsFreqDf())
  
  #callback for wordcloud TAB
  output$wordcloud <- renderWordcloud2(
    {
      wordcloud2(tweetsFreqDf()[1:100, ])
    }
  )
  
  #callback for tweets TAB
  output$tweets <- renderDataTable(
    {
      df <- tweets()
      compact <- data.frame(date = df$created_at, userid = df$screen_name, tweet = df$text)
      compact
    }
  )
  
  output$sentimentAnalysisPlot <- renderPlot(
    {
      df <- sentimentDf()
      barplot(colSums(df),
              las = 2,
              col = rainbow(10),
              ylab = 'Count',
              main = paste('Sentiment Scores for', getHashtag()  ,'Tweets'))
    }
  )
  
}