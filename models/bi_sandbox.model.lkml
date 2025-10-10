connection: "badal_internal_projects"


include: "/explores/case_21.explore"
include: "/explores/general_views.explore"

#including dashboard files


#including dlp files from dbt_internal_framwork project
include: "//dbt-internal-framework/views/dlp/*.view.lkml"

  #join: product_table {
  #  sql_on: ${main_table.product_id} = ${product_table.id} ;;
  #  relationship: many_to_on
  #always_filter: {
    #filters: [category_table.name: "A,"B","C"]
  #}
   # type: left_outer
 # }
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

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
