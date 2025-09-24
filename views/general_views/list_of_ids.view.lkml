view: list_of_ids {
  derived_table: {
    sql: SELECT * FROM `prj-s-dlp-dq-sandbox-0b3c.dbt_Evgenii.list_of_ids`;;
  }

  measure: count {
    label: "COUNT"
    type: count
  }

  dimension: id {
    label: "ID"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    label: "NAME"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: code {
    label: "CODE"
    type: number
    sql: ${TABLE}.code ;;
  }

  dimension: flag {
    label: "FLAG"
    type: string
    sql: ${TABLE}.flag ;;
  }

}
