view: product_table {
  label: "Product Details"
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.ah_lookml_testing.product_table` ;;


  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.name ;;
  }
}
