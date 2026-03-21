SELECT
  c.customer_id,
  c.first_name,
  o.order_id,
  o.order_date
FROM analytics.countries
INNER JOIN analytics.orders o
  ON c.customer_id = o.customer_id;

SELECT
	*
FROM analytics.cities;

SELECT
	c.*,
	region_name,
	country_name
FROM analytics.cities AS c
LEFT JOIN analytics.regions AS r ON (c.region_id = r.region_id)
LEFT JOIN analytics.countries AS co ON (r.country_id = co.country_id)



SELECT 
	*
FROM analytics.customers AS c
INNER JOIN analytics.orders AS o ON (c.customer_id = o.customer_id)

SELECT 
	c.customer_id,
	first_name ||' ' ||last_name AS fullname,
	COUNT(c.customer_id) AS customer_order_count
	-- order_id,
	-- order_date

FROM analytics.customers AS c
INNER JOIN analytics.orders AS o ON (c.customer_id = o.customer_id)
GROUP BY c.customer_id


SELECT
  c.customer_id,
  c.first_name,
  o.order_id
FROM analytics.customers c
LEFT JOIN analytics.orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


SELECT
  o.order_id,
  p.product_name,
  oi.quantity
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id;




SELECT
	 product_name,
	 COUNT(product_name) number_of_transactions,
	 SUM(quantity) total_quantity,
	 SUM(oi.quantity*p.price) AS total_revenue
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id
GROUP BY product_name
ORDER BY total_quantity DESC;














