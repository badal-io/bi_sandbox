include: "/views/general_views/**/*.view"
include: "/views/lookml_best_practices/**/*.view"

explore: evg_incremental_summary {
  label: "Incremental Summary"
}

explore: evg_taxi_trips_snapshot {
  label: "Taxi Trips Snapshot"
}

explore: chicago_crime {
  label: "Chicago Crime"
}

explore: v_netflix_titles_enriched {
  label: "Netflix Titles"
}

explore: netflix_dynamic_measures {
  label: "Dynamic Netflix Measures "
}

explore: netflix_dynamic_movie_tvshow {
  label: "Dynamic Netflix User Attributes "
}
explore: biglake{
  label: "Big Lake Test"
}

explore: table_1 {
  label: "Main + Category"
  group_label: "Test Explores"
  view_label: "Main"
  from: main_table
  join: table_2 {
    view_label: "Category"
    from: category_table
    sql_on: ${table_2.id} = ${table_1.category_id};;
    relationship: many_to_one
    type: left_outer
  }
}

explore: main_table {
  label: "Product and Category analysis"
  description: "This is the main_table explore that I have joined the category_table view to"
  view_label: "Field Picker title "
  group_label: "Test Explores"
  always_filter: {
    filters: [product_table.name: "A,B,C"]
  }
  join: category_table {
    sql_on: ${main_table.category_id} = ${category_table.id} ;;
    relationship: many_to_one
    type: left_outer
    fields: [category_table.name]
  }
  join: product_table {
    sql_on: ${main_table.product_id} = ${product_table.id} ;;
    type: left_outer
    relationship: many_to_one
  }
}

# --- Base Explore ---
# This Explore is based on our extended movie view.
explore: movies_base {
  from: movies_extended
  description: "A simple base for analyzing movie data."
}

# --- Extending Explore ---
# This new Explore inherits everything from 'movies_base' but overrides the label.
explore: movies_analysis {
  extends: [movies_base]
  label: "In-Depth Movie Analysis" # Overrides the default label 'Movies Base'
}

#--- Base Explore (Not visible to users) ---
explore: netflix_base_explore {
  view_name: tv_shows_extended
  extension: required
  label: "Base Content"
  join: movies_extended {
    type: left_outer
    sql_on: ${tv_shows_extended.show_id} = ${movies_extended.show_id} ;;
    relationship: one_to_one
  }
}

# --- Extending Explore (Visible to users) ---
explore: netflix_extended_explore {
  extends: [netflix_base_explore]
  from: tv_shows_extended
  label: "Netflix Content Extended"
}

explore: list_of_ids {
  # add for test purpose only
  join: list_of_ids_2 {
    from: list_of_ids
    type: left_outer
    sql_on: ${list_of_ids.id} = ${list_of_ids_2.id} ;;
    relationship: many_to_many
  }
  label: "List of IDs"
}

explore: view_1 {
  label: "Explore with an example of Linking"
}

explore: html_view {
  label: "Explore with an example of HTML use"
}
