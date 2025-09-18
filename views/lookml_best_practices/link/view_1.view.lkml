view: view_1 {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.looker_demo.v_netflix_titles_enriched` ;;

  dimension: country {
    label: "Country"
    description: "Country name"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: duration_unit {
    label: "Duration Unit"
    description: "Duration unit, like minutes, seasons, hours, etc"
    type: string
    sql: ${TABLE}.duration_unit ;;
  }

  dimension: title {
    label: "Title"
    description: "Item title like for movies or tv shows"
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: type {
    label: "Type"
    description: "Type of the itme: movies or tv shows"
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: rating {
    label: "Rating"
    description: "Rating of the show or movie (G, PG-13, TV-Y, etc)"
    type: string
    sql: ${TABLE}.rating ;;
  }

  dimension: duration_value {
    label: "Durantion Value Dimension"
    description: "hidden dimension to make a measure"
    hidden: yes
    type: number
    sql: ${TABLE}.duration_value ;;
  }

  measure: total_value {
    label: "Duration Value"
    description: "Duration period"
    type: sum
    sql: ${duration_value} ;;
  }


}
