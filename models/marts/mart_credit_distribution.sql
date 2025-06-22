SELECT
  CASE
    WHEN credit_amount < 1000 THEN 'Under $1K'
    WHEN credit_amount < 10000 THEN '$1K - $10K'
    WHEN credit_amount < 100000 THEN '$10K - $100K'
    ELSE 'Over $100K'
  END AS credit_bucket,
  COUNT(*) AS num_claims,
  SUM(credit_amount) AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY credit_bucket
