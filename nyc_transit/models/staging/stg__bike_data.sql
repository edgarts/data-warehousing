-- dbt Staging file for the NYC Bike data table

-- source is bike_data raw table
with source as (

    select * from {{ source('main', 'bike_data') }}

),

-- bike_data is composed by 2 different file formats, the old and the new,
-- combined horizontally so it needs to be split and then rejoined.
-- rideid and rideable_type columns from the new format  as well as 
-- bikeid, birth_year and gender from the old format should be included
-- in both sets to avoid missing this information.

-- Cast data types and rename columns for the old format columns
old_format_renamed as (

    select

        ride_id,
        rideable_type,
        TRY_CAST(tripduration as integer) as trip_duration_sec,
        TRY_CAST(starttime as datetime) as start_time,
        TRY_CAST(stoptime as datetime) as stop_time,
        TRY_CAST("start station id" as integer) as start_station_id,
        "start_station_name" as start_station_name,
        TRY_CAST("start station latitude" as double) as start_station_latitude,
        TRY_CAST("start station longitude" as double) as start_station_longitude,
        TRY_CAST("end station id" as integer) as end_station_id,
        "end station name" as end_station_name,
        TRY_CAST("end station latitude" as double) as end_station_latitude,
        TRY_CAST("end station longitude" as double) as end_station_longitude,
        -- user type values are Customer or Subscriber in the old format so
        -- changing them to casual and member respectively to match new format
        {{ code_to_category("usertype", "UserType") }} as user_type,
        TRY_CAST(bikeid as bigint) as bike_id,
        TRY_CAST("birth year" as integer) as birthyear,
        {{ code_to_category("gender", "Gender") }} as gender,
        filename
 
    from source
    -- tripdurations are not null for the old format records
    where tripduration is not null
    -- filtering out trip durations of more than 24 hours or 86400 seconds
    -- because most likely are outlier cases
    and trip_duration_sec <= 86400

),

-- Cast data types and rename columns for the new format columns
new_format_renamed as (

    select

        ride_id,
        rideable_type,
        -- tripduration doesn't exist in the new format but can be calculated
        datediff('second', TRY_CAST(started_at as datetime), TRY_CAST(ended_at as datetime)) as trip_duration_sec,
        TRY_CAST(started_at as datetime) as start_time,
        TRY_CAST(ended_at as datetime) as stop_time,
        TRY_CAST(start_station_id as integer) as start_station_id,
        start_station_name,
        TRY_CAST(start_lat as double) as start_station_latitude,
        TRY_CAST(start_lng as double) as start_station_longitude,
        TRY_CAST(end_station_id as integer) as end_station_id,
        end_station_name,
        TRY_CAST(end_lat as double) as end_station_latitude,
        TRY_CAST(end_lng as double) as end_station_longitude,
        -- member_casual values are member or casual
        member_casual as user_type,
        TRY_CAST(bikeid as bigint) as bike_id,
        TRY_CAST("birth year" as integer) as birthyear,
        {{ code_to_category("gender", "Gender") }} as gender,
        filename
 
    from source
    -- tripdurations are null for the new format records
    where tripduration is null
    -- filtering out trip durations of more than 24 hours or 86400 seconds
    -- because most likely are outlier cases
    and trip_duration_sec <= 86400

),

-- Unite both old and new format parts
renamed as (

    select * from old_format_renamed
    union all
    select * from new_format_renamed
    
)

-- Final output for stg__bike_data
select * from renamed