-- dbt Staging file for For Hire Vehicle High Volume Trip data table

-- source is fhvhv_tripdata raw table
with source as (

    select * from {{ source('main', 'fhvhv_tripdata') }}

),

-- Cast data types and rename columns,
-- dropped airport_fee column since is all null
renamed as (

    select

        hvfhs_license_num,
        dispatching_base_num,
        originating_base_num,
        request_datetime,
        on_scene_datetime,
        pickup_datetime,
        dropoff_datetime,
        TRY_CAST(pulocationid as integer) as pickup_location_id,
        TRY_CAST(dolocationid as integer) as dropoff_location_id,
        trip_miles as trip_distance,
        trip_time as trip_time_sec,
        base_passenger_fare,
        tolls as tolls_amount,
        bcf as black_car_fund,
        sales_tax,
        congestion_surcharge,
        tips as tip_amount,
        driver_pay,
        {{ code_to_category("shared_request_flag", "Flag") }} as shared_request_flag,
        {{ code_to_category("shared_match_flag", "Flag") }} as shared_match_flag,
        -- access_a_ride_flag is for Metropolitan Transportation
        -- Autorithy (MTA) administered rides
        {{ code_to_category("access_a_ride_flag", "Flag") }} as mta_admin_ride,
        -- WAV stands for Wheelchair-Accessible Vehicle
        {{ code_to_category("wav_request_flag", "Flag") }} as wav_request_flag,
        {{ code_to_category("wav_match_flag", "Flag") }} as wav_match_flag,
        filename
    
    from source

)

-- Final output for stg__fhvhv_tripdata
select * from renamed