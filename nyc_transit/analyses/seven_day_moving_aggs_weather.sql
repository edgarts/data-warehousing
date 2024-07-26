-- This analysis calculates the 7 day moving minimum, maximum, average
-- and sum of precipitation and snow for every day in the weather data
-- with the window centered on the day in question using a named window

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/seven_day_moving_aggs_weather.txt

-- This select uses ordered dates and a range interval of 3 days
-- before and 3 days after to determine the moving window and
-- calculate the min, max, avg and sum of precipitation and snow
-- This analysis is based on the example on page 22 of
-- Week 5 slide deck
select
      date,
      min(precipitation)
            over seven_days as seven_day_moving_min_prcp,
      max(precipitation)
            over seven_days as seven_day_moving_max_prcp,
      round(avg(precipitation)
            over seven_days, 4) as seven_day_moving_avg_prcp,
      round(sum(precipitation)
            over seven_days, 4) as seven_day_moving_sum_prcp,
      min(snowfall)
            over seven_days as seven_day_moving_min_snow,
      max(snowfall)
            over seven_days as seven_day_moving_max_snow,
      round(avg(snowfall)
            over seven_days, 4) as seven_day_moving_avg_snow,
      round(sum(snowfall)
            over seven_days, 4) as seven_day_moving_sum_snow
from {{  ref('mart__fact_central_park_weather') }}
window seven_days as (
      order by date asc
      range between interval 3 days preceding and
                    interval 3 days following
)
order by date