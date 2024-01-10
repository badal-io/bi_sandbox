connection: "badal_internal_projects"

include: "/explores/*"
include: "/views/*"                # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: world_population_by_country_2023 {
  label: "first explore for the World Population"

  join: world_country_stats {
    type: left_outer
    relationship: one_to_one
    sql_on: ${world_population_by_country_2023.country} = ${world_country_stats.country} ;;
  }
}
