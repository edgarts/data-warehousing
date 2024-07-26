-- This analysis compares each individual fare to the zone, borough
-- and overall average fare using fare_amount in the yellow taxi trip
-- data

-- This select works like this:
-- takes all taxi trips coming from stg__yellow_tripdata
-- then joins to mart__dim_locations on pickup location id
-- and selects borough, zone and fare amount
-- pickup location was chosen over drop off location for convenience
-- but it can be chosen otherwise
with yellow_trips_w_locations as (
	select

        borough,
        zone,
        fare_amount

	from {{ ref('mart__fact_yellow_taxi_trips') }}
	left join {{ ref('mart__dim_locations') }}
	on pulocationid = locationid
)

-- This select execute the window function to calculate the average
-- by zone, borough and overall
select

    borough,
    zone,
	fare_amount,
	round(avg(fare_amount) over (partition by zone), 2) as avg_fare_zone,
	round(avg(fare_amount) over (partition by borough), 2) as avg_fare_borough,
	round(avg(fare_amount) over (), 2) as avg_fare_overall

from yellow_trips_w_locations
order by borough, zone