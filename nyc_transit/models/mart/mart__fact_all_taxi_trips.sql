-- dbt Mart file for fact all taxi trips

-- Read desired columns from all trip records in stg__fhv_tripdata
with fhv_trips as (

select

    'fhv' as type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pickup_location_id as pulocationid,
    dropoff_location_id as dolocationid

from {{ ref('stg__fhv_tripdata') }}

),

-- Read desired columns from all trip records in stg__fhvhv_tripdata
fhvhv_trips as (

select

    'fhvhv' as type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pickup_location_id as pulocationid,
    dropoff_location_id as dolocationid

from {{ ref('stg__fhvhv_tripdata') }}

),

-- Read desired columns from all trip records in stg__green_tripdata
green_trips as (

select

    'green' as type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pickup_location_id as pulocationid,
    dropoff_location_id as dolocationid

from {{ ref('stg__green_tripdata') }}

),

-- Read desired columns from all trip records in stg__yellow_tripdata
yellow_trips as (

select

    'yellow' as type,
    pickup_datetime,
    dropoff_datetime,
    datediff('minute', pickup_datetime, dropoff_datetime) as duration_min,
    datediff('second', pickup_datetime, dropoff_datetime) as duration_sec,
    pickup_location_id as pulocationid,
    dropoff_location_id as dolocationid

from {{ ref('stg__yellow_tripdata') }}

),

-- Unite all records from different taxi trip tables
taxi_trips as (

select * from fhv_trips
union all
select * from fhvhv_trips
union all
select * from green_trips
union all
select * from yellow_trips

)

-- Final output for mart_fact_all_taxi_trips
select * from taxi_trips