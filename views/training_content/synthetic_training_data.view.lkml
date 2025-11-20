view: synthetic_training_data {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.dbt_thrytsyk.synthetic_training_data` ;;

  dimension: agent_id {
    type: number
    sql: ${TABLE}.agent_id ;;
  }
  dimension: agent_manager {
    type: string
    sql: ${TABLE}.agent_manager ;;
  }
  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }
  dimension: call_type {
    type: string
    sql: ${TABLE}.call_type ;;
  }
  dimension_group: coversation {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.coversation_date ;;
  }
  dimension: coversation_id {
    type: string
    sql: ${TABLE}.coversation_id ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: duration {
    type: number
    sql: ${TABLE}.duration ;;
  }
  dimension: language {
    type: string
    sql: ${TABLE}.language ;;
  }
  dimension: lob {
    type: string
    sql: ${TABLE}.lob ;;
  }
  dimension: primary_topic {
    type: string
    sql: ${TABLE}.primary_topic ;;
  }
  dimension: repeat_call {
    type: yesno
    sql: ${TABLE}.repeat_call ;;
  }
  dimension: retention_call {
    type: yesno
    sql: ${TABLE}.retention_call ;;
  }
  dimension: sales_call {
    type: yesno
    sql: ${TABLE}.sales_call ;;
  }
  dimension: secondary_topic {
    type: string
    sql: ${TABLE}.secondary_topic ;;
  }
  dimension: training_duration {
    type: number
    sql: ${TABLE}.training_duration ;;
  }
  dimension_group: training_last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.training_last_update ;;
  }
  dimension: training_topic {
    type: string
    sql: ${TABLE}.training_topic ;;
  }
  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}
