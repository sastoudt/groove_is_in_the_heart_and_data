#### packages ####

library(tm)
library(SnowballC)
library(tidyr)
library(tidytext)
library(sentimentr)
library(dplyr)
library(ggplot2)

#### getting organized ####
load(file = "lyrics19.RData")


test <- lapply(lyrics19, function(x) {
  x$result
})

allL <- do.call("rbind", test)


#### clean ####

# http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know


docs <- Corpus(VectorSource(allL$lyric))

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("tco", "https", "amp", "'s", "-"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)

d$word <- as.character(d$word)
d2 <- d[which(nchar(d$word) > 2), ] ## get rid of filler words

d2$wordLength <- nchar(d2$word)

d2 %>% arrange(desc(wordLength)) %>% head()


d2 %>%
  group_by(wordLength) %>%
  top_n(n = 5, wt = freq) %>%
  arrange(wordLength) %>%
  as.data.frame()

#### bigrams ####

trybg <- allL %>% unnest_tokens(bigram, lyric, token = "ngrams", n = 2)


bigrams_separated <- trybg %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%


  # new bigram counts:
  bigram_counts() <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)

bigram_counts %>% as.data.frame() %>% head(25)

#### trigrams ####

trytg <- allL %>% unnest_tokens(trigram, lyric, token = "ngrams", n = 3)


trigrams_separated <- trytg %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ")

trigrams_filtered <- trigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word)


trigram_counts <- trigrams_filtered %>%
  count(word1, word2, word3, sort = TRUE)

trigram_counts %>% as.data.frame() %>% head(25)

#### simple sentiment analysis ####
allSentiment <- sentiment(allL$lyric)

allL$id <- 1:nrow(allL)

allL2 <- merge(allSentiment, allL, by.x = "element_id", by.y = "id")

allL3 <- allL2 %>% group_by(track_title) %>% summarise(meanSentiment = mean(sentiment))

allL3 %>% arrange(desc(meanSentiment))

allL3 %>% arrange(meanSentiment)

summary(allL3$meanSentiment)

ggplot(allL3, aes(meanSentiment)) + geom_histogram() + theme_minimal()