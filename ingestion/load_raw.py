import argparse
import os

import pandas as pd
from dotenv import load_dotenv
from google.cloud import bigquery
from google.api_core.exceptions import NotFound

SIMPLE_TABLES = {
    "olist_customers_dataset.csv": "customers",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "olist_geolocation_dataset.csv": "geolocation",
    "product_category_name_translation.csv": "category_translation",
}

load_dotenv()

def create_raw_dataset(client: bigquery.Client, dataset_name: str = "raw") -> None:
    dataset_id = f"{client.project}.{dataset_name}"
    dataset = bigquery.Dataset(dataset_id)
    dataset.location = "US"
    client.create_dataset(dataset, exists_ok=True)
    print(f"Dataset ready: {dataset_id}")


def load_table(client: bigquery.Client, csv_path: str, table_id: str, string_columns: list[str] | None = None) -> None:
    dtype_overrides = {col: str for col in (string_columns or [])}
    df = pd.read_csv(csv_path, dtype=dtype_overrides)

    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        autodetect=True,
    )

    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()

    print(f"Loaded {len(df)} rows into {table_id}")


def load_orders_by_month(client: bigquery.Client, csv_path: str, table_id: str) -> None:
    df = pd.read_csv(csv_path, parse_dates=["order_purchase_timestamp"])
    df["order_month"] = df["order_purchase_timestamp"].dt.to_period("M").astype(str)

    for month, month_df in df.groupby("order_month"):
        delete_query = f"""
            DELETE FROM `{table_id}`
            WHERE FORMAT_TIMESTAMP('%Y-%m', order_purchase_timestamp) = @month
        """
        query_config = bigquery.QueryJobConfig(
            query_parameters=[bigquery.ScalarQueryParameter("month", "STRING", month)]
        )
        try:
            client.query(delete_query, job_config=query_config).result()
        except NotFound:
            pass  # table doesn't exist yet on the very first run — nothing to delete

        month_df = month_df.drop(columns=["order_month"])
        load_config = bigquery.LoadJobConfig(
            write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
            autodetect=True,
        )
        job = client.load_table_from_dataframe(month_df, table_id, job_config=load_config)
        job.result()

        print(f"Loaded {len(month_df)} rows for {month} into {table_id}")


def main():
    parser = argparse.ArgumentParser(description="Load Olist CSVs into BigQuery raw dataset")
    parser.add_argument(
        "--source-dir",
        type=str,
        default="data",
        help="Folder containing the 9 Olist CSVs (default: data/)",
    )
    args = parser.parse_args()

    client = bigquery.Client()
    print(f"Connected to project: {client.project}")
    create_raw_dataset(client)
    print(f"Reading CSVs from: {args.source_dir}")

    for filename, table_name in SIMPLE_TABLES.items():
        csv_path = os.path.join(args.source_dir, filename)
        table_id = f"{client.project}.raw.{table_name}"
        load_table(client, csv_path, table_id)
    
    orders_csv = os.path.join(args.source_dir, "olist_orders_dataset.csv")
    orders_table_id = f"{client.project}.raw.orders"
    load_orders_by_month(client, orders_csv, orders_table_id)


if __name__ == "__main__":
    main()