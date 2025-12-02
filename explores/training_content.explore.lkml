include: "/views/training_content/**/*.view"

explore: synthetic_training_data {
  label: "Training Analysis"
}

explore: synthetic_training_data_enhanced {
  label: "Training Content Analysis"
}

explore: training_schedule {
  label: "Training Schedule"
  description: "Information about all trainings"
  view_name: training_schedule
  view_label: "Schedule"

  join: synthetic_training_data_enhanced {
    type: left_outer
    relationship: one_to_many
    sql_on: ${training_schedule.module_name} = ${synthetic_training_data_enhanced.training_topic} ;;
  }
}
