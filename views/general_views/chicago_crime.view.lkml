view: chicago_crime {

  derived_table: {
    sql: select *
             from `bigquery-public-data.chicago_crime.crime`
             where date>='2025-01-01'
            ;;
  }


  dimension: unique_key {
    type: number
    label: "Unique Key"
    sql: ${TABLE}.unique_key ;;
  }

  dimension: case_number {
    type: string
    label: "Case Number"
    sql: ${TABLE}.case_number ;;
  }

  dimension: block {
    type: string
    label: "Block"
    sql: ${TABLE}.block ;;
  }

  dimension: iucr {
    type: string
    label: "Iucr"
    sql: ${TABLE}.iucr ;;
  }

  dimension: primary_type {
    type: string
    label: "Primary Type"
    sql: ${TABLE}.primary_type ;;
  }

  dimension: description {
    type: string
    label: "Description"
    sql: ${TABLE}.description ;;
  }

  dimension: location_description {
    type: string
    label: "Location Description"
    sql: ${TABLE}.location_description ;;
  }

  dimension: arrest {
    type: yesno
    label: "Arrest"
    sql: ${TABLE}.arrest ;;
  }

  dimension: domestic {
    type: yesno
    label: "Domestic"
    sql: ${TABLE}.domestic ;;
  }

  dimension: beat {
    type: number
    label: "Beat"
    sql: ${TABLE}.beat ;;
  }

  dimension: district {
    type: number
    label: "District"
    sql: ${TABLE}.district ;;
  }

  dimension: ward {
    type: number
    label: "Ward"
    sql: ${TABLE}.ward ;;
  }

  dimension: community_area {
    type: number
    label: "Community Area"
    sql: ${TABLE}.community_area ;;
  }

  dimension: fbi_code {
    type: string
    label: "Fbi Code"
    sql: ${TABLE}.fbi_code ;;
  }

  dimension: x_coordinate {
    type: number
    label: "X Coordinate"
    sql: ${TABLE}.x_coordinate ;;
  }

  dimension: y_coordinate {
    type: number
    label: "Y Coordinate"
    sql: ${TABLE}.y_coordinate ;;
  }


  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension_group: updated_on {
    type: time
    sql: ${TABLE}.updated_on ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  measure: count {
    type: count
  }

}
