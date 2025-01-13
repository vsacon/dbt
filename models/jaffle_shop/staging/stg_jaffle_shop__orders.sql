select
    order_id,
    customer_id,
    order_date,
    status
from {{ source('jaffle_shop', 'stg_orders') }}