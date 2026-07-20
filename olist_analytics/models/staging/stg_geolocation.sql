select
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    lpad(cast(geolocation_zip_code_prefix as string), 5, '0')
        as geolocation_zip_code_prefix
from {{ source('raw', 'geolocation') }}
