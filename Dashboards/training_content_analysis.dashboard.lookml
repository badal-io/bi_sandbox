- dashboard: training_analysis_dashboard
  title: Training Analysis Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Comprehensive analysis of training effectiveness, call transcript topics, and module utilization'

  filters:
  - name: lob_filter
    title: Line of Business (LOB)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    explore: synthetic_training_data_enhanced
    field: synthetic_training_data_enhanced.lob

  - name: department_filter
    title: Department
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    explore: synthetic_training_data_enhanced
    field: synthetic_training_data_enhanced.department

  - name: language_filter
    title: Language
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
    explore: synthetic_training_data_enhanced
    field: synthetic_training_data_enhanced.language


  - name: agent_manager_filter
    title: Agent Manager
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    explore: synthetic_training_data_enhanced
    field: synthetic_training_data_enhanced.agent_manager

  elements:

  # ============================================================================
  # SECTION 1: KEY METRICS OVERVIEW
  # ============================================================================

  - name: total_calls
    title: Total Calls
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [synthetic_training_data_enhanced.count]

    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 0
    width: 4
    height: 3

  - name: repeat_call_rate
    title: Repeat Call Rate
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [repeat_call_percentage]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Call Percentage
      value_format: '#,##0.00\%'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_call_percentage
      type: percent_of_total
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 4
    width: 4
    height: 3

  - name: retention_success_rate
    title: Retention Call Rate
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [retention_call_percentage]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Retention Call Percentage
      value_format: '#,##0.00\%'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_call_percentage
      type: percent_of_total
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'

    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 8
    width: 4
    height: 3

  - name: sales_success_rate
    title: Sales Call Rate
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [sales_call_percentage]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Sales Call Percentage
      value_format: '#,##0.00\%'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_call_percentage
      type: percent_of_total
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'

    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 12
    width: 4
    height: 3

  - name: avg_call_duration
    title: Average Call Duration (minutes)
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [avg_duration]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Average Duration
      value_format: '#,##0.00'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number

    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 16
    width: 4
    height: 3

  - name: unique_training_modules
    title: Unique Training Modules
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [module_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Module Count
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.training_topic
      _kind_hint: measure
      measure: module_count
      type: count_distinct
      _type_hint: number

    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 0
    col: 20
    width: 4
    height: 3

  # ============================================================================
  # SECTION 2: TRAINING MODULE EFFECTIVENESS ANALYSIS
  # ============================================================================

  - name: training_module_comparison
    title: Training Module Comparison with Call Frequency
    note_text: 'Shows how often training modules are referenced in actual calls. High frequency = high value topics. Low frequency = potentially unnecessary content.'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
             synthetic_training_data_enhanced.lob, synthetic_training_data_enhanced.department,
             avg_training_duration, repeat_calls, retention_calls, sales_calls]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Average Training Duration
      value_format: '#,##0.00'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.training_duration
      _kind_hint: measure
      measure: avg_training_duration
      type: average
      _type_hint: number
    - category: measure
      expression: ''
      label: Repeat Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: measure
      expression: ''
      label: Retention Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: measure
      expression: ''
      label: Sales Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields: [synthetic_training_data_enhanced.count]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 3
    col: 0
    width: 24
    height: 8

  - name: high_frequency_modules
    title: High Frequency Training Modules (Top 15)
    note_text: 'Training modules most frequently referenced in calls - high value priority topics'
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      synthetic_training_data_enhanced.count: "#1f78b4"
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 11
    col: 0
    width: 12
    height: 8

  - name: low_frequency_modules
    title: Low Frequency Training Modules (Bottom 15)
    note_text: 'Training modules rarely referenced in calls - potentially unnecessary content that should be evaluated for e-learning or video alternatives'
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical2
    series_colors:
      synthetic_training_data_enhanced.count: "#e31a1c"
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 11
    col: 12
    width: 12
    height: 8

  # ============================================================================
  # SECTION 3: TOPIC ANALYSIS (PRIMARY AND SECONDARY)
  # ============================================================================

  - name: primary_topic_distribution
    title: Primary Topic Distribution
    note_text: 'Main topics discussed in calls - helps identify critical topics for training focus'
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors: {}
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 19
    col: 0
    width: 12
    height: 8

  - name: secondary_topic_distribution
    title: Secondary Topic Distribution (Sub-categories)
    note_text: 'Sub-categories of call topics - provides deeper level analysis as requested in BRD'
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.secondary_topic, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical2
    series_colors: {}
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 19
    col: 12
    width: 12
    height: 8

  - name: topic_mapping_to_training
    title: Call Topics Mapped to Training Modules
    note_text: 'Shows which call topics are covered by which training modules - helps identify gaps'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.secondary_topic,
             synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
             repeat_calls, retention_calls, sales_calls]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: measure
      expression: ''
      label: Retention Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: measure
      expression: ''
      label: Sales Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields: [synthetic_training_data_enhanced.count]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 27
    col: 0
    width: 24
    height: 8

  # ============================================================================
  # SECTION 4: TRAINING IMPACT ON KPIs
  # ============================================================================

  - name: training_impact_on_repeats
    title: Training Module Impact on Repeat Calls
    note_text: 'Identifies which training modules correlate with high repeat call rates - indicates potential training gaps'
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, repeat_call_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Total Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.count
      _kind_hint: measure
      measure: total_calls
      type: count
      _type_hint: number
    - category: measure
      expression: ''
      label: Repeat Call Count
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_call_count
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: table_calculation
      expression: "${repeat_call_count}/${total_calls}"
      label: Repeat Rate
      value_format: '#,##0.0%'
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: repeat_call_rate
      _type_hint: number

    sorts: [repeat_call_rate desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    y_axes: [{label: '', orientation: left, series: [{axisId: repeat_call_rate, id: repeat_call_rate,
            name: Repeat Rate}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [total_calls, repeat_call_count]
    series_colors:
      repeat_call_rate: "#e31a1c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 35
    col: 0
    width: 8
    height: 8

  - name: training_impact_on_retention
    title: Training Module Impact on Retention Success
    note_text: 'Shows which training modules correlate with retention call success/failure'
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, retention_call_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Total Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.count
      _kind_hint: measure
      measure: total_calls
      type: count
      _type_hint: number
    - category: measure
      expression: ''
      label: Retention Call Count
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_call_count
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: table_calculation
      expression: "${retention_call_count}/${total_calls}"
      label: Retention Rate
      value_format: '#,##0.0%'
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: retention_rate
      _type_hint: number

    sorts: [retention_rate desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    y_axes: [{label: '', orientation: left, series: [{axisId: retention_rate, id: retention_rate,
            name: Retention Rate}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [total_calls, retention_call_count]
    series_colors:
      retention_rate: "#33a02c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 35
    col: 8
    width: 8
    height: 8

  - name: training_impact_on_sales
    title: Training Module Impact on Sales Success
    note_text: 'Shows which training modules correlate with sales call success/failure'
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, sales_call_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Total Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.count
      _kind_hint: measure
      measure: total_calls
      type: count
      _type_hint: number
    - category: measure
      expression: ''
      label: Sales Call Count
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_call_count
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
    - category: table_calculation
      expression: "${sales_call_count}/${total_calls}"
      label: Sales Rate
      value_format: '#,##0.0%'
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: sales_rate
      _type_hint: number

    sorts: [sales_rate desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    y_axes: [{label: '', orientation: left, series: [{axisId: sales_rate, id: sales_rate,
            name: Sales Rate}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [total_calls, sales_call_count]
    series_colors:
      sales_rate: "#1f78b4"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 35
    col: 16
    width: 8
    height: 8

  # ============================================================================
  # SECTION 5: LOB AND DEPARTMENT ANALYSIS
  # ============================================================================

  - name: calls_by_lob_department
    title: Call Volume by LOB and Department
    note_text: 'Grouped call transcripts by Line of Business and Department as required'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.lob, synthetic_training_data_enhanced.department,
             synthetic_training_data_enhanced.count, repeat_calls, retention_calls, sales_calls,
             avg_duration]
    pivots: []
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: measure
      expression: ''
      label: Retention Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: measure
      expression: ''
      label: Sales Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
    - category: measure
      expression: ''
      label: Average Duration
      value_format: '#,##0.00'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields: [synthetic_training_data_enhanced.count]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 43
    col: 0
    width: 24
    height: 8

  - name: lob_heatmap
    title: Training Topics by LOB (Heatmap)
    note_text: 'Visual representation of training topic distribution across LOBs'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.lob, synthetic_training_data_enhanced.training_topic,
             synthetic_training_data_enhanced.count]
    pivots: [synthetic_training_data_enhanced.training_topic]

    sorts: [synthetic_training_data_enhanced.count desc 0, synthetic_training_data_enhanced.training_topic]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_sequential1
        options:
          steps: 5
      bold: false
      italic: false
      strikethrough: false
      fields: []
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 51
    col: 0
    width: 24
    height: 8

  # ============================================================================
  # SECTION 6: LANGUAGE AND BILINGUAL SUPPORT
  # ============================================================================

  - name: language_distribution
    title: Call Distribution by Language
    note_text: 'English and French language support as required in BRD'
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.language, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      en-US: "#1f78b4"
      Fr-fr: "#e31a1c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 59
    col: 0
    width: 8
    height: 6

  - name: training_by_language
    title: Training Module Usage by Language
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
             synthetic_training_data_enhanced.language]
    pivots: [synthetic_training_data_enhanced.language]

    sorts: [synthetic_training_data_enhanced.count desc 0, synthetic_training_data_enhanced.language]
    limit: 15
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      en-US - synthetic_training_data_enhanced.count: "#1f78b4"
      Fr-fr - synthetic_training_data_enhanced.count: "#e31a1c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 59
    col: 8
    width: 16
    height: 6

  # ============================================================================
  # SECTION 7: AGENT PERFORMANCE ANALYSIS
  # ============================================================================

  - name: agent_performance_summary
    title: Agent Performance Summary by Manager
    note_text: 'Agent performance metrics filtered by manager to help improve agent KPIs'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.agent_manager, synthetic_training_data_enhanced.agent_name,
             synthetic_training_data_enhanced.count, repeat_calls, retention_calls, sales_calls,
             avg_duration]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: measure
      expression: ''
      label: Retention Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: measure
      expression: ''
      label: Sales Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
    - category: measure
      expression: ''
      label: Average Duration
      value_format: '#,##0.00'
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number
    - category: table_calculation
      expression: "${repeat_calls}/${synthetic_training_data_enhanced.count}"
      label: Repeat Rate
      value_format: '#,##0.0%'
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: repeat_call_rate
      _type_hint: number

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields: [repeat_call_rate]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 65
    col: 0
    width: 24
    height: 8

  # ============================================================================
  # SECTION 8: TIME-BASED TRENDS
  # ============================================================================

  - name: call_trends_over_time
    title: Call Volume Trends Over Time
    note_text: 'Temporal analysis of call patterns'
    explore: synthetic_training_data_enhanced
    type: looker_line
    fields: [synthetic_training_data_enhanced.coversation_date, synthetic_training_data_enhanced.count,
             repeat_calls, retention_calls, sales_calls]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.repeat_call
      _kind_hint: measure
      measure: repeat_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.repeat_call: 'Yes'
    - category: measure
      expression: ''
      label: Retention Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.retention_call
      _kind_hint: measure
      measure: retention_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.retention_call: 'Yes'
    - category: measure
      expression: ''
      label: Sales Calls
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'

    sorts: [synthetic_training_data_enhanced.coversation_date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      synthetic_training_data_enhanced.count: "#1f78b4"
      repeat_calls: "#e31a1c"
      retention_calls: "#33a02c"
      sales_calls: "#ff7f00"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 73
    col: 0
    width: 24
    height: 8

  # ============================================================================
  # SECTION 9: CRITICAL SKILLS GAP ANALYSIS
  # ============================================================================

  - name: missing_training_coverage
    title: Call Topics with No Training Coverage
    note_text: 'Identifies critical topics present in calls but missing or underrepresented in training modules'
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.secondary_topic,
             synthetic_training_data_enhanced.count, training_modules_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Training Modules Count
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.training_topic
      _kind_hint: measure
      measure: training_modules_count
      type: count_distinct
      _type_hint: number

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields: [synthetic_training_data_enhanced.count]
    - type: along a scale...
      value_format:
      background_color:
      font_color:
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging2
      bold: false
      italic: false
      strikethrough: false
      fields: [training_modules_count]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 81
    col: 0
    width: 24
    height: 8

  # ============================================================================
  # SECTION 10: CALL TYPE ANALYSIS
  # ============================================================================

  - name: inbound_vs_outbound
    title: Inbound vs Outbound Call Distribution
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.call_type, synthetic_training_data_enhanced.count]

    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      inbound: "#1f78b4"
      outbound: "#33a02c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 89
    col: 0
    width: 8
    height: 6

  - name: call_type_by_training
    title: Training Module Application by Call Type
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
             synthetic_training_data_enhanced.call_type]
    pivots: [synthetic_training_data_enhanced.call_type]

    sorts: [synthetic_training_data_enhanced.count desc 0, synthetic_training_data_enhanced.call_type]
    limit: 15
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors:
      inbound - synthetic_training_data_enhanced.count: "#1f78b4"
      outbound - synthetic_training_data_enhanced.count: "#33a02c"
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      language_filter: synthetic_training_data_enhanced.language
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
    row: 89
    col: 8
    width: 16
    height: 6
