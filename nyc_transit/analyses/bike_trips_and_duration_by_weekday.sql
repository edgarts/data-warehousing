-- This analysis performs a count and total time
-- of bike trips by weekday

select
    weekday(started_at_ts) as weekday_num,
    -- converts weekday numbers to weekday names
    case
        when weekday(started_at_ts) = 0 then 'Sunday'
        when weekday(started_at_ts) = 1 then 'Monday'
        when weekday(started_at_ts) = 2 then 'Tuesday'
        when weekday(started_at_ts) = 3 then 'Wednesday'
        when weekday(started_at_ts) = 4 then 'Thursday'
        when weekday(started_at_ts) = 5 then 'Friday'
        when weekday(started_at_ts) = 6 then 'Saturday'
    end as weekday,
    count(*) as number_of_trips,
    sum(duration_min) as all_trips_duration_min,
    sum(duration_sec) as all_trips_duration_sec
from {{ ref('mart__fact_all_bike_trips') }}
group by weekday_num, weekday
order by weekday_num