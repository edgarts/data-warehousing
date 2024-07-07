-- dbt Staging file for the Central Park Weather table

-- source is central_park_weather raw table
with source as (

    select * from {{ source('main', 'central_park_weather') }}

),

-- Cast data types and rename columns
renamed as (

    select

        station,
        name,
        TRY_CAST(date as date) as date,
        TRY_CAST(awnd as double) as avg_wind_speed,
        TRY_CAST(prcp as double) as precipitation,
        TRY_CAST(snow as double) as snowfall,
        TRY_CAST(snwd as double) as snow_depth,
        TRY_CAST(tmax as integer) as max_temperature,
        TRY_CAST(tmin as integer) as min_temperature,
        filename
    
    from source

)

-- Final output for stg__central_park_weather
select * from renamed