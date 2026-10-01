{{ config(materialized='table') }}

select
    {{ dbt_utils.generate_surrogate_key(['postal_code', 'city', 'state']) }} as geography_key,
    postal_code,
    city,
    state,
    region,
    country
from {{ ref('stg_superstore') }}
group by 1, 2, 3, 4, 5, 6