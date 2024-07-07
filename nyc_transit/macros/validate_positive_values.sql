-- This macro creates the case statement to make null all negative values
-- Parameters: column_name  - name of the column that contains the code value
-- Parts of the code for this macro were taken from the following sources:
-- https://docs.getdbt.com/guides/using-jinja?step=1
-- https://documentation.bloomreach.com/engagement/docs/jinja

{% macro validate_positive_values(column_name) %}
    -- Creates the case statement.
    {% set case_statement %}
        case
            when {{column_name}} >= 0 then {{column_name}}
            else null
        end
    {% endset %}

    {{ return(case_statement) }}
{% endmacro %}