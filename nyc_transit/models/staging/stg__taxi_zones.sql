-- dbt Staging file for the NYC Taxi zones table

-- source is taxi_zones raw table
with source as (

    select * from {{ source('main', 'taxi_zones') }}

),

-- Rename columns
renamed as (

    select

        objectid as object_id,
        shape_leng as shape_lenght,
        shape_area,
        zone as zone_name,
        locationid as location_id,
        borough,
        geom,
        filename

    from source

)

-- Final output for stg__fhv_bases
select * from renamed