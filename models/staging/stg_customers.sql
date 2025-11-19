{{ config(materialized='view') }}

SELECT
  CAST(CustomerID AS STRING) AS customer_id,
  TRIM(ANY_VALUE(FirstName)) AS first_name,
  TRIM(ANY_VALUE(MiddleInitial)) AS middle_initial,
  TRIM(ANY_VALUE(LastName)) AS last_name,
  CAST(CityID AS STRING) AS city_id,
  TRIM(ANY_VALUE(Address)) AS address
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID, CityID
