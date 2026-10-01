{{ config(materialized='table') }}

with dates as (
    select distinct order_date as date_day
    from {{ ref('stg_superstore') }}
    where order_date is not null

    union

    select distinct ship_date as date_day
    from {{ ref('stg_superstore') }}
    where ship_date is not null
)

select
    date_day,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(dow from date_day) as day_of_week,
    extract(week from date_day) as week_of_year,
    extract(quarter from date_day) as quarter
from dates