view: bq_allup {
  sql_table_name: `prj-s-dlp-dq-sandbox-0b3c.dbt_thrytsyk.bq_allup` ;;

  dimension: agent_ids {
    type: string
    description: "Genesys agent id's involved in the call"
    sql: ${TABLE}.agent_ids ;;
  }
  dimension: agnt_sntmnt_mgntd_qty {
    type: number
    description: "Insights absolute magnitude of the agent sentiment"
    sql: ${TABLE}.agnt_sntmnt_mgntd_qty ;;
  }
  dimension: agnt_sntmnt_scor_qty {
    type: number
    description: "Insights agent sentiment score"
    sql: ${TABLE}.agnt_sntmnt_scor_qty ;;
  }
  dimension: ani {
    type: string
    description: "caller id phone number"
    sql: ${TABLE}.ani ;;
  }
  dimension: asa {
    type: number
    description: "Total average speed of answer"
    sql: ${TABLE}.asa ;;
  }
  dimension: ban_2 {
    type: string
    description: "second ban from 0 meta data fields for ban"
    sql: ${TABLE}.ban_2 ;;
  }
  dimension: bus_acct_num {
    type: string
    description: "Insights, BAN from meta data"
    sql: ${TABLE}.bus_acct_num ;;
  }
  dimension: businessunit {
    type: string
    description: "Queue Hierarchy business unit"
    sql: ${TABLE}.businessunit ;;
  }
  dimension: call_convrstn_id {
    type: string
    description: "Unique identifier for transcribed calls from source"
    sql: ${TABLE}.call_convrstn_id ;;
  }
  dimension_group: call_convrstn_utc_dt {
    type: time
    description: "UTC date from source data"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.call_convrstn_utc_dt ;;
  }
  dimension: call_type {
    type: string
    description: "Call type direction, Outbound or Inbound"
    sql: ${TABLE}.call_type ;;
  }
  dimension: ccts_cat0_bucketing {
    type: string
    description: "ccts category bucket"
    sql: ${TABLE}.ccts_cat0_bucketing ;;
  }
  dimension: ccts_cat1 {
    type: string
    description: "ccts category 1"
    sql: ${TABLE}.ccts_cat1 ;;
  }
  dimension: ccts_cat2 {
    type: string
    description: "ccts category 2"
    sql: ${TABLE}.ccts_cat2 ;;
  }
  dimension: ccts_cat3 {
    type: string
    description: "ccts category 3"
    sql: ${TABLE}.ccts_cat3 ;;
  }
  dimension: ccts_driver {
    type: string
    description: "ccts driver"
    sql: ${TABLE}.ccts_driver ;;
  }
  dimension: ccts_driver_cat {
    type: string
    description: "ccts driver category description"
    sql: ${TABLE}.ccts_driver_cat ;;
  }
  dimension_group: ccts_dt {
    type: time
    description: "ccts incident date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ccts_dt ;;
  }
  dimension: ccts_incident_no {
    type: string
    description: "ccts incident number"
    sql: ${TABLE}.ccts_incident_no ;;
  }
  dimension: ccts_rca_summary {
    type: string
    description: "ccts root cause summary"
    sql: ${TABLE}.ccts_rca_summary ;;
  }
  dimension: clnt_sntmnt_mgntd_qty {
    type: number
    description: "Insights absolute magnitude of the client sentiment"
    sql: ${TABLE}.clnt_sntmnt_mgntd_qty ;;
  }
  dimension: clnt_sntmnt_scor_qty {
    type: number
    description: "Insights customer sentiment score"
    sql: ${TABLE}.clnt_sntmnt_scor_qty ;;
  }
  dimension: connid {
    type: string
    description: "Genesys connection id"
    sql: ${TABLE}.connid ;;
  }
  dimension: contact_type {
    type: string
    description: "Queue Hierarchy contact type"
    sql: ${TABLE}.contact_type ;;
  }
  dimension: convrstn_durtn_min_qty {
    type: number
    description: "Insights conversation duration in minutes"
    sql: ${TABLE}.convrstn_durtn_min_qty ;;
  }
  dimension: convrstn_turn_cnt {
    type: number
    description: "Insights the number of turns taken in the conversation"
    sql: ${TABLE}.convrstn_turn_cnt ;;
  }
  dimension_group: credits_create_dt {
    type: time
    description: "credits creation date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.credits_create_dt ;;
  }
  dimension_group: credits_posted_dt {
    type: time
    description: "credits posted date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.credits_posted_dt ;;
  }
  dimension: credits_total {
    type: number
    description: "total credits added on call that show up on next bill"
    sql: ${TABLE}.credits_total ;;
  }
  dimension: cslt_grouping_friendly_name {
    type: string
    description: "Queue Hierarchy CSTL grouping friendly name"
    sql: ${TABLE}.cslt_grouping_friendly_name ;;
  }
  dimension: cust_id {
    type: string
    description: "Insights, cust_id from meta data"
    sql: ${TABLE}.cust_id ;;
  }
  dimension: custom_highlight {
    type: string
    description: "Insights, custom highlighters"
    sql: ${TABLE}.custom_highlight ;;
  }
  dimension_group: datetime_est {
    type: time
    description: "EST interaction start datetime"
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.datetime_est ;;
  }
  dimension_group: datetime_mst {
    type: time
    description: "MST interaction start datetime"
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.datetime_mst ;;
  }
  dimension_group: datetime_pst {
    type: time
    description: "ST interaction start datetime"
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.datetime_pst ;;
  }
  dimension_group: datetime_utc {
    type: time
    description: "UTC interation start datetime"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.datetime_utc ;;
  }
  dimension: ecr_ban {
    type: string
    description: "ECR case ban"
    sql: ${TABLE}.ecr_ban ;;
  }
  dimension: ecr_case_number {
    type: string
    description: "ECR case number"
    sql: ${TABLE}.ecr_case_number ;;
  }
  dimension: ecr_cat1 {
    type: string
    description: "ECR case category 1"
    sql: ${TABLE}.ecr_cat1 ;;
  }
  dimension: ecr_cat2 {
    type: string
    description: "ECR case category 2"
    sql: ${TABLE}.ecr_cat2 ;;
  }
  dimension: ecr_cat3 {
    type: string
    description: "ECR case category 3"
    sql: ${TABLE}.ecr_cat3 ;;
  }
  dimension_group: ecr_close {
    type: time
    description: "ECR case closed date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ecr_close_date ;;
  }
  dimension: ecr_lob {
    type: string
    description: "ECR case lob"
    sql: ${TABLE}.ecr_lob ;;
  }
  dimension_group: ecr_open {
    type: time
    description: "ECR case open date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ecr_open_date ;;
  }
  dimension: ecr_status {
    type: string
    description: "ECR case status"
    sql: ${TABLE}.ecr_status ;;
  }
  dimension: enterprise_group {
    type: string
    description: "Queue Hierarchy enterprise group"
    sql: ${TABLE}.enterprise_group ;;
  }
  dimension: ffh_deact_date {
    type: string
    description: "string aggregated list of deact dates"
    sql: ${TABLE}.ffh_deact_date ;;
  }
  dimension: ffh_deact_final {
    type: string
    description: "ffh deact flag to lock in deact products within date range"
    sql: ${TABLE}.ffh_deact_final ;;
  }
  dimension: ffh_deact_product {
    type: string
    description: "string aggregated list of ffh deact products"
    sql: ${TABLE}.ffh_deact_product ;;
  }
  dimension: hrdw_adj_portfolio {
    type: string
    description: "hardware portfolio name"
    sql: ${TABLE}.hrdw_adj_portfolio ;;
  }
  dimension: hrdw_complete_dts_est {
    type: string
    description: "aggregate dates hardware order was completed in EST"
    sql: ${TABLE}.hrdw_complete_dts_est ;;
  }
  dimension: hrdw_po_name {
    type: string
    description: "hardware product order name"
    sql: ${TABLE}.hrdw_po_name ;;
  }
  dimension: insights_agent_chatter {
    type: string
    description: "Insights Agent transcript"
    sql: ${TABLE}.insights_agent_chatter ;;
  }
  dimension: insights_customer_chatter {
    type: string
    description: "Insights Customer transcript"
    sql: ${TABLE}.insights_customer_chatter ;;
  }
  dimension: insights_transcript_txt {
    type: string
    description: "Insights full transcript"
    sql: ${TABLE}.insights_transcript_txt ;;
  }
  dimension: interaction_id {
    type: string
    description: "Genesys unique identifier for all legs of the call"
    sql: ${TABLE}.interaction_id ;;
  }
  dimension: iss_scor_qty {
    type: string
    description: "Score indicating the likelihood of the issue assignment"
    sql: ${TABLE}.iss_scor_qty ;;
  }
  dimension: issue {
    type: string
    description: "conversation issue"
    sql: ${TABLE}.issue ;;
  }
  dimension: ivr_ava_intents {
    type: string
    description: "Nuance IVR AVA intent"
    sql: ${TABLE}.ivr_ava_intents ;;
  }
  dimension: ivr_ava_utterance {
    type: string
    description: "Nuance IVR AVA utterance"
    sql: ${TABLE}.ivr_ava_utterance ;;
  }
  dimension: ivr_session_id {
    type: string
    description: "Nuance IVR session id"
    sql: ${TABLE}.ivr_session_id ;;
  }
  dimension: lob {
    type: string
    description: "Queue Hierarchy line of business"
    sql: ${TABLE}.lob ;;
  }
  dimension: lob_friendly_name {
    type: string
    description: "Queue Hierarchy line of business friendly name"
    sql: ${TABLE}.lob_friendly_name ;;
  }
  dimension: localcalltype {
    type: string
    description: "Local Call type direction"
    sql: ${TABLE}.localcalltype ;;
  }
  dimension: manual_outbound {
    type: number
    description: "indicates if call started as a manual outbound"
    sql: ${TABLE}.manual_outbound ;;
  }
  dimension: media_server_ixn_guid {
    type: string
    description: "Genesys media server id"
    sql: ${TABLE}.media_server_ixn_guid ;;
  }
  dimension: metadata_agent {
    type: string
    description: "agent from source metadata"
    sql: ${TABLE}.metadata_agent ;;
  }
  dimension: metadata_businessunit {
    type: string
    description: "Queue Hierarchy business unit based on metadata_queue"
    sql: ${TABLE}.metadata_businessunit ;;
  }
  dimension: metadata_contact_type {
    type: string
    description: "Queue Hierarchy contact type based on metadata_queue"
    sql: ${TABLE}.metadata_contact_type ;;
  }
  dimension: metadata_cslt_grouping_friendly_name {
    type: string
    description: "Queue Hierarchy CSTL grouping friendly name based on metadata_queue"
    sql: ${TABLE}.metadata_cslt_grouping_friendly_name ;;
  }
  dimension: metadata_enterprise_group {
    type: string
    description: "Queue Hierarchy enterprise group based on metadata_queue"
    sql: ${TABLE}.metadata_enterprise_group ;;
  }
  dimension: metadata_lob {
    type: string
    description: "Queue Hierarchy line of business based on metadata_queue"
    sql: ${TABLE}.metadata_lob ;;
  }
  dimension: metadata_lob_friendly_name {
    type: string
    description: "Queue Hierarchy line of business friendly name based on metadata_queue"
    sql: ${TABLE}.metadata_lob_friendly_name ;;
  }
  dimension: metadata_queue {
    type: string
    description: "queue from source metadata"
    sql: ${TABLE}.metadata_queue ;;
  }
  dimension: metadata_subgrouping_friendly_name {
    type: string
    description: "Queue Hierarchy sub grouping friendly name based on metadata_queue"
    sql: ${TABLE}.metadata_subgrouping_friendly_name ;;
  }
  dimension: mob_deact_date {
    type: string
    description: "string aggregated list of deact dates"
    sql: ${TABLE}.mob_deact_date ;;
  }
  dimension: mob_deact_final {
    type: string
    description: "mob deact flag to lock in deact products within date range"
    sql: ${TABLE}.mob_deact_final ;;
  }
  dimension: mob_deact_product {
    type: string
    description: "string aggregated list of ffh deact products"
    sql: ${TABLE}.mob_deact_product ;;
  }
  dimension: outcome {
    type: string
    description: "conversation outcome"
    sql: ${TABLE}.outcome ;;
  }
  dimension: peat {
    type: string
    description: "repeat caller flag from voicebot for repeats 3 and up"
    sql: ${TABLE}.peat ;;
  }
  dimension: product_mention {
    type: string
    description: "products mentioned in the conversation"
    sql: ${TABLE}.product_mention ;;
  }
  dimension: products_normalized {
    type: string
    description: "products mentioned in the conversation and percentage of conversation time"
    sql: ${TABLE}.products_normalized ;;
  }
  dimension: queues {
    type: string
    description: "All Genesys queues the call transversed"
    sql: ${TABLE}.queues ;;
  }
  dimension: rp_40day_interaction_start_date {
    type: string
    description: "40 day repeat call utc date"
    sql: ${TABLE}.rp_40day_interaction_start_date ;;
  }
  dimension: rp_40day_repeat_call_key {
    type: string
    description: "40 day repeat unique key"
    sql: ${TABLE}.rp_40day_repeat_call_key ;;
  }
  dimension: rp_40day_repeat_repeat_reporting_group2 {
    type: string
    description: "40 day repeat lob identifier"
    sql: ${TABLE}.rp_40day_repeat_repeat_reporting_group2 ;;
  }
  dimension: rp_40day_repeat_reporting_group1 {
    type: string
    description: "40 day repeat lob identifier"
    sql: ${TABLE}.rp_40day_repeat_reporting_group1 ;;
  }
  dimension: rp_40day_resource_name {
    type: string
    description: "40 day repeat call initial agent"
    sql: ${TABLE}.rp_40day_resource_name ;;
  }
  dimension: rp_40day_sap_id {
    type: string
    description: "40 day repeat agent sapid"
    sql: ${TABLE}.rp_40day_sap_id ;;
  }
  dimension: rp_40day_virtual_queue_name {
    type: string
    description: "40 day repeat initial call vq"
    sql: ${TABLE}.rp_40day_virtual_queue_name ;;
  }
  dimension: rp_7day_interaction_start_date {
    type: string
    description: "7 day repeat initial call utc date"
    sql: ${TABLE}.rp_7day_interaction_start_date ;;
  }
  dimension: rp_7day_next_days_between {
    type: string
    description: "7 day repeat days between"
    sql: ${TABLE}.rp_7day_next_days_between ;;
  }
  dimension: rp_7day_next_interaction_id {
    type: string
    description: "7 day repeat call interaction id"
    sql: ${TABLE}.rp_7day_next_interaction_id ;;
  }
  dimension: rp_7day_next_interaction_start_date {
    type: string
    description: "7 day repeat call utc date"
    sql: ${TABLE}.rp_7day_next_interaction_start_date ;;
  }
  dimension: rp_7day_next_resource_name {
    type: string
    description: "7 day repeat call next agent"
    sql: ${TABLE}.rp_7day_next_resource_name ;;
  }
  dimension: rp_7day_next_virtual_queue_name {
    type: string
    description: "7 day repeat call vq"
    sql: ${TABLE}.rp_7day_next_virtual_queue_name ;;
  }
  dimension: rp_7day_repeat_call_key {
    type: string
    description: "7 day repeat unique key"
    sql: ${TABLE}.rp_7day_repeat_call_key ;;
  }
  dimension: rp_7day_reporting_group1 {
    type: string
    description: "7 day repeat lob identifier"
    sql: ${TABLE}.rp_7day_reporting_group1 ;;
  }
  dimension: rp_7day_reporting_group2 {
    type: string
    description: "7 day repeat lob identifier"
    sql: ${TABLE}.rp_7day_reporting_group2 ;;
  }
  dimension: rp_7day_resource_name {
    type: string
    description: "7 day repeat call initial agent"
    sql: ${TABLE}.rp_7day_resource_name ;;
  }
  dimension: rp_7day_sap_id {
    type: string
    description: "7 day repeat agent sapid"
    sql: ${TABLE}.rp_7day_sap_id ;;
  }
  dimension: rp_7day_virtual_queue_name {
    type: string
    description: "7 day repeat initial call vq"
    sql: ${TABLE}.rp_7day_virtual_queue_name ;;
  }
  dimension: service_id {
    type: string
    description: "Genesys scheduled and immediate callback unique identifier"
    sql: ${TABLE}.service_id ;;
  }
  dimension: silence_durtn_min_qty {
    type: number
    description: "Insights Total conversation duration in minutes"
    sql: ${TABLE}.silence_durtn_min_qty ;;
  }
  dimension: silence_pct {
    type: number
    description: "Insights Percentage of the total conversation spent in silence"
    sql: ${TABLE}.silence_pct ;;
  }
  dimension: skyline_intent {
    type: string
    description: "skyline intent matching to skyline google sheet intent on topic 1"
    sql: ${TABLE}.skyline_intent ;;
  }
  dimension: smart_highlight {
    type: string
    description: "Insights, smart highlighters"
    sql: ${TABLE}.smart_highlight ;;
  }
  dimension: sntnce_lang_cd {
    type: string
    description: "Insights sentence level language code"
    sql: ${TABLE}.sntnce_lang_cd ;;
  }
  dimension: sntnce_lang_cd_dominant {
    type: string
    description: "language with the most instances by sentence"
    sql: ${TABLE}.sntnce_lang_cd_dominant ;;
  }
  dimension: srv_first_contact_resolution {
    type: string
    description: "survey result, first contact resolution"
    sql: ${TABLE}.srv_first_contact_resolution ;;
  }
  dimension: srv_last_call_resolution {
    type: string
    description: "survey result, last call resolution"
    sql: ${TABLE}.srv_last_call_resolution ;;
  }
  dimension_group: srv_part_vndr_compl_dt {
    type: time
    description: "Survey completion date"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.srv_part_vndr_compl_dt ;;
  }
  dimension: srv_res_perform {
    type: string
    description: "survey result"
    sql: ${TABLE}.srv_res_perform ;;
  }
  dimension: srv_src_dtl_str {
    type: string
    description: "Source for identifier"
    sql: ${TABLE}.srv_src_dtl_str ;;
  }
  dimension: srv_src_id {
    type: string
    description: "interaction_id"
    sql: ${TABLE}.srv_src_id ;;
  }
  dimension: srv_src_id_lbl_str {
    type: string
    description: "Source for identifier aka interaction_id"
    sql: ${TABLE}.srv_src_id_lbl_str ;;
  }
  dimension: srv_surv_brand_txt {
    type: string
    description: "survey brand"
    sql: ${TABLE}.srv_surv_brand_txt ;;
  }
  dimension: srv_surv_dept_txt {
    type: string
    description: "survey department"
    sql: ${TABLE}.srv_surv_dept_txt ;;
  }
  dimension: srv_surv_dest_txt {
    type: string
    description: "survey destination"
    sql: ${TABLE}.srv_surv_dest_txt ;;
  }
  dimension: srv_surv_id {
    type: string
    description: "survey id"
    sql: ${TABLE}.srv_surv_id ;;
  }
  dimension: srv_surv_lob_txt {
    type: string
    description: "survey line of business"
    sql: ${TABLE}.srv_surv_lob_txt ;;
  }
  dimension: srv_surv_med_txt {
    type: string
    description: "survey medium used"
    sql: ${TABLE}.srv_surv_med_txt ;;
  }
  dimension: srv_surv_seq_num {
    type: number
    description: "Survey sequence number"
    sql: ${TABLE}.srv_surv_seq_num ;;
  }
  dimension: srv_surv_sub_typ_cd {
    type: string
    description: "survey lob sub type"
    sql: ${TABLE}.srv_surv_sub_typ_cd ;;
  }
  dimension: srv_verbatim_agent {
    type: string
    description: "survey verbatim about agent"
    sql: ${TABLE}.srv_verbatim_agent ;;
  }
  dimension: srv_verbatim_callreasn {
    type: string
    description: "survey verbatim call reason"
    sql: ${TABLE}.srv_verbatim_callreasn ;;
  }
  dimension: srv_vndr_compl_stat_str {
    type: string
    description: "survey status"
    sql: ${TABLE}.srv_vndr_compl_stat_str ;;
  }
  dimension: srv_vndr_key_str {
    type: string
    description: "Survey vendor key"
    sql: ${TABLE}.srv_vndr_key_str ;;
  }
  dimension: srv_vndr_nm {
    type: string
    description: "Survey vendor name"
    sql: ${TABLE}.srv_vndr_nm ;;
  }
  dimension: sub_topic {
    type: string
    description: "Insights, custom highlighters with name sub_topic"
    sql: ${TABLE}.sub_topic ;;
  }
  dimension: subgrouping_friendly_name {
    type: string
    description: "Queue Hierarchy sub grouping friendly name"
    sql: ${TABLE}.subgrouping_friendly_name ;;
  }
  dimension: summary {
    type: string
    description: "conversation summary"
    sql: ${TABLE}.summary ;;
  }
  dimension: swap_equipment_delivery_mode {
    type: string
    description: "swap orders equipment_delivery_mode aggregated"
    sql: ${TABLE}.swap_equipment_delivery_mode ;;
  }
  dimension_group: swap_order_create {
    type: time
    description: "date of swap order created in utc"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.swap_order_create_date ;;
  }
  dimension: swap_order_item_number {
    type: string
    description: "swap orders order_item_number aggregated"
    sql: ${TABLE}.swap_order_item_number ;;
  }
  dimension: swap_order_name {
    type: string
    description: "swap orders order_name aggregated"
    sql: ${TABLE}.swap_order_name ;;
  }
  dimension: swap_order_status {
    type: string
    description: "swap orders status aggregated"
    sql: ${TABLE}.swap_order_status ;;
  }
  dimension: swap_service_delivery_method {
    type: string
    description: "swap orders service_delivery_method aggregated"
    sql: ${TABLE}.swap_service_delivery_method ;;
  }
  dimension: swap_top_order_item_name {
    type: string
    description: "swap orders top_order_item_name aggregated"
    sql: ${TABLE}.swap_top_order_item_name ;;
  }
  dimension: swap_type {
    type: string
    description: "swap orders swap_type aggregated"
    sql: ${TABLE}.swap_type ;;
  }
  dimension: tk_resolution3_cd {
    type: string
    description: "ticket resolution 3 cd"
    sql: ${TABLE}.tk_resolution3_cd ;;
  }
  dimension: tkt_agent_notes {
    type: string
    description: "ticket agent notes"
    sql: ${TABLE}.tkt_agent_notes ;;
  }
  dimension: tkt_category1_cd {
    type: string
    description: "ticket category 1 cd"
    sql: ${TABLE}.tkt_category1_cd ;;
  }
  dimension: tkt_category2_cd {
    type: string
    description: "ticket category 2 cd"
    sql: ${TABLE}.tkt_category2_cd ;;
  }
  dimension: tkt_category3_cd {
    type: string
    description: "ticket category 3 cd"
    sql: ${TABLE}.tkt_category3_cd ;;
  }
  dimension_group: tkt_created_ts {
    type: time
    description: "UTC ticket created date and time"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.tkt_created_ts ;;
  }
  dimension: tkt_cust_typ_cd {
    type: string
    description: "ticket customer type cd"
    sql: ${TABLE}.tkt_cust_typ_cd ;;
  }
  dimension: tkt_dispatch_flag {
    type: string
    description: "ticket dispatch flag"
    sql: ${TABLE}.tkt_dispatch_flag ;;
  }
  dimension: tkt_resolution1_cd {
    type: string
    description: "ticket resolution 1 cd"
    sql: ${TABLE}.tkt_resolution1_cd ;;
  }
  dimension: tkt_resolution2_cd {
    type: string
    description: "ticket resolution 2 cd"
    sql: ${TABLE}.tkt_resolution2_cd ;;
  }
  dimension: tkt_rsoln_txt {
    type: string
    description: "ticket resolution text"
    sql: ${TABLE}.tkt_rsoln_txt ;;
  }
  dimension: tkt_source_system {
    type: string
    description: "ticket source system"
    sql: ${TABLE}.tkt_source_system ;;
  }
  dimension: tkt_tech_typ_cd {
    type: string
    description: "ticket tech type cd"
    sql: ${TABLE}.tkt_tech_typ_cd ;;
  }
  dimension: tkt_ticket_status {
    type: string
    description: "ticket status"
    sql: ${TABLE}.tkt_ticket_status ;;
  }
  dimension: tkt_trbl_tkt_id {
    type: string
    description: "ticket trouble id number"
    sql: ${TABLE}.tkt_trbl_tkt_id ;;
  }
  dimension: tkt_trbl_typ_txt {
    type: string
    description: "ticket type text"
    sql: ${TABLE}.tkt_trbl_typ_txt ;;
  }
  dimension: tkt_wrk_ord_id {
    type: string
    description: "ticket work ord id"
    sql: ${TABLE}.tkt_wrk_ord_id ;;
  }
  dimension: topic {
    type: string
    description: "Insights Topic model derived reason for calling"
    sql: ${TABLE}.topic ;;
  }
  dimension: topic1 {
    type: string
    description: "Insights, first Topic model based on Confidence score"
    sql: ${TABLE}.topic1 ;;
  }
  dimension: topic1_level1 {
    type: string
    description: "Topic with highest confidence level, parent level"
    sql: ${TABLE}.topic1_level1 ;;
  }
  dimension: topic1_level2 {
    type: string
    description: "Topic with highest confidence level, child level"
    sql: ${TABLE}.topic1_level2 ;;
  }
  dimension: topic1_level3 {
    type: string
    description: "Topic with highest confidence level, second child level"
    sql: ${TABLE}.topic1_level3 ;;
  }
  dimension: topic2 {
    type: string
    description: "Insights, second Topic model based on Confidence score"
    sql: ${TABLE}.topic2 ;;
  }
  dimension: topic2_level1 {
    type: string
    description: "Topic with second highest confidence level, parent level"
    sql: ${TABLE}.topic2_level1 ;;
  }
  dimension: topic2_level2 {
    type: string
    description: "Topic with second highest confidence level, child level"
    sql: ${TABLE}.topic2_level2 ;;
  }
  dimension: topic2_level3 {
    type: string
    description: "Topic with second highest confidence level, second child level"
    sql: ${TABLE}.topic2_level3 ;;
  }
  dimension: topic3 {
    type: string
    description: "Insights, third Topic model based on Confidence score"
    sql: ${TABLE}.topic3 ;;
  }
  dimension: topic3_level1 {
    type: string
    description: "Topic with third highest confidence level, parent level"
    sql: ${TABLE}.topic3_level1 ;;
  }
  dimension: topic3_level2 {
    type: string
    description: "Topic with third highest confidence level, child level"
    sql: ${TABLE}.topic3_level2 ;;
  }
  dimension: topic3_level3 {
    type: string
    description: "Topic with third highest confidence level, second child level"
    sql: ${TABLE}.topic3_level3 ;;
  }
  dimension: topicmodel {
    type: string
    description: "Insights, sourced from Meta Data, topic model used"
    sql: ${TABLE}.topicmodel ;;
  }
  dimension: topicmodelvq {
    type: string
    description: "Insights, Genesys queue that determined which topic model was run on"
    sql: ${TABLE}.topicmodelvq ;;
  }
  dimension: topicmodelvq_aht {
    type: number
    description: "Insights, Average Handle Time for topicmodelvq"
    sql: ${TABLE}.topicmodelvq_aht ;;
  }
  dimension: tot_durtn_min_qty {
    type: number
    description: "Insights conversation total duration in minutes"
    sql: ${TABLE}.tot_durtn_min_qty ;;
  }
  dimension: total_acw_time {
    type: number
    description: "Total after call work time"
    sql: ${TABLE}.total_acw_time ;;
  }
  dimension: total_agents {
    type: number
    description: "Total number of agents involved in the call"
    sql: ${TABLE}.total_agents ;;
  }
  dimension: total_conf_time {
    type: number
    description: "Total conference time"
    sql: ${TABLE}.total_conf_time ;;
  }
  dimension: total_conferences {
    type: number
    description: "Total number of conferences"
    sql: ${TABLE}.total_conferences ;;
  }
  dimension: total_consult_time {
    type: number
    description: "Total consult work time for all legs of the call"
    sql: ${TABLE}.total_consult_time ;;
  }
  dimension: total_consults {
    type: number
    description: "Total number of consults"
    sql: ${TABLE}.total_consults ;;
  }
  dimension: total_handle_time {
    type: number
    description: "Total ring time + talk time + after call work time + total hold time"
    sql: ${TABLE}.total_handle_time ;;
  }
  dimension: total_hold_time {
    type: number
    description: "Total hold time"
    sql: ${TABLE}.total_hold_time ;;
  }
  dimension: total_ring_time {
    type: number
    description: "Total ring time"
    sql: ${TABLE}.total_ring_time ;;
  }
  dimension: total_talk_time {
    type: number
    description: "Total talk time"
    sql: ${TABLE}.total_talk_time ;;
  }
  dimension: total_transfers {
    type: number
    description: "Total number of transfers"
    sql: ${TABLE}.total_transfers ;;
  }
  dimension: total_wait_time {
    type: number
    description: "Total wait time"
    sql: ${TABLE}.total_wait_time ;;
  }
  dimension: transcript_label {
    type: string
    description: "Full transcript with labels"
    sql: ${TABLE}.transcript_label ;;
  }
  dimension: tx_acw_total {
    type: number
    description: "transfer after call work time total in seconds"
    sql: ${TABLE}.tx_acw_total ;;
  }
  dimension: tx_emp_ids {
    type: string
    description: "transfer agent ids in order"
    sql: ${TABLE}.tx_emp_ids ;;
  }
  dimension: tx_hold_total {
    type: number
    description: "transfer hold time total in seconds"
    sql: ${TABLE}.tx_hold_total ;;
  }
  dimension: tx_resource_ids {
    type: string
    description: "transfer resource ids in order"
    sql: ${TABLE}.tx_resource_ids ;;
  }
  dimension: tx_ring_total {
    type: number
    description: "transfer ring time total in seconds"
    sql: ${TABLE}.tx_ring_total ;;
  }
  dimension: tx_talk_total {
    type: number
    description: "transfer talk time total in seconds"
    sql: ${TABLE}.tx_talk_total ;;
  }
  dimension: tx_transfer_types {
    type: string
    description: "transfer types example cold or warm"
    sql: ${TABLE}.tx_transfer_types ;;
  }
  dimension: tx_vqs {
    type: string
    description: "transfer queues in order"
    sql: ${TABLE}.tx_vqs ;;
  }
  dimension: url {
    type: string
    description: "Insights URL for the Ul to view the full conversation"
    sql: ${TABLE}.url ;;
  }
  dimension: utn {
    type: string
    description: "Phone number captured from Insights metadata"
    sql: ${TABLE}.utn ;;
  }
  dimension: vbot_bots {
    type: string
    description: "if call originated in voicebot list of bots calls transversed"
    sql: ${TABLE}.vbot_bots ;;
  }
  dimension: vbot_head_intent {
    type: string
    description: "if call originated in voicebot list of head intents in sequence"
    sql: ${TABLE}.vbot_head_intent ;;
  }
  dimension: vbot_last_page {
    type: string
    description: "if call originated in voicebot last page"
    sql: ${TABLE}.vbot_last_page ;;
  }
  dimension: vbot_last_page_agent_handoff {
    type: string
    description: "if call originated in voicebot last page prior to handoff"
    sql: ${TABLE}.vbot_last_page_agent_handoff ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
	swap_top_order_item_name,
	cslt_grouping_friendly_name,
	rp_7day_resource_name,
	metadata_lob_friendly_name,
	metadata_subgrouping_friendly_name,
	rp_7day_virtual_queue_name,
	rp_40day_resource_name,
	rp_40day_virtual_queue_name,
	hrdw_po_name,
	metadata_cslt_grouping_friendly_name,
	lob_friendly_name,
	subgrouping_friendly_name,
	rp_7day_next_resource_name,
	rp_7day_next_virtual_queue_name,
	swap_order_name
	]
  }

}
