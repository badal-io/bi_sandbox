view: evg_incremental_summary {
  derived_table: {
    sql: SELECT * FROM `prj-s-dlp-dq-sandbox-0b3c.dbt_Evgenii.incremental_summary`;;
  }

  measure: count {
    label: "COUNT"
    type: count
  }

  dimension: label {
    label: "LABEL"
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension_group: dbt_load_timestamp {
    label: "DBT LOAD TIMESTAMP"
    type: time
    sql: ${TABLE}.dbt_load_timestamp ;;
  }

  dimension: id_count {
    label: "ID COUNT"
    type: number
    sql: ${TABLE}.id_count ;;
  }

  dimension: number_categories {
    label: "NUMBER CATEGORIES"
    type: number
    sql: ${TABLE}.number_categories ;;
  }

  dimension: total_cnt {
    label: "TOTAL CNT"
    hidden: yes
    type: number
    sql: ${TABLE}.total_cnt ;;
  }

  dimension: total_value {
    label: "TOTAL VALUE"
    hidden: yes
    type: number
    sql: ${TABLE}.total_value ;;
  }

  dimension: flag_color {
    label: "FLAG COLOR"
    type: string
    sql: case when ${id_count}<100 then "blue" else "red" end ;;
  }

  dimension: button_taxi {
    label: "BUTTON TAXI"
    type: string
    sql: "Go to Taxi Trips" ;;
    link: {
      label: "Go to Taxi Trips Dashboard"
      url: "/dashboards/319?Dbt+Load+Timestamp+Date=&Flag.+Color={{ _filters['evg_incremental_summary.flag_color'] | url_encode }}"
    }
  }

  dimension: button_taxi_image {
    label: "BUTTON TAXI IMAGE"
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
    label: "REPORTING TOTAL CNT"
    value_format: "#,##0"
    sql: ${total_cnt} ;;
  }

  measure: reporting_total_value {
    type: sum
    label: "REPORTING TOTAL VALUE"
    value_format: "#,##0"
    sql: ${total_value} ;;
  }

}
