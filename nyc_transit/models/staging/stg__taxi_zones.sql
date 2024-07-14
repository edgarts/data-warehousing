-- dbt Staging file for the NYC Taxi zones table

-- source is taxi_zones raw table
with source as (

    select * from {{ source('main', 'taxi_zones') }}

),

-- Rename columns
renamed as (

    select

        -- Some locationid are repeated and must be unique so in order
        -- to enforce it for the test, only one is being selected using
        -- min, max and group by. Further analysis would be required
        -- to determine why are they duplicated and which one is the 
        -- right one. Using this solution for now.
        min(objectid) as object_id,
        max(shape_leng) as shape_lenght,
        max(shape_area) as shape_area,
        min(zone) as zone_name,
        locationid as location_id,
        min(borough),
        min(geom),
        filename

    from source
    group by locationid, filename

)

-- Final output for stg__fhv_bases
select * from renamed