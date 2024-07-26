-- This analysis performs a count of total trips, trips
-- starting and ending in different borough and percentage
-- of trips start/end in different borouth to total trips

-- This select works with 2 virtual tables:
--   - The first one has the weekdays and total trips each
with all_trips as (

    -- Select all taxi trips from mart__fact_all_taxi_trips and groups by weekday
    -- and calculate total trips
    select

        weekday(pickup_datetime) as weekday_num,
        -- converts weekday numbers to weekday names
        case
            when weekday(pickup_datetime) = 0 then 'Sunday'
            when weekday(pickup_datetime) = 1 then 'Monday'
            when weekday(pickup_datetime) = 2 then 'Tuesday'
            when weekday(pickup_datetime) = 3 then 'Wednesday'
            when weekday(pickup_datetime) = 4 then 'Thursday'
            when weekday(pickup_datetime) = 5 then 'Friday'
            when weekday(pickup_datetime) = 6 then 'Saturday'
        end as weekday,
        count(*) as total_trips

    from {{ ref('mart__fact_all_taxi_trips') }}
    group by weekday_num, weekday

),

--   - The second one has the weekdays and the total trips whose starting borough is different than its ending borough
diff_bor_trips as (

    -- Selects taxi trips from mart__fact_all_taxi_trips and joins each pulocationid and
    -- dolocationid with mart__dim_locations table independently, then filters for only
    -- those whose pickup borough is different than dropoff borough, groups by weekday
    -- and calculate total trips
    select

        weekday(pickup_datetime) as weekday_num,
        -- converts weekday numbers to weekday names
        case
            when weekday(pickup_datetime) = 0 then 'Sunday'
            when weekday(pickup_datetime) = 1 then 'Monday'
            when weekday(pickup_datetime) = 2 then 'Tuesday'
            when weekday(pickup_datetime) = 3 then 'Wednesday'
            when weekday(pickup_datetime) = 4 then 'Thursday'
            when weekday(pickup_datetime) = 5 then 'Friday'
            when weekday(pickup_datetime) = 6 then 'Saturday'
        end as weekday,
        count(*) as trips_diff_bor_start_end

    from {{ ref('mart__fact_all_taxi_trips') }}
    join {{ ref('mart__dim_locations') }} as pu_zone
    on pulocationid = pu_zone.locationid
    join {{ ref('mart__dim_locations') }} as do_zone
    on dolocationid = do_zone.locationid
    where pu_zone.borough != do_zone.borough
    group by weekday_num, weekday

)

-- Joins both virtual tables on weekday and calculates the percentage
select
    all_trips.weekday_num as weekday_num,
    all_trips.weekday as weekday,
    total_trips,
    trips_diff_bor_start_end,
    round(100 * trips_diff_bor_start_end / total_trips, 2) as pct_diff_bor_to_total_trips
from all_trips join diff_bor_trips
on all_trips.weekday_num = diff_bor_trips.weekday_num
order by all_trips.weekday_num