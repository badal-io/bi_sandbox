view: spotify2023 {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.Ilya_looker.Spotify-2023` ;;

  dimension: acousticness__ {
    type: number
    sql: ${TABLE}.acousticness__ ;;
  }
  dimension: artist_count {
    type: number
    sql: ${TABLE}.artist_count ;;
  }
  dimension: artist_s__name {
    type: string
    sql: ${TABLE}.artist_s__name ;;
  }
  dimension: bpm {
    type: number
    sql: ${TABLE}.bpm ;;
  }
  dimension: danceability__ {
    type: number
    sql: ${TABLE}.danceability__ ;;
  }
  dimension: energy__ {
    type: number
    sql: ${TABLE}.energy__ ;;
  }
  dimension: in_apple_charts {
    type: number
    sql: ${TABLE}.in_apple_charts ;;
  }
  dimension: in_apple_playlists {
    type: number
    sql: ${TABLE}.in_apple_playlists ;;
  }
  dimension: in_deezer_charts {
    type: number
    sql: ${TABLE}.in_deezer_charts ;;
  }
  dimension: in_deezer_playlists {
    type: number
    sql: ${TABLE}.in_deezer_playlists ;;
  }
  dimension: in_shazam_charts {
    type: number
    sql: ${TABLE}.in_shazam_charts ;;
  }
  dimension: in_spotify_charts {
    type: number
    sql: ${TABLE}.in_spotify_charts ;;
  }
  dimension: in_spotify_playlists {
    type: number
    sql: ${TABLE}.in_spotify_playlists ;;
  }
  dimension: instrumentalness__ {
    type: number
    sql: ${TABLE}.instrumentalness__ ;;
  }
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }
  dimension: liveness__ {
    type: number
    sql: ${TABLE}.liveness__ ;;
  }
  dimension: mode {
    type: string
    sql: ${TABLE}.mode ;;
  }
  dimension: released_day {
    type: number
    sql: ${TABLE}.released_day ;;
  }
  dimension: released_month {
    type: number
    sql: ${TABLE}.released_month ;;
  }
  dimension: released_year {
    type: number
    sql: ${TABLE}.released_year ;;
  }
  dimension: speechiness__ {
    type: number
    sql: ${TABLE}.speechiness__ ;;
  }
  dimension: streams {
    type: string
    sql: ${TABLE}.streams ;;
  }
  dimension: track_name {
    type: string
    sql: ${TABLE}.track_name ;;
  }
  dimension: valence__ {
    type: number
    sql: ${TABLE}.valence__ ;;
  }
  measure: count {
    type: count
    drill_fields: [artist_s__name, track_name]
  }
}
