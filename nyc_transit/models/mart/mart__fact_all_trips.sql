-- dbt Mart file for fact all trips

-- Read desired columns from all trip records in mart__all_bike_trips
with all_bike_trips as (

select

    'bike' as type,
    started_at_ts,
    ended_at_ts,
    duration_min,
    duration_sec

from {{ ref('mart__fact_all_bike_trips') }}

),

-- Read desired columns from all trip records in mart__all_taxi_trips
all_taxi_trips as (

select

    type,
    pickup_datetime as started_at_ts,
    dropoff_datetime as ended_at_ts,
    duration_min,
    duration_sec

from {{ ref('mart__fact_all_taxi_trips') }}

),

-- Unite all records from different mart trip tables
all_daily_trips as (

select * from all_bike_trips
union all
select * from all_taxi_trips

)

-- Final output for mart_fact_all_taxi_trips
select * from all_daily_trips