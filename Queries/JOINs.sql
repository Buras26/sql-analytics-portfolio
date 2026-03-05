CREATE TABLE analytics.countries (
    country_id   INT PRIMARY KEY,
    country_name TEXT NOT NULL
);


CREATE TABLE analytics.regions (
    region_id   INT PRIMARY KEY,
    region_name TEXT NOT NULL,
    country_id  INT NOT NULL REFERENCES analytics.countries(country_id)
);




CREATE TABLE analytics.cities (
    city_id   INT PRIMARY KEY,
    city_name TEXT NOT NULL,
    region_id INT NOT NULL REFERENCES analytics.regions(region_id)
);


CREATE TABLE analytics.customers (
    customer_id INT PRIMARY KEY,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    age         INT CHECK (age BETWEEN 16 AND 100),
    email       TEXT UNIQUE,
    city_id     INT REFERENCES analytics.cities(city_id),
    signup_date DATE NOT NULL
);


CREATE TABLE analytics.products (
    product_id   INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category     TEXT NOT NULL,
    price        NUMERIC(10,2) NOT NULL
);


CREATE TABLE analytics.orders (
    order_id    INT PRIMARY KEY,
    customer_id INT REFERENCES analytics.customers(customer_id),
    order_date  DATE NOT NULL,
    status      TEXT NOT NULL
);


CREATE TABLE analytics.order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES analytics.orders(order_id),
    product_id    INT NOT NULL REFERENCES analytics.products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0)
);

CREATE TABLE analytics.country_boundaries (
    country_id INT PRIMARY KEY REFERENCES analytics.countries(country_id),
    geom       GEOMETRY(MultiPolygon, 4326)
);


CREATE TABLE analytics.region_boundaries (
    region_id INT PRIMARY KEY REFERENCES analytics.regions(region_id),
    geom      GEOMETRY(Polygon, 4326)
);

CREATE TABLE analytics.city_boundaries (
    city_id INT PRIMARY KEY REFERENCES analytics.cities(city_id),
    geom    GEOMETRY(Polygon, 4326)
);


CREATE TABLE analytics.customer_locations (
    customer_id INT PRIMARY KEY REFERENCES analytics.customers(customer_id),
    geom        GEOMETRY(Point, 4326)
);

SELECT pg_ls_dir('/data');


COPY analytics.countries
FROM '/data/countries.csv'
CSV HEADER;

SELECT * FROM analytics.countries;

COPY analytics.regions
FROM '/data/regions.csv'
CSV HEADER;

SELECT * FROM analytics.regions;

COPY analytics.cities
FROM '/data/cities.csv'
CSV HEADER;

SELECT * FROM analytics.cities;


COPY analytics.customers
FROM '/data/customers.csv'
CSV HEADER;

SELECT * FROM analytics.customers LIMIT 10;


COPY analytics.products
FROM '/data/products.csv'
CSV HEADER;

SELECT * FROM analytics.products;

COPY analytics.orders
FROM '/data/orders.csv'
CSV HEADER;

SELECT * FROM analytics.orders LIMIT 10;


COPY analytics.order_items
FROM '/data/order_items.csv'
CSV HEADER;

SELECT * FROM analytics.order_items LIMIT 10;






CREATE TABLE IF NOT EXISTS analytics._stg_country_boundaries (
    country_id INT,
    wkt TEXT
);


CREATE TABLE IF NOT EXISTS analytics._stg_region_boundaries (
    region_id INT,
    wkt TEXT
);

CREATE TABLE IF NOT EXISTS analytics._stg_city_boundaries (
    city_id INT,
    wkt TEXT
);

CREATE TABLE IF NOT EXISTS analytics._stg_points (
    point_id INT,
    wkt TEXT
);

COPY analytics._stg_country_boundaries
FROM '/data/country_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_country_boundaries;

COPY analytics._stg_region_boundaries
FROM '/data/region_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_region_boundaries;

COPY analytics._stg_city_boundaries
FROM '/data/city_boundaries.csv'
CSV HEADER;

SELECT * FROM analytics._stg_city_boundaries;


COPY analytics._stg_points
FROM '/data/customer_locations.csv'
CSV HEADER;

SELECT * FROM analytics._stg_points;


INSERT INTO analytics.country_boundaries (country_id, geom)
SELECT
  country_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_country_boundaries;

INSERT INTO analytics.region_boundaries (region_id, geom)
SELECT
  region_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_region_boundaries;


INSERT INTO analytics.city_boundaries (city_id, geom)
SELECT
  city_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_city_boundaries;

INSERT INTO analytics.customer_locations (customer_id, geom)
SELECT
  point_id,
  ST_GeomFromText(wkt, 4326)
FROM analytics._stg_points;

SELECT
  COUNT(*) FILTER (WHERE ST_IsValid(geom)) AS valid_geom,
  COUNT(*) AS total
FROM analytics.country_boundaries;

SELECT
  ST_GeometryType(geom),
  COUNT(*)
FROM analytics.country_boundaries
GROUP BY 1;

SELECT
  COUNT(*) FILTER (WHERE ST_IsValid(geom)) AS valid_geometries,
  COUNT(*) AS total_geometries
FROM analytics.city_boundaries;


SELECT
  COUNT(*) FILTER (WHERE ST_SRID(geom) = 4326) AS correct_srid,
  COUNT(*) AS total_geometries
FROM analytics.city_boundaries;


SELECT
  c.customer_id,
  c.first_name,
  o.order_id,
  o.order_date
FROM analytics.customers c
INNER JOIN analytics.orders o
  ON c.customer_id = o.customer_id;












