view: world_country_stats {
  sql_table_name: `Ilya_looker.world_country_stats` ;;

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension: fertility_rate {
    type: number
    sql: ${TABLE}.fertility_rate ;;
  }
  dimension: land_area {
    type: number
    sql: ${TABLE}.land_area ;;
  }
  dimension: median_age {
    type: number
    sql: ${TABLE}.median_age ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  measure: count {
    type: count
  }
}
