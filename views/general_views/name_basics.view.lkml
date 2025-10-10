view: name_basics {

  dimension: birth_year {
    type: number
    sql: ${TABLE}.birth_year ;;
  }
  dimension: death_year {
    type: number
    sql: ${TABLE}.death_year ;;
  }
  dimension: known_for_titles {
    type: string
    sql: ${TABLE}.known_for_titles ;;
  }
  dimension: nconst {
    type: string
    sql: ${TABLE}.nconst ;;
  }
  dimension: primary_name {
    type: string
    sql: ${TABLE}.primary_name ;;
  }
  dimension: primary_profession {
    type: string
    sql: ${TABLE}.primary_profession ;;
  }
  dimension_group: timestamp_execution {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.timestamp_execution ;;
  }
  measure: count {
    type: count
    drill_fields: [primary_name]
    filters: [primary_profession:"executive"]
  }
}
