-- This analysis removes duplicates from event seed dataset using
-- Qualify and row_number selecting later time stamps

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/dedupe.txt

-- This select uses row_number() and qualify to remove duplicates
-- This analysis is basically a copy of Qualify example on page 26 of
-- Week 5 slide deck
select *
from {{ ref('mart__fact_events') }}
qualify (row_number()
         over (partition by event_id
               order by insert_timestamp desc)) = 1
order by event_id