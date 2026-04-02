/*
===============================================================================
Change Over Time Analysis (PostgreSQL)
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

PostgreSQL Functions Used:
    - Date Functions: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- 1. Analyse sales performance over time
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1, 2 -- Using column positions for cleaner GROUP BY
ORDER BY 1, 2;

-- 2. DATE_TRUNC()
SELECT
    DATE_TRUNC('month', order_date)::DATE AS order_month_start, -- Додаємо ::DATE для очищення часу
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 3. TO_CHAR() 
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_period,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon'), DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);