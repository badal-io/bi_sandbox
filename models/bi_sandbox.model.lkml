connection: "badal_internal_projects"

include: "/explores/case_21.explore"
include: "/explores/general_views.explore"
include: "/explores/training_content.explore"



# --- MERGED INCLUDES ---

# Including dashboard files and data tests
include: "/data_tests/*"
include: "/demo_lookml.dashboard.lookml"
include: "/Dashboards/netflix_base.dashboard.lookml"
include: "/Dashboards/netflix_extended.dashboard.lookml"
# Including dlp files from dbt_internal_framework project
include: "//dbt-internal-framework/views/dlp/*.view.lkml"
include: "/Dashboards/Training_analysis.dashboard.lookml"
include: "/Dashboards/training_content_analysis.dashboard.lookml"


# --- END MERGED INCLUDES ---

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

datagroup: month_end_datagroup {
  sql_trigger: SELECT EXTRACT( MONTH FROM CURRENT_DATE());;
  description: "Triggered on the last day of each month"
}

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
