view: case21_dep_a_data {
  sql_table_name: `looker_foundation_test.case21_dep_a_data` ;;

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
  dimension: flag {
    type: number
    sql: ${TABLE}.flag ;;
  }
  dimension: number {
    type: number
    sql: ${TABLE}.number ;;
  }

  measure: total_number {
    type: sum
    sql: ${number} ;;
  }

  measure: count {
    type: count
  }
}
