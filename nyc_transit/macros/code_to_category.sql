-- This macro creates the case statement to convert it from code based column to categorical value column
-- Parameters: column_name  - name of the column that contains the code value
--             catalog_name - name of the conversion map to be used for this column
-- Parts of the code for this macro were taken from the following sources:
-- https://docs.getdbt.com/guides/using-jinja?step=1
-- https://documentation.bloomreach.com/engagement/docs/jinja
-- https://stackoverflow.com/questions/16675716/check-variable-type-inside-jinja2-in-flask


{% macro code_to_category(column_name, catalog_name) %}
    -- Create the catalog map with the conversion maps used in this project.
    -- The catalog map is a dictionary that is composed by the name of the catalog and a list of conversion values as tuples.
    {% set catalog_map = ({"Flag":[("Y","Yes"),("N","No")],
                           "UserType":[("Customer","casual"),("Subscriber","member")],
                           "VendorID":[(1,"Creative Mobile Technologies, LLC"),(2,"Verifone Inc.")],
                           "TripType":[(1,"Street-hail"),(2,"Dispatch")],
                           "RateCode":[(1,"StandardRate"),(2,"JFK"),(3,"Newark"),(4,"Nassau or Westchester"),(5, "Negotiated fare"),(6,"Group ride")],
                           "PaymentType":[(1,"Credit card"),(2,"Cash"),(3,"No charge"),(4,"Dispute"),(5,"Unknown"),(6,"Voided trip")]}) %}

    -- Load the specific map
    {% set conversion_map = catalog_map[catalog_name] %}

    -- Creates the case statement based on the mapping. If the first value of the pair is numeric 
    -- then that is not quoted, otherwise it is.
    {% set case_statement %}
        case
        {% for conversion_value in conversion_map %}
            {% if conversion_value[0] is integer %}
            when {{column_name}} = {{conversion_value[0]}} then '{{conversion_value[1]}}'
            {% else %}
            when {{column_name}} = '{{conversion_value[0]}}' then '{{conversion_value[1]}}'
            {% endif %}
        {% endfor %}
            else null
        end
    {% endset %}

    {{ return(case_statement) }}
{% endmacro %}