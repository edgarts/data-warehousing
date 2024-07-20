-- dbt Mart file for dimension bike stations

-- Select and join all stations from start and end station ids
with all_stations as (

-- First select station ids from start stations
select

    start_station_id as station_id,
    start_station_name as station_name,
    start_station_latitude as station_lat,
    start_station_longitude as station_lng

from {{ ref('stg__bike_data') }}

-- Select station ids from end stations and use union so
-- duplicated stations are excluded
union

select

    end_station_id as station_id,
    end_station_name as station_name,
    end_station_latitude as station_lat,
    end_station_longitude as station_lng

from {{ ref('stg__bike_data') }}

),

-- Due to some differences in data other than the id, there
-- are repeated station id so using group by and min to 
-- select just one
unique_stations as (

select

    station_id,
    min(station_name) as station_name,
    min(station_lat) as station_lat,
    min(station_lng) as station_lng
from all_stations
group by station_id

)

-- Final output for mart_dim_bike_stations
select * from unique_stations