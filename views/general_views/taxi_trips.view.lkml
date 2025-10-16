view: taxi_trips {
    sql_table_name: `bigquery-public-data.chicago_taxi_trips.taxi_trips` ;;

    dimension: unique_key {
        primary_key: yes
        type: string
        sql: ${TABLE}.unique_key ;;
        description: "Unique identifier for the trip."
    }
    dimension: taxi_id {
        type: string
        sql: ${TABLE}.taxi_id ;;
        description: "A unique identifier for the taxi."
    }
    dimension_group: trip_start_timestamp {
        type: time
        timeframes: [raw, time, date, week, month, quarter, year]
        sql: ${TABLE}.trip_start_timestamp ;;
        description: "When the trip started, rounded to the nearest 15 minutes."
    }
    dimension_group: trip_end_timestamp {
        type: time
        timeframes: [raw, time, date, week, month, quarter, year]
        sql: ${TABLE}.trip_end_timestamp ;;
        description: "When the trip ended, rounded to the nearest 15 minutes."
    }
    dimension: trip_seconds {
        type: number
        sql: ${TABLE}.trip_seconds ;;
        description: "Time of the trip in seconds."
    }
    dimension: trip_miles {
        type: number
        sql: ${TABLE}.trip_miles ;;
        description: "Distance of the trip in miles."
    }
    dimension: pickup_census_tract {
        type: number
        sql: ${TABLE}.pickup_census_tract ;;
        description: "The Census Tract where the trip began. For privacy, this Census Tract is not shown for some trips."
    }
    dimension: dropoff_census_tract {
        type: number
        sql: ${TABLE}.dropoff_census_tract ;;
        description: "The Census Tract where the trip ended. For privacy, this Census Tract is not shown for some trips."
    }
    dimension: pickup_community_area {
        type: number
        sql: ${TABLE}.pickup_community_area ;;
        description: "The Community Area where the trip began."
    }
    dimension: dropoff_community_area {
        type: number
        sql: ${TABLE}.dropoff_community_area ;;
        description: "The Community Area where the trip ended."
    }
    dimension: fare {
        type: number
        sql: ${TABLE}.fare ;;
        description: "The fare for the trip."
    }
    dimension: tips {
        type: number
        sql: ${TABLE}.tips ;;
        description: "The tip for the trip. Cash tips generally will not be recorded."
    }
    dimension: tolls {
        type: number
        sql: ${TABLE}.tolls ;;
        description: "The tolls for the trip."
    }
    dimension: extras {
        type: number
        sql: ${TABLE}.extras ;;
        description: "Extra charges for the trip."
    }
    dimension: trip_total {
        type: number
        sql: ${TABLE}.trip_total ;;
        description: "Total cost of the trip, the total of the fare, tips, tolls, and extras."
    }
    dimension: payment_type {
        type: string
        sql: ${TABLE}.payment_type ;;
        description: "Type of payment for the trip."
    }
    dimension: company {
        type: string
        sql: ${TABLE}.company ;;
        description: "The taxi company."
    }
    dimension: pickup_latitude {
        type: number
        sql: ${TABLE}.pickup_latitude ;;
        description: "The latitude of the center of the pickup census tract or the community area if the census tract has been hidden for privacy."
    }
    dimension: pickup_longitude {
        type: number
        sql: ${TABLE}.pickup_longitude ;;
        description: "The longitude of the center of the pickup census tract or the community area if the census tract has been hidden for privacy."
    }
    dimension: pickup_location {
        type: string
        sql: ${TABLE}.pickup_location ;;
        description: "The location of the center of the pickup census tract or the community area if the census tract has been hidden for privacy."
    }
    dimension: dropoff_latitude {
        type: number
        sql: ${TABLE}.dropoff_latitude ;;
        description: "The latitude of the center of the dropoff census tract or the community area if the census tract has been hidden for privacy."
    }
    dimension: dropoff_longitude {
        type: number
        sql: ${TABLE}.dropoff_longitude ;;
        description: "The longitude of the center of the dropoff census tract or the community area if the census tract has been hidden for privacy."
    }
    dimension: dropoff_location {
        type: string
        sql: ${TABLE}.dropoff_location ;;
        description: "The location of the center of the dropoff census tract or the community area if the census tract has been hidden for privacy."
    }

    # Sum measures for all numeric fields
    measure: sum_trip_seconds {
        type: sum
        sql: ${trip_seconds} ;;
        description: "Sum of trip duration in seconds."
    }
    measure: sum_trip_miles {
        type: sum
        sql: ${trip_miles} ;;
        description: "Sum of trip distance in miles."
    }
    measure: sum_pickup_census_tract {
        type: sum
        sql: ${pickup_census_tract} ;;
        description: "Sum of pickup census tracts."
    }
    measure: sum_dropoff_census_tract {
        type: sum
        sql: ${dropoff_census_tract} ;;
        description: "Sum of dropoff census tracts."
    }
    measure: sum_pickup_community_area {
        type: sum
        sql: ${pickup_community_area} ;;
        description: "Sum of pickup community areas."
    }
    measure: sum_dropoff_community_area {
        type: sum
        sql: ${dropoff_community_area} ;;
        description: "Sum of dropoff community areas."
    }
    measure: sum_fare {
        type: sum
        sql: ${fare} ;;
        description: "Sum of fares."
    }
    measure: sum_tips {
        type: sum
        sql: ${tips} ;;
        description: "Sum of tips."
    }
    measure: sum_tolls {
        type: sum
        sql: ${tolls} ;;
        description: "Sum of tolls."
    }
    measure: sum_extras {
        type: sum
        sql: ${extras} ;;
        description: "Sum of extras."
    }
    measure: sum_trip_total {
        type: sum
        sql: ${trip_total} ;;
        description: "Sum of total trip costs."
    }
    measure: sum_pickup_latitude {
        type: sum
        sql: ${pickup_latitude} ;;
        description: "Sum of pickup latitudes."
    }
    measure: sum_pickup_longitude {
        type: sum
        sql: ${pickup_longitude} ;;
        description: "Sum of pickup longitudes."
    }
    measure: sum_dropoff_latitude {
        type: sum
        sql: ${dropoff_latitude} ;;
        description: "Sum of dropoff latitudes."
    }
    measure: sum_dropoff_longitude {
        type: sum
        sql: ${dropoff_longitude} ;;
        description: "Sum of dropoff longitudes."
    }
}
