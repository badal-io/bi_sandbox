include: "/views/general_views/**/*.view"

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

explore: name_basics{
  label: "Name Basics"
  group_label: "Test Explores"
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
  view_name: tv_shows_extended  # CRITICAL FIX: The base explore must explicitly use 'view_name'.
  extension: required
  label: "Base Content"

  # This join will be inherited by any Explore that extends this one.
  # It uses the 'show_id' field which exists in both tables.
  join: movies_extended {
    type: left_outer
    sql_on: ${tv_shows_extended.show_id} = ${movies_extended.show_id} ;;
    relationship: one_to_one
  }
}

# --- Extending Explore (Visible to users) ---
explore: netflix_extended_explore {
  extends: [netflix_base_explore]
  from: tv_shows_extended # The extending explore must still declare its base view.
  label: "Netflix Content Extended"

  # This Explore automatically includes the 'movies_extended' join from the base.
  # The 'label' above overrides the 'Base Content' label.
}



 #--------------Conditionally Filter Example-----------------------------------------------
#explore: main_table {
#label: "Product and Category Analysis"
#description: "This is the main_table explore that I have joined the category_table view to"

# Applies this filter to every query...
#conditionally_filter: {
#  filters: [product_table.name: "B"]
#  # ...UNLESS the user filters on the 'id' field
#  unless: [main_table.id]
#}
#
#join: category_table {
#  sql_on: ${main_table.category_id} = ${category_table.id} ;;
#  relationship: many_to_one
#  type: left_outer
#  fields: [category_table.name]
#}
#
#join: product_table {
#  sql_on: ${main_table.product_id} = ${product_table.id} ;;
#  type: left_outer
#  relationship: many_to_one
#}
#}

#------------------SQL Always Having Example-----------------------------------------

#explore: main_table {
#label: "Product and Category Analysis"
#description: "This is the main_table explore that I have joined the category_table view to"

# Applies this filter after aggregation
#sql_always_having: ${total_sales} > 100 ;;

#join: category_table {
#  sql_on: ${main_table.category_id} = ${category_table.id} ;;
#  relationship: many_to_one
#  type: left_outer
#  fields: [category_table.name]
#}

#join: product_table {
#  sql_on: ${main_table.product_id} = ${product_table.id} ;;
#  type: left_outer
#  relationship: many_to_one
#}
#}
# make sure to create a measure first , as sql always having must be applied on measures like type sum value

#-------------------------SQL Alway Where Example------------------------------
#explore: main_table {
#label: "Product and Category Analysis"
#description: "This is the main_table explore that I have joined the category_table view to"

# Applies this filter to every row before aggregation
#sql_always_where: ${main_table.color} = 'red' ;;

#join: category_table {
#  sql_on: ${main_table.category_id} = ${category_table.id} ;;
#  relationship: many_to_one
#  type: left_outer
#  fields: [category_table.name]
#}

#join: product_table {
#  sql_on: ${main_table.product_id} = ${product_table.id} ;;
#  type: left_outer
#  relationship: many_to_one
#}
#}
