view: car_crash200315 {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.Ilya_looker.car_crash2003-15` ;;

  dimension: collision_type {
    label: "Collision Types (LABEL)"
    description: "this dim describes a type of collision occured"
    type: string
    sql: ${TABLE}.Collision_Type ;;
  }
  dimension: year {
    label: "Year"
    description: "year of the event"
    type: number
    sql: ${TABLE}.Year ;;
  }
  dimension: month {
    label: "Month"
    description: "month of the event"
    type: number
    sql: ${TABLE}.Month ;;
  }
  dimension: day {
    label: "Day"
    description: "day of the event"
    type: number
    sql: ${TABLE}.Day ;;
  }
  dimension: hour {
    label: "Hour"
    description: "hour of the event"
    type: number
    sql: ${TABLE}.Hour ;;
    value_format: "00:00"
  }
  dimension_group: event {
    label: "Event"
    description: "dimension group for type:time"
    type:  time
    #timeframes: [time, date, month, year]
    sql: TIMESTAMP(CONCAT(
    CAST(${year} as STRING), '-',
    CAST(${month} as STRING), '-',
    CAST(${day} as STRING), ' ',
    CAST(${hour}/100 AS STRING), ':00:00'
    )) ;;
  }
  dimension: injury_type {
    label: "Injury Type"
    description: "describes the types of injuries"
    type: string
    sql: ${TABLE}.Injury_Type ;;
  }
  dimension: latitude {
    label: "Latitude"
    description: "Latitude position of the event"
    type: number
    sql: ${TABLE}.Latitude ;;
  }
  dimension: longitude {
    label: "Longitude"
    description: "Longitude position of the event"
    type: number
    sql: ${TABLE}.Longitude ;;
  }
  dimension: primary_factor {
    label: "Primary factor"
    description: "Primary factor of the event"
    type: string
    sql: ${TABLE}.Primary_Factor ;;
  }
  dimension: reported_location {
    label: "Location"
    description: "Geographical location of the event "
    type: string
    sql: ${TABLE}.Reported_Location ;;
  }
  dimension: weekend_ {
    label: "Weekend or Weekday"
    description: ""
    type: string
    sql: ${TABLE}.Weekend_ ;;
  }
  measure: count {
    label: "Count"
    description: "measure for count-type aggregation"
    type: count
  }
}
