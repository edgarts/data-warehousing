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
    -- removing records which request_datetime is null due to tests
    -- they are just 5 records in 32M+
    where request_datetime is not null
    -- Per the relation between dispatching_base_num to fhv_bases.base_number,
    -- excluding those records which base_number doesn't exist in the bases catalog.
    -- Only 2 bases doesn't exist but they represent 4,445,961 records, ~14% but
    -- still 27M+ records remain.
    -- The relation between originating_base_num to fhv_bases.base_number doesn't
    -- fail the test (only null values doesn't match) after filtering out
    -- dispatching_base_num so nothing else needs to be excluded.
    and dispatching_base_num in
    (select base_number from fhv_bases)
    -- Per the relation between pulocationid to taxi_zones.locationid,
    -- excluding those records which locationid doesn't exist in the zones catalog.
    -- There are 8K+ records which locations don't exist, <1% of 30M+ records.
    and pickup_location_id in
    (select locationid from taxi_zones)
    -- Per the relation between dolocationid to taxi_zones.locationid,
    -- excluding those records which locationid doesn't exist in the zones catalog.
    -- There are 908K+ records which locations don't exist, ~3% of 3M+ records.
    and dropoff_location_id in
    (select locationid from taxi_zones)
    -- After all filtering 26M+ remain of a raw count of 32M+, around 83%.

)

-- Final output for stg__fhvhv_tripdata
select * from renamed