test: org_value_value_check {
  explore_source: org_a_data_all_dep {
    column: val {
      field: org_a_data_all_dep.value
    }
  }
  assert: value_limit {
    expression: ${org_a_data_all_dep.value} >0 ;;
  }
}

test: org_value_dep_length_check {
  explore_source: department {
    column: val {
      field: org_a_data_all_dep.department
    }
  }
  assert: value_limit {
    expression: len(${org_a_data_all_dep.department}) =5 ;;
  }
}
