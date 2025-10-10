- dashboard: netflix_base
  title: Netflix Movies & TV Shows
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: ''
  preferred_slug: FzEvxvyLQljvZrTrmo32Kn
  elements:
  - title: Catalog Growth Over Time
    name: Catalog Growth Over Time
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_column
    fields: [v_netflix_titles_enriched.date_added_month, v_netflix_titles_enriched.count]
    fill_fields: [v_netflix_titles_enriched.date_added_month]
    sorts: [v_netflix_titles_enriched.date_added_month desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
      collection_id: 1297ec12-86a5-4ae0-9dfc-82de70b3806a
      palette_id: 93f8aeb4-3f4a-4cd7-8fee-88c3417516a1
      options:
        steps: 5
    x_axis_label: Added Month
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      v_netflix_titles_enriched.count: "#7CC8FA"
    series_labels:
      v_netflix_titles_enriched.count: Movie & TV Show Count
    advanced_vis_config: |-
      {
        "chart": {
          "backgroundColor": "#D3D3D3",
          "inverted": false,
          "style": {
            "fontFamily": "inherit",
            "fontSize": "12px"
          },
          "type": "column"
        },
        "series": [{
          "color": "#7CC8FA",
          "id": "v_netflix_titles_enriched.count",
          "name": "Movie & TV Show Count",
          "type": "column",
          "visible": true,
          "formatters": [{
              "select": "value > 10",
              "style": {
                "color": "#FF69B4"
              }
            },
            {
              "select": "value < 10",
              "style": {
                "opacity": 0.5
              }
            }
          ]
        }],
        "xAxis": {
          "type": "datetime"
        },
        "yAxis": [{
          "type": "linear"
        }]
      }
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    hidden_points_if_no: []
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    hidden_pivots: {}
    listen:
      Date Added Date: v_netflix_titles_enriched.date_added_date
      Listed In: v_netflix_titles_enriched.listed_in
      Country: v_netflix_titles_enriched.country
    row: 0
    col: 0
    width: 12
    height: 7
  - title: Content Type Distribution by Country
    name: Content Type Distribution by Country
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_column
    fields: [v_netflix_titles_enriched.movies_count, v_netflix_titles_enriched.tv_shows_count,
      v_netflix_titles_enriched.country]
    filters:
      v_netflix_titles_enriched.country: "-NULL"
      v_netflix_titles_enriched.date_added_date: 1 years
    sorts: [v_netflix_titles_enriched.movies_count desc 0]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
      collection_id: 1297ec12-86a5-4ae0-9dfc-82de70b3806a
      palette_id: 93f8aeb4-3f4a-4cd7-8fee-88c3417516a1
      options:
        steps: 5
    x_axis_label: Added Month
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors: {}
    series_labels:
      v_netflix_titles_enriched.count: Movie & TV Show Count
      v_netflix_titles_enriched.movies_count: Movies
      v_netflix_titles_enriched.tv_shows_count: TV Shows
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    hidden_points_if_no: []
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    hidden_pivots: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date Added Date: v_netflix_titles_enriched.date_added_date
      Listed In: v_netflix_titles_enriched.listed_in
      Country: v_netflix_titles_enriched.country
    row: 7
    col: 8
    width: 13
    height: 7
  - title: Top Countries
    name: Top Countries
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_pie
    fields: [v_netflix_titles_enriched.country, v_netflix_titles_enriched.count]
    filters:
      v_netflix_titles_enriched.country: "-NULL"
      v_netflix_titles_enriched.date_added_date: 1 years
    sorts: [v_netflix_titles_enriched.count desc 0]
    limit: 500
    column_limit: 50
    value_labels: legend
    label_type: labPer
    color_application:
      collection_id: 1297ec12-86a5-4ae0-9dfc-82de70b3806a
      palette_id: 93f8aeb4-3f4a-4cd7-8fee-88c3417516a1
      options:
        steps: 5
    series_colors: {}
    series_labels:
      v_netflix_titles_enriched.count: Movie & TV Show Count
      v_netflix_titles_enriched.movies_count: Movies
      v_netflix_titles_enriched.tv_shows_count: TV Shows
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Added Month
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    x_axis_zoom: true
    y_axis_zoom: true
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    hidden_points_if_no: []
    defaults_version: 1
    hidden_pivots: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Date Added Date: v_netflix_titles_enriched.date_added_date
      Listed In: v_netflix_titles_enriched.listed_in
      Country: v_netflix_titles_enriched.country
    row: 0
    col: 12
    width: 9
    height: 7
  filters:
  - name: Date Added Date
    title: Date Added Date
    type: field_filter
    default_value: this year
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    listens_to_filters: []
    field: v_netflix_titles_enriched.date_added_date
  - name: Listed In
    title: Listed In
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    listens_to_filters: []
    field: v_netflix_titles_enriched.listed_in
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    listens_to_filters: []
    field: v_netflix_titles_enriched.country
