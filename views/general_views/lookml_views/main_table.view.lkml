view: main_table {
  label: "Product Details"
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.ah_lookml_testing.main_table`;;

  dimension: id {
    primary_key: yes
    #hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: category_id {
    #hidden: yes
    type: number
    sql: ${TABLE}.category_id ;;
  }

  dimension: product_id {
    label: "Product ID"
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: color {
    label: "Product Color"
    type: string
    sql: ${TABLE}.color ;;
  }

  measure: value {
    label: "Product value"
    type: sum
    sql: ${TABLE}.value ;;
  }
}
