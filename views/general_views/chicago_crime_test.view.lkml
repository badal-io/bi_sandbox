view: chicago_crime_test {
  derived_table: {
    sql: select
          primary_type
          count(*) as cnt
          from `bigquery-public-data.chicago_crime.crime`
          where date>='2025-01-01'
          group by 1
            ;;
  }

  dimension: cnt {
    label: "count"
    description: "hidden count"
    hidden: yes
    type: number
    sql: ${TABLE}.cnt ;;
  }

  measure: total_count {
    label: "Total Count"
    description: "Number of rows"
    type: sum
    sql: ${cnt} ;;
  }

  dimension: primary_type {
    label: "Primary TYPE"
    description: "Type which is primary"
    type: string
    sql: ${TABLE}.primary_type ;;
  }
}
