-- This analysis creates a pivot table of trips by borough

-- Set output to project's answers directory
-- Per recommendation in Homework 5 Assignment, slide 30
.once ./answers/pivot_trips_by_borough.txt

-- This select uses dbt_utils.pivot function to create the table
-- To create this analysis, examples were taken from the following sources:
-- https://github.com/dbt-labs/dbt-utils#pivot-source
-- https://stackoverflow.com/questions/75164207/dbt-pivoting-a-table-with-multiple-columns
select
    {{ dbt_utils.pivot('borough',
        dbt_utils.get_column_values( ref('mart__fact_trips_by_borough'), 'borough'),
        then_value="trips_by_borough"
    ) }}

from {{ ref('mart__fact_trips_by_borough') }}