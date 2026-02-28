SELECT 
    DATE_TRUNC('month', order_date_date) AS month,
    SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 1
ORDER BY total_revenue DESC;



SELECT 
    DATE_TRUNC('quarter', order_date_date) AS quarter,
    SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 1
ORDER BY total_revenue DESC;


SELECT
	DATE_TRUNC('year', order_date_date) AS year,
 	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY 1
ORDER BY total_revenue DESC;


SELECT 
    DATE_TRUNC('month', order_date_date) AS month,
    DATE_TRUNC('quarter', order_date_date) AS quarter,
    DATE_TRUNC('year', order_date_date) AS year,
    SUM(total_sales) AS total_revenue,
    COUNT(*) AS total_sales
FROM sales_analysis
GROUP BY 1, 2, 3
ORDER BY total_revenue ASC;






