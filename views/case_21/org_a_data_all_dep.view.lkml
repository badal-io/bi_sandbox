view: org_a_data_all_dep {
  sql_table_name: `looker_foundation_test.org_a_data_all_dep` ;;

  dimension: department {
    label: "Department"
    description: "description"
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: department_id {
    label: "Department id"
    description: "description"
    type: number
    sql: ${TABLE}.department_id ;;
  }
  dimension: value {
    label: "Value"
    description: "description"
    hidden: yes
    type: number
    sql: ${TABLE}.value ;;
  }

  measure: total_value {
    label: "Total Value"
    description: "description"
    type: sum
    sql: ${value} ;;
  }

  measure: count {
    label: "Department"
    description: "description"
    type: count
  }
}
