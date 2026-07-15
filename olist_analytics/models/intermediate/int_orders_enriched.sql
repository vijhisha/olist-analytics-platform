select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    case
        when order_delivered_customer_date is not null
            then timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, day)
        else null
    end as delivery_days,

    case
        when order_delivered_customer_date is not null
            then order_delivered_customer_date > order_estimated_delivery_date
        else null
    end as is_late

from {{ ref('stg_orders') }}