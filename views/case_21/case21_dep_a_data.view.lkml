view: case21_dep_a_data {
  sql_table_name: `looker_foundation_test.case21_dep_a_data` ;;

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


  dimension: flag {
    label: "Flag"
    description: "description"
    type: number
    sql: ${TABLE}.flag ;;
  }

  dimension: number {
    label: "Number"
    description: "description"
    type: number
    sql: ${TABLE}.number ;;
  }


  measure: total_number {
    label: "Total Number"
    description: "description"
    type: sum
    sql: ${number} ;;
  }


  measure: count {
    label: "Count"
    description: "description"
    type: count
  }

}
