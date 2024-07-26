-- dbt Mart file for central Park weather

-- Read all records from stg__central_park_weather table
with central_park_weather as (

select

        date,
        avg_wind_speed,
        precipitation,
        snowfall,
        snow_depth,
        max_temperature,
        min_temperature

from {{ ref('stg__central_park_weather') }}

)

-- Final output for mart_fact_central_park_weather
select * from central_park_weather