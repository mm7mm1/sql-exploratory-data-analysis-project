/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS (SELECT 
    customer_key,
    sum(sales_amount) as total_spending,
    MAX(order_date) - MIN(order_date) as diff_days
FROM gold.fact_sales 
GROUP BY customer_key) 
SELECT 
    customer_key,
    total_spending,
    diff_days,
    CASE 
        WHEN diff_days/30 > 12 AND total_spending >= 6000 THEN 'VIP'
        WHEN diff_days/30 > 12 AND total_spending < 6000 THEN 'Regular'
        ELSE 'New'
    END AS customer_status
FROM customer_spending;