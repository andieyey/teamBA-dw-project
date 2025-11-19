{{ config(materialized='table') }}

/*
    Product Performance Analysis
    Detailed metrics for each product including sales, revenue, and margins
*/

WITH product_sales AS (
    SELECT
        s.product_id,
        COUNT(DISTINCT s.sales_id) AS times_sold,
        SUM(s.quantity) AS total_units_sold,
        SUM(s.total_price) AS total_revenue,
        AVG(s.total_price) AS avg_sale_price,
        AVG(s.discount) AS avg_discount_rate,
        COUNT(DISTINCT s.customer_id) AS unique_customers,
        MIN(s.sales_date) AS first_sale_date,
        MAX(s.sales_date) AS last_sale_date
    FROM {{ ref('stg_sales') }} s
    GROUP BY s.product_id
),

product_details AS (
    SELECT
        p.product_id,
        p.product_name,
        p.price AS list_price,
        p.category_id,
        c.category_name,
        p.class,
        p.vitality_days,
        p.is_allergic,
        p.resistant
    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_categories') }} c ON p.category_id = c.category_id
)

SELECT
    pd.product_id,
    pd.product_name,
    pd.category_name,
    pd.class,
    pd.list_price,
    pd.vitality_days,
    pd.is_allergic,
    pd.resistant,
    COALESCE(ps.times_sold, 0) AS times_sold,
    COALESCE(ps.total_units_sold, 0) AS total_units_sold,
    COALESCE(ps.total_revenue, 0) AS total_revenue,
    COALESCE(ps.avg_sale_price, 0) AS avg_sale_price,
    COALESCE(ps.avg_discount_rate, 0) AS avg_discount_rate,
    COALESCE(ps.unique_customers, 0) AS unique_customers,
    ps.first_sale_date,
    ps.last_sale_date,
    CASE
        WHEN ps.times_sold IS NULL THEN 'Never Sold'
        WHEN DATE_DIFF(CURRENT_DATE(), DATE(ps.last_sale_date), DAY) > 90 THEN 'Dormant'
        WHEN ps.times_sold >= 100 AND ps.total_revenue >= 5000 THEN 'Star Product'
        WHEN ps.times_sold >= 50 THEN 'Good Performer'
        WHEN ps.times_sold < 10 THEN 'Slow Mover'
        ELSE 'Average'
    END AS product_status,
    RANK() OVER (ORDER BY COALESCE(ps.total_revenue, 0) DESC) AS revenue_rank,
    RANK() OVER (PARTITION BY pd.category_name ORDER BY COALESCE(ps.total_revenue, 0) DESC) AS category_rank
FROM product_details pd
LEFT JOIN product_sales ps ON pd.product_id = ps.product_id
ORDER BY total_revenue DESC

