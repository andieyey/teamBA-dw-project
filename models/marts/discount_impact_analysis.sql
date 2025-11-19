{{ config(materialized='table') }}

/*
    Discount Impact Analysis
    Analyzes the effectiveness of discounts on sales volume and revenue
*/

WITH discount_buckets AS (
    SELECT
        sales_id,
        product_id,
        customer_id,
        sales_date,
        quantity,
        discount,
        total_price,
        CASE
            WHEN discount = 0 THEN 'No Discount'
            WHEN discount > 0 AND discount <= 0.10 THEN '1-10%'
            WHEN discount > 0.10 AND discount <= 0.20 THEN '11-20%'
            WHEN discount > 0.20 AND discount <= 0.30 THEN '21-30%'
            WHEN discount > 0.30 THEN '30%+'
            ELSE 'Unknown'
        END AS discount_tier
    FROM {{ ref('stg_sales') }}
    WHERE discount IS NOT NULL
)

SELECT
    discount_tier,
    COUNT(DISTINCT sales_id) AS num_transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity) AS total_units_sold,
    SUM(total_price) AS total_revenue,
    AVG(total_price) AS avg_transaction_value,
    AVG(quantity) AS avg_units_per_transaction,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,
    AVG(discount) AS avg_discount
FROM discount_buckets
GROUP BY discount_tier
ORDER BY 
    CASE discount_tier
        WHEN 'No Discount' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        WHEN '21-30%' THEN 4
        WHEN '30%+' THEN 5
        ELSE 6
    END

