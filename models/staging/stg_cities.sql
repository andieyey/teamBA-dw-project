{{ config(materialized='view') }}


SELECT
CAST(CityID AS STRING) AS city_id,
CityName AS city_name,
Zipcode AS zipcode,
CAST(CountryID AS STRING) AS country_id
FROM {{ source('raw','cities') }}