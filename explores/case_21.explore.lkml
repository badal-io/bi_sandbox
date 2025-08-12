include: "/views/case_21/**/*.view"

datagroup: lf_case21_dep_all_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: lf_case21_dep_all_default_datagroup

explore: org_a_data_all_dep {
  sql_always_where:
    {% if _user_attributes['dep_user_access'] == "Basic" %}
    ${org_a_data_all_dep.department} = "dep_A"
    {% elsif _user_attributes['dep_user_access'] == "Advanced" %}
    ${org_a_data_all_dep.department} in  ("dep_A","dep_C")
    {% elsif _user_attributes['dep_user_access'] == "Full" %}
    ${org_a_data_all_dep.department} in  ("dep_A","dep_B","dep_C")
    {% else %}
    ${org_a_data_all_dep.department}=""
    {% endif %}
  ;;
}

explore: case21_dep_a_data {}

explore: case21_dep_b_data {}
