-- dbt Mart file for fact trips by borough

-- Join all taxi trips with taxi zone lookup using the
-- pickup location id to get the borough and group by borough
-- pickup location was chosen over drop off location for convenience
-- but it can be chosen otherwise
with taxi_trips_by_borough as (

select

    borough,
    count(*) as trips_by_borough

from {{ ref('mart__fact_all_taxi_trips') }}
join {{ ref('mart__dim_locations') }}
on pulocationid = locationid
group by borough

)

-- Final output for mart_fact_trips_by_borough
select * from taxi_trips_by_borough