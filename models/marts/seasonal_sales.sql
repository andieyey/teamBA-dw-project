{{ config(materialized='table') }}


WITH monthly_sales AS (
SELECT
DATE_TRUNC(sales_date, MONTH) AS sale_month,
EXTRACT(MONTH FROM sales_date) AS month_number,
SUM(total_price) AS revenue
FROM {{ ref('stg_sales') }}
WHERE sales_date IS NOT NULL
GROUP BY 1,2
)


SELECT
month_number,
AVG(revenue) AS avg_monthly_revenue,
MAX(revenue) AS max_monthly_revenue,
MIN(revenue) AS min_monthly_revenue
FROM monthly_sales
WHERE month_number IS NOT NULL
GROUP BY month_number
ORDER BY month_number