{{ config(materialized='table') }}

/*
    Customer Segmentation - RFM Analysis
    Segments customers based on Recency, Frequency, and Monetary value
*/

WITH customer_metrics AS (
    SELECT
        s.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        ci.city_name,
        co.country_name,
        COUNT(DISTINCT s.sales_id) AS purchase_frequency,
        SUM(s.total_price) AS total_monetary_value,
        AVG(s.total_price) AS avg_order_value,
        MIN(s.sales_date) AS first_purchase_date,
        MAX(s.sales_date) AS last_purchase_date,
        DATE_DIFF(CURRENT_DATE(), DATE(MAX(s.sales_date)), DAY) AS days_since_last_purchase
    FROM {{ ref('stg_sales') }} s
    LEFT JOIN {{ ref('stg_customers') }} c ON s.customer_id = c.customer_id
    LEFT JOIN {{ ref('stg_cities') }} ci ON c.city_id = ci.city_id
    LEFT JOIN {{ ref('stg_countries') }} co ON ci.country_id = co.country_id
    GROUP BY s.customer_id, customer_name, ci.city_name, co.country_name
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY days_since_last_purchase) AS recency_score,
        NTILE(5) OVER (ORDER BY purchase_frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY total_monetary_value DESC) AS monetary_score
    FROM customer_metrics
)

SELECT
    customer_id,
    customer_name,
    city_name,
    country_name,
    purchase_frequency,
    total_monetary_value,
    avg_order_value,
    first_purchase_date,
    last_purchase_date,
    days_since_last_purchase,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total_score,
    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost'
        ELSE 'Potential Loyalists'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total_score DESC

