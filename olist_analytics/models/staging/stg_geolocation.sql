select
    lpad(cast(geolocation_zip_code_prefix as string), 5, '0') as geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
from {{ source('raw', 'geolocation') }}
