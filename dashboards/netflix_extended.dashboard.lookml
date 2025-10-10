- dashboard: netflix_extended
  title: "Extended Netflix Dashboard"
  extends: netflix_base

  elements:
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
    listen:
      Date Added Date: v_netflix_titles_enriched.date_added_date
      Listed In: v_netflix_titles_enriched.listed_in
      Country: v_netflix_titles_enriched.country
    row: 7
    col: 0
    width: 8
    height: 7
