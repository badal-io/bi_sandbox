view: taxi_trips {

  sql_table_name: `bigquery-public-data.chicago_taxi_trips.taxi_trips` ;;

  dimension: unique_key {
    primary_key: yes
    type: string
    sql: ${TABLE}.unique_key ;;
    description: "Unique identifier for the trip."
    label: "PK"
  }

  dimension: taxi_id {
    type: string
    sql: ${TABLE}.taxi_id ;;
    description: "A unique identifier for the taxi."
    label: "Taxi ID"
  }

  # Sum measures for all numeric fields
  measure: trip_count {
    type: count
    description: "Sum of trip duration in seconds."
    label: "Count"
  }

}
