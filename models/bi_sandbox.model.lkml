connection: "badal_internal_projects"

include: "/explores/*"
include: "/views/*"                # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: world_population_by_country_2023 {
  label: "first explore for the World Population"
  persist_with: world_population_total

  join: world_country_stats {
    type: left_outer
    relationship: one_to_one
    sql_on: ${world_population_by_country_2023.country} = ${world_country_stats.country} ;;
  }

}
# max_cache_age: Specifies a string that defines a time period.
# When the age of a query's cache exceeds the time period,
# Looker invalidates the cache. The next time the query is issued,
# Looker sends the query to the database for fresh results.

datagroup: world_population_total {
  max_cache_age: "24 hours"
  sql_trigger: SELECT sum(population) FROM `prj-s-dlp-dq-sandbox-0b3c.Ilya_looker.world_population_by_country_2023`  ;;
  interval_trigger: "12 hours"
  label: "world_population_total"
  description: "description string"
}


explore: world_population_derived {
  label: "World Population_dervied"
}
