{{ config(materialized='table') }}

/*
    Sales Team Performance
    Metrics for sales people/employees to track their performance
*/

WITH employee_sales AS (
    SELECT
        s.sales_person_id,
        COUNT(DISTINCT s.sales_id) AS num_sales,
        COUNT(DISTINCT s.customer_id) AS unique_customers_served,
        SUM(s.quantity) AS total_units_sold,
        SUM(s.total_price) AS total_revenue,
        AVG(s.total_price) AS avg_transaction_value,
        AVG(s.discount) AS avg_discount_given,
        MIN(s.sales_date) AS first_sale_date,
        MAX(s.sales_date) AS last_sale_date,
        DATE_DIFF(DATE(MAX(s.sales_date)), DATE(MIN(s.sales_date)), DAY) AS days_active
    FROM {{ ref('stg_sales') }} s
    WHERE s.sales_person_id IS NOT NULL
    GROUP BY s.sales_person_id
),

employee_info AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', 
               IFNULL(CONCAT(e.middle_initial, '. '), ''), 
               e.last_name) AS employee_name,
        e.gender,
        e.hire_date,
        DATE_DIFF(CURRENT_DATE(), e.hire_date, YEAR) AS years_of_service,
        ci.city_name AS employee_city,
        co.country_name AS employee_country
    FROM {{ ref('stg_employees') }} e
    LEFT JOIN {{ ref('stg_cities') }} ci ON e.city_id = ci.city_id
    LEFT JOIN {{ ref('stg_countries') }} co ON ci.country_id = co.country_id
)

SELECT
    ei.employee_id,
    ei.employee_name,
    ei.gender,
    ei.hire_date,
    ei.years_of_service,
    ei.employee_city,
    ei.employee_country,
    COALESCE(es.num_sales, 0) AS num_sales,
    COALESCE(es.unique_customers_served, 0) AS unique_customers_served,
    COALESCE(es.total_units_sold, 0) AS total_units_sold,
    COALESCE(es.total_revenue, 0) AS total_revenue,
    COALESCE(es.avg_transaction_value, 0) AS avg_transaction_value,
    COALESCE(es.avg_discount_given, 0) AS avg_discount_given,
    es.first_sale_date,
    es.last_sale_date,
    es.days_active,
    CASE
        WHEN es.total_revenue >= 100000 THEN 'Top Performer'
        WHEN es.total_revenue >= 50000 THEN 'High Performer'
        WHEN es.total_revenue >= 25000 THEN 'Average Performer'
        WHEN es.total_revenue > 0 THEN 'Developing'
        ELSE 'No Sales Recorded'
    END AS performance_tier,
    RANK() OVER (ORDER BY COALESCE(es.total_revenue, 0) DESC) AS revenue_rank
FROM employee_info ei
LEFT JOIN employee_sales es ON ei.employee_id = es.sales_person_id
ORDER BY total_revenue DESC

