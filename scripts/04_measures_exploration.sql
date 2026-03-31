/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG(), ROUND(), ::NUMERIC
===============================================================================
*/

-- 1. Individual Metric Queries
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;
SELECT ROUND(AVG(price), 2) AS avg_price FROM gold.fact_sales; 

-- 2. Orders and Customers
SELECT COUNT(order_number) AS total_order_lines FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(product_name) AS total_products FROM gold.dim_products;
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;
SELECT COUNT(DISTINCT customer_key) AS customers_who_ordered FROM gold.fact_sales;

-- 3. Business Key Metrics Report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount)::NUMERIC AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity)::NUMERIC FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price), 2)::NUMERIC FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number)::NUMERIC FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name)::NUMERIC FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key)::NUMERIC FROM gold.dim_customers;