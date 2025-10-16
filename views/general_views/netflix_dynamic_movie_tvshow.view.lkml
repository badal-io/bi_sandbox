view: netflix_dynamic_movie_tvshow {
sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.looker_demo.{{ _user_attributes['test_movie_tvshow'] }}` ;;


  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

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
   }
