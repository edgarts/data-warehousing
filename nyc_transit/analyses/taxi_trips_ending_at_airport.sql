-- This analysis performs a count of the number of taxi
-- trips ending at airports ('Airports' and 'EWR')

select
    count(*) as all_airport_ending_taxi_trips
from {{ ref('mart__fact_all_taxi_trips') }}
join {{ ref('taxi+_zone_lookup') }}
  on dolocationid = locationid
where service_zone in ('Airports','EWR')