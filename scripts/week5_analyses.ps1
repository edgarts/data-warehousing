# Main script file to run Homework 5 analyses
# This script must be ran from the repo root directory as: ./scripts/week4_analyses.ps1

# Command to run the analysis that calculates the number of trips and average duration by borough and zone
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/trips_duration_grouped_by_borough_zone.sql"

# Command to run the analysis that counts the number of trips which don't have a pickup location in the locations table
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/taxi_trips_no_valid_pickup_location_id.sql"

# Command to run the analysis that finds all the Zones where there are less than 100000 trips
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/zones_with_less_than_100k_trips.sql"

# Command to run the analysis that creates a pivot table of trips by borough
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/pivot_trips_by_borough.sql"

# Command to run the analysis that compares each individual fare to the zone, borough and overall average fare
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/yellow_taxi_fare_comparison.sql" > ./answers/yellow_taxi_fare_comparison.txt

# Command to run the analysis that removes duplicates from event seed dataset using Qualify and row_number
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/dedupe.sql"

# Command to run the analysis that calculates the 7 day moving average precipitation for every day in the weather data
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/seven_day_moving_average_prcp.sql"

# Command to run the analysis that calculates the 7 day moving min, max, avg and sum of precipitation and snow for every day in the weather data
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/seven_day_moving_aggs_weather.sql"

# Command to run the analysis that finds the average time between taxi pick ups per zone
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/average_time_between_pickups.sql"

# Command to run the analysis that determines if days immediately preceding precipitation or snow had more bike trips than those with precipitation or snow
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/days_before_precip_more_bike_trips.sql"
