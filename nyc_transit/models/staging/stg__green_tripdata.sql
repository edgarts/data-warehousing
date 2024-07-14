-- dbt Staging file for Green Taxi data table

-- source is green_tripdata raw table
with source as (

    select * from {{ source('main', 'green_tripdata') }}

),

-- Cast data types and rename columns,
-- dropped ehail_fee column since is all Null
renamed as (

    select

        -- vendorid values are 1=Creative Mobile Technologies, LLC; 2= VeriFone Inc.
        {{ code_to_category("vendorid", "VendorID") }} as vendor_id,
        -- TPEP/LPEP stands for Taxicab & Livery Passenger Enhancement
        -- Programs but prefix is not needed in column names
        lpep_pickup_datetime as pickup_datetime,
        lpep_dropoff_datetime as dropoff_datetime,
        -- store_and_fwd_flag indicates whether the trip record was held in vehicle
        -- memory before sending to the vendor, aka “store and forward,”
        -- because the vehicle did not have a connection to the server.
        {{ code_to_category("store_and_fwd_flag", "Flag") }} as store_and_fwd_flag,
        -- ratecodeid is the final rate code in effect at the end of the trip.
        -- 1=Standard rate, 2=JFK, 3=Newark, 4=Nassau or Westchester,
        -- 5=Negotiated fare, 6=Group ride
        {{ code_to_category("ratecodeid", "RateCode") }} as rate_code_id,
        TRY_CAST(pulocationid as integer) as pickup_location_id,
        TRY_CAST(dolocationid as integer) as dropoff_location_id,
        TRY_CAST(passenger_count as integer) as passenger_count,
        -- some distances are negative so changing those to null
        {{ validate_positive_values("trip_distance") }} as trip_distance,
        fare_amount,
        extra,
        -- MTA stands for Metropolitan Transportation Authority
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        -- payment_type code values are:
        -- 1= Credit card, 2= Cash, 3= No charge, 4= Dispute, 5= Unknown, 6= Voided trip
        {{ code_to_category("payment_type", "PaymentType") }} as payment_type,
        -- trip_type values are 1=Street-hail, 2=Dispatch
        {{ code_to_category("trip_type", "TripType") }} as trip_type,
        congestion_surcharge,
        filename,

    from source
    -- Per the vendorif test, excluding those records which values are neither 1 nor 2.
    -- Only 16 records have a value of 6 in 238K+ records, <1%.
    where vendorid in (1, 2)
    -- Per the trip_distance test, excluding those records which values are not >= 0.
    -- Only 52 records have a negative value in 238K+ records, <1%.
    and trip_distance > 0
    -- Per the relation between pulocationid to taxi_zones.locationid,
    -- excluding those records which locationid doesn't exist in the zones catalog.
    -- There are 1,283 records which locations don't exist, <1% of 238K+ records.
    and pickup_location_id in
    (select locationid from taxi_zones)
    -- Per the relation between dolocationid to taxi_zones.locationid,
    -- excluding those records which locationid doesn't exist in the zones catalog.
    -- There are 502 records which locations don't exist, <1% of 238K+ records.
    and dropoff_location_id in
    (select locationid from taxi_zones)
    -- After all filtering 228K+ remain of a raw count of 238K+, around 96%.

)

-- Final output for stg__green_tripdata
select * from renamed