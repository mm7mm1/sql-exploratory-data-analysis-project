/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
SELECT
    t.category,
    t.sales_by_category,
    SUM(t.sales_by_category) OVER() AS total_sales,
    CONCAT(ROUND((t.sales_by_category * 100) / SUM(t.sales_by_category) OVER(), 2), '%') AS percentage_of_total_sales
FROM
    (SELECT 
            gdp.category as category,
            sum(gfs.sales_amount) as sales_by_category
        FROM gold.fact_sales gfs
        LEFT JOIN gold.dim_products gdp
        ON gfs.product_key = gdp.product_key
        GROUP BY gdp.category
        ORDER BY gdp.category) as t;