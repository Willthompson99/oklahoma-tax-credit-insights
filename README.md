# Oklahoma Tax Credit Insights

A full-stack analytics pipeline using **Snowflake**, **dbt**, **BigQuery**, and **Qlik** to analyze and visualize Oklahoma tax credit data. Built to demonstrate strong data modeling, pipeline governance, and executive-ready dashboards in alignment with the **Oklahoma Tax Commission's Innovation Division**.

## 📊 Project Objective

Analyze trends, anomalies, and overutilization in tax credit claims across Oklahoma by:
- Aggregating and cleansing raw tax credit data
- Modeling insights with DBT in Snowflake
- Enriching data via BigQuery public datasets
- Building an interactive Qlik dashboard for KPIs and drilldowns

## 🔧 Tech Stack

| Tool        | Role                              |
|-------------|-----------------------------------|
| **Snowflake** | Cloud data warehouse (raw + marts) |
| **DBT**       | Transformations + testing          |
| **BigQuery**  | Public dataset joins (economic, geo) |
| **Qlik**      | Visual storytelling + compliance insights |

## 📂 Project Structure

```
├── data/                    # Source CSVs (e.g., tax_credits_2023.csv)
├── models/
│   ├── staging/
│   │   └── stg_tax_credits.sql
│   └── marts/
│       └── mart_credit_summary.sql
├── schema.yml
├── dbt_project.yml
├── notebooks/              # Optional: ML or analysis scripts
└── README.md
```

## 📈 Example Metrics (Qlik)

- Total credits claimed by year & type
- County-level heatmap of claim volume
- Flagged anomalies or large claims
- Year-over-year program growth
