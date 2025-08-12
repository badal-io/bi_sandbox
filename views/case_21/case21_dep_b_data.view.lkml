view: case21_dep_b_data {
  sql_table_name: `looker_foundation_test.case21_dep_b_data` ;;

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: number {
    type: number
    sql: ${TABLE}.number ;;
  }
  measure: count {
    type: count
    drill_fields: [name]
  }
}
