view: world_population_derived {
  derived_table: {
    sql: SELECT
           w1.country,
           w1.fertility_rate AS fertility_rate_world_country,
           w1.land_area AS land_area_world_country,
           w1.median_age AS median_age_world_country,
           w1.region AS region_world_country,
           w2.density AS density_world_population,
           w2.net_change AS net_change_world_population,
           w2.net_migrants AS net_migrants_world_population,
           w2.population AS population_world_population,
           w2.population_urban AS population_urban_world_population,
           w2.world_share AS world_share_world_population,
           w2.yearly_change AS yearly_change_world_population,
         FROM world_country_stats w1
         LEFT JOIN world_population_by_country_2023 w2 ON w1.country = w2.country ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: fertility_rate {
    type: number
    sql: ${TABLE}.fertility_rate_world_country ;;
  }

  dimension: land_area {
    type: number
    sql: ${TABLE}.land_area_world_country ;;
  }

  dimension: median_age {
    type: number
    sql: ${TABLE}.median_age_world_country ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region_world_country ;;
  }

  dimension: density {
    type: number
    sql: ${TABLE}.density_world_population ;;
  }

  dimension: net_change {
    type: number
    sql: ${TABLE}.net_change_world_population ;;
  }

  dimension: net_migrants {
    type: number
    sql: ${TABLE}.net_migrants_world_population ;;
  }

  dimension: population {
    type: number
    sql: ${TABLE}.population_world_population ;;
  }

  dimension: population_urban {
    type: number
    sql: ${TABLE}.population_urban_world_population ;;
  }

  dimension: world_share {
    type: number
    sql: ${TABLE}.world_share_world_population ;;
  }

  dimension: yearly_change {
    type: number
    sql: ${TABLE}.yearly_change_world_population ;;
  }

  measure: count {
    type: count
  }
}
