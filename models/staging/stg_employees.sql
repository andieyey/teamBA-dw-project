{{ config(materialized='view') }}


SELECT
CAST(EmployeeID AS STRING) AS employee_id,
FirstName AS first_name,
MiddleInitial AS middle_initial,
LastName AS last_name,
SAFE_CAST(BirthDate AS DATE) AS birth_date,
Gender AS gender,
CAST(CityID AS STRING) AS city_id,
SAFE_CAST(HireDate AS DATE) AS hire_date
FROM `grocery-sales-478511`.`grocery_sales_478511_grocery_sales`.`Grocery_Sales`