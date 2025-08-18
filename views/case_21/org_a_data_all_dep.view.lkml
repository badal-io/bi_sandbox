view: org_a_data_all_dep {
  sql_table_name: `looker_foundation_test.org_a_data_all_dep` ;;

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }
  dimension: value {
    hidden: yes
    type: number
    sql: ${TABLE}.value ;;
  }

  measure: total_value {
    label: "Total Value"
    type: sum
    sql: ${value} ;;
  }

  measure: count {
    type: count
  }
}
