with order_item_agg as (
    select
        order_id,
        sum(item_total) as order_value,
        count(order_item_id) as item_count
    from {{ ref('int_order_items_priced') }}
    group by order_id
)

select
    orders_enriched.order_id,
    orders_enriched.customer_id,
    orders_enriched.order_status,
    orders_enriched.order_purchase_timestamp,
    orders_enriched.order_approved_at,
    orders_enriched.order_delivered_carrier_date,
    orders_enriched.order_delivered_customer_date,
    orders_enriched.order_estimated_delivery_date,
    orders_enriched.delivery_days,
    orders_enriched.days_early,
    orders_enriched.is_late,
    coalesce(order_item_agg.order_value, 0) as order_value,
    coalesce(order_item_agg.item_count, 0) as item_count

from {{ ref ('int_orders_enriched') }} as orders_enriched
left join order_item_agg
    on orders_enriched.order_id = order_item_agg.order_id
