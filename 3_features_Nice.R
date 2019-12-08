#### packages ####

library(dplyr)
library(purrr)
library(ggplot2)
library(scales)

#### getting organized ####

load(file = "top100_2016f.RData")
load(file = "top100_2017f.RData")
load(file = "top100_2018f.RData")
load(file = "top100_2019f.RData")


top100_2016f$listYear <- rep(2016, 101)
top100_2017f$listYear <- rep(2017, 100)
top100_2018f$listYear <- rep(2018, 100)
top100_2019f$listYear <- rep(2019, 100)

all <- rbind.data.frame(top100_2016f, top100_2017f, top100_2018f, top100_2019f)


all$primaryArtist <- map(all$track.artists, ~ .x[1, "name"]) %>% unlist() ## just pick the primary artist to make things easier

#### single plots ####

ggplot(all, aes(danceability)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(energy)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(loudness)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(speechiness)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(acousticness)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(instrumentalness)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(liveness)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(valence)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

ggplot(all, aes(tempo)) + geom_histogram() + facet_wrap(~listYear) + theme_minimal()

#### ggradar tweaks ####

source("fix_ggradar.R") ## I made some modifications for my own purposes
#https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/fix_ggradar.R

source("helper_plot.R") ## using source code from ggradar, adapted for my own purposes
# https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/helper_plot.R


#### all together now ####

characteristics <- c("danceability", "energy", "loudness", "speechiness", "acousticness", "instrumentalness", "liveness", "valence")

charSum <- all[, c(characteristics, "listYear")] %>%
  group_by(listYear) %>%
  summarise(
    meanDanceability = mean(danceability), meanEnergy = mean(energy),
    meanLoudness = mean(loudness), meanSpeechiness = mean(speechiness),
    meanAcousticness = mean(acousticness), meanInstrumentalness = mean(instrumentalness), meanLiveness = mean(liveness), meanValence = mean(valence),
    varDanceability = var(danceability), varEnergy = var(energy),
    varLoudness = var(loudness), varSpeechiness = var(speechiness),
    varAcousticness = var(acousticness), varInstrumentalness = var(instrumentalness), varLiveness = var(liveness), varValence = var(valence)
  ) ## there is definitely a better way to do this, but going with this for now

add <- cbind.data.frame(album_name = "avg", t(apply(all[, c(characteristics)], 2, mean)))


meanStuff <- charSum[, 1:9]
names(add) <- names(meanStuff)
meanStuff <- rbind.data.frame(meanStuff, add)
varStuff <- charSum[, c(1, 10:17)]


toP <- meanStuff %>% mutate_at(vars(-listYear), rescale)

base <- ggradar2(toP[-nrow(toP), ])

helperPlot(base)

#### tables ####

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = speechiness) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = instrumentalness) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = acousticness) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = liveness) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = valence) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = danceability) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = energy) %>%
  select(primaryArtist, track.name, listYear)

all %>%
  group_by(listYear) %>%
  top_n(n = 5, wt = loudness) %>%
  select(primaryArtist, track.name, listYear)