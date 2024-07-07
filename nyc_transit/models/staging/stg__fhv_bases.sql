-- dbt Staging file for the NYC For Hire Vehicle bases table

-- source is fhv_bases raw table
with source as (

    select * from {{ source('main', 'fhv_bases') }}

),

-- Rename columns
renamed as (

    select

        base_number,
        base_name,
        dba as doing_business_as,
        dba_category as business_category,
        filename

    from source

)

-- Final output for stg__fhv_bases
select * from renamed