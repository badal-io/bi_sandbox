view: orders {

    sql_table_name: public.orders ;;

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }


    dimension: status {
      type: string
      sql: ${TABLE}.status ;;

    }

    dimension_group: created {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.created_at ;;
    }


    dimension: amount {
      type: number
      sql: ${TABLE}.amount ;;
    }

    measure: count {
      type: count
      drill_fields: [id, created_date, status, customer.name]
    }

    measure: total_sales {
      type: sum
      sql: ${amount} ;;
    }


    measure: average_order_value {
      type: average
      sql: ${amount} ;;
    }

    measure: max_order_amount {
      type: max
      sql: ${amount} ;;
    }

 }
