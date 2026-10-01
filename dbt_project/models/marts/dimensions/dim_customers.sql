{{ config(materialized='table') }}

select distinct
    customer_id,
    customer_name,
    segment
from {{ ref('stg_superstore') }}