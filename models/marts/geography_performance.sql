{{ config(materialized='table') }}

/*
    Geography Performance Analysis
    Revenue and customer metrics by location
*/

SELECT
    co.country_name,
    co.country_code,
    ci.city_name,
    ci.zipcode,
    COUNT(DISTINCT c.customer_id) AS num_customers,
    COUNT(DISTINCT s.sales_id) AS num_transactions,
    SUM(s.quantity) AS total_units_sold,
    SUM(s.total_price) AS total_revenue,
    AVG(s.total_price) AS avg_transaction_value,
    SUM(s.total_price) / NULLIF(COUNT(DISTINCT c.customer_id), 0) AS revenue_per_customer,
    RANK() OVER (ORDER BY SUM(s.total_price) DESC) AS revenue_rank_overall,
    RANK() OVER (PARTITION BY co.country_name ORDER BY SUM(s.total_price) DESC) AS revenue_rank_in_country
FROM {{ ref('stg_sales') }} s
LEFT JOIN {{ ref('stg_customers') }} c ON s.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_cities') }} ci ON c.city_id = ci.city_id
LEFT JOIN {{ ref('stg_countries') }} co ON ci.country_id = co.country_id
WHERE co.country_name IS NOT NULL AND ci.city_name IS NOT NULL
GROUP BY co.country_name, co.country_code, ci.city_name, ci.zipcode
ORDER BY total_revenue DESC

