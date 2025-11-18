{{ config(materialized='table') }}

WITH ranked_customers AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ',
               IFNULL(CONCAT(c.middle_initial, ' '), ''),
               c.last_name) AS customer_name,
        SUM(COALESCE(s.total_price, 0)) AS total_spent,
        RANK() OVER (ORDER BY SUM(COALESCE(s.total_price, 0)) DESC) AS rnk
    FROM {{ ref('stg_sales') }} s
    LEFT JOIN {{ ref('stg_customers') }} c
        ON s.customer_id = c.customer_id
    WHERE c.customer_id IS NOT NULL
    GROUP BY 1,2
)
SELECT *
FROM ranked_customers
WHERE rnk <= 10
ORDER BY total_spent DESC
