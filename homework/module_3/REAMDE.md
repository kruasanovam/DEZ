###### SETUP ######
------ Create an external table using the Green Taxi Trip Records Data for 2022 ------

CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-412621.taxi_rides_ny.green_tripdata_2022_external`
OPTIONS (
  format = 'parquet',
  uris = ['gs://nytaxi_dez/green/green_tripdata_2022-*.parquet']
);

------ Create a table in BQ ------

CREATE OR REPLACE TABLE dtc-de-course-412621.taxi_rides_ny.green_tripdata_2022_bq AS
SELECT * FROM dtc-de-course-412621.taxi_rides_ny.green_tripdata_2022_external;

###### 1a. What is count of records for the 2022 Green Taxi Data ######

SELECT COUNT(*) FROM `dtc-de-course-412621.taxi_rides_ny.green_tripdata_2022_external`
840,402

###### 1b. Count the distinct number of PULocationIDs from external table ######

SELECT count (DISTINCT PULocationID)
FROM taxi_rides_ny.green_tripdata_2022_external

###### 3. Count the distinct number of PULocationIDs from BQ table ######

SELECT count (DISTINCT PULocationID)
FROM taxi_rides_ny.green_tripdata_2022_bq

###### 4. How many records have a fare_amount of 0 ######

SELECT COUNT(*)
FROM taxi_rides_ny.green_tripdata_2022_external
WHERE fare_amount = 0

###### 5. What is the best strategy to make an optimized table in Big Query ######

CREATE OR REPLACE TABLE taxi_rides_ny.green_tripdata_2022_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM taxi_rides_ny.green_tripdata_2022_external;

###### 6. ######
SELECT count (DISTINCT PULocationID)
FROM taxi_rides_ny.green_tripdata_2022_bq
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-01-06' and '2022-06-30'

This query will process 12.82 MB when run.

SELECT count (DISTINCT PULocationID)
FROM taxi_rides_ny.green_tripdata_2022_partitoned_clustered
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-01-06' and '2022-06-30'

This query will process 6.53 MB when run.