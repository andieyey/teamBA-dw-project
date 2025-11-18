{{ config(materialized='view') }}


SELECT
CAST(CountryID AS STRING) AS country_id,
CountryName AS country_name,
CountryCode AS country_code
FROM {{ source('raw','countries') }}