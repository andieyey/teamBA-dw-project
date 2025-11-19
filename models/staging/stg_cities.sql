{{ config(materialized='view') }}

SELECT
  DISTINCT
  CAST(CityID AS STRING) AS city_id,
  TRIM(CityName) AS city_name,
  TRIM(Zipcode) AS zipcode,
  CAST(CountryID AS STRING) AS country_id
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE CityID IS NOT NULL
  AND CityName IS NOT NULL
  AND CountryID IS NOT NULL
