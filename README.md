# Oklahoma Tax Credit Insights

A complete end-to-end analytics pipeline for ingesting, modeling, and visualizing Oklahoma tax-credit data using Snowflake, dbt, and Power BI.

---

## Repository Structure

```bash
.
├── .env                              # Local Snowflake credentials (ignored)
├── .gitattributes                    # Git text-normalization settings
├── .gitignore                        # Excluded files & folders
├── dbt_project.yml                   # dbt configuration
├── export_mart_tables.py             # Python script to export mart tables to CSV
├── oklahoma-tax-credit-insights.pbix # Power BI dashboard file
├── models/                           # dbt models (staging & marts)
│   ├── staging/
│   │   ├── sources.yml               # Source definitions for raw table
│   │   ├── schema.yml                # Schema tests & descriptions
│   │   └── stg_tax_credits.sql       # Staging view SQL
│   └── marts/
│       ├── mart_credit_distribution.sql
│       ├── mart_credit_summary.sql
│       ├── mart_credit_trends.sql
│       ├── mart_credit_utilization_rate.sql
│       ├── mart_credits_by_industry.sql
│       └── mart_top_recipients.sql
├── powerbi/
│   └── OK_Tax_Credit_Insights.pbix   # Power BI report file
├── profiles.yml.example              # dbt profile template (no real creds)
└── reports/
    └── stakeholder_report.pdf        # Generated stakeholder report PDF

Prerequisites
Snowflake account with a COMPUTE_WH warehouse & WILLTHOMPSON.PUBLIC schema

dbt ≥ 1.x installed

Power BI Desktop (Windows)

Python 3.8+ with pandas, snowflake-connector-python, and python-dotenv

Setup & Usage
Clone the repo

bash
Copy code
git clone https://github.com/Willthompson99/oklahoma-tax-credit-insights.git
cd oklahoma-tax-credit-insights
Install Python dependencies

bash
Copy code
pip install -r requirements.txt
Configure credentials

Copy profiles.yml.example → ~/.dbt/profiles.yml and fill in your Snowflake account settings.

Edit .env with your Snowflake environment variables.

Build & test with dbt

bash
Copy code
dbt deps
dbt run     # constructs staging and marts
dbt test    # runs schema tests
(Optional) Export CSVs

bash
Copy code
python export_mart_tables.py
Open Power BI dashboard

Launch powerbi/OK_Tax_Credit_Insights.pbix

Refresh connections to your Snowflake models

Interact with KPI cards, charts, slicers, and drill-through

Key Dashboard Features
Visualization	Description
KPI Cards	Total Claims, Average Credit Amount, Total Credit Amount
Bar Chart	Utilization Rate (%) by Recipient
Bar Chart	Total Amount (USD) by Industry
Line Chart	Total Amount & Total Claims by Tax Year
Drill-through Table	Detailed credit records (Fiscal Year, Recipient, Credit Type)
Slicers	Credit Type, Fiscal Year

Contribution
Fork the repository

Create a feature branch

Submit a pull request

