{{ config(materialized='view') }}

SELECT
  FISCAL_YEAR::VARCHAR   AS fiscal_year,
  TAX_YEAR,
  RECIPIENT_NAME,
  CREDIT_TYPE,
  AMOUNT,
  CREDIT_DESCRIPTION
FROM {{ source('willthompson', 'stg_tax_credits') }}
