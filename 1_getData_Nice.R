#### packages ####
library(spotifyr)
library(purrr)
library(genius)

#### authorization
spotify_client_id <- "" ## put yours here
spotify_client_secret <- "" ## put yours here
access_token <- get_spotify_access_token(client_id = spotify_client_id, client_secret = spotify_client_secret)

Sys.setenv(SPOTIFY_CLIENT_ID = spotify_client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = spotify_client_secret)

genius_token() ## this will prompt you for your info


##### summary info ####

top100_2016 <- get_playlist_tracks("37i9dQZF1CyJMsfFrWRs3e", authorization = access_token) ## replace with your playlist ids (spotify uris)

## https://community.spotify.com/t5/Spotify-Answers/What-s-a-Spotify-URI/ta-p/919201

top100_2017 <- get_playlist_tracks("37i9dQZF1E9VMadgBWBz54", authorization = access_token)
top100_2018 <- get_playlist_tracks("37i9dQZF1EjgejlROSsKGo", authorization = access_token)
top100_2019 <- get_playlist_tracks("37i9dQZF1EteKcFAfmqtzy", authorization = access_token)

#### features ####

top100_2016f <- get_playlist_audio_features(username = "sstoudt", playlist_uris = "37i9dQZF1CyJMsfFrWRs3e", authorization = access_token) ## replace with your info
top100_2017f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1E9VMadgBWBz54", authorization = access_token)
top100_2018f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1EjgejlROSsKGo", authorization = access_token)
top100_2019f <- get_playlist_audio_features(username = "sstoudt", "37i9dQZF1EteKcFAfmqtzy", authorization = access_token)

save(top100_2016, file = "top100_2016.RData")
save(top100_2017, file = "top100_2017.RData")
save(top100_2018, file = "top100_2018.RData")
save(top100_2019, file = "top100_2019.RData")

save(top100_2016f, file = "top100_2016f.RData")
save(top100_2017f, file = "top100_2017f.RData")
save(top100_2018f, file = "top100_2018f.RData")
save(top100_2019f, file = "top100_2019f.RData")

#### lyrics ####

artists <- map(top100_2019$track.artists, ~ .x[1, "name"]) %>% unlist()
track_name <- top100_2019$track.name




safe_lyrics <- safely(genius_lyrics)

lyrics19 <- map2(artists, track_name, safe_lyrics)


didItWork <- map(lyrics19, ~ .x$error)

sum(unlist(map(didItWork, is.null))) ## How many have lyrics

save(lyrics19, file = "lyrics19.RData")