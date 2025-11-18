{{ config(materialized='view') }}


SELECT
CAST(CategoryID AS STRING) AS category_id,
CategoryName AS category_name
FROM {{ source('raw','categories') }}