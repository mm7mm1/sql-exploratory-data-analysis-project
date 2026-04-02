/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

CREATE OR REPLACE VIEW gold.vw_product_yearly_performance AS
SELECT
    t.product_key,
    dp.product_name,
    t.order_year,
    t.sales_over_year,
    COALESCE(LAG(t.sales_over_year) OVER (PARTITION BY t.product_key ORDER BY t.order_year), 0) AS previous_year_sales,
    t.avg_sales_all_time,
    CASE 
    WHEN t.sales_over_year > t.avg_sales_all_time THEN 'Above Average'  
    WHEN t.sales_over_year < t.avg_sales_all_time THEN 'Below Average'  
    ELSE 'Average' 
    END AS performance_compared_to_average
FROM 
    (SELECT
        product_key,
        EXTRACT(YEAR FROM order_date) AS order_year,
        SUM(sales_amount) AS sales_over_year,
        ROUND(AVG(SUM(sales_amount)) OVER (PARTITION BY product_key), 2) AS avg_sales_all_time
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY product_key, EXTRACT(YEAR FROM order_date)
    ORDER BY product_key, order_year) AS t
    LEFT JOIN gold.dim_products dp 
    ON t.product_key = dp.product_id; 


SELECT * FROM gold.vw_product_yearly_performance;




