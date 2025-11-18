{{ config(materialized='table') }}


SELECT
c.customer_id,
CONCAT(c.first_name, ' ', COALESCE(c.middle_initial || ' ', ''), c.last_name) AS customer_name,
SUM(s.total_price) AS total_spent
FROM {{ ref('stg_sales') }} s
LEFT JOIN {{ ref('stg_customers') }} c
ON s.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY total_spent DESC
LIMIT 10