view: evg_taxi_trips_snapshot {
  derived_table: {
    sql: SELECT * FROM `prj-s-dlp-dq-sandbox-0b3c.dbt_Evgenii.taxi_trips_snapshot`;;
  }

  measure: count {
    type: count
  }

  dimension: unique_key {
    type: string
    sql: ${TABLE}.unique_key ;;
  }

  dimension: taxi_id {
    type: string
    sql: ${TABLE}.taxi_id ;;
  }

  dimension_group: trip_start_timestamp {
    type: time
    sql: ${TABLE}.trip_start_timestamp ;;
  }

  dimension_group: trip_end_timestamp {
    type: time
    sql: ${TABLE}.trip_end_timestamp ;;
  }

  dimension: trip_seconds {
    type: number
    sql: ${TABLE}.trip_seconds ;;
  }

  dimension: trip_miles {
    type: number
    sql: ${TABLE}.trip_miles ;;
  }

  dimension: pickup_census_tract {
    type: number
    sql: ${TABLE}.pickup_census_tract ;;
  }

  dimension_group: dbt_load_timestamp {
    type: time
    sql: ${TABLE}.dbt_load_timestamp ;;
  }

  dimension: dbt_scd_id {
    type: string
    sql: ${TABLE}.dbt_scd_id ;;
  }

  dimension_group: dbt_updated_at {
    type: time
    sql: ${TABLE}.dbt_updated_at ;;
  }

  dimension_group: dbt_valid_from {
    type: time
    sql: ${TABLE}.dbt_valid_from ;;
  }

  dimension_group: dbt_valid_to {
    type: time
    sql: ${TABLE}.dbt_valid_to ;;
  }

  dimension: flag_color {
    label: "Flag. Color"
    type: string
    sql: case when ${trip_seconds}<300 then "blue" else "red" end ;;
  }

  ############ MEASURES ############
}
