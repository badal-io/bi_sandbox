view: category_table {
  label: "Product Categories"
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.ah_lookml_testing.category_table` ;;

  dimension: id {
    primary_key: yes
    #hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    label: "Category Name"
    type: string
    sql: ${TABLE}.name ;;
  }
}
