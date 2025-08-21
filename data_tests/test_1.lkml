test: org_value_check {
  explore_source: org_a_data_all_dep {
    column: total_value {
      field: org_a_data_all_dep.total_value
    }
  }
  assert: value_limit {
    expression: ${org_a_data_all_dep.total_value} >0 ;;
  }
}
