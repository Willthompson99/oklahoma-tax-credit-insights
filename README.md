# Oklahoma Tax Credit Insights

This project analyzes public tax credit data from the Oklahoma state government using dbt, Snowflake, and (optionally) Qlik Cloud.

## Project Goals

- Understand trends in tax credit utilization across industries and credit types.
- Transform raw tax credit data into clean, analysis-ready models.
- Provide reusable, tested dbt transformations to power data visualization.

## Tech Stack

- **Data Warehouse**: Snowflake
- **Transformation**: dbt (Data Build Tool)
- **Visualization**: Qlik (optional; intended for future dashboarding)
- **Source Data**: [Oklahoma OpenGov Portal](https://data.ok.gov)

---

## DBT Models

### Staging

- `stg_tax_credits.sql`: Cleans and standardizes raw input.

### Marts

- `mart_credits_summary.sql`: Total credit amount per credit type per year.
- `mart_credits_by_industry.sql`: Credit totals by industry and fiscal year.
- `mart_credit_trends.sql`: Trends in volume and value of claims per credit type.
- `mart_credit_utilization_rate.sql`: Estimated utilization rates vs. max allocation.
- `mart_credit_distribution.sql`: Distribution of credit claims by dollar range.

---

## Project Structure

```
oklahoma-tax-credit-insights/
├── models/
│   ├── staging/
│   │   └── stg_tax_credits.sql
│   └── marts/
│       ├── mart_credits_summary.sql
│       ├── mart_credits_by_industry.sql
│       ├── mart_credit_trends.sql
│       ├── mart_credit_utilization_rate.sql
│       └── mart_credit_distribution.sql
├── dbt_project.yml
├── schema.yml
└── README.md
```

---

## Testing

Run basic tests:

```bash
dbt test
```

---

## Dashboard

Data is structured to support a Qlik Cloud dashboard (or alternative BI tools). Key metrics include:

- Total credits claimed
- Claim distribution by industry and fiscal year
- Trends in credit usage
- Utilization percentages (if limits known)

---

## Future Improvements

- Add dbt tests for nulls, ranges, and uniqueness
- Visual dashboard once Qlik access is available
- Incorporate additional datasets (economic impact, employment data, etc.)