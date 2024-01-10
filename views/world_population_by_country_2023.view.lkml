view: world_population_by_country_2023 {
  sql_table_name: `Ilya_looker.world_population_by_country_2023` ;;

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension: density {
    type: number
    sql: ${TABLE}.density ;;
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
  dimension: net_change {
    type: number
    sql: ${TABLE}.net_change ;;
  }
  dimension: net_migrants {
    type: number
    sql: ${TABLE}.net_migrants ;;
  }
  dimension: population {
    type: number
    sql: ${TABLE}.population ;;
  }
  dimension: population_urban {
    type: number
    sql: ${TABLE}.population_urban ;;
  }
  dimension: world_share {
    type: number
    sql: ${TABLE}.world_share ;;
  }
  dimension: yearly_change {
    type: number
    sql: ${TABLE}.yearly_change ;;
  }
  measure: count {
    type: count
  }
}
