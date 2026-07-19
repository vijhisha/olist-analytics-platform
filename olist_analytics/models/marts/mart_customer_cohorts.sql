with customer_orders as (
     select distinct
        customers.customer_unique_id,
        date_trunc(date(fct_orders.order_purchase_timestamp), month) as order_month
    from {{ ref('fct_orders') }} as fct_orders
    left join {{ ref('dim_customers') }} as customers
        on customers.customer_id = fct_orders.customer_id
)

, customer_cohorts as (
    select
        customer_unique_id,
        min(order_month) as cohort_month
    from customer_orders
    group by customer_unique_id
)

, cohort_size as (
    select
        cohort_month,
        count(distinct customer_unique_id) as cohort_size
    from customer_cohorts
    group by cohort_month
)

, customer_orders_with_cohort as (
    select
        cohorts.cohort_month,
        cohorts.customer_unique_id,
        orders.order_month
    from customer_cohorts as cohorts
    left join customer_orders as orders
        on cohorts.customer_unique_id = orders.customer_unique_id
)

select 
    cowc.cohort_month,
    cs.cohort_size,
    cowc.order_month,
    count(distinct cowc.customer_unique_id) as active_customers,
    count(distinct cowc.customer_unique_id)/ cs.cohort_size as retention_rate
from customer_orders_with_cohort as cowc
left join cohort_size as cs
    on cowc.cohort_month = cs.cohort_month
group by cowc.cohort_month, cowc.order_month, cs.cohort_size
order by cowc.cohort_month, cowc.order_month