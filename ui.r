ui <- fluidPage(
    
    # Application title
    titlePanel("WordCloud for Twitter Hashtags"),
    
    # Inputs(s) panel
    fluidRow(
        
        # Enter a hashtag that interests you.
        column(5, textInput(inputId = "word",
                           label = "Hashtag",
                           value='corona')),
        
        #Select sample size
        column(5, sliderInput(inputId='n',
                             label='Sample Size',
                             value=200,
                             min=100,
                             max=1000))
    ),
    
    #Output tab panel
    tabsetPanel(
        
        # Output(s)
        tabPanel('Wordclouds',wordcloud2Output(outputId = "wordcloud")),
        tabPanel('Frequency Table',DT::dataTableOutput(outputId = "table")),
        tabPanel('Tweets',DT::dataTableOutput(outputId='txt'))
    )
    
)
