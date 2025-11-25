view: synthetic_training_data_enhanced {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.dbt_thrytsyk.synthetic_training_data` ;;

  # ============================================================================
  # PRIMARY KEY
  # ============================================================================

  dimension: coversation_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.coversation_id ;;
    label: "Conversation ID"
  }

  # ============================================================================
  # AGENT DIMENSIONS
  # ============================================================================
#
#  dimension: agent_id {
#    type: number
#    sql: ${TABLE}.agent_id ;;
#    label: "Agent ID"
#  }

#  dimension: agent_name {
#    type: string
#    sql: ${TABLE}.agent_name ;;
#    label: "Agent Name"
#  }

#  dimension: agent_manager {
#    type: string
#    sql: ${TABLE}.agent_manager ;;
#    label: "Agent Manager"
#  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}.agent_id ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}ID Agent{% else %}Agent ID{% endif %}"
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Nom de l'Agent{% else %}Agent Name{% endif %}"
  }

  dimension: agent_manager {
    type: string
    sql: ${TABLE}.agent_manager ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Gestionnaire d'Agent{% else %}Agent Manager{% endif %}"
  }

  # ============================================================================
  # CALL CHARACTERISTICS
  # ============================================================================

  dimension: call_type {
    type: string
    sql: ${TABLE}.call_type ;;
    label: "Call Type"
  }

  dimension: language {
    type: string
    sql: ${TABLE}.language ;;
    label: "Language"
    # Add labels for better display
    html:
      {% if value == 'en-US' %}
        <span style="color: #1f78b4;">🇺🇸 English</span>
      {% elsif value == 'Fr-fr' %}
        <span style="color: #e31a1c;">🇫🇷 French</span>
      {% else %}
        {{ value }}
      {% endif %}
    ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}.duration ;;
    label: "Duration (minutes)"
    value_format_name: decimal_2
  }

  # Duration tiers for analysis
  dimension: duration_tier {
    type: tier
    tiers: [5, 10, 15, 20, 25]
    style: integer
    sql: ${duration} ;;
    label: "Duration Tier (minutes)"
  }

  # ============================================================================
  # ORGANIZATIONAL DIMENSIONS
  # ============================================================================

  dimension: lob {
    type: string
    sql: ${TABLE}.lob ;;
    label: "Line of Business (LOB)"
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
    label: "Department"
  }

  # ============================================================================
  # TOPIC DIMENSIONS
  # ============================================================================

  dimension: primary_topic {
    type: string
    sql: ${TABLE}.primary_topic ;;
    label: "Primary Topic"
    drill_fields: [secondary_topic, training_topic]
  }

  dimension: secondary_topic {
    type: string
    sql: ${TABLE}.secondary_topic ;;
    label: "Secondary Topic (Sub-category)"
  }

  # Combined topic for deeper analysis
  dimension: full_topic {
    type: string
    sql: CONCAT(${primary_topic}, ' - ', ${secondary_topic}) ;;
    label: "Full Topic (Primary - Secondary)"
  }

  # ============================================================================
  # TRAINING DIMENSIONS
  # ============================================================================

  dimension: training_topic {
    type: string
    sql: ${TABLE}.training_topic ;;
    label: "Training Module Topic"
  }

  dimension: training_duration {
    type: number
    sql: ${TABLE}.training_duration ;;
    label: "Training Duration (hours)"
    value_format_name: decimal_2
  }

  # Training duration tiers
  dimension: training_duration_tier {
    type: tier
    tiers: [50, 75, 100, 125, 150]
    style: integer
    sql: ${training_duration} ;;
    label: "Training Duration Tier (hours)"
  }

  # Topic-Training Match indicator
  dimension: topic_matches_training {
    type: yesno
    sql: ${primary_topic} = ${training_topic} ;;
    label: "Primary Topic Matches Training"
  }

  # ============================================================================
  # KPI FLAGS
  # ============================================================================

  dimension: repeat_call {
    type: yesno
    sql: ${TABLE}.repeat_call ;;
    label: "Repeat Call"
  }

  dimension: retention_call {
    type: yesno
    sql: ${TABLE}.retention_call ;;
    label: "Retention Call"
  }

  dimension: sales_call {
    type: yesno
    sql: ${TABLE}.sales_call ;;
    label: "Sales Call"
  }

  # Combined problem indicator
  dimension: has_issue {
    type: yesno
    sql: ${repeat_call} OR ${retention_call} ;;
    label: "Has Issue (Repeat or Retention)"
  }

  # ============================================================================
  # DATE/TIME DIMENSIONS
  # ============================================================================

  dimension_group: coversation {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year, day_of_week, hour_of_day]
    sql: ${TABLE}.coversation_date ;;
    label: "Conversation"
  }

  dimension_group: training_last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.training_last_update ;;
    label: "Training Last Update"
  }

  # Training freshness
  dimension: training_age_days {
    type: number
    sql: DATE_DIFF(${coversation_date}, ${training_last_update_date}, DAY) ;;
    label: "Training Age (days)"
    description: "Days between training last update and conversation date"
  }

  dimension: training_freshness {
    type: string
    sql: CASE
      WHEN ${training_age_days} <= 7 THEN '1. Very Fresh (0-7 days)'
      WHEN ${training_age_days} <= 14 THEN '2. Fresh (8-14 days)'
      WHEN ${training_age_days} <= 30 THEN '3. Recent (15-30 days)'
      ELSE '4. Outdated (30+ days)'
    END ;;
    label: "Training Freshness Category"
  }

  # ============================================================================
  # BASIC MEASURES
  # ============================================================================

  measure: count {
    type: count
    drill_fields: [detail*]
    label: "Total Calls"
  }

  measure: total_duration {
    type: sum
    sql: ${duration} ;;
    label: "Total Call Duration"
    value_format_name: decimal_2
  }

  measure: avg_duration {
    type: average
    sql: ${duration} ;;
    label: "Average Call Duration"
    value_format_name: decimal_2
  }

  measure: avg_training_duration {
    type: average
    sql: ${training_duration} ;;
    label: "Training Duration"
    value_format_name: decimal_2
  }

  # ============================================================================
  # KPI MEASURES
  # ============================================================================

  measure: repeat_call_count {
    type: count
    filters: [repeat_call: "Yes"]
    label: "Repeat Call Count"
    drill_fields: [detail*]
  }

  measure: repeat_call_rate {
    type: number
    sql: 1.0 * ${repeat_call_count} / NULLIF(${count}, 0) ;;
    label: "Repeat Call Rate"
    value_format_name: percent_2
  }

  measure: retention_call_count {
    type: count
    filters: [retention_call: "Yes"]
    label: "Retention Call Count"
    drill_fields: [detail*]
  }

  measure: retention_call_rate {
    type: number
    sql: 1.0 * ${retention_call_count} / NULLIF(${count}, 0) ;;
    label: "Retention Call Rate"
    value_format_name: percent_2
  }

  measure: sales_call_count {
    type: count
    filters: [sales_call: "Yes"]
    label: "Sales Call Count"
    drill_fields: [detail*]
  }

  measure: sales_call_rate {
    type: number
    sql: 1.0 * ${sales_call_count} / NULLIF(${count}, 0) ;;
    label: "Sales Call Rate"
    value_format_name: percent_2
  }

  # ============================================================================
  # TRAINING EFFECTIVENESS MEASURES
  # ============================================================================

  measure: unique_training_topics {
    type: count_distinct
    sql: ${training_topic} ;;
    label: "Unique Training Topics"
  }

  measure: unique_agents {
    type: count_distinct
    sql: ${agent_id} ;;
    label: "Unique Agents"
  }

  measure: unique_primary_topics {
    type: count_distinct
    sql: ${primary_topic} ;;
    label: "Unique Primary Topics"
  }

  measure: unique_secondary_topics {
    type: count_distinct
    sql: ${secondary_topic} ;;
    label: "Unique Secondary Topics"
  }

  # Training coverage score
  measure: training_coverage_score {
    type: number
    sql: 1.0 * ${unique_training_topics} / NULLIF(${unique_primary_topics}, 0) ;;
    label: "Training Coverage Score"
    description: "Ratio of training topics to primary call topics"
    value_format_name: percent_2
  }

  # Topic match rate
  measure: topic_match_rate {
    type: number
    sql: 1.0 * SUM(CASE WHEN ${primary_topic} = ${training_topic} THEN 1 ELSE 0 END) / NULLIF(${count}, 0) ;;
    label: "Topic-Training Match Rate"
    description: "Percentage of calls where primary topic matches training module"
    value_format_name: percent_2
  }

  # ============================================================================
  # TRAINING FREQUENCY CLASSIFICATION
  # ============================================================================

  measure: training_frequency_classification {
    type: string
    sql: CASE
      WHEN ${count} >= 200 THEN 'High Priority'
      WHEN ${count} >= 100 THEN 'Medium Priority'
      WHEN ${count} >= 50 THEN 'Low Priority'
      ELSE 'Consider for E-Learning/Video'
    END ;;
    label: "Training Module Priority"
    description: "Classification based on call frequency"
  }

  # ============================================================================
  # AGGREGATE QUALITY MEASURES
  # ============================================================================

  measure: quality_score {
    type: number
    sql: (1.0 - ${repeat_call_rate}) * 0.4 +
         ${retention_call_rate} * 0.3 +
         ${sales_call_rate} * 0.3 ;;
    label: "Overall Quality Score"
    description: "Composite score: (1-Repeat%)×0.4 + Retention%×0.3 + Sales%×0.3"
    value_format_name: percent_2
  }

  # ============================================================================
  # DRILL SETS
  # ============================================================================

  set: detail {
    fields: [
      coversation_id,
      coversation_date,
      agent_name,
      agent_manager,
      lob,
      department,
      primary_topic,
      secondary_topic,
      training_topic,
      duration,
      call_type,
      language,
      repeat_call,
      retention_call,
      sales_call
    ]
  }

  set: agent_detail {
    fields: [
      agent_name,
      agent_manager,
      count,
      avg_duration,
      repeat_call_rate,
      retention_call_rate,
      sales_call_rate,
      quality_score
    ]
  }

  set: training_detail {
    fields: [
      training_topic,
      count,
      avg_training_duration,
      training_last_update_date,
      training_age_days,
      unique_agents,
      repeat_call_rate,
      retention_call_rate,
      sales_call_rate
    ]
  }
}
