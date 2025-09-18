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
  explore_source: org_a_data_all_dep {
    column: department {
      field: org_a_data_all_dep.department
    }
  }
  assert: length_check {
    expression: length(${org_a_data_all_dep.department}) =5;;
  }
}

test: org_value_depid_notnull_check {
  explore_source: org_a_data_all_dep {
    column: department_id {
      field: org_a_data_all_dep.department_id
    }
  }
  assert: not_null_check {
    expression: NOT is_null(${org_a_data_all_dep.department_id}) ;;
  }
}

test: dep_a_good_number_limit {
  explore_source: case21_dep_a_data {
    column: total_number { field: case21_dep_a_data.total_number }
    filters: {
      field: case21_dep_a_data.category
      value: "good"
    }
  }
  assert: number_limit {
    expression: ${case21_dep_a_data.total_number} <10000 ;;
  }
}
