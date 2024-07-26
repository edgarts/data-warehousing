-- This analysis performs a count of total trips, trips
-- starting and ending in different borough and percentage
-- of trips start/end in different borough to total trips

-- This select works like this:
-- takes all taxi trips coming from mart__fact_all_taxi_trips
-- then left joins to mart__dim_locations on pickup location id, this avoids losing trips,
-- then also left joins to mart__dim_locations on dropoff location id, this also avoids losing trips,
-- compares pickup borough to dropoff borough and if they are different puts 1 or in any other case 0,
-- then takes weekday from pickup date time (numeric and then converts to weekday name) and groups by these,
-- counts total records per weekday and sums the boroughs comparison calculation which counts all trips
-- that started in a different borough than the one they ended also per weekday
-- and finally calculates the percentage of these latter trips against total count and orders by weekday number.
with trips_w_locations as (
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
		case
			when pu_zone.borough != do_zone.borough then 1
			else 0
		end as diff_bor_start_end

	from {{ ref('mart__fact_all_taxi_trips') }}
	left join {{ ref('mart__dim_locations') }} as pu_zone
	on pulocationid = pu_zone.locationid
	left join {{ ref('mart__dim_locations') }} as do_zone
	on dolocationid = do_zone.locationid
)

select

	weekday_num,
	weekday,
	count(*) as total_trips,
	sum(diff_bor_start_end) as trips_diff_bor_start_end,
	round(100 * trips_diff_bor_start_end / total_trips, 2) as pct_diff_bor_to_total_trips

from trips_w_locations
group by weekday_num, weekday
order by weekday_num