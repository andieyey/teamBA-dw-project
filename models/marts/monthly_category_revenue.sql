{{ config(materialized='table') }}


WITH sales AS (
SELECT
DATE_TRUNC(sales_date, MONTH) AS sale_month,
product_id,
SUM(total_price) AS revenue
FROM {{ ref('stg_sales') }}
WHERE sales_date IS NOT NULL
GROUP BY 1,2
),
prod_cat AS (
SELECT
p.product_id,
COALESCE(c.category_name, 'Uncategorized') AS category_name
FROM {{ ref('stg_products') }} p
LEFT JOIN {{ ref('stg_categories') }} c
ON p.category_id = c.category_id
)


SELECT
s.sale_month,
pc.category_name,
SUM(s.revenue) AS total_revenue
FROM sales s
LEFT JOIN prod_cat pc
ON s.product_id = pc.product_id
WHERE s.sale_month IS NOT NULL
  AND pc.category_name IS NOT NULL
GROUP BY 1,2
ORDER BY 1,3 DESC