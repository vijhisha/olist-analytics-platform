select
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    lpad(cast(customer_zip_code_prefix as string), 5, '0')
        as customer_zip_code_prefix
from {{ source('raw', 'customers') }}
