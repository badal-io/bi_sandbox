view: biglake {
  derived_table: {
    sql: SELECT * FROM `prj-s-dlp-dq-sandbox-0b3c.dlp.biglake_test` ;;
  }

  measure: count {
    label: "No. of Accounts"
    description: " Counting the number of IDs"
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: id_img {
    type: string
    sql: ${TABLE}.id ;;
    #html: <img src="https://www.brettcase.com/product_images/{{ value }}.jpg"/> ;;
    html: <img src="https://pbs.twimg.com/profile_images/779305023507271681/GJJhYpD2_400x400.jpg"/> ;;
  }

  dimension: data {
    type: string
    sql: ${TABLE}.data ;;
  }

  dimension: created_at {
    type: string
    sql: ${TABLE}.created_at ;;
  }

  set: detail {
    fields: [
      id,
      data,
      created_at
    ]
  }
}
