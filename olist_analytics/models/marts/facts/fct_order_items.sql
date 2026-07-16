{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'order_item_id']
    )
}}

select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    product_category_name,
    product_category_name_english,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    item_total
from {{ ref('int_order_items_priced') }}

{% if is_incremental() %}
where shipping_limit_date > (select max(shipping_limit_date) from {{ this }})
{% endif %}