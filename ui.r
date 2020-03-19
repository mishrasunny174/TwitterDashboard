ui <- fluidPage(
    
    # Application title
    titlePanel("WordCloud for Twitter Hashtags"),
    
    # Inputs(s) panel
    fluidRow(
        
        # Enter a hashtag that interests you.
        column(5, textInput(inputId = "hashtag",
                           label = "Hashtag",
                           value='corona')),
        
        #Select sample size
        column(5, sliderInput(inputId='sampleSize',
                             label='Sample Size',
                             value=100,
                             min=100,
                             max=1000))
    ),
    
    #Output tab panel
    tabsetPanel(
        
        # Output(s)
        tabPanel('Wordcloud',
                 wordcloud2Output(outputId = "wordcloud")),
        tabPanel('Frequency Table', 
                 dataTableOutput(outputId = "frequencyTable")),
        tabPanel('Tweets', 
                 dataTableOutput(outputId='tweets'))
    )
    
)
