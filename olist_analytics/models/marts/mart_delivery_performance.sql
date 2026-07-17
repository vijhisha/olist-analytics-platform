select 
    date_trunc(date(fct_orders.order_purchase_timestamp), month) as order_month,
    dim_customers.customer_state,
    count(distinct fct_orders.order_id) as total_orders,
    count(distinct fct_orders.customer_id) as total_customers,
    avg(fct_orders.delivery_days) as avg_delivery_days,
    avg(fct_orders.days_early) as avg_days_early,
    avg(cast(fct_orders.is_late as int64)) as late_delivery_rate

from {{ref ('fct_orders')}} as fct_orders
    left join {{ref ('dim_customers')}} as dim_customers 
        on fct_orders.customer_id = dim_customers.customer_id
group by 
    date_trunc(date(fct_orders.order_purchase_timestamp), month),
    dim_customers.customer_state