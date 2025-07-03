{{ config(materialized='view') }}

SELECT
  credit_type  AS industry,
  COUNT(*)      AS claim_count,
  SUM(amount)   AS total_amount
FROM {{ ref('stg_tax_credits') }}
GROUP BY credit_type
