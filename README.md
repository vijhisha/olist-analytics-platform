# olist-analytics-platform

## Prerequisites

- Python 3.12
- A GCP project with BigQuery enabled
- A service account JSON key with `BigQuery Data Editor` and `BigQuery Job User` roles


## Setup

1. Clone the repo and create a virtual environment:
`py -3.12 -m venv .venv`
`.venv\Scripts\Activate.ps1`
`pip install -r requirements.txt`
2. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) into a `data/` folder at the repo root.
3. Create a `.env` file at the repo root:
`DBT_BQ_PROJECT=<your-gcp-project-id>
DBT_BQ_DATASET=dev
GOOGLE_APPLICATION_CREDENTIALS=<path-to-your-service-account-key>`


## Dataset: 9 CSVs

Please download the dataset from Kaggle here: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
Create a folder '/data' under the root where you can place the 9 CSVs.

| File | Grain (1 row =) | Primary Key | Key Foreign Keys | Description |
|---|---|---|---|---|
| `olist_orders_dataset.csv` | one order | `order_id` | `customer_id` | Core order record: status, purchase/approval/delivery/estimated-delivery timestamps |
| `olist_order_items_dataset.csv` | one line item within an order | `order_id` + `order_item_id` | `order_id`, `product_id`, `seller_id` | Items purchased per order, with price, freight value, and shipping deadline |
| `olist_order_payments_dataset.csv` | one payment installment on an order | `order_id` + `payment_sequential` | `order_id` | Payment method, installment count, and value per installment |
| `olist_order_reviews_dataset.csv` | one review-to-order association | `review_id` + `order_id` | `order_id` | Customer satisfaction score (1–5), comment text, review/response timestamps. Note: `review_id` alone is **not unique** — the same review (identical score/comment/timestamps) can be attached to multiple orders. Verified via `dbt test`; composite key `(review_id, order_id)` is unique. |
| `olist_customers_dataset.csv` | one customer *per order* | `customer_id` | — | Order-level customer location; `customer_unique_id` identifies the actual person across orders |
| `olist_products_dataset.csv` | one product | `product_id` | — | Category name (PT) and physical dimensions/weight |
| `olist_sellers_dataset.csv` | one seller | `seller_id` | — | Seller location (zip/city/state) |
| `olist_geolocation_dataset.csv` | one lat/lng sample per zip-code prefix (many rows per prefix) | none (not unique) | — | Brazilian zip-code-prefix to coordinate mapping, for distance/mapping analysis |
| `product_category_name_translation.csv` | one category | `product_category_name` | — | Maps PT category names to English |


## Running ingestion

Loads all 9 Olist CSVs into a `raw` dataset in BigQuery. 8 tables load with a full-replace on each run; `orders` loads in month-by-month batches (delete-then-append per month), so it's safe to rerun without duplicating data.