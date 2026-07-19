select
    order_items.order_id,
    order_items.order_item_id,
    order_items.product_id,
    order_items.seller_id,
    order_items.shipping_limit_date,
    order_items.price,
    order_items.freight_value,
    products.product_category_name,
    category_translation.product_category_name_english,
    sellers.seller_zip_code_prefix,
    sellers.seller_city,
    sellers.seller_state,
    (order_items.price + order_items.freight_value) as item_total

from {{ ref('stg_order_items') }} as order_items
left join {{ ref('stg_products') }} as products
    on order_items.product_id = products.product_id
left join {{ ref('stg_sellers') }} as sellers
    on order_items.seller_id = sellers.seller_id
left join {{ ref('stg_category_translation') }} as category_translation
    on
        products.product_category_name
        = category_translation.product_category_name
