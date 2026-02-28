TASK 1

SELECT
	transaction_id,
	city,
	category,
	total_sales,
	CASE
	WHEN total_sales > 251 AND discount < 0.25 THEN 'high_value'
	WHEN total_sales = 251 AND discount <=  0.25 THEN 'medium_value'
	WHEN total_sales < 251 AND discount > 0.25 THEN 'Low_value'
	ELSE 'other'
	END AS value
FROM sales_analysis
WHERE year = 2023 AND category = 'Electronics';

TASK 2

SELECT
	category,
	SUM(total_sales) AS total_sum,
	COUNT(transaction_id) AS trnsaction_count,
	AVG(discount) AS avg_discount,
	CASE
	WHEN SUM(total_sales) > 80000 AND AVG(discount) < 0.25 THEN 'Strong_Performer'
	WHEN SUM(total_sales) BETWEEN 50000 AND 80000 AND AVG(discount) > 0.25 THEN 'Average_Performer'
	ELSE 'Underperformer'
	END AS performance
FROM sales_analysis
WHERE year =2023
GROUP BY category
HAVING COUNT (transaction_id) > 100
ORDER BY total_sum DESC;


TESK 3

SELECT
	city,
	COUNT (*) AS transaction_volume,
	CASE
	WHEN COUNT(*) > 100 THEN 'High_activity'
	WHEN COUNT(*) BETWEEN 50 AND 100 THEN 'Medium_activity'
	WHEN COUNT(*) < 50 THEN 'Low_activity'
	END AS activity
FROM sales_analysis
WHERE year =2023
GROUP BY city
HAVING COUNT (transaction_id) > 1;


TESK 4

SELECT
	category,
	AVG(discount) AS avg_discount,
	SUM(total_sales) AS total_sales,
	CASE
	WHEN AVG(discount) > 0.25 THEN 'Discount_heavy'
	WHEN AVG(discount) BETWEEN 0.10 AND 0.25 THEN 'Moderate_discount'
	ELSE 'Low discount'
	END AS discount
FROM sales_analysis
GROUP BY category
HAVING COUNT (transaction_id) > 10
ORDER BY total_sales DESC;

