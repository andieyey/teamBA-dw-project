{{ config(materialized='view') }}


SELECT
CAST(CityID AS STRING) AS city_id,
CityName AS city_name,
Zipcode AS zipcode,
CAST(CountryID AS STRING) AS country_id
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`