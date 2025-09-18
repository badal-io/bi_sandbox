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

  ####### Link Examples #########

  dimension: type_link1 {
    label: "Type. Simple Link"
    group_label: "Link Examples"
    description: "This dimension now has a link to IMDB site. All different values of the dimension have the same link"
    type: string
    sql: ${TABLE}.type ;;
    link: {
      label: "Link to IMDB"
      url: "https://www.imdb.com/"
    }
  }

  dimension: type_link2 {
    label: "Type. Simple Link with an icon"
    group_label: "Link Examples"
    description: "This dimension now has a link to IMDB site. All different values of the dimension have the same link + they have an IMDB logo next to it"
    type: string
    sql: ${TABLE}.type ;;
    link: {
      label: "Link to IMDB"
      url: "https://www.imdb.com/"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/IMDB_Logo_2016.svg/1280px-IMDB_Logo_2016.svg.png"
    }
  }

  dimension: title_link3 {
    group_label: "Link Examples"
    label: "Title. Link to Google"
    description: "This dimension has a link attached to it that leads to google engine where the value of the dimension is searched"
    type: string
    sql: ${TABLE}.title ;;
    link: {
      label: "Search this title in Google"
      url: "https://www.google.com/search?q={{value}}"
    }
  }

  dimension: title_link4 {
    group_label: "Link Examples"
    label: "Title. Link to Google with custom label"
    description: "This dimension has a link attached to it that leads to google engine where the value of the dimension is searched + link label changes depending on the value"
    type: string
    sql: ${TABLE}.title ;;
    link: {
      label: "Search {{value}} in Google"
      url: "https://www.google.com/search?q={{value}}"
    }
  }

  dimension: type_link5 {
    label: "Type. Linked to Explore"
    group_label: "Link Examples"
    description: "This Type dimension has a link to an explore where type values is going to by applied as a filter to show all its titles"
    type: string
    sql: ${TABLE}.type ;;
    link: {
      label: "Link to a detailed explore for {{value}}"
      url: "https://badalio.ca.looker.com/explore/bi_sandbox/view_1?fields=view_1.total_value,view_1.title_link4&f[view_1.type]={{value}}&sorts=view_1.total_value+desc+0&limit=50"
    }
  }

  dimension: type_link6 {
    label: "Type. Linked to Dashboard"
    group_label: "Link Examples"
    description: "This Type dimension has a link to the Detailed report and passes Type value to Type filter on the Detailed report"
    type: string
    sql: ${TABLE}.type ;;
    link: {
      label: "Link to a Detailed report filtered by Type <{{value}}>"
      url: "https://badalio.ca.looker.com/dashboards/366?Type={{value}}&Rating=&Country="
    }
  }

  dimension: type_link7 {
    label: "Type. Linked to Dashboard with passing filters"
    group_label: "Link Examples"
    description: "This Type dimension has a link to the Detailed report and passes Type value to Type filter on the Detailed report, additionally it passes the value of filter Country from Summary dashboard to Detailed report"
    type: string
    sql: ${TABLE}.type ;;
    link: {
      label: "Link to a Detailed report filtered by Type <{{value}}>"
      url: "https://badalio.ca.looker.com/dashboards/366?Type={{value}}&Rating=&Country={{_filters['view_1.country']}}"
    }
  }


}
