select
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
from {{ ref('int_orders_enriched') }}
where order_delivered_customer_date < order_purchase_timestamp