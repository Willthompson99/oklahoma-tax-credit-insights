{{ config(materialized='view') }}

SELECT
  recipient_name,
  COUNT(*)    AS claim_count,
  SUM(amount) AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY recipient_name
ORDER BY total_amount DESC
LIMIT 10