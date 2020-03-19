getTweets <- function(hashtag, sampleSize) {
  # load credentials from the json file
  credentials <- fromJSON(file="apikey.json", simplify = TRUE)
  
  # create an oauth token from the loaded credentials
  oauthToken <- create_token(app = as.character(credentials["app_name"]), 
                             consumer_key = as.character(credentials["api_key"]),
                             consumer_secret = as.character(credentials["api_key_secret"]),
                             access_token = as.character(credentials["access_token"]),
                             access_secret = as.character(credentials["access_token_secret"]))
  
  df <- search_tweets(paste("#", hashtag, sep = ""), n=sampleSize)
  df$cleanText <- as.character(df$text)
  df$cleanText <- stripWhitespace(df$cleanText)
  df$cleanText <- removePunctuation(df$cleanText)
  df$cleanText <- replace_internet_slang(df$cleanText)
  df$cleanText <- replace_emoji(df$cleanText)
  df$cleanText <- replace_contraction(df$cleanText)
  df$cleanText <- removeWords(df$cleanText, stopwords())
  df$cleanText <- gsub(pattern="\\d",replace=" ",df$cleanText)
  df$cleanText <- gsub("[[:punct:]]", " ", df$cleanText)
  df$cleanText <- gsub("(f|ht)+p(s?)://(.*)[.][a-z]+"," ",df$cleanText)
  df$cleanText <- gsub(pattern="\\b[a-z]\\b{1}","", df$cleanText)
  df$cleanText <- tolower(df$cleanText)
  df
}