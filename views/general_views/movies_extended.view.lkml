# This view inherits title, release_year, and content_count from netflix_base
include: "/views/general_views/netflix_base.view.lkml"

view: movies_extended {
  extends: [netflix_base] # Inherit from the base view

  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.looker_demo.movie` ;;

  # Override the label of the inherited measure to make it unique
  measure: content_count {
    type: count
    label: "Movie Count"
  }

  # --- New field specific to this view ---
  dimension: movie_specific_field {
    type: string
    sql: "This is a movie" ;;
  }
}
