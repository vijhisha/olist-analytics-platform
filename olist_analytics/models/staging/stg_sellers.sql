select
    seller_id,
    seller_city,
    seller_state,
    lpad(cast(seller_zip_code_prefix as string), 5, '0')
        as seller_zip_code_prefix
from {{ source('raw', 'sellers') }}
