-- This analysis finds all the zones where there are less than 100K trips

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/zones_with_less_than_100k_trips.txt

-- This select works like this:
-- takes all taxi trips coming from mart__fact_all_taxi_trips
-- then joins to mart__dim_locations on pickup location id
-- and selects zone
-- pickup location was chosen over drop off location for convenience
-- but it can be chosen otherwise
with trips_w_locations as (
	select

        zone

	from {{ ref('mart__fact_all_taxi_trips') }}
	join {{ ref('mart__dim_locations') }}
	on pulocationid = locationid
)

-- This select zone and counts the trips by zone from
-- trips_w_locations
select

    zone,
	count(*) as trips_by_zone

from trips_w_locations
group by zone
having trips_by_zone < 100000