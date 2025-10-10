view: chicago_crime {
  derived_table: {
    sql: select *
             from `bigquery-public-data.chicago_crime.crime`
             -- where date>='2025-01-01'
            -- where {% condition filter_test %} primary_type {% endcondition %}
            ;;
  }

  filter: filter_test {
    type: string # string | number | date
    label: "PDT Filter on Crime Primary Type"
    description: "Help text for the filter."
    sql: {% condition filter_test %} primary_type {% endcondition %} ;;
  }

  dimension_group: earliest_date {
    type:  time
    sql:  CASE WHEN ${TABLE}.date >= ${TABLE}.updated_on THEN ${TABLE}.date ELSE ${TABLE}.updated_on END;;
    timeframes: [date, day_of_month, day_of_week, day_of_year]
  }

  dimension_group: date_difference {
    type:  duration
    group_label: "Testing Label"
    sql_start: ${TABLE}.date ;;
    sql_end: ${TABLE}.updated_on ;;
    intervals: [second,day,hour,minute,month,week]
  }

  dimension_group: date_difference_all {
    type:  duration
    sql_start: ${TABLE}.date ;;
    sql_end: ${TABLE}.updated_on ;;
    #    intervals: [second,day,hour,minute,month,week] # When intervals parameter is not specified, all intervals are included in the dimension group.
  }

  measure: count {
    type: count
    value_format: "*000000#"
  }

  measure: half_count {
    type: number
    sql: ${count}/2 ;;
    value_format_name: decimal_0
  }

  measure: year_percentile_1 {
    type: percentile
    percentile: 1
    sql: ${TABLE}.year ;;
    value_format_name: decimal_2
  }

  measure: year_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${TABLE}.year ;;
    value_format_name: decimal_2
  }

  measure: year_percentile_50 {
    type: percentile
    percentile: 50
    sql: ${TABLE}.year ;;
    value_format_name: decimal_2
  }

  measure: year_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${TABLE}.year ;;
    value_format_name: decimal_2
  }

  measure: year_percentile_99 {
    type: percentile
    percentile: 99
    sql: ${TABLE}.year ;;
    value_format_name: decimal_2
  }

  dimension: unique_key {
    type: number
    sql: ${TABLE}.unique_key ;;
  }

  dimension: case_number {
    type: string
    sql: ${TABLE}.case_number ;;
  }

  dimension_group: date {
    type: time
    sql: ${TABLE}.date ;;
    # timeframes: [date, day_of_month, day_of_week, day_of_year] # When timeframes parameter is not specified, all timeframes are included in the dimension group.
  }
  dimension_group: reporting_date {
    type: time
    group_label: "The Ultimate Reporting Date"
    #timeframes: [time, date, raw]
    sql: ${TABLE}.date ;;
  }

  dimension_group: reporting {
    type: time
    label: "Reporting"
    #timeframes: [time, date, raw]
    sql: ${TABLE}.date ;;
  }

    dimension: reporting_month_year {
      group_label: "Reporting Date"
      label: "Reporting Month + Year"
      type: string
      sql: DATE_TRUNC(${reporting_date}, MONTH) ;;
      html: {{ rendered_value | date: "%B %Y" }};;
    }

  dimension: block {
    type: string
    sql: ${TABLE}.block ;;
  }

  dimension: iucr {
    type: string
    sql: ${TABLE}.iucr ;;
  }

  dimension: primary_type {
    type: string
    sql: ${TABLE}.primary_type ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: location_description {
    type: string
    sql: ${TABLE}.location_description ;;
  }

  dimension: arrest {
    type: yesno
    sql: ${TABLE}.arrest ;;
  }

  dimension: domestic {
    type: yesno
    sql: ${TABLE}.domestic ;;
  }

  dimension: beat {
    type: number
    sql: ${TABLE}.beat ;;
  }

  dimension: district {
    type: number
    sql: ${TABLE}.district ;;
  }

  dimension: ward {
    type: number
    sql: ${TABLE}.ward ;;
  }

  dimension: community_area {
    type: number
    sql: ${TABLE}.community_area ;;
  }

  dimension: fbi_code {
    type: string
    sql: ${TABLE}.fbi_code ;;
  }

  dimension: x_coordinate {
    type: number
    sql: ${TABLE}.x_coordinate ;;
  }

  dimension: y_coordinate {
    type: number
    sql: ${TABLE}.y_coordinate ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension_group: updated_on {
    type: time
    sql: ${TABLE}.updated_on ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

}
