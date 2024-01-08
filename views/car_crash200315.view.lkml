view: car_crash200315 {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.Ilya_looker.car_crash2003-15` ;;

  dimension: collision_type {
    type: string
    sql: ${TABLE}.Collision_Type ;;
  }
  dimension: day {
    type: number
    sql: ${TABLE}.Day ;;
  }
  dimension: hour {
    type: number
    sql: ${TABLE}.Hour ;;
  }
  dimension: injury_type {
    type: string
    sql: ${TABLE}.Injury_Type ;;
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.Latitude ;;
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.Longitude ;;
  }
  dimension: month {
    type: number
    sql: ${TABLE}.Month ;;
  }
  dimension: primary_factor {
    type: string
    sql: ${TABLE}.Primary_Factor ;;
  }
  dimension: reported_location {
    type: string
    sql: ${TABLE}.Reported_Location ;;
  }
  dimension: weekend_ {
    type: string
    sql: ${TABLE}.Weekend_ ;;
  }
  dimension: year {
    type: number
    sql: ${TABLE}.Year ;;
  }
  measure: count {
    type: count
  }
}
