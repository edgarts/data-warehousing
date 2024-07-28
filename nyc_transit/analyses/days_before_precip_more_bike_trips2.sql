-- This analysis determines if days immediately preceding precipitation
-- or snow had more bike trips than those with precipitation or snow
-- This second version of the analysis takes into account all those 
-- days with precipitation and/or snow in a run series and only one
-- preceding day before the series.

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/days_before_precip_more_bike_trips2.txt

-- This analysis is based on the different examples of Week 5 slide
-- deck

-- Select date from started_at_ts (for convenience, could have used
-- ended_at_ts as well) and number of bike trips by day from
-- mart__fact_all_bike_trips
with bike_trips_by_day as (
	select
		datetrunc('day', started_at_ts) as date,
		count(*) as bike_trips
		
	from {{  ref('mart__fact_all_bike_trips') }}
	group by date
),

-- selected date and the sum of precipitation plus snow (so if this
-- sum is greater than zero means that either or both of them happened
-- in a particular day) from mart__fact_central_park_weather
prcp_snow_days as (
	select

		date,
		precipitation + snowfall as prcp_snow

	from {{ ref('mart__fact_central_park_weather') }}
),

-- joined both previous CTEs by date to have date, the sum of
-- precipitation plus snow and then number of bike trips; used
-- inner join to ignore weather days with missing bike trips
prcp_snow_bike_trips as (
	select
	
		prcp_snow.date as date,
		prcp_snow,
		bike_trips
		
	from prcp_snow_days as prcp_snow
	join bike_trips_by_day as bike_trips
	on prcp_snow.date = bike_trips.date
),

-- Using window functions and a range interval of only the preceding
-- day, determined the date, precipitation plus snow and bike trips from
-- the immediately preceding day; used min because the window function
-- requires and aggregate function but could have used others like max
-- or avg since it retrives only one row, the preceeding one;
-- filtered out those which preceding day was null (i.e., the oldest one
-- in the set) and only included those days which had precipitation or
-- snow.
current_preced_day as (
	select
	
		date as curr_date,
		prcp_snow as curr_prcp_snow,
		bike_trips as curr_bike_trips,
		min(date) over preceding_day as prcd_date,
		min(prcp_snow) over preceding_day as prcd_prcp_snow,
		min(bike_trips) over preceding_day as prcd_bike_trips
		
	from prcp_snow_bike_trips
	window preceding_day as (
		order by date asc
		range between interval 1 day preceding
				  and interval 1 day preceding)
	qualify prcd_date is not null
	and curr_prcp_snow > 0
		
),

-- For those which current day had precipitation and/or snow and also the preceding
-- day, those are part of a run series of precipitation/snow days and those
-- preceding days should not be counted in the bike trips average, therefore the
-- bike trips are zeroed for them and a new column is added to help counting the
-- valid preceding days, meaning, those with no precipitation and/or snow, this
-- column will be used to calculate the average
curr_prcd_for_avg as (
	select

		curr_date,
		curr_prcp_snow,
		curr_bike_trips,
		prcd_date,
		prcd_prcp_snow,
		case
			when prcd_prcp_snow = 0 then prcd_bike_trips
			else 0
		end as prcd_bike_trips,
		case
			when prcd_prcp_snow = 0 then 1
			else 0
		end as prdc_day_count_to_avg
		
	from current_preced_day
)

-- calculate the average of bike trips for both the days with precipitation
-- or snow and the preceding ones with the previous consideration, this latter
-- ones are calculated manually.
select

	round(avg(curr_bike_trips), 2) as bike_trips_avg_in_prcp_snow_days,
	round(sum(prcd_bike_trips) / sum(prdc_day_count_to_avg), 2)
	as bike_trips_avg_in_prcd_prcp_snow_days
	
from curr_prcd_for_avg