{{ config(materialized='view') }}


SELECT
CAST(CategoryID AS STRING) AS category_id,
CategoryName AS category_name
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`