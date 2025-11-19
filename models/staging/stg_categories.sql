{{ config(materialized='view') }}

SELECT
  DISTINCT CAST(CategoryID AS STRING) AS category_id,
  TRIM(CategoryName) AS category_name
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE CategoryID IS NOT NULL
  AND CategoryName IS NOT NULL
