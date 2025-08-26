view: case21_dep_b_data {
  sql_table_name: `looker_foundation_test.case21_dep_b_data` ;;

  dimension: category {
    label: "Category"
    description: "description"
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension_group: date {
    label: "Date"
    description: "description"
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: name {
    label: "Name"
    description: "description"
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: number {
    label: "Number"
    description: "description"
    type: number
    sql: ${TABLE}.number ;;
  }
  measure: count {
    label: "Count"
    description: "description"
    type: count
    drill_fields: [name]
  }
}
