ui <- fluidPage(
    
    # Application title
    titlePanel("Hashtag Analysis"),
    
    # Inputs(s) panel
    fluidRow(
        
        # Enter a hashtag that interests you.
        column(width = 4,
               offset = 0,
               textInput(inputId = "hashtag",
                           label = "Hashtag",
                           value='corona')),
        
        #Select sample size
        column(width = 4,
               offset = 4,
               sliderInput(inputId='sampleSize',
                             label='Sample Size',
                             value=100,
                             min=100,
                             max=1000))
    ),
    
    #Output tab panel
    tabsetPanel(
        
        # Output(s)
        tabPanel('Word Cloud',
                 wordcloud2Output(outputId = "wordcloud")),
        tabPanel('Word Frequency Table', 
                 dataTableOutput(outputId = "frequencyTable")),
        tabPanel('Tweets', 
                 dataTableOutput(outputId='tweets')),
        tabPanel("Sentiment Analysis", 
                 plotOutput(outputId = "sentimentAnalysisPlot"))
        
    )
    
)
