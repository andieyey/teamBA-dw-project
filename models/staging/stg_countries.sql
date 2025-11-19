{{ config(materialized='view') }}

SELECT
  DISTINCT
  CAST(CountryID AS STRING) AS country_id,
  TRIM(CountryName) AS country_name,
  UPPER(TRIM(CountryCode)) AS country_code
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE CountryID IS NOT NULL
  AND CountryName IS NOT NULL
  AND CountryCode IS NOT NULL
