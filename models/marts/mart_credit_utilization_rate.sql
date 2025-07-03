{{ config(materialized='view') }}

WITH yearly_totals AS (
  SELECT
    fiscal_year,
    SUM(amount) AS year_total
  FROM {{ ref('stg_tax_credits') }}
  GROUP BY fiscal_year
)

SELECT
  a.fiscal_year,
  a.recipient_name,
  a.amount,
  y.year_total,
  ROUND(a.amount / y.year_total * 100, 2) AS utilization_pct
FROM {{ ref('stg_tax_credits') }} AS a
JOIN yearly_totals AS y ON a.fiscal_year = y.fiscal_year
ORDER BY a.fiscal_year, a.amount DESC