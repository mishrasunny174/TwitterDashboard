ui <- fluidPage(
  # setup shiny alerts
  useShinyalert(),
  # Application title
  titlePanel("Twitter Sentiment Analysis"),
  tabsetPanel(
    tabPanel("SYUZNET Approach",
             fluidPage(
               # Inputs(s) panel
               fluidRow(
                 # Enter a hashtag that interests you.
                 column(
                   width = 4,
                   offset = 4,
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
                 tabPanel("Word Cloud",
                          wordcloud2Output(outputId = "wordcloud")),
                 tabPanel(
                   "Word Frequency Table",
                   dataTableOutput(outputId = "frequencyTable")
                 ),
                 tabPanel("Tweets",
                          dataTableOutput(outputId = "tweets")),
                 tabPanel(
                   "Sentiment Analysis",
                   plotOutput(outputId = "sentimentAnalysisPlot")
                 )
               )
             )),
    # ML Approach TAB
    tabPanel("ML Approach",
             fluidPage(
               fluidRow(
                 column (
                   offset = 0,
                   width = 4,
                   checkboxInput(
                     label = "USE CACHED MODEL (Note: Retraining requires 2 Hour)",
                     inputId = "useCache",
                     value = TRUE
                   )
                 ),
                 column(
                   width = 4,
                   offset = 4,
                   textInput(
                     inputId = "hashtagML",
                     label = "Enter any hashtag to analyze",
                     value = "corona"
                   )
                 ),
                 
                 # Select sample size
                 column(
                   width = 4,
                   offset = 8,
                   sliderInput(
                     inputId = "sampleSizeML",
                     label = "Sample Size",
                     value = 100,
                     min = 100,
                     max = 1000
                   )
                 )
               ),
               # Output tab panel
               tabsetPanel(
                 tabPanel(
                   "Sentiment Analysis SVM",
                   plotOutput(outputId = "mlSentimentPlotSVM")
                 ),
                 tabPanel(
                   "Sentiment Analysis KNN",
                   plotOutput(outputId = "mlSentimentPlotKNN")
                 ),
                 tabPanel("SVM Model Graph",
                          plotOutput(outputId = "svmPlot")),
                 tabPanel("KNN Model Graph",
                          plotOutput(outputId = "knnPlot")),
                 tabPanel("SVM Confusion matrix",
                          plotOutput(outputId = "svmCMPlot")),
                 
                 tabPanel("KNN Confusion matrix",
                          plotOutput(outputId = "knnCMPlot"))
               )
             ))
  )
)
