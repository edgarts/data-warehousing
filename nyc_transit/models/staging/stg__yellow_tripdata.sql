-- dbt Staging file for Yellow Taxi data table

-- source is yellow_tripdata raw table
with source as (

    select * from {{ source('main', 'yellow_tripdata') }}

),

-- Cast data types and rename columns
renamed as (

    select

        -- vendorid values are 1=Creative Mobile Technologies, LLC; 2= VeriFone Inc.
        {{ code_to_category("vendorid", "VendorID") }} as vendor_id,
        -- TPEP/LPEP stands for Taxicab & Livery Passenger Enhancement
        -- Programs but prefix is not needed in column names
        tpep_pickup_datetime as pickup_datetime,
        tpep_dropoff_datetime as dropoff_datetime,
        -- store_and_fwd_flag indicates whether the trip record was held in vehicle
        -- memory before sending to the vendor, aka “store and forward,”
        -- because the vehicle did not have a connection to the server.
        TRY_CAST(passenger_count as integer) as passenger_count,
        -- some distances are negative so changing those to null
        {{ validate_positive_values("trip_distance") }} as trip_distance,
        -- ratecodeid is the final rate code in effect at the end of the trip.
        -- 1=Standard rate, 2=JFK, 3=Newark, 4=Nassau or Westchester,
        -- 5=Negotiated fare, 6=Group ride
        {{ code_to_category("ratecodeid", "RateCode") }} as rate_code_id,
        -- store_and_fwd_flag indicates whether the trip record was held in vehicle
        -- memory before sending to the vendor, aka “store and forward,”
        -- because the vehicle did not have a connection to the server.
        {{ code_to_category("store_and_fwd_flag", "Flag") }} as store_and_fwd_flag,
        TRY_CAST(pulocationid as integer) as pickup_location_id,
        TRY_CAST(dolocationid as integer) as dropoff_location_id,
        -- payment_type code values are:
        -- 1= Credit card, 2= Cash, 3= No charge, 4= Dispute, 5= Unknown, 6= Voided trip
        {{ code_to_category("payment_type", "PaymentType") }} as payment_type,
        fare_amount,
        extra,
        -- MTA stands for Metropolitan Transportation Authority
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        filename

    from source
    -- Per the trip_distance test, excluding those records which values are not >= 0.
    -- Only 164 records have a negative value in 5M+ records.
    where trip_distance > 0
    -- Per the relation between pulocationid to taxi_zones.locationid,
    -- excluding those records which locationid doesn't exist in the zones catalog.
    -- There are 50K+ records which locations don't exist, <1% of 5M+ records.

)

-- Final output for stg__yellow_tripdata
select * from renamed