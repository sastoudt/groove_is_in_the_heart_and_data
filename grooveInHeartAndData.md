Groove is in the Heart (and the Data)
========================================================
author: Sara Stoudt (@sastoudt)
date: December 10, 2019
autosize: true

<style>
.reveal .slides{
    width: 90% !important;  /* or other width */
}
</style>

<style>
.reveal .slides section .slideContent{
    font-size: 18pt;
}
</style>

"Without music, life would be a blank to me." - Jane Austen (Emma)
========================================================

So you want to analyze some music data?

- [spotifyr](https://cran.r-project.org/web/packages/spotifyr/index.html)
- [genius](https://cran.r-project.org/web/packages/genius/index.html)

You'll need API keys for both:

- [Spotify](https://developer.spotify.com/documentation/web-api/)
- [Genius](https://docs.genius.com/)

Get Summary Data
========================================================

[Code]((https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/1_getData_Nice.R)


```r
top100_2019 <- spotifyr::get_playlist_tracks("37i9dQZF1EteKcFAfmqtzy")

# track.artists
# track.duration_ms
# track.name
# track.popularity
# track.album.name
# track.album.release_date
```

Get Audio Feature Data
========================================================


```r
top100_2019f <- spotifyr::get_playlist_audio_features(username="sstoudt",
                                                      "37i9dQZF1EteKcFAfmqtzy")

# danceability
# energy
# loudness
# speechiness
# acousticness
# instrumentalness
# liveness
# valence
# tempo
```

Get Lyrics
========================================================


```r
artists <- purrr::map(top100_2019$track.artists, ~.x[1,"name"]) %>% unlist()

track_name <- top100_2019$track.name

safe_lyrics <- purrr::safely(genius::genius_lyrics)

lyrics19 <- map2(artists, track_name, safe_lyrics)
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> track_title </th>
   <th style="text-align:right;"> line </th>
   <th style="text-align:left;"> lyric </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> Why're men great 'til they gotta be great? ('Til they gotta be great) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> Don't text me, tell it straight to my face (Tell it straight to my face) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> Best friend sat me down in the salon chair (Down in the salon chair) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> Shampoo press, get you out of my hair </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> Fresh photos with the bomb lighting (Bomb lighting) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:left;"> New man on the Minnesota Vikings (Minnesota Vikings) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> Truth hurts, needed something more exciting (Yee) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Truth Hurts </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> Bom bom bi dom bi dum bum bay (Eh, yeah, yeah, yeah) </td>
  </tr>
</tbody>
</table>

Summaries
========================================================

[Code](https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/2_summaries_Nice.R)




```r
all %>% arrange(releaseYear) %>% select(track.name, primaryArtist, releaseYear) %>% head(10)  %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> track.name </th>
   <th style="text-align:left;"> primaryArtist </th>
   <th style="text-align:left;"> releaseYear </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Don't You Worry 'Bout A Thing </td>
   <td style="text-align:left;"> Stevie Wonder </td>
   <td style="text-align:left;"> 1973 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> American Girl </td>
   <td style="text-align:left;"> Tom Petty and the Heartbreakers </td>
   <td style="text-align:left;"> 1976 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> I Can't Go for That (No Can Do) </td>
   <td style="text-align:left;"> Daryl Hall &amp; John Oates </td>
   <td style="text-align:left;"> 1981 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jack &amp; Diane </td>
   <td style="text-align:left;"> John Mellencamp </td>
   <td style="text-align:left;"> 1982 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Say You'll Be There </td>
   <td style="text-align:left;"> Spice Girls </td>
   <td style="text-align:left;"> 1996 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mo Money Mo Problems (feat. Mase &amp; Puff Daddy) </td>
   <td style="text-align:left;"> The Notorious B.I.G. </td>
   <td style="text-align:left;"> 1997 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> That Don't Impress Me Much </td>
   <td style="text-align:left;"> Shania Twain </td>
   <td style="text-align:left;"> 1997 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Where My Girls At </td>
   <td style="text-align:left;"> 702 </td>
   <td style="text-align:left;"> 1999 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Overprotected - Radio Edit </td>
   <td style="text-align:left;"> Britney Spears </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Can't Stop </td>
   <td style="text-align:left;"> Red Hot Chili Peppers </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
</tbody>
</table>

***


```r
all %>% group_by(primaryArtist, track.name) %>% summarize(count=n()) %>% arrange(desc(count)) %>% head(4) %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> primaryArtist </th>
   <th style="text-align:left;"> track.name </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Robyn </td>
   <td style="text-align:left;"> Dancing On My Own </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Angel Haze </td>
   <td style="text-align:left;"> Battle Cry </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bleachers </td>
   <td style="text-align:left;"> Don't Take The Money </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bleachers </td>
   <td style="text-align:left;"> Rollercoaster </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>

```r
all %>% group_by(primaryArtist) %>% summarize(count=n()) %>% arrange(desc(count)) %>% head(4)  %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> primaryArtist </th>
   <th style="text-align:right;"> count </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ed Sheeran </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bleachers </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sia </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> The Maine </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
</tbody>
</table>

Feature Analysis
========================================================

[Code](https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/3_features_Nice.R)

![plot of chunk unnamed-chunk-8](grooveInHeartAndData-figure/unnamed-chunk-8-1.png)

***


```r
all %>% group_by(listYear) %>%
  top_n(n = 1, wt = acousticness) %>%  select(primaryArtist, track.name, listYear)  %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> primaryArtist </th>
   <th style="text-align:left;"> track.name </th>
   <th style="text-align:right;"> listYear </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ZAYN </td>
   <td style="text-align:left;"> MiNd Of MiNdd (Intro) </td>
   <td style="text-align:right;"> 2016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Marian Hill </td>
   <td style="text-align:left;"> Down </td>
   <td style="text-align:right;"> 2017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Betty Who </td>
   <td style="text-align:left;"> Ignore Me </td>
   <td style="text-align:right;"> 2018 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Foo Fighters </td>
   <td style="text-align:left;"> Everlong - Acoustic Version </td>
   <td style="text-align:right;"> 2019 </td>
  </tr>
</tbody>
</table>

```r
all %>% group_by(listYear) %>%
  top_n(n = 1, wt = liveness) %>%  select(primaryArtist, track.name, listYear)  %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> primaryArtist </th>
   <th style="text-align:left;"> track.name </th>
   <th style="text-align:right;"> listYear </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FRENSHIP </td>
   <td style="text-align:left;"> Capsize </td>
   <td style="text-align:right;"> 2016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kesha </td>
   <td style="text-align:left;"> Woman </td>
   <td style="text-align:right;"> 2017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Deaf Havana </td>
   <td style="text-align:left;"> Sinner </td>
   <td style="text-align:right;"> 2018 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Foo Fighters </td>
   <td style="text-align:left;"> Best Of You - Live at the Pantages Theatre, Los Angeles, CA - August 2006 </td>
   <td style="text-align:right;"> 2019 </td>
  </tr>
</tbody>
</table>


Sentiment Analysis
========================================================

[Code](https://github.com/sastoudt/groove_is_in_the_heart_and_data/blob/master/4_lyrics_Nice.R)




```r
allL3 %>% arrange(desc(meanSentiment)) %>% head(5) %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> track_title </th>
   <th style="text-align:right;"> meanSentiment </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Silver Lining </td>
   <td style="text-align:right;"> 0.3959204 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> California Poppies </td>
   <td style="text-align:right;"> 0.3061862 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Soulmate </td>
   <td style="text-align:right;"> 0.2179815 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Daft Pretty Boys </td>
   <td style="text-align:right;"> 0.1731145 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Big Plans </td>
   <td style="text-align:right;"> 0.1595306 </td>
  </tr>
</tbody>
</table>

```r
allL3 %>% arrange(meanSentiment) %>% head(5) %>% kable() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> track_title </th>
   <th style="text-align:right;"> meanSentiment </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sucker Punch </td>
   <td style="text-align:right;"> -0.3234278 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Unbelievable </td>
   <td style="text-align:right;"> -0.2614811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bad Liar </td>
   <td style="text-align:right;"> -0.2125145 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alligator </td>
   <td style="text-align:right;"> -0.1854486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jealous </td>
   <td style="text-align:right;"> -0.1835855 </td>
  </tr>
</tbody>
</table>
***

```r
ggplot(allL3, aes(meanSentiment))+
  geom_histogram()+theme_minimal()
```

![plot of chunk unnamed-chunk-12](grooveInHeartAndData-figure/unnamed-chunk-12-1.png)
