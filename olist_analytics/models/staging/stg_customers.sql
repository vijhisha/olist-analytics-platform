select
    customer_id,
    customer_unique_id,
    lpad(cast(customer_zip_code_prefix as string), 5, '0') as customer_zip_code_prefix,
    customer_city,
    customer_state
from {{ source('raw', 'customers') }}
