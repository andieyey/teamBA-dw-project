{{ config(materialized='view') }}


SELECT
CAST(CustomerID AS STRING) AS customer_id,
FirstName AS first_name,
MiddleInitial AS middle_initial,
LastName AS last_name,
CAST(CityID AS STRING) AS city_id,
Address AS address
FROM {{ source('raw','customers') }}