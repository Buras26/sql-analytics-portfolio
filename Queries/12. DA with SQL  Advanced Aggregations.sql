CREATE MATERIALIZED VIEW analytics.mv_order_revenue AS
SELECT
    c.country_name,
    r.region_name,
    ci.city_name,
    p.category,
    oi.quantity * p.price AS revenue
FROM analytics.order_items oi
JOIN analytics.orders o
    ON oi.order_id = o.order_id
JOIN analytics.products p
    ON oi.product_id = p.product_id
JOIN analytics.customers cu
    ON o.customer_id = cu.customer_id
JOIN analytics.cities ci
    ON cu.city_id = ci.city_id
JOIN analytics.regions r
    ON ci.region_id = r.region_id
JOIN analytics.countries c
    ON r.country_id = c.country_id;


SELECT
    country_name,
    region_name,
    city_name,
    category,
    SUM(revenue) AS total_revenue
FROM analytics.mv_order_revenue
GROUP BY GROUPING SETS (
    (country_name, region_name, city_name, category),
    (country_name, region_name),
    (category),
    ()
)
ORDER BY
    country_name,
    region_name,
    city_name,
    category;