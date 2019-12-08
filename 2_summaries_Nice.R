#### packages ####

library(stringr)
library(ggplot2)
library(purrr)
library(dplyr)


#### get organized ####

load(file = "top100_2016.RData")
load(file = "top100_2017.RData")
load(file = "top100_2018.RData")
load(file = "top100_2019.RData")

top100_2016$listYear <- rep(2016, 100)
top100_2017$listYear <- rep(2017, 100)
top100_2018$listYear <- rep(2018, 100)
top100_2019$listYear <- rep(2019, 100)

all <- rbind.data.frame(top100_2016, top100_2017, top100_2018, top100_2019)


all$releaseYear <- str_sub(all$track.album.release_date, 1, 4) ## get the year

all$primaryArtist <- map(all$track.artists, ~ .x[1, "name"]) %>% unlist() ## just pick the primary artist to make things easier


#### plots ####
ggplot(all, aes(track.duration_ms)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(track.popularity)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(releaseYear)) + geom_histogram(stat = "count") + facet_wrap(~listYear) + theme_minimal()


#### tables ####
all %>% arrange(releaseYear) %>% select(track.name, primaryArtist) %>% head(10) ## oldest songs


all %>% group_by(primaryArtist, track.name) %>% summarize(count = n()) %>% arrange(desc(count)) %>% as.data.frame() %>% head(15) ## repeats of songs across years


all %>% group_by(primaryArtist) %>% summarize(count = n()) %>% arrange(desc(count)) %>% as.data.frame() %>% head(25) ## repeats of artists across years