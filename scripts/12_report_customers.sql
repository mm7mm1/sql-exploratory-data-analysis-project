/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - lifespan (in days)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.vw_customers_report
-- =============================================================================
CREATE OR REPLACE VIEW gold.vw_customers_report AS
WITH customer_spending AS (
    SELECT 
        customer_key,
        SUM(sales_amount) as total_spending,
        COUNT(sales_amount) as total_orders,
        MAX(order_date) - MIN(order_date) as diff_days,
        MAX(order_date) as last_order_date,
        ROUND(AVG(sales_amount), 2) as avg_order_price
    FROM gold.fact_sales 
    GROUP BY customer_key),

customer_info AS (
    SELECT 
        customer_key,
        CONCAT(first_name, ' ', last_name) AS customer_name,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) AS age,
        CASE 
            WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 50 THEN '50 or above'
            WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) >= 30 THEN '30-49'
            ELSE 'above 30'
        END AS age_group
    FROM gold.dim_customers
    )

SELECT 
    cs.customer_key,
    ci.customer_name,
    ci.age,
    ci.age_group,
    CASE 
        WHEN cs.diff_days/30 > 12 AND cs.total_spending >= 6000 THEN 'VIP'
        WHEN cs.diff_days/30 > 12 AND cs.total_spending < 6000 THEN 'Regular'
        ELSE 'New'
    END AS customer_status,
    cs.last_order_date,
    cs.total_orders,
    cs.total_spending,
    cs.avg_order_price,
    cs.diff_days
FROM customer_info as ci
LEFT JOIN customer_spending as cs
ON ci.customer_key = cs.customer_key;


--SELECT * FROM gold.vw_customers_report;



