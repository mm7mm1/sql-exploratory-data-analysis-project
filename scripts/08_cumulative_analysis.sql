/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER()
===============================================================================
*/

SELECT
    order_date_formatted AS order_date, 
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month_start) AS cumulative_sales
FROM (
    SELECT
        TO_CHAR(order_date, 'YYYY-Mon') AS order_date_formatted, 
        DATE_TRUNC('month', order_date) AS order_month_start,  
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 1, 2 
) AS t
ORDER BY order_month_start;
