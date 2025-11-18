{{ config(materialized='view') }}


SELECT
CAST(CountryID AS STRING) AS country_id,
CountryName AS country_name,
CountryCode AS country_code
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`