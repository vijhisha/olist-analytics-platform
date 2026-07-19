{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'order_item_id']
    )
}}

select
    items.order_id,
    items.order_item_id,
    items.product_id,
    items.seller_id,
    items.shipping_limit_date,
    items.price,
    items.freight_value,
    items.product_category_name,
    items.product_category_name_english,
    items.seller_zip_code_prefix,
    items.seller_city,
    items.seller_state,
    items.item_total
from {{ ref('int_order_items_priced') }} as items

{% if is_incremental() %}
    where
        items.shipping_limit_date
        > (select max(latest.shipping_limit_date) from {{ this }} as latest)
{% endif %}
