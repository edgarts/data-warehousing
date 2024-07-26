-- dbt Mart file for seed events csv table

-- Read all records from events seed table
with events as (

select

    insert_timestamp,
    event_id,
    event_type,
    user_id,
    event_timestamp

from {{ ref('events') }}

)

-- Final output for mart_fact_events
select * from events