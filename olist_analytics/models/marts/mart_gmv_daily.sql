with category_gmv_aov_cte as (
    select
        fct_order_items.product_category_name,
        fct_order_items.product_category_name_english,
        date(fct_orders.order_purchase_timestamp) as order_date,
        sum(fct_order_items.item_total) as daily_gmv,
        count(distinct fct_order_items.order_id) as order_count,
        sum(fct_order_items.item_total)
        / count(distinct fct_order_items.order_id) as daily_aov

    from {{ ref ('fct_order_items') }} as fct_order_items
    left join
        {{ ref ('fct_orders') }} as fct_orders
        on fct_order_items.order_id = fct_orders.order_id
    where fct_orders.order_status not in ('canceled', 'unavailable')
    group by
        date(fct_orders.order_purchase_timestamp),
        fct_order_items.product_category_name,
        fct_order_items.product_category_name_english

)

select
    order_date,
    product_category_name,
    product_category_name_english,
    daily_gmv,
    order_count,
    daily_aov,
    daily_gmv
    / sum(daily_gmv) over (partition by order_date) as category_gmv_share

from category_gmv_aov_cte
