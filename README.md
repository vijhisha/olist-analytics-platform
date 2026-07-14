# olist-analytics-platform

## Dataset: 9 CSVs

| File | Grain (1 row =) | Primary Key | Key Foreign Keys | Description |
|---|---|---|---|---|
| `olist_orders_dataset.csv` | one order | `order_id` | `customer_id` | Core order record: status, purchase/approval/delivery/estimated-delivery timestamps |
| `olist_order_items_dataset.csv` | one line item within an order | `order_id` + `order_item_id` | `order_id`, `product_id`, `seller_id` | Items purchased per order, with price, freight value, and shipping deadline |
| `olist_order_payments_dataset.csv` | one payment installment on an order | `order_id` + `payment_sequential` | `order_id` | Payment method, installment count, and value per installment |
| `olist_order_reviews_dataset.csv` | one review | `review_id` | `order_id` | Customer satisfaction score (1–5), comment text, review/response timestamps |
| `olist_customers_dataset.csv` | one customer *per order* | `customer_id` | — | Order-level customer location; `customer_unique_id` identifies the actual person across orders |
| `olist_products_dataset.csv` | one product | `product_id` | — | Category name (PT) and physical dimensions/weight |
| `olist_sellers_dataset.csv` | one seller | `seller_id` | — | Seller location (zip/city/state) |
| `olist_geolocation_dataset.csv` | one lat/lng sample per zip-code prefix (many rows per prefix) | none (not unique) | — | Brazilian zip-code-prefix to coordinate mapping, for distance/mapping analysis |
| `product_category_name_translation.csv` | one category | `product_category_name` | — | Maps PT category names to English |
