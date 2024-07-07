-- dbt Staging file for For Hire Vehicle Trip data table

-- source is fhv_tripdata raw table
with source as (

    select * from {{ source('main', 'fhv_tripdata') }}

),

-- Cast data types and rename columns,
-- dropped SR_flag column since is all Null
renamed as (

    select

        dispatching_base_num,
        pickup_datetime,
        TRY_CAST(pulocationid as integer) as pickup_location_id,
        dropoff_datetime,
        TRY_CAST(dolocationid as integer) as dropoff_location_id,
        -- Some affiliated base numbers are null and some have #N/A so
        -- converting them all to null.
        case
            when affiliated_base_number = '#N/A' then null
            else affiliated_base_number
        end as affiliated_base_number,
        filename

    from source

)

-- Final output for stg__fhv_tripdata
select * from renamed