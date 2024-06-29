-- SQL File to perform the ingest of data files

-- Create table for bike data
CREATE TABLE bike_data AS
    SELECT * FROM read_csv('citibike-tripdata.csv.gz',
    filename = true);

-- Create table for Central Park weather
CREATE TABLE central_park_weather AS
    SELECT * FROM read_csv('central_park_weather.csv',
    filename = true);

-- Create table from taxi bases
CREATE TABLE fhv_bases AS
    SELECT * FROM read_csv('fhv_bases.csv',
    filename = true);

-- Create table for taxi zones
CREATE TABLE taxi_zones AS
   SELECT * FROM 'taxi_zones.shp';

-- Alter table to add the filename column since this cannot be 
-- done automatically for an ESRI shp file
ALTER TABLE taxi_zones ADD COLUMN filename VARCHAR DEFAULT 'taxi_zones.shp';

-- Create tables from taxi data 
CREATE TABLE fhv_tripdata AS
    SELECT * FROM read_parquet('fhv_tripdata.parquet',
    filename = true);

CREATE TABLE fhvhv_tripdata AS
    SELECT * FROM read_parquet('fhvhv_tripdata.parquet',
    filename = true);

CREATE TABLE green_tripdata AS
    SELECT * FROM read_parquet('green_tripdata.parquet',
    filename = true);

CREATE TABLE yellow_tripdata AS
    SELECT * FROM read_parquet('yellow_tripdata.parquet',
    filename = true);
