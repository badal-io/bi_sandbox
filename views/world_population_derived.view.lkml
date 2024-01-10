view: world_population_derived {
  derived_table: {
    sql: SELECT
           w1.country,
           w1.fertility_rate AS fertility_rate_world_country,
           w1.land_area AS land_area_world_country,
           w1.median_age AS median_age_world_country,
           w1.region AS region_world_country,
           w1.count AS count_world_country,
           w2.density AS density_world_population,
           w2.net_change AS net_change_world_population,
           w2.net_migrants AS net_migrants_world_population,
           w2.population AS population_world_population,
           w2.population_urban AS population_urban_world_population,
           w2.world_share AS world_share_world_population,
           w2.yearly_change AS yearly_change_world_population,
           w2.count AS count_world_population
         FROM world_country_stats w1
         LEFT JOIN world_population_by_country_2023 w2 ON w1.country = w2.country ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: fertility_rate_world_country {
    type: number
    sql: ${TABLE}.fertility_rate_world_country ;;
  }

  dimension: land_area_world_country {
    type: number
    sql: ${TABLE}.land_area_world_country ;;
  }

  dimension: median_age_world_country {
    type: number
    sql: ${TABLE}.median_age_world_country ;;
  }

  dimension: region_world_country {
    type: string
    sql: ${TABLE}.region_world_country ;;
  }

  dimension: density_world_population {
    type: number
    sql: ${TABLE}.density_world_population ;;
  }

  dimension: net_change_world_population {
    type: number
    sql: ${TABLE}.net_change_world_population ;;
  }

  dimension: net_migrants_world_population {
    type: number
    sql: ${TABLE}.net_migrants_world_population ;;
  }

  dimension: population_world_population {
    type: number
    sql: ${TABLE}.population_world_population ;;
  }

  dimension: population_urban_world_population {
    type: number
    sql: ${TABLE}.population_urban_world_population ;;
  }

  dimension: world_share_world_population {
    type: number
    sql: ${TABLE}.world_share_world_population ;;
  }

  dimension: yearly_change_world_population {
    type: number
    sql: ${TABLE}.yearly_change_world_population ;;
  }

  # measure: count_world_country {
  #   type: count
  #   sql: ${TABLE}.count_world_country ;;
  # }

  # measure: count_world_population {
  #   type: count
  #   sql: ${TABLE}.count_world_population ;;
  # }
}
