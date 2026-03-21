
CREATE TEMP TABLE tmp_order_ptoducts AS
SELECT
	o.order_id,
	oi.product_id,
	oi.quantity,
	p.product_name,
	p.category,
	p.price
	oi.quantity * p.price AS revenue
FROM analytics.orders o
LEFT JOIN analytics.order_items oi ON (o.order_id = oi.order_id)
LEFT JOIN analytics.products p ON (oi.product_id = p.product_id)
LEFT JOIN analytics.customers c ON (o.customer_id = c.customer_id)


SELECT
	product_name,
    COUNT(order_id) number_of_orders
FROM tmp_order_ptoducts
GROUP BY product_name
ORDER BY number_of_orders DESC


SELECT
	product_name,
   SUM(quantity) quantity
FROM tmp_order_ptoducts
GROUP BY product_name
ORDER BY number_of_orders DESC




CREATE TEMP TABLE tmp_order_revenue AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    SUM(oi.quantity * p.price) AS order_revenue
FROM analytics.orders o
JOIN analytics.order_items oi ON o.order_id = oi.order_id
JOIN analytics.products p ON oi.product_id = p.product_id
GROUP BY o.order_id, o.customer_id, o.order_date;

SELECT
    *
FROM tmp_order_revenue
LIMIT 10;



SELECT
     AVG(order_revenue)
FROM tmp_order_revenue;



SELECT
    customer_id,
    AVG(order_revenue) AS avg_customer_revenue
FROM tmp_order_revenue
GROUP BY customer_id
HAVING AVG(order_revenue) > (
           SELECT AVG(order_revenue)
           FROM tmp_order_revenue);



SELECT
    c.customer_id
FROM analytics.customers c
WHERE (
    SELECT SUM(oi.quantity * p.price)
    FROM analytics.orders o
    JOIN analytics.order_items oi ON o.order_id = oi.order_id
    JOIN analytics.products p ON oi.product_id = p.product_id
    WHERE o.customer_id = c.customer_id
) >
(
    SELECT AVG(customer_total)
    FROM (
        SELECT
            o.customer_id,
            SUM(oi.quantity * p.price) AS customer_total
        FROM analytics.orders o
        JOIN analytics.order_items oi ON o.order_id = oi.order_id
        JOIN analytics.products p ON oi.product_id = p.product_id
        GROUP BY o.customer_id
    ) t
);




SELECT
    customer_id,
    avg_order_revenue
FROM (
    SELECT
        customer_id,
        AVG(order_revenue) AS avg_order_revenue
    FROM tmp_order_revenue
    GROUP BY customer_id
) t
WHERE avg_order_revenue >
      (
          SELECT AVG(order_revenue)
          FROM tmp_order_revenue
      );





