ui <- fluidPage(
  # setup shiny alerts
  useShinyalert(),
  # Application title
  titlePanel("Hashtag Analysis"),
  tabsetPanel(
    tabPanel(
      "SYUZNET Approach",
      fluidPage(
        # Inputs(s) panel
        fluidRow(

          # Enter a hashtag that interests you.
          column(
            width = 4,
            offset = 0,
            textInput(
              inputId = "hashtag",
              label = "Enter any hashtag to analyze",
              value = "corona"
            )
          ),

          # Select sample size
          column(
            width = 4,
            offset = 4,
            sliderInput(
              inputId = "sampleSize",
              label = "Sample Size",
              value = 100,
              min = 100,
              max = 1000
            )
          )
        ),

        # Output tab panel
        tabsetPanel(

          # Output(s)
          tabPanel(
            "Word Cloud",
            wordcloud2Output(outputId = "wordcloud")
          ),
          tabPanel(
            "Word Frequency Table",
            dataTableOutput(outputId = "frequencyTable")
          ),
          tabPanel(
            "Tweets",
            dataTableOutput(outputId = "tweets")
          ),
          tabPanel(
            "Sentiment Analysis",
            plotOutput(outputId = "sentimentAnalysisPlot")
          )
        )
      )
    ),
    # ML TAB for comparison stuff
    tabPanel(
      "ML Approach",
      fluidPage(
        # Output tab panel
        tabsetPanel(
          tabPanel(
            "KNN Confusion matrix",
            plotOutput(outputId = "knnCMPlot")
          ),
          tabPanel(
            "SVM Confusion matrix",
            plotOutput(outputId = "svnCMPlot"))
        )
      )
    )
  )
)
