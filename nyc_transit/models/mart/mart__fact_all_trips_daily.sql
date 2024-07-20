-- dbt Mart file for fact all daily trips

-- Read desired columns from all trip records in mart__all_bike_trips
with all_bike_trips as (

select

    'bike' as type,
    date_trunc('day', started_at_ts) as date,
    count(*) as trips,
    avg(duration_min) as average_trip_duration_min

from {{ ref('mart__fact_all_bike_trips') }}
group by type, date

),

-- Read desired columns from all trip records in mart__all_taxi_trips
all_taxi_trips as (

select

    type,
    date_trunc('day', pickup_datetime) as date,
    count(*) as trips,
    avg(duration_min) as average_trip_duration_min

from {{ ref('mart__fact_all_taxi_trips') }}
group by type, date

),

-- Unite all records from different mart trip tables
all_daily_trips as (

select * from all_bike_trips
union all
select * from all_taxi_trips

)

-- Final output for mart_fact_all_taxi_trips
select * from all_daily_trips