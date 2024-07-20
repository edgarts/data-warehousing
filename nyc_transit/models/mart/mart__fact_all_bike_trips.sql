-- dbt Mart file for fact all bike trips

-- Read desired columns from all records in stg__bike_data table
with bike_trips as (

select

    start_time as started_at_ts,
    stop_time as ended_at_ts,
    datediff('minute', start_time, stop_time) as duration_min,
    datediff('second', start_time, stop_time) as duration_sec,
    start_station_id,
    end_station_id

from {{ ref('stg__bike_data') }}

)

-- Final output for mart_fact_all_bike_trips
select * from bike_trips