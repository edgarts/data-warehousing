-- This analysis calculates the number of trips and average
-- durations by borough and zone

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/trips_duration_grouped_by_borough_zone.txt

-- This select works like this:
-- takes all taxi trips coming from mart__fact_all_taxi_trips
-- then joins to mart__dim_locations on pickup location id and selects
-- borough, zone and durations
-- pickup location was chosen over drop off location for convenience
-- but it can be chosen otherwise
with trips_w_locations as (
	select

        borough,
        zone,
        duration_min,
        duration_sec

	from {{ ref('mart__fact_all_taxi_trips') }}
	join {{ ref('mart__dim_locations') }}
	on pulocationid = locationid
)

-- This select just takes the output from trips_w_locations, groups by
-- borough and zone and gets the durations averages
select

	borough,
	zone,
	count(*) as trips_by_borough_and_zone,
	round(avg(duration_min), 2) as avg_duration_min,
	round(avg(duration_sec), 2) as avg_duration_sec

from trips_w_locations
group by borough, zone