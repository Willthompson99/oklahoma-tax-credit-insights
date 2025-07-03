{{ config(materialized='view') }}

SELECT
  CASE
    WHEN amount < 1000    THEN 'Under $1K'
    WHEN amount < 10000   THEN '$1K - $10K'
    WHEN amount < 100000  THEN '$10K - $100K'
    ELSE 'Over $100K'
  END AS credit_bucket,
  COUNT(*)    AS num_claims,
  SUM(amount) AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY credit_bucket
ORDER BY 
  CASE 
    WHEN credit_bucket = 'Under $1K' THEN 1
    WHEN credit_bucket = '$1K - $10K' THEN 2
    WHEN credit_bucket = '$10K - $100K' THEN 3
    WHEN credit_bucket = 'Over $100K' THEN 4
  END