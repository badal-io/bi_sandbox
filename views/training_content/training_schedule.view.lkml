view: training_schedule {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.dbt_thrytsyk.training_schedule` ;;

  dimension: cslt_grouping {
    type: string
    description: "The specific CSLT grouping (e.g., 'CxSS')."
    sql: ${TABLE}.CSLT_Grouping ;;
  }
  dimension: day {
    type: string
    description: "The specific day of the training (e.g., 'Day 1')."
    sql: ${TABLE}.day ;;
  }
  dimension: file_name {
    type: string
    description: "Source file name or category (e.g., 'Koodo CxSS')."
    sql: ${TABLE}.file_name ;;
  }
  dimension: lob {
    type: string
    description: "Line of Business (e.g., 'KDO')."
    sql: ${TABLE}.lob ;;
  }
  dimension: module_name {
    type: string
    description: "The name of the training module or activity."
    sql: ${TABLE}.module_name ;;
  }
  dimension: spend_time_min {
    type: number
    description: "The time duration for the module, in minutes. NULLABLE as some activities have no specified duration."
    sql: ${TABLE}.spend_time_min ;;
  }
  dimension: week {
    type: string
    description: "The training week identifier (e.g., 'Week 1')."
    sql: ${TABLE}.week ;;
  }
  measure: count {
    type: count
    drill_fields: [file_name, module_name]
  }
  measure: total_spend_time_min {
    type: sum
    sql: ${spend_time_min} ;;
  }


}
