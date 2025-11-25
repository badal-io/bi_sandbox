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
    label: "{% if _user_attributes['user_language'] == 'fr' %}Type d'Appel{% else %}Call Type{% endif %}"
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
    label: "{% if _user_attributes['user_language'] == 'fr' %}Durée (minutes){% else %}Duration (minutes){% endif %}"
    value_format_name: decimal_2
  }

  dimension: duration_tier {
    type: tier
    tiers: [5, 10, 15, 20, 25]
    style: integer
    sql: ${duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Tranche de Durée (minutes){% else %}Duration Tier (minutes){% endif %}"
  }

  # ============================================================================
  # ORGANIZATIONAL DIMENSIONS
  # ============================================================================

  dimension: lob {
    type: string
    sql: ${TABLE}.lob ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Ligne d'Affaires (LOB){% else %}Line of Business (LOB){% endif %}"
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Département{% else %}Department{% endif %}"
  }

  # ============================================================================
  # TOPIC DIMENSIONS
  # ============================================================================

  dimension: primary_topic {
    type: string
    sql: ${TABLE}.primary_topic ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Sujet Principal{% else %}Primary Topic{% endif %}"
    drill_fields: [secondary_topic, training_topic]
  }

  dimension: secondary_topic {
    type: string
    sql: ${TABLE}.secondary_topic ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Sous-Catégorie{% else %}Secondary Topic (Sub-category){% endif %}"
  }

  dimension: full_topic {
    type: string
    sql: CONCAT(${primary_topic}, ' - ', ${secondary_topic}) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Sujet Complet{% else %}Full Topic{% endif %}"
  }

  # ============================================================================
  # TRAINING DIMENSIONS
  # ============================================================================

  dimension: training_topic {
    type: string
    sql: ${TABLE}.training_topic ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Module de Formation{% else %}Training Module Topic{% endif %}"
  }

  dimension: training_duration {
    type: number
    sql: ${TABLE}.training_duration ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Durée de Formation (heures){% else %}Training Duration (hours){% endif %}"
    value_format_name: decimal_2
  }

  dimension: training_duration_tier {
    type: tier
    tiers: [50, 75, 100, 125, 150]
    style: integer
    sql: ${training_duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Tranche de Durée de Formation (heures){% else %}Training Duration Tier (hours){% endif %}"
  }


  # ============================================================================
  # KPI FLAGS
  # ============================================================================

  dimension: repeat_call {
    type: yesno
    sql: ${TABLE}.repeat_call ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Appel Répété{% else %}Repeat Call{% endif %}"
  }

  dimension: retention_call {
    type: yesno
    sql: ${TABLE}.retention_call ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Appel de Rétention{% else %}Retention Call{% endif %}"
  }

  dimension: sales_call {
    type: yesno
    sql: ${TABLE}.sales_call ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Appel de Vente{% else %}Sales Call{% endif %}"
  }

  dimension: has_issue {
    type: yesno
    sql: ${repeat_call} OR ${retention_call} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}A un Problème{% else %}Has Issue{% endif %}"
  }

  # ============================================================================
  # DATE/TIME DIMENSIONS
  # ============================================================================

  dimension_group: coversation {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year, day_of_week, hour_of_day]
    sql: ${TABLE}.coversation_date ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Conversation{% else %}Conversation{% endif %}"
  }

  dimension_group: training_last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.training_last_update ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Dernière Mise à Jour de Formation{% else %}Training Last Update{% endif %}"
  }

  dimension: training_age_days {
    type: number
    sql: DATE_DIFF(${coversation_date}, ${training_last_update_date}, DAY) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Âge de la Formation (jours){% else %}Training Age (days){% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Jours entre la dernière mise à jour de formation et la date de conversation{% else %}Days between training last update and conversation date{% endif %}"
  }

  dimension: training_freshness {
    type: string
    sql: CASE
      WHEN ${training_age_days} <= 7 THEN '1. {% if _user_attributes["user_language"] == "fr" %}Très Récent (0-7 jours){% else %}Very Fresh (0-7 days){% endif %}'
      WHEN ${training_age_days} <= 14 THEN '2. {% if _user_attributes["user_language"] == "fr" %}Récent (8-14 jours){% else %}Fresh (8-14 days){% endif %}'
      WHEN ${training_age_days} <= 30 THEN '3. {% if _user_attributes["user_language"] == "fr" %}Actuel (15-30 jours){% else %}Recent (15-30 days){% endif %}'
      ELSE '4. {% if _user_attributes["user_language"] == "fr" %}Obsolète (30+ jours){% else %}Outdated (30+ days){% endif %}'
    END ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Fraîcheur de Formation{% else %}Training Freshness Category{% endif %}"
  }

  # ============================================================================
  # BASIC MEASURES
  # ============================================================================

  measure: count {
    type: count
    drill_fields: [detail*]
    label: "{% if _user_attributes['user_language'] == 'fr' %}Total des Appels{% else %}Total Calls{% endif %}"
  }

  measure: total_duration {
    type: sum
    sql: ${duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Durée Totale d'Appel{% else %}Total Call Duration{% endif %}"
    value_format_name: decimal_2
  }

  measure: avg_duration {
    type: average
    sql: ${duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Durée Moyenne d'Appel{% else %}Average Call Duration{% endif %}"
    value_format_name: decimal_2
  }

  measure: avg_training_duration {
    type: average
    sql: ${training_duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Durée Moyenne de Formation{% else %}Average Training Duration{% endif %}"
    value_format_name: decimal_2
  }

  measure: total_training_hours {
    type: sum
    sql: ${training_duration} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Heures Totales de Formation{% else %}Total Training Hours{% endif %}"
    value_format_name: decimal_2
  }

  # ============================================================================
  # KPI MEASURES
  # ============================================================================

  measure: repeat_call_count {
    type: count
    filters: [repeat_call: "Yes"]
    label: "{% if _user_attributes['user_language'] == 'fr' %}Nombre d'Appels Répétés{% else %}Repeat Call Count{% endif %}"
    drill_fields: [detail*]
  }

  measure: repeat_call_rate {
    type: number
    sql: 1.0 * ${repeat_call_count} / NULLIF(${count}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Taux d'Appels Répétés{% else %}Repeat Call Rate{% endif %}"
    value_format_name: percent_2
  }

  measure: retention_call_count {
    type: count
    filters: [retention_call: "Yes"]
    label: "{% if _user_attributes['user_language'] == 'fr' %}Nombre d'Appels de Rétention{% else %}Retention Call Count{% endif %}"
    drill_fields: [detail*]
  }

  measure: retention_call_rate {
    type: number
    sql: 1.0 * ${retention_call_count} / NULLIF(${count}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Taux de Rétention{% else %}Retention Call Rate{% endif %}"
    value_format_name: percent_2
  }

  measure: sales_call_count {
    type: count
    filters: [sales_call: "Yes"]
    label: "{% if _user_attributes['user_language'] == 'fr' %}Nombre d'Appels de Vente{% else %}Sales Call Count{% endif %}"
    drill_fields: [detail*]
  }

  measure: sales_call_rate {
    type: number
    sql: 1.0 * ${sales_call_count} / NULLIF(${count}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Taux de Vente{% else %}Sales Call Rate{% endif %}"
    value_format_name: percent_2
  }

  # ============================================================================
  # TRAINING EFFECTIVENESS MEASURES
  # ============================================================================

  measure: unique_training_topics {
    type: count_distinct
    sql: ${training_topic} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Modules de Formation Uniques{% else %}Unique Training Topics{% endif %}"
  }

  measure: unique_agents {
    type: count_distinct
    sql: ${agent_id} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Agents Uniques{% else %}Unique Agents{% endif %}"
  }

  measure: unique_primary_topics {
    type: count_distinct
    sql: ${primary_topic} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Sujets Principaux Uniques{% else %}Unique Primary Topics{% endif %}"
  }

  measure: unique_secondary_topics {
    type: count_distinct
    sql: ${secondary_topic} ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Sous-Catégories Uniques{% else %}Unique Secondary Topics{% endif %}"
  }

  measure: training_coverage_score {
    type: number
    sql: 1.0 * ${unique_training_topics} / NULLIF(${unique_primary_topics}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Score de Couverture de Formation{% else %}Training Coverage Score{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Ratio des modules de formation aux sujets d'appel{% else %}Ratio of training topics to primary call topics{% endif %}"
    value_format_name: percent_2
  }

  measure: topic_match_rate {
    type: number
    sql: 1.0 * SUM(CASE WHEN ${primary_topic} = ${training_topic} THEN 1 ELSE 0 END) / NULLIF(${count}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Taux de Correspondance Sujet-Formation{% else %}Topic-Training Match Rate{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Pourcentage d'appels où le sujet principal correspond au module de formation{% else %}Percentage of calls where primary topic matches training module{% endif %}"
    value_format_name: percent_2
  }

  measure: calls_per_training_hour {
    type: number
    sql: 1.0 * ${count} / NULLIF(${avg_training_duration}, 0) ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Appels par Heure de Formation{% else %}Calls per Training Hour{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Efficacité: nombre d'appels générés par heure de formation{% else %}Efficiency: number of calls generated per training hour{% endif %}"
    value_format_name: decimal_2
  }

  measure: training_efficiency_score {
    type: number
    sql: ((${count} / MAX(${count}) OVER()) * 0.6 + (1 - ${avg_training_duration} / MAX(${avg_training_duration}) OVER()) * 0.4) * 100 ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Score d'Efficacité de Formation{% else %}Training Efficiency Score{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Score composite (0-100): 60% volume d'appels + 40% efficacité de formation{% else %}Composite score (0-100): 60% call volume + 40% training efficiency{% endif %}"
    value_format_name: decimal_2
  }

  # ============================================================================
  # TRAINING FREQUENCY CLASSIFICATION
  # ============================================================================

  measure: training_priority_classification {
    type: string
    sql: CASE
      WHEN ${count} >= 200 THEN '{% if _user_attributes["user_language"] == "fr" %}Haute Priorité{% else %}High Priority{% endif %}'
      WHEN ${count} >= 100 THEN '{% if _user_attributes["user_language"] == "fr" %}Priorité Moyenne{% else %}Medium Priority{% endif %}'
      WHEN ${count} >= 50 THEN '{% if _user_attributes["user_language"] == "fr" %}Basse Priorité{% else %}Low Priority{% endif %}'
      ELSE '{% if _user_attributes["user_language"] == "fr" %}Candidat E-Learning/Vidéo{% else %}Consider for E-Learning/Video{% endif %}'
    END ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Classification de Priorité{% else %}Training Module Priority{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Classification basée sur la fréquence d'appels{% else %}Classification based on call frequency{% endif %}"
  }

  # ============================================================================
  # AGGREGATE QUALITY MEASURES
  # ============================================================================

  measure: quality_score {
    type: number
    sql: (1.0 - ${repeat_call_rate}) * 0.4 +
         ${retention_call_rate} * 0.3 +
         ${sales_call_rate} * 0.3 ;;
    label: "{% if _user_attributes['user_language'] == 'fr' %}Score de Qualité Global{% else %}Overall Quality Score{% endif %}"
    description: "{% if _user_attributes['user_language'] == 'fr' %}Score composite: (1-Répétés%)×0.4 + Rétention%×0.3 + Ventes%×0.3{% else %}Composite score: (1-Repeat%)×0.4 + Retention%×0.3 + Sales%×0.3{% endif %}"
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
