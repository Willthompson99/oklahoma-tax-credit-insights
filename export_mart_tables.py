from pathlib import Path
from datetime import datetime
import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

# Load credentials from .env
load_dotenv()

SF_ACCOUNT   = os.getenv("SF_ACCOUNT")
SF_USER      = os.getenv("SF_USER")
SF_PASSWORD  = os.getenv("SF_PASSWORD")
SF_WAREHOUSE = os.getenv("SF_WAREHOUSE")
SF_DATABASE  = os.getenv("SF_DATABASE")
SF_SCHEMA    = os.getenv("SF_SCHEMA")
SF_ROLE      = os.getenv("SF_ROLE")


def get_connection():
    """Establish and return a Snowflake connection."""
    conn = snowflake.connector.connect(
        user=SF_USER,
        password=SF_PASSWORD,
        account=SF_ACCOUNT,
        warehouse=SF_WAREHOUSE,
        database=SF_DATABASE,
        schema=SF_SCHEMA,
        role=SF_ROLE
    )
    return conn


def export_table(table_name: str, conn, output_dir: Path):
    """
    Query `table_name` from Snowflake, load into a DataFrame,
    and write out as CSV into `output_dir`.
    """
    query = f"SELECT * FROM {SF_DATABASE}.{SF_SCHEMA}.{table_name}"
    df = pd.read_sql(query, conn)
    output_dir.mkdir(parents=True, exist_ok=True)
    csv_path = output_dir / f"{table_name}.csv"
    df.to_csv(csv_path, index=False)
    print(f"✔ Exported {table_name} → {csv_path}")


def main():
    conn = get_connection()
    timestamp = datetime.now().strftime("%Y-%m-%d_%H%M%S")
    output_dir = Path("data") / "marts_exports" / timestamp

    tables = [
        "MART_CREDIT_DISTRIBUTION",
        "MART_CREDIT_SUMMARY",
        "MART_CREDIT_TRENDS",
        "MART_CREDIT_UTILIZATION_RATE",
        "MART_CREDITS_BY_INDUSTRY",
        "MART_TOP_RECIPIENTS",
    ]
    for tbl in tables:
        export_table(tbl, conn, output_dir)

    conn.close()


if __name__ == "__main__":
    main()
