-- dbt Mart file for dimension taxi locations

-- Read all records from taxi+_zone_lookup seed table
with locations as (

select * from {{ ref('taxi+_zone_lookup') }}

)

-- Final output for mart_dim_locations
select * from locations