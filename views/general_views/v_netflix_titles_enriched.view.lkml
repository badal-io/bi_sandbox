view: v_netflix_titles_enriched {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.looker_demo.v_netflix_titles_enriched` ;;

  dimension: cast_names {
    type: string
    sql: ${TABLE}.cast_names ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension_group: date_added {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_added ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }
  dimension: director {
    type: string
    sql: ${TABLE}.director ;;
  }
  dimension: duration {
    type: string
    sql: ${TABLE}.duration ;;
  }
  dimension: duration_unit {
    type: string
    sql: ${TABLE}.duration_unit ;;
  }
  dimension: duration_value {
    type: number
    sql: ${TABLE}.duration_value ;;
  }
  dimension: listed_in {
    type: string
    sql: ${TABLE}.listed_in ;;
  }
  dimension: rating {
    type: string
    sql: ${TABLE}.rating ;;
  }
  dimension: release_year {
    type: number
    sql: ${TABLE}.release_year ;;
  }
  dimension: show_id {
    type: string
    sql: ${TABLE}.show_id ;;
  }
  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count
  }

  measure: movies_count {
    label: "Movies"
    type: sum
    sql: CASE WHEN ${type} = 'Movie' THEN 1 ELSE 0 END ;;
  }

  measure: tv_shows_count {
    label: "TV Shows"
    type: sum
    sql: CASE WHEN ${type} = 'TV Show' THEN 1 ELSE 0 END ;;
  }

  measure: avg_days_from_release_to_added {
    label: "Avg Days: Release → Added"
    type: average
    sql: DATE_DIFF(${date_added_date}, DATE(SAFE_CAST(${release_year} AS INT64), 1, 1), DAY) ;;
    value_format: "0"
  }

  measure: avg_years_since_release {
    label: "Avg Years Since Release"
    type: average
    sql: EXTRACT(YEAR FROM CURRENT_DATE()) - ${release_year} ;;
    value_format: "0.0"
  }

  measure: avg_tv_seasons {
    label: "Avg TV Seasons"
    type: average
    sql: CASE
         WHEN ${type} = 'TV Show' AND ${duration_unit} LIKE '%Season%'
           THEN ${duration_value}
       END ;;
  }

}
