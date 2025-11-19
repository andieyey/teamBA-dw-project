{{ config(materialized='table') }}

/*
    Monthly Growth Metrics
    Tracks month-over-month and year-over-year growth
*/

WITH monthly_aggregates AS (
    SELECT
        DATE_TRUNC(sales_date, MONTH) AS sale_month,
        COUNT(DISTINCT sales_id) AS num_transactions,
        COUNT(DISTINCT customer_id) AS unique_customers,
        COUNT(DISTINCT product_id) AS unique_products_sold,
        SUM(quantity) AS total_units_sold,
        SUM(total_price) AS total_revenue,
        AVG(total_price) AS avg_transaction_value
    FROM {{ ref('stg_sales') }}
    WHERE sales_date IS NOT NULL
    GROUP BY sale_month
),

with_previous_periods AS (
    SELECT
        sale_month,
        num_transactions,
        unique_customers,
        unique_products_sold,
        total_units_sold,
        total_revenue,
        avg_transaction_value,
        LAG(total_revenue, 1) OVER (ORDER BY sale_month) AS prev_month_revenue,
        LAG(total_revenue, 12) OVER (ORDER BY sale_month) AS prev_year_revenue,
        LAG(unique_customers, 1) OVER (ORDER BY sale_month) AS prev_month_customers
    FROM monthly_aggregates
)

SELECT
    sale_month,
    num_transactions,
    unique_customers,
    unique_products_sold,
    total_units_sold,
    total_revenue,
    avg_transaction_value,
    prev_month_revenue,
    prev_year_revenue,
    ROUND((total_revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0) * 100, 2) AS mom_revenue_growth,
    ROUND((total_revenue - prev_year_revenue) / NULLIF(prev_year_revenue, 0) * 100, 2) AS yoy_revenue_growth,
    ROUND((unique_customers - prev_month_customers) / NULLIF(prev_month_customers, 0) * 100, 2) AS mom_customer_growth,
    SUM(total_revenue) OVER (ORDER BY sale_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM with_previous_periods
ORDER BY sale_month

