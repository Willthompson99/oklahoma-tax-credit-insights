"""
export_mart_tables.py
Pull every mart-level table from Snowflake → CSVs for Power BI
Run:  python export_mart_tables.py
"""

from pathlib import Path
from datetime import datetime
import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

# --------------------------------------------------------------------- #
# 1) Load Snowflake creds from .env                                     #
# --------------------------------------------------------------------- #
load_dotenv()                      # reads .env in current directory

SF_ACCOUNT   = os.getenv("SF_ACCOUNT")      # fhsaoto-ui58547
SF_USER      = os.getenv("SF_USER")
SF_PASSWORD  = os.getenv("SF_PASSWORD")
SF_WAREHOUSE = os.getenv("SF_WAREHOUSE")
SF_DATABASE  = os.getenv("SF_DATABASE")
SF_SCHEMA    = os.getenv("SF_SCHEMA")
SF_ROLE      = os.getenv("SF_ROLE")

# --------------------------------------------------------------------- #
# 2) Connect to Snowflake                                               #
# --------------------------------------------------------------------- #
conn = snowflake.connector.connect(
    account   = SF_ACCOUNT,
    user      = SF_USER,
    password  = SF_PASSWORD,
    warehouse = SF_WAREHOUSE,
    database  = SF_DATABASE,
    schema    = SF_SCHEMA,
    role      = SF_ROLE,
)

# --------------------------------------------------------------------- #
# 3) Tables you want to export (add/remove as needed)                   #
# --------------------------------------------------------------------- #
tables = [
    "mart_credit_summary",
    "mart_top_recipients",
    "mart_credit_distribution",
    "mart_credit_trends",
    "mart_credit_utilization_rate",
    "mart_credits_by_industry",
]

# --------------------------------------------------------------------- #
# 4) Export loop                                                        #
# --------------------------------------------------------------------- #
export_dir = Path("data/exports")
export_dir.mkdir(parents=True, exist_ok=True)
stamp = datetime.now().strftime("%Y%m%d")

for tbl in tables:
    query = f'SELECT * FROM "{tbl}"'
    df = pd.read_sql(query, conn)
    outfile = export_dir / f"{tbl}_{stamp}.csv"
    df.to_csv(outfile, index=False)
    print(f"✔  Exported {tbl} → {outfile.relative_to(Path.cwd())}")

conn.close()
print("\nAll done.")
