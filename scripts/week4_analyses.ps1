# Main script file to run Homework 4 analyses
# This script must be ran from the repo root directory as: ./scripts/week4_analyses.ps1

# Command to run the analysis that performs a count and total time of bike trips by weekday
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/bike_trips_and_duration_by_weekday.sql" > ./answers/bike_trips_and_duration_by_weekday.txt

# Command to run the analysis performs a count of the number of taxi trips ending at airports ('Airports' and 'EWR')
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/taxi_trips_ending_at_airport.sql" > ./answers/taxi_trips_ending_at_airport.txt

# Command to run the analysis performs a count of total trips, trips starting and ending in different borough and percentage of trips start/end in different borouth to total trips (first option)
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/inter_borough_taxi_trips_by_weekday.sql" > ./answers/inter_borough_taxi_trips_by_weekday.txt

# Command to run the analysis performs a count of total trips, trips starting and ending in different borough and percentage of trips start/end in different borouth to total trips (second option)
duckdb ./database/nyc_transit.db -s ".read ./nyc_transit/target/compiled/nyc_transit/analyses/inter_borough_taxi_trips_by_weekday2.sql" > ./answers/inter_borough_taxi_trips_by_weekday2.txt