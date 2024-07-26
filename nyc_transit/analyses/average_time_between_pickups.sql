-- This analysis finds the average time between taxi pick ups per zone

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/average_time_between_pickups.txt

-- This select works like this:
-- takes all taxi trips coming from mart__fact_all_taxi_trips
-- then joins to mart__dim_locations on pickup location id
-- and selects zone, pickup date time and the previous pickup date
-- time using the lag window function and pickup date times in
-- ascending order
-- This analysis is based on the example on page 25 of Week 5 slide
-- deck
with trips_w_locations as (
	select

        zone,
		pickup_datetime,
		lag(pickup_datetime, 1)
			over (partition by zone order by pickup_datetime asc)
			as prev_pickup_datetime

	from {{ ref('mart__fact_all_taxi_trips') }}
	join {{ ref('mart__dim_locations') }}
	on pulocationid = locationid
),

-- This select calculates the time difference between pick ups and
-- filters on null previous date which will be the case for the oldest
-- date and time for each zone
trips_time_diff as (
	select

	zone,
	datediff('minute', prev_pickup_datetime, pickup_datetime) as time_diff_min,
	datediff('second', prev_pickup_datetime, pickup_datetime) as time_diff_sec

	from trips_w_locations
	where prev_pickup_datetime is not null
)

-- This select zone and counts the trips by zone from
-- trips_w_locations
select

    zone,
	round(avg(time_diff_min), 2) as avg_time_between_pu_min,
	round(avg(time_diff_sec), 2) as avg_time_between_pu_sec

from trips_time_diff
group by zone