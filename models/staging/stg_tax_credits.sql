{{ config(materialized='view') }}

SELECT
  FISCAL_YEAR::VARCHAR   AS fiscal_year,
  TAX_YEAR,
  RECIPIENT_NAME,
  CREDIT_TYPE,
  -- Clean the AMOUNT field by removing commas and converting to numeric
  CASE 
    WHEN AMOUNT IS NULL OR AMOUNT = '' THEN 0
    ELSE TRY_CAST(REPLACE(AMOUNT, ',', '') AS DECIMAL(15,2))
  END AS amount,
  CREDIT_DESCRIPTION
FROM {{ source('willthompson', 'tax_credits_2023') }}