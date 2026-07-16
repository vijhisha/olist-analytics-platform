select 
    product_id, 
    products.product_category_name,
    category_translation.product_category_name_english, 
    product_name_lenght,
    product_description_lenght, 
    product_photos_qty,
    product_weight_g, 
    product_length_cm, 
    product_height_cm,
    product_width_cm

from {{ref ('stg_products')}} as products
left join {{ref ('stg_category_translation')}} as category_translation
    on products.product_category_name = category_translation.product_category_name