view: evg_incremental_summary {
  derived_table: {
    sql: SELECT * FROM `prj-s-dlp-dq-sandbox-0b3c.dbt_Evgenii.incremental_summary`;;
  }

  measure: count {
    type: count
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension_group: dbt_load_timestamp {
    type: time
    sql: ${TABLE}.dbt_load_timestamp ;;
  }

  dimension: id_count {
    type: number
    sql: ${TABLE}.id_count ;;
  }

  dimension: number_categories {
    type: number
    sql: ${TABLE}.number_categories ;;
  }

  dimension: total_cnt {
    hidden: yes
    type: number
    sql: ${TABLE}.total_cnt ;;
  }

  dimension: total_value {
    hidden: yes
    type: number
    sql: ${TABLE}.total_value ;;
  }

  dimension: flag_color {
    label: "Flag. Color"
    type: string
    sql: case when ${id_count}<100 then "blue" else "red" end ;;
  }

  dimension: button_taxi {
    label: "Button Text to Taxi Trips"
    type: string
    sql: "Go to Taxi Trips" ;;
    link: {
      label: "Go to Taxi Trips Dashboard"
      url: "/dashboards/319?Dbt+Load+Timestamp+Date=&Flag.+Color={{ _filters['evg_incremental_summary.flag_color'] | url_encode }}"
    }
  }

  dimension: button_taxi_image {
    label: "Button Image to Taxi Trips"
    type: string
    sql: "Go to Taxi Trips" ;;
    link: {
      label: "Go to Taxi Trips Dashboard"
      url: "/dashboards/319?Dbt+Load+Timestamp+Date=&Flag.+Color={{ _filters['evg_incremental_summary.flag_color'] | url_encode }}"
    }
    html: <img src="https://w7.pngwing.com/pngs/247/15/png-transparent-arrow-arrow-angle-triangle-black-thumbnail.png", style="max-width: 15%;"/> ;;
  }

  ############ MEASURES ############

  measure: reporting_total_cnt {
    type: sum
    label: "Total Cnt"
    value_format: "#,##0"
    sql: ${total_cnt} ;;
  }

  measure: reporting_total_value {
    type: sum
    label: "Total Value"
    value_format: "#,##0"
    sql: ${total_value} ;;
  }

}
