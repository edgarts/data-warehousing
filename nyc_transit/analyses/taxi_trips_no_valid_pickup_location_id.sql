-- This analysis counts the number of trips which don't have a pickup
-- location in the locations table

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/taxi_trips_no_valid_pickup_location_id.txt

-- This select works like this:
-- takes all taxi trips coming from mart__fact_all_taxi_trips
-- then left joins to mart__dim_locations on pickup location id,
-- filters for null location ids and selects pulocationid and
-- locationid
-- pickup location was chosen over drop off location for convenience
-- but it can be chosen otherwise
with trips_w_locations as (
	select

        pulocationid,
        locationid

	from {{ ref('mart__fact_all_taxi_trips') }}
	left join {{ ref('mart__dim_locations') }}
	on pulocationid = locationid
	-- excluding those records which pickup location id is null
	-- included in staging to avoid removing great number of
	-- records
    where pulocationid is not null
	-- when location id is null is because didn't find a valid
	-- match for that location in the locations dimension
	and locationid is null
)

-- This select counts the trips from trips_w_locations
select

	count(*) as trips_no_valid_pulocation

from trips_w_locations