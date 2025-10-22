---
- dashboard: netflix_extended
  title: Netflix Movies & TV Shows (copy)
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: ''
  preferred_slug: SK22Jog1pWCmWHTMNeWxIO
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
          "backgroundColor": "#a7a7a7",
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
    listen: {}
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
    listen: {}
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
    listen: {}
    row: 0
    col: 12
    width: 9
    height: 7
  - title: Top 5 Genres
    name: Top 5 Genres
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_pie
    fields: [v_netflix_titles_enriched.listed_in, v_netflix_titles_enriched.count]
    filters:
      v_netflix_titles_enriched.date_added_date: 1 years
    sorts: [v_netflix_titles_enriched.count desc 0]
    limit: 5
    column_limit: 50
    value_labels: legend
    label_type: labPer
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 1297ec12-86a5-4ae0-9dfc-82de70b3806a
      palette_id: 93f8aeb4-3f4a-4cd7-8fee-88c3417516a1
      options:
        steps: 5
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      v_netflix_titles_enriched.count: Movie & TV Show Count
      v_netflix_titles_enriched.movies_count: Movies
      v_netflix_titles_enriched.tv_shows_count: TV Shows
    series_cell_visualizations:
      v_netflix_titles_enriched.avg_tv_seasons:
        is_active: true
    series_colors: {}
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    listen: {}
    row: 7
    col: 0
    width: 8
    height: 7
  - title: Top Countries (Copy)
    name: Top Countries (Copy)
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_donut_multiples
    fields: [v_netflix_titles_enriched.country, v_netflix_titles_enriched.count, v_netflix_titles_enriched.movies_count]
    filters:
      v_netflix_titles_enriched.country: "-NULL"
      v_netflix_titles_enriched.date_added_date: 1 years
    sorts: [v_netflix_titles_enriched.count desc 0]
    limit: 500
    column_limit: 50
    show_value_labels: false
    font_size: 12
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
    bar_arm_length: 9
    bar_arm_weight: 48
    bar_spinner_length: 121
    bar_spinner_weight: 25
    bar_style: vertical
    bar_range_min: 0
    bar_range_max: 100.701
    bar_value_label_type: both
    bar_value_label_font: 8
    bar_value_label_padding: 45
    bar_target_source: 'off'
    bar_target_label_type: none
    bar_target_label_font: 3
    bar_label_font_size: 3
    bar_fill_color: "#0092E5"
    bar_background_color: "#CECECE"
    bar_spinner_color: "#282828"
    bar_range_color: "#282828"
    listen: {}
    row: 14
    col: 0
    width: 9
    height: 7
  - title: Top 5 Genres (Copy)
    name: Top 5 Genres (Copy)
    model: bi_sandbox
    explore: v_netflix_titles_enriched
    type: looker_area
    fields: [v_netflix_titles_enriched.listed_in, v_netflix_titles_enriched.count,
      v_netflix_titles_enriched.avg_tv_seasons]
    filters:
      v_netflix_titles_enriched.date_added_date: 1 years
    sorts: [v_netflix_titles_enriched.count desc 0]
    limit: 5
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
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 1297ec12-86a5-4ae0-9dfc-82de70b3806a
      palette_id: 93f8aeb4-3f4a-4cd7-8fee-88c3417516a1
      options:
        steps: 5
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    minimum_column_width: 75
    series_labels:
      v_netflix_titles_enriched.count: Movie & TV Show Count
      v_netflix_titles_enriched.movies_count: Movies
      v_netflix_titles_enriched.tv_shows_count: TV Shows
    series_cell_visualizations:
      v_netflix_titles_enriched.avg_tv_seasons:
        is_active: true
    series_colors: {}
    x_axis_label: Added Month
    x_axis_zoom: true
    y_axis_zoom: true
    ordering: none
    show_null_labels: false
    hidden_fields: []
    hidden_points_if_no: []
    defaults_version: 1
    hidden_pivots: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    listen: {}
    row: 14
    col: 9
    width: 8
    height: 7
