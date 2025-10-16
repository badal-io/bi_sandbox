view: netflix_dynamic_measures {
  sql_table_name: `@{NETFLIX_DATASET}.v_netflix_titles_enriched` ;;

# --- VIEW-LEVEL DRILL FIELDS (Default Granularity) ---
# Every measure in this view will default to drilling down to these fields,
  # unless specifically overridden at the measure level.
  drill_fields: [
    title,
    type,
    country_field,
    cast_count,
    duration_value
  ]


  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
    # The label now includes the value of the constant defined in manifest.lkml
    label: "Title (Source: @{NETFLIX_DATASET})"
    # --- Custom Link Drill-Through ---
    # Allows user to search the title on an external site (e.g., Google)
    link: {
      label: "Search Google for '{{ value }}'"
      url: "[https://www.google.com/search?q=](https://www.google.com/search?q=){{ value }}"
      icon_url: "[https://www.google.com/favicon.ico](https://www.google.com/favicon.ico)"
    }
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: duration_value {
    label: "Duration Value Dimension"
    description: "hidden dimension to make a measure"
    hidden: yes
    type: number
    sql: ${TABLE}.duration_value ;;
  }

  dimension: cast_names {
    label: "Cast Names"
    description: "The names of cast members, actors...etc"
    type: string
    sql: ${TABLE}.cast_names ;;
  }

  dimension: cast_count {
    label: "Cast Count"
    type: number
    sql: LENGTH(${cast_names}) - LENGTH(REPLACE(${cast_names}, ',', '')) + 1;;
  }

  dimension: country_field {
    label: "Country"
    type: string
    sql: ${TABLE}.country ;;

    # Clicking 'Country' will open a menu to replace the column with 'director' or 'title',
    # filtered by the selected country (e.g., all directors from USA).
    drill_fields: [
      director_field,
      title
    ]
  }
  dimension: director_field {
    label: "Director"
    type: string
    sql: ${TABLE}.director ;;
  }
  dimension: rating_field {
    label: "Rating"
    type: string
    sql: ${TABLE}.rating ;;
  }
#-----------------------DIMENSION PARAMETER------------------------------------
  parameter: dimension_parameter {
    type: unquoted
    default_value: "country_field"
    allowed_value: {
      label: "Country"
      value: "country_field"
    }
    allowed_value: {
      label: "Director"
      value: "director_field"
    }
    allowed_value: {
      label: "Rating"
      value: "rating_field"
    }
  }
#---------------------------DYNAMIC DIMENSION--------------------------

 dimension: dynamic_dimension {
    label: "Dynamic Dimension"
    sql:
    {% if dimension_parameter._parameter_value == 'country_field' %}
    ${country_field}
    {% elsif dimension_parameter._parameter_value == 'director_field' %}
    ${director_field}
    {% else %}
    ${rating_field}
    {% endif %} ;;

  # sql:
  #  CASE
  #    WHEN {% parameter dimension_parameter %} = "country_field" THEN ${country_field}
  #    WHEN {% parameter dimension_parameter %} = "director_field" THEN ${director_field}
  #    {% parameter dimension_parameter %} = "rating_field" THEN ${country_field}
  #    END ;;
}








#---------------------------------MEASURE PARAMETER----------------------------------
parameter: measure_parameter {
  type: unquoted
  default_value: "total_value"
  allowed_value: {
    label: "Total Duration"
    value: "total_value"
  }
  allowed_value: {
    label: "Average Duration"
    value: "avg_value"
  }
  allowed_value: {
    label: "Total Cast Members"
    value: "total_cast"
  }
  allowed_value: {
    label: "Average Cast Members"
    value: "avg_cast"
  }
}

#-----------------------------------DYNAMIC MEASURE-----------------------

  measure: dynamic_measure {
    label: "Dynamic Measure"
    type: number
    sql:
        {% if measure_parameter._parameter_value == 'total_value' %}
          ${total_value}
        {% elsif measure_parameter._parameter_value == 'avg_value' %}
          ${avg_value}
        {% elsif measure_parameter._parameter_value == 'total_cast' %}
        ${total_cast}
        {% elsif measure_parameter._parameter_value == 'avg_cast' %}
        ${avg_cast}
        {% else %}
          100
        {% endif %};;
    value_format: "#,##0"
  }

#measure: dynamic_cast_measure {
 # label: "Dynamic Cast Members"
 # type: number
 # sql:
 #     {% if measure_parameter._parameter_value == 'total_cast' %}
  #      ${total_cast}
  #    {% elsif measure_parameter._parameter_value == 'avg_cast' %}
  #      ${avg_cast}
   #   {% else %}
   #     100
  #    {% endif %};;
 # value_format: "#,##0"
#}



#---------------------------------MEASURES----------------------------------------
  measure: total_value {
    label: "Duration Value"
    description: "Duration period"
    type: sum
    sql: ${duration_value} ;;
    # --- Measure-Level Drill Override ---
    # This overrides the View-level drill_fields to show specific duration-related detail.
    drill_fields: [
      duration_value,
      cast_names
    ]
  }

  measure: avg_value {
    label: "Average Value"
    description: "Duration period"
    type: average
    sql: ${duration_value} ;;
  }

  measure: total_cast {
    type: sum
    sql: ${cast_count} ;;

    # The default drill fields are inherited from the view level, but we add a custom link
    link: {
      label: "Explore Top 50 Longest Titles"
      # Appends standard URL parameters:
      # &limit=50      -> Limits the rows to 50
      # &sorts=...desc -> Sorts by duration_value descending
      url: "{{ link }}&limit=50&sorts=netflix_dynamic_measures.duration_value+desc"
    }
  }

measure: avg_cast {
  label: "Average Cast Members"
  type: average
  sql: ${cast_count} ;;
}
}
