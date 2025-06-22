SELECT
  credit_type,
  fiscal_year,
  SUM(credit_amount) / NULLIF(SUM(max_allocated), 0) AS utilization_rate
FROM {{ ref('stg_tax_credits') }}
GROUP BY credit_type, fiscal_year
