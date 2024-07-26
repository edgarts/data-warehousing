-- This analysis calculates the 7 day moving average precipitation for
-- every day in the weather data with the window centered on the day
-- in question

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/seven_day_moving_average_prcp.txt

-- This select uses ordered dates and a range interval of 3 days
-- before and 3 days after to determine the moving window and
-- calculate the average
-- This analysis is based on the example on page 22 of
-- Week 5 slide deck
select
      date,
      round(avg(precipitation)
            over (order by date asc
                  range between interval 3 days preceding and
                                interval 3 days following), 4)
            as seven_days_moving_avg
from {{  ref('mart__fact_central_park_weather') }}
order by date