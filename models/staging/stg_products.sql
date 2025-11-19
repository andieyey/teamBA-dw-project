{{ config(materialized='view') }}

SELECT
  DISTINCT
  CAST(ProductID AS STRING) AS product_id,
  TRIM(ProductName) AS product_name,
  SAFE_CAST(Price AS FLOAT64) AS price,
  CAST(CategoryID AS STRING) AS category_id,
  TRIM(Class) AS class,
  SAFE_CAST(ModifyDate AS TIMESTAMP) AS modify_date,
  TRIM(Resistant) AS resistant,
  TRIM(IsAllergic) AS is_allergic,
  SAFE_CAST(VitalityDays AS INT64) AS vitality_days
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE ProductID IS NOT NULL
