# Main script file to run Homework 1 commands
# This script must be ran from the repo root directory as: ./scripts/main.ps1

# Command to download the project data from S3://cmu-95797-23m2 using aws cli
# Options taken from https://dev.to/aws-builders/access-s3-public-data-without-credentials-4f06 
aws s3 cp s3://cmu-95797-23m2 ./ --recursive --no-sign-request

# Move data files to ingest to ./data to have them all at the same level
mv ./data/taxi/*.* ./data
mv ./data/taxi_zones/*.* ./data

# Command to create create the duckdb database and set the temp directory
duckdb ./database/nyc_transit.db -s "SET temp_directory TO './database/temp'"

# Change directory to .data so when read_csv and read parquet are used with filename option
# they don't include the dir path
cd ./data

# Command to ingest data into the duckdb database
duckdb ../database/nyc_transit.db -s ".read ../sql/ingest.sql"

# Return to root directory for the remaining commands
cd ../

# Command to print out the table names and schemas
duckdb ./database/nyc_transit.db -s ".read ./sql/dump_raw_schemas.sql" > ./answers/raw_schemas.txt

# Python script to print out the table names and row counts
py ./scripts/dump_raw_counts.py > ./answers/raw_counts.txt