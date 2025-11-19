{{ config(materialized='view') }}

SELECT
  DISTINCT
  CAST(EmployeeID AS STRING) AS employee_id,
  TRIM(FirstName) AS first_name,
  TRIM(MiddleInitial) AS middle_initial,
  TRIM(LastName) AS last_name,
  SAFE_CAST(BirthDate AS DATE) AS birth_date,
  UPPER(TRIM(Gender)) AS gender,
  CAST(CityID AS STRING) AS city_id,
  SAFE_CAST(HireDate AS DATE) AS hire_date
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`
WHERE EmployeeID IS NOT NULL
