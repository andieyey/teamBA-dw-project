{{ config(materialized='view') }}

WITH raw AS (
  SELECT * FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
)

SELECT
  DISTINCT
  CAST(SalesID AS STRING) AS sales_id,
  CAST(SalesPersonID AS STRING) AS sales_person_id,
  CAST(CustomerID AS STRING) AS customer_id,
  CAST(ProductID AS STRING) AS product_id,
  CAST(Quantity AS INT64) AS quantity,
  SAFE_CAST(Discount AS FLOAT64) AS discount,
  SAFE_CAST(TotalPrice AS FLOAT64) AS total_price,
  SAFE_CAST(SalesDate AS TIMESTAMP) AS sales_date,
  TRIM(TransactionNumber) AS transaction_number
FROM raw
WHERE SalesID IS NOT NULL
  AND CustomerID IS NOT NULL
  AND ProductID IS NOT NULL
