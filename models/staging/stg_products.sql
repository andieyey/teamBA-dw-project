{{ config(materialized='view') }}


SELECT
CAST(ProductID AS STRING) AS product_id,
ProductName AS product_name,
SAFE_CAST(Price AS FLOAT64) AS price,
CAST(CategoryID AS STRING) AS category_id,
Class AS class,
SAFE_CAST(ModifyDate AS TIMESTAMP) AS modify_date,
Resistant AS resistant,
IsAllergic AS is_allergic,
SAFE_CAST(VitalityDays AS INT64) AS vitality_days
FROM {{ source('raw','products') }}