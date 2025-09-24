view: html_view {
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

  ####### HTML Examples #########

  measure: total_value_html1 {
    label: "Duration Value. Formatted"
    description: "Duration value formatted with html"
    type: sum
    sql: ${duration_value} ;;
    html:
    <ul>
    <li> value: {{ value }} </li>
    <li> rendered_value: {{ rendered_value }} </li>
    <li> model: {{ _model._name }} </li>
    </ul> ;;
  }

  dimension: type_html2 {
    label: "Type. Formatted background"
    description: "Type of the item: movies or tv shows with different background colors depending on the value"
    type: string
    sql: ${TABLE}.type ;;
    html: {% if value == 'Movie' %}
    <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'TV Show' %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: type_html3 {
    label: "Type. Formatted with icons"
    description: "Type of the item: movies or tv shows with different icons next to the value depending on the value"
    type: string
    sql: ${TABLE}.type ;;
    html: {% if value == 'Movie' %}
          <p><img src="https://images.freeimages.com/image/previews/58c/movie-reel-tape-icon-5693177.png?fmt=webp&h=350" alt="" height="20" width="20">{{ rendered_value }}</p>
          {% elsif value == 'TV Show' %}
          <p><img src="https://images.freeimages.com/clg/images/16/161616/tv_f?fmt=webp&h=350" alt="" height="20" width="20">{{ rendered_value }}</p>
          {% else %}
          <p><img src="https://findicons.com/files/icons/573/must_have/48/check.png" alt="" height="20" width="20">{{ rendered_value }}</p>
          {% endif %}
          ;;
  }

}
