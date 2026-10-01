{{ config(materialized='table') }}

-- A handful of product_ids in the source carry more than one product_name.
-- Keep one row per product_id so joins from the fact table never fan out.
select
    product_id,
    product_name,
    category,
    sub_category
from {{ ref('stg_superstore') }}
qualify row_number() over (
    partition by product_id
    order by product_name
) = 1
