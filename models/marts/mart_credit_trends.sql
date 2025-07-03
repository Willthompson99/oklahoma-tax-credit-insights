{{ config(materialized='view') }}

SELECT
  tax_year,
  SUM(amount) AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY tax_year
ORDER BY tax_year
