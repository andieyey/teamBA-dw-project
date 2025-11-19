{{ config(materialized='table') }}


SELECT
DATE_TRUNC(s.sales_date, MONTH) AS sale_month,
ci.city_name,
co.country_name,
SUM(s.total_price) AS revenue
FROM {{ ref('stg_sales') }} s
LEFT JOIN {{ ref('stg_customers') }} cu
ON s.customer_id = cu.customer_id
LEFT JOIN {{ ref('stg_cities') }} ci
ON cu.city_id = ci.city_id
LEFT JOIN {{ ref('stg_countries') }} co
ON ci.country_id = co.country_id
WHERE s.sales_date IS NOT NULL
GROUP BY 1,2,3
ORDER BY 1,4 DESC