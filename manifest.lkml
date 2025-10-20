project_name: "bi_sandbox"


local_dependency: {
  project: "dbt-internal-framework"
}

constant: NETFLIX_DATASET {
  # This value is the project/dataset path that will be substituted in your view files.
  value: "prj-s-dlp-dq-sandbox-0b3c.looker_demo"
  export: override_optional
}

visualization: {
  id: "spider-marketplace-dev"
  label: "Spider Viz"
  url: "https://marketplace-api.looker.com/viz-dist/spider.js"
  sri_hash: "oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"
  dependencies: ["https://code.jquery.com/jquery-2.2.4.min.js","https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.9.1/underscore-min.js","https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js","https://cdnjs.cloudflare.com/ajax/libs/d3-legend/1.13.0/d3-legend.min.js"]
}




# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }
