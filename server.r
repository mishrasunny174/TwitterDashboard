server <- function(input, output) {
  
  # reactive expression to get tweets
  tweets <- reactive(
    {
      getTweets(input$hashtag, input$sampleSize)
    }
  )
  
  #reactive expression to calculate the word tweet frequency 
  tweetsFreqDf <- reactive(
    {
      df <- getTweetsFreqDf(tweets())
      data.frame(Word=df$word, Frequency=df$freq)
    }
  )
  
  #callback for frequencyTable TAB
  output$frequencyTable <- renderDataTable(tweetsFreqDf())
  
  #callback for wordcloud TAB
  output$wordcloud <- renderWordcloud2({
    wordcloud2(tweetsFreqDf()[1:100, ])
  })
}