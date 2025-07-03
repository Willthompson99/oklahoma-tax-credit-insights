{{ config(materialized='view') }}

SELECT
  fiscal_year,
  COUNT(*)    AS total_claims,
  SUM(amount) AS total_amount,
  AVG(amount) AS average_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY fiscal_year
ORDER BY fiscal_year