-- dbt Mart file for fact all yellow taxi trips

-- Read desired columns from all trip records in stg__yellow_tripdata
with yellow_trips as (

select

    'yellow' as type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pickup_location_id as pulocationid,
    dropoff_location_id as dolocationid,
    fare_amount

from {{ ref('stg__yellow_tripdata') }}

)

-- Final output for mart_fact_all_taxi_trips
select * from yellow_trips