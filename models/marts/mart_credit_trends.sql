SELECT
  credit_type,
  fiscal_year,
  COUNT(*) AS num_claims,
  SUM(credit_amount) AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY credit_type, fiscal_year
