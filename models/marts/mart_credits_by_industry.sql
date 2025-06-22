SELECT
  industry,
  fiscal_year,
  SUM(credit_amount) AS total_credits
FROM {{ ref('stg_tax_credits') }}
GROUP BY industry, fiscal_year
