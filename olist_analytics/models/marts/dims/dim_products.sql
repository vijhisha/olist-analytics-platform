select
    products.product_id,
    products.product_category_name,
    category_translation.product_category_name_english,
    products.product_name_lenght,
    products.product_description_lenght,
    products.product_photos_qty,
    products.product_weight_g,
    products.product_length_cm,
    products.product_height_cm,
    products.product_width_cm

from {{ ref ('stg_products') }} as products
left join {{ ref ('stg_category_translation') }} as category_translation
    on
        products.product_category_name
        = category_translation.product_category_name
