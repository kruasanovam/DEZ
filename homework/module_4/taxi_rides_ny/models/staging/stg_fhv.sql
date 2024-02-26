{{ config(materialized='view') }}

with fhv as 
(
select 
    dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    cast(PUlocationID as integer) as pickup_locationid,
    cast(DOlocationID as integer) as dropoff_locationid,
    cast(SR_Flag as integer) as sr_flag,
    affiliated_base_number
    
from {{ source ('staging', 'fhv') }}
)

select *
from fhv
where extract(year from pickup_datetime) = 2019

--dbt build -m <model.sql> --var 'is_test_run: false'
{% if var ('is_test_run', default=true) %}
    limit 100
{% endif %}