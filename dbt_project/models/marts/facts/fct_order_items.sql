{{ config(materialized='table') }}

select
    f.row_id,
    f.order_id,
    f.customer_id,
    f.product_id,
    
    -- geography foreign key
    {{ dbt_utils.generate_surrogate_key(['f.postal_code', 'f.city', 'f.state']) }} as geography_key,

    f.order_date,
    f.ship_date,
    f.ship_mode,
    f.sales,
    f.quantity,
    f.discount,
    f.profit,
    f.sales - f.profit as cost,
    case when f.sales = 0 then 0 else f.profit / f.sales end as profit_margin

from {{ ref('stg_superstore') }} f