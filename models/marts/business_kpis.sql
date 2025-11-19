{{ config(materialized='table') }}

/*
    Business KPIs Dashboard - Overall Performance Metrics
    Key metrics for executive dashboard
*/

WITH sales_by_date AS (
    SELECT
        DATE(sales_date) AS sale_date,
        COUNT(DISTINCT sales_id) AS num_transactions,
        COUNT(DISTINCT customer_id) AS unique_customers,
        SUM(quantity) AS total_units_sold,
        SUM(total_price) AS total_revenue,
        AVG(total_price) AS avg_transaction_value,
        SUM(discount * total_price) AS total_discount_amount
    FROM {{ ref('stg_sales') }}
    WHERE sales_date IS NOT NULL
    GROUP BY sale_date
),

daily_with_prev AS (
    SELECT
        sale_date,
        num_transactions,
        unique_customers,
        total_units_sold,
        total_revenue,
        avg_transaction_value,
        total_discount_amount,
        LAG(total_revenue, 1) OVER (ORDER BY sale_date) AS prev_day_revenue,
        LAG(total_revenue, 7) OVER (ORDER BY sale_date) AS prev_week_revenue
    FROM sales_by_date
)

SELECT
    sale_date,
    num_transactions,
    unique_customers,
    total_units_sold,
    total_revenue,
    avg_transaction_value,
    total_discount_amount,
    ROUND(total_discount_amount / NULLIF(total_revenue, 0) * 100, 2) AS discount_percentage,
    ROUND((total_revenue - prev_day_revenue) / NULLIF(prev_day_revenue, 0) * 100, 2) AS day_over_day_growth,
    ROUND((total_revenue - prev_week_revenue) / NULLIF(prev_week_revenue, 0) * 100, 2) AS week_over_week_growth
FROM daily_with_prev
ORDER BY sale_date DESC

