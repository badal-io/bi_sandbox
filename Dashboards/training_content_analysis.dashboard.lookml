---
- dashboard: training_analysis__analyse_de_la_formation_v2
  title: Training Analysis / Analyse de la Formation V2
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Comprehensive analysis of training effectiveness, call transcript topics,
    and module utilization
  preferred_slug: ThKERrivCzGpUEZuIuhRyE
  elements:
  - title: Total Calls / Total Appels
    name: Total Calls / Total Appels
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [synthetic_training_data_enhanced.count]
    limit: 5000
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Total Calls / Total Appels
    smart_single_value_size: false
    defaults_version: 1
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 0
    width: 4
    height: 3
  - title: Avg Duration / Durée Moy
    name: Avg Duration / Durée Moy
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [avg_duration]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Average Duration
      value_format: "#,##0.00"
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 16
    width: 4
    height: 3
  - title: Modules Cnt/ Modules Cpt
    name: Modules Cnt/ Modules Cpt
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [module_count]
    dynamic_fields:
    - category: measure
      expression: ''
      label: Module Count / Nombre de Modules
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 20
    width: 4
    height: 3
  - title: Module Comparison / Comparaison Modules
    name: Module Comparison / Comparaison Modules
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.lob,
      synthetic_training_data_enhanced.department, synthetic_training_data_enhanced.count,
      synthetic_training_data_enhanced.avg_training_duration, synthetic_training_data_enhanced.repeat_call_count,
      synthetic_training_data_enhanced.retention_call_count, synthetic_training_data_enhanced.sales_call_count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeats / Répétitions #Repeat Calls / Appels Répétés
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
      label: Retention Calls / Appels Rétention
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
      label: Sales Calls / Appels Vente
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
    show_view_names: false
    show_row_numbers: false
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
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      synthetic_training_data_enhanced.count:
        is_active: true
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    conditional_formatting: [{type: along a scale..., value_format: '', background_color: '',
        font_color: '', color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: [synthetic_training_data_enhanced.count]}]
    note_text: Shows how often training modules are referenced in actual calls. High
      frequency = high value topics. Low frequency = potentially unnecessary content.
    defaults_version: 1
    hidden_pivots: {}
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 3
    col: 0
    width: 24
    height: 8
  - title: High Frequency Modules (Top 5) / Modules Haute Fréquence (Top 5)
    name: High Frequency Modules (Top 5) / Modules Haute Fréquence (Top 5)
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 5
    column_limit: 50
    note_text: Training modules most frequently referenced in calls - high value priority
      topics
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 11
    col: 0
    width: 12
    height: 8
  - title: Low Frequency Modules (Bottom 5) / Modules Basse Fréquence (Bottom 5)
    name: Low Frequency Modules (Bottom 5) / Modules Basse Fréquence (Bottom 5)
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count]
    sorts: [synthetic_training_data_enhanced.count]
    limit: 5
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    note_text: Training modules rarely referenced in calls - potentially unnecessary
      content that should be evaluated for e-learning or video alternatives
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical2
    series_colors:
      synthetic_training_data_enhanced.count: "#e31a1c"
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    defaults_version: 1
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 11
    col: 12
    width: 12
    height: 8
  - title: Primary Topic Distribution / Distribution Sujets Principaux
    name: Primary Topic Distribution / Distribution Sujets Principaux
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    value_labels: legend
    label_type: labPer
    note_text: Main topics discussed in calls - helps identify critical topics for
      training focus
    inner_radius: 50
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_colors: {}
    defaults_version: 1
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 27
    col: 0
    width: 12
    height: 8
  - title: Secondary Topic Distribution / Distribution des Sujets Secondaires
    name: Secondary Topic Distribution / Distribution des Sujets Secondaires
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_pie
    fields: [synthetic_training_data_enhanced.secondary_topic, synthetic_training_data_enhanced.count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    note_text: Sub-categories of call topics - provides deeper level analysis as requested
      in BRD
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 27
    col: 12
    width: 12
    height: 8
  - title: Topic-Module Mapping / Sujets et Modules de Formation
    name: Topic-Module Mapping / Sujets et Modules de Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.secondary_topic,
      synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
      synthetic_training_data_enhanced.repeat_call_count, synthetic_training_data_enhanced.retention_call_count,
      synthetic_training_data_enhanced.sales_call_count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls / Appels Répétés
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
      label: Retention Calls / Appels de Rétention
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
      label: Sales Calls / Appels Vente
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
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
    note_text: Shows which call topics are covered by which training modules - helps
      identify gaps
    conditional_formatting: [{type: along a scale..., value_format: '', background_color: '',
        font_color: '', color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: [synthetic_training_data_enhanced.count]}]
    defaults_version: 1
    hidden_pivots: {}
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 35
    col: 0
    width: 24
    height: 8
  - title: Repeats vs Training / Répétitions vs Formation
    name: Repeats vs Training / Répétitions vs Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, repeat_call_count]
    sorts: [repeat_call_rate desc]
    limit: 15
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
      value_format: "#,##0.0%"
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: repeat_call_rate
      _type_hint: number
    note_text: Identifies which training modules correlate with high repeat call rates
      - indicates potential training gaps
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 43
    col: 0
    width: 8
    height: 8
  - title: Retention vs Training / Rétention vs Formation
    name: Retention vs Training / Rétention vs Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, retention_call_count]
    sorts: [retention_rate desc]
    limit: 15
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
      value_format: "#,##0.0%"
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: retention_rate
      _type_hint: number
    note_text: Shows which training modules correlate with retention call success/failure
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 43
    col: 8
    width: 8
    height: 8
  - title: Sales vs Training / Ventes vs Formation
    name: Sales vs Training / Ventes vs Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_column
    fields: [synthetic_training_data_enhanced.training_topic, total_calls, sales_call_count]
    sorts: [sales_rate desc]
    limit: 15
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
      value_format: "#,##0.0%"
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: sales_rate
      _type_hint: number
    note_text: Shows which training modules correlate with sales call success/failure
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 43
    col: 16
    width: 8
    height: 8
  - title: Call Volume / Volume d'Appels
    name: Call Volume / Volume d'Appels
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.lob, synthetic_training_data_enhanced.department,
      synthetic_training_data_enhanced.count, synthetic_training_data_enhanced.repeat_call_count,
      synthetic_training_data_enhanced.retention_call_count, synthetic_training_data_enhanced.sales_call_count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls / Appels Répétés
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
      label: Retention Calls / Appels de Rétention
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
      label: Sales Calls / Appels Vente
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
      value_format: "#,##0.00"
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number
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
    note_text: Grouped call transcripts by Line of Business and Department as required
    conditional_formatting: [{type: along a scale..., value_format: '', background_color: '',
        font_color: '', color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: [synthetic_training_data_enhanced.count]}]
    hidden_pivots: {}
    defaults_version: 1
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 51
    col: 0
    width: 24
    height: 8
  - title: Training Topics / Sujets de Formation
    name: Training Topics / Sujets de Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.lob, synthetic_training_data_enhanced.training_topic,
      synthetic_training_data_enhanced.count]
    pivots: [synthetic_training_data_enhanced.training_topic]
    sorts: [synthetic_training_data_enhanced.count desc 0, synthetic_training_data_enhanced.training_topic]
    limit: 500
    column_limit: 50
    note_text: Visual representation of training topic distribution across LOBs
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
    conditional_formatting: [{type: along a scale..., value_format: , background_color: ,
        font_color: , color_application: {collection_id: legacy, palette_id: legacy_sequential1,
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: []}]
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 59
    col: 0
    width: 24
    height: 8
  - title: Agent Summary by Manager / Résumé des Agents par Responsable
    name: Agent Summary by Manager / Résumé des Agents par Responsable
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.agent_manager, synthetic_training_data_enhanced.agent_name,
      synthetic_training_data_enhanced.count, synthetic_training_data_enhanced.repeat_call_count,
      synthetic_training_data_enhanced.retention_call_count, synthetic_training_data_enhanced.sales_call_count]
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls / Appels Répétés
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
      label: Retention Calls / Appels de Rétention
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
      label: Sales Calls / Appels Vente
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
      value_format: "#,##0.00"
      value_format_name: __custom
      based_on: synthetic_training_data_enhanced.duration
      _kind_hint: measure
      measure: avg_duration
      type: average
      _type_hint: number
    - category: table_calculation
      expression: "${synthetic_training_data_enhanced.repeat_call_count}/${synthetic_training_data_enhanced.count}"
      label: Repeat Rate
      value_format: "#,##0.0%"
      value_format_name: __custom
      _kind_hint: measure
      table_calculation: repeat_rate
      _type_hint: number
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
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    conditional_formatting: [{type: along a scale..., value_format:, background_color: ,
        font_color: , color_application: {collection_id: legacy, palette_id: legacy_diverging1,
          options: {steps: 5, reverse: true}}, bold: false, italic: false, strikethrough: false,
        fields: []}]
    note_text: Agent performance metrics filtered by manager to help improve agent
      KPIs
    hidden_pivots: {}
    defaults_version: 1
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 67
    col: 0
    width: 24
    height: 8
  - title: Call Volume Trend / Tendance du Volume d'Appels
    name: Call Volume Trend / Tendance du Volume d'Appels
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_line
    fields: [synthetic_training_data_enhanced.coversation_date, synthetic_training_data_enhanced.count,
      repeat_calls, retention_calls, sales_calls]
    sorts: [synthetic_training_data_enhanced.coversation_date]
    limit: 500
    dynamic_fields:
    - category: measure
      expression: ''
      label: Repeat Calls / Appels Répétés
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
      label: Retention Calls / Appels de Rétention
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
      label: Sales Calls / Appels Vente
      value_format:
      value_format_name:
      based_on: synthetic_training_data_enhanced.sales_call
      _kind_hint: measure
      measure: sales_calls
      type: count
      _type_hint: number
      filters:
        synthetic_training_data_enhanced.sales_call: 'Yes'
    note_text: Temporal analysis of call patterns
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
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 75
    col: 0
    width: 24
    height: 8
  - title: Untrained Call Topics / Sujets d'Appel Non Couverts par la Formation
    name: Untrained Call Topics / Sujets d'Appel Non Couverts par la Formation
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.primary_topic, synthetic_training_data_enhanced.secondary_topic,
      synthetic_training_data_enhanced.count]
    filters:
      synthetic_training_data_enhanced.training_topic: 'NULL'
    sorts: [synthetic_training_data_enhanced.count desc]
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
    note_text: Identifies critical topics present in calls but missing or underrepresented
      in training modules
    conditional_formatting: [{type: along a scale..., value_format: , background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: [synthetic_training_data_enhanced.count]},
      {type: along a scale..., value_format: !!null '', background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: legacy, palette_id: legacy_diverging2},
        bold: false, italic: false, strikethrough: false, fields: [training_modules_count]}]
    defaults_version: 1
    hidden_pivots: {}
    listen:
      lob_filter: synthetic_training_data_enhanced.lob
      department_filter: synthetic_training_data_enhanced.department
      agent_manager_filter: synthetic_training_data_enhanced.agent_manager
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 19
    col: 0
    width: 12
    height: 8
  - title: Sales / Ventes # Calls / Appels Vente
    name: Sales / Ventes #Calls / Appels Vente
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [synthetic_training_data_enhanced.sales_call_count]
    limit: 5000
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 12
    width: 4
    height: 3
  - title: Retentions / Rétentions # Calls / Appels de Rétention
    name: Retentions / Rétentions # Calls / Appels de Rétention
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [synthetic_training_data_enhanced.retention_call_count]
    limit: 5000
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 8
    width: 4
    height: 3
  - title: Untouched Training Topics / Sujets de Formation Non Sollicités
    name: Untouched Training Topics / Sujets de Formation Non Sollicités
    model: bi_sandbox
    explore: training_schedule
    type: looker_grid
    fields: [training_schedule.module_name, training_schedule.total_spend_time_min]
    filters:
      training_schedule.lob: "-NULL"
    sorts: [training_schedule.total_spend_time_min desc 0]
    limit: 10
    column_limit: 50
    show_view_names: false
    show_row_numbers: false
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
    truncate_column_names: false
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#BEE9E8",
        font_color: !!null '', color_application: {collection_id: badal, palette_id: badal-sequential-0,
          options: {steps: 5, constraints: {min: {type: minimum}, mid: {type: number,
                value: 0}, max: {type: maximum}}, mirror: false, reverse: false, stepped: false}},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: along
          a scale..., value: !!null '', background_color: "#BEE9E8", font_color: !!null '',
        color_application: {collection_id: badal, palette_id: badal-diverging-0, options: {
            constraints: {min: {type: minimum}, mid: {type: number, value: 0}, max: {
                type: maximum}}, mirror: true, reverse: false, stepped: false}}, bold: false,
        italic: false, strikethrough: false, fields: !!null ''}]
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    defaults_version: 1
    listen: {}
    row: 19
    col: 12
    width: 12
    height: 8
  - title: Efficiency Score (Calls per Training Min) / Score d'Efficacité (Appels
      par Min Formation)
    name: Efficiency Score (Calls per Training Min) / Score d'Efficacité (Appels par
      Min Formation)
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: looker_grid
    fields: [synthetic_training_data_enhanced.training_topic, synthetic_training_data_enhanced.count,
      synthetic_training_data_enhanced.avg_training_duration]
    filters:
      synthetic_training_data_enhanced.training_topic: "-NULL"
    sorts: [synthetic_training_data_enhanced.count desc]
    limit: 500
    column_limit: 50
    dynamic_fields:
    - category: table_calculation
      expression: sum(${synthetic_training_data_enhanced.avg_training_duration})/count(${synthetic_training_data_enhanced.avg_training_duration})
      label: Avg. Duration
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: avg_duration
      _type_hint: number
      is_disabled: true
    - category: table_calculation
      expression: "${synthetic_training_data_enhanced.count}/(${synthetic_training_data_enhanced.avg_training_duration})"
      label: Proficiency
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: proficiency
      _type_hint: number
    - category: table_calculation
      expression: "${synthetic_training_data_enhanced.count}/${average_training_duration}"
      label: Ratio
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: ratio
      _type_hint: number
      is_disabled: true
    - category: table_calculation
      expression: "((${synthetic_training_data_enhanced.count}-${average_training_duration})/${average_training_duration})*100"
      label: ROI Percentage
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: roi_percentage
      _type_hint: number
      is_disabled: true
    - category: table_calculation
      label: Rating
      value_format:
      value_format_name:
      calculation_type: rank_of_column
      table_calculation: rating
      args:
      - proficiency
      _kind_hint: measure
      _type_hint: number
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
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_cell_visualizations:
      synthetic_training_data_enhanced.count:
        is_active: true
    conditional_formatting: [{type: along a scale..., value_format: !!null '', background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: [synthetic_training_data_enhanced.count]}]
    note_text: Shows how often training modules are referenced in actual calls. High
      frequency = high value topics. Low frequency = potentially unnecessary content.
    defaults_version: 1
    hidden_pivots: {}
    hidden_fields: [average_training_duration]
    listen:
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 83
    col: 0
    width: 24
    height: 7
  - title: Repeats / Répétitions #Repeat Calls / Appels Répétés
    name: Repeats / Répétitions # #Repeat Calls / Appels Répétés
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    type: single_value
    fields: [synthetic_training_data_enhanced.repeat_call_count]
    limit: 5000
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_pivots: {}
    listen:
      Conversation Date: synthetic_training_data_enhanced.coversation_date
    row: 0
    col: 4
    width: 4
    height: 3
  filters:
  - name: lob_filter
    title: Line of Business (LOB) / Ligne d'Affaires (LOB)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    listens_to_filters: []
    field: synthetic_training_data_enhanced.lob
  - name: department_filter
    title: Department / Département
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    listens_to_filters: []
    field: synthetic_training_data_enhanced.department
  - name: agent_manager_filter
    title: Agent Manager / Gestionnaire d'Agent
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    listens_to_filters: []
    field: synthetic_training_data_enhanced.agent_manager
  - name: Conversation Date
    title: Conversation Date / Date de Conversation
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: bi_sandbox
    explore: synthetic_training_data_enhanced
    listens_to_filters: []
    field: synthetic_training_data_enhanced.coversation_date
