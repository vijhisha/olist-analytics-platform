select
    seller_id,
    lpad(cast(seller_zip_code_prefix as string), 5, '0') as seller_zip_code_prefix,
    seller_city,
    seller_state
from {{ source('raw', 'sellers') }}
