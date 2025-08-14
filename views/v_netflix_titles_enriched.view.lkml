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
}
