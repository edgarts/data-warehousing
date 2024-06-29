-- SQL file to print out table names and schemas

-- Configure duckdb settings
.echo on
.mode quote

-- Describe  table for bike data
DESCRIBE bike_data;

-- Describe table for Central Park weather
DESCRIBE central_park_weather;

-- Describe table for taxi zones
DESCRIBE taxi_zones;

-- Describe table from taxi bases
DESCRIBE fhv_bases;

-- Describe tables from taxi data 
DESCRIBE fhv_tripdata;

DESCRIBE fhvhv_tripdata;

DESCRIBE green_tripdata;

DESCRIBE yellow_tripdata;
